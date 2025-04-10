// F-22A EFM.cpp : F-22A flight model
#include "stdafx.h"
#include "ED_FM_TemplateAPI.h"
#include "Utility.h"
#include <math.h>
#include <stdio.h>
#include <string>
#include <algorithm> // Added for std::min and std::max
#include "Inputs.h"
#include "include/Cockpit/CockpitAPI_Declare.h"
#include "include/FM/API_Declare.h"
#include "FM_data.h"

#define EXPORT __declspec(dllexport)

namespace FM {
    Vec3 common_force, common_moment, center_of_mass, wind, velocity_world, airspeed;
    double const pi = 3.1415926535897932384626433832795;
    double const rad_to_deg = 180.0 / pi;
    inline double rad(double deg) { return deg * pi / 180.0; }

    double S = 78.04;
    double wingspan = 13.56, length = 18.92, height = 5.08;
    double idle_rpm = 0.675;
    double empty_mass = 19700;

    double Ixx = 30000.0;  // Roll inertia (kg·m²)
    double Iyy = 350000.0; // Pitch inertia (kg·m²)
    double Izz = 300000.0; // Yaw inertia (kg·m²)

    Vec3 left_wing_pos(center_of_mass.x - 0.7, center_of_mass.y + 0.5, -wingspan / 2);
    Vec3 right_wing_pos(center_of_mass.x - 0.7, center_of_mass.y + 0.5, wingspan / 2);
    Vec3 tail_pos(center_of_mass.x - 0.5, center_of_mass.y, 0);
    Vec3 elevator_pos(-length / 2, center_of_mass.y, 0);
    Vec3 left_aileron_pos(center_of_mass.x, center_of_mass.y, -wingspan * 0.5);
    Vec3 right_aileron_pos(center_of_mass.x, center_of_mass.y, wingspan * 0.5);
    Vec3 rudder_pos(-length / 2, height / 2, 0);
    Vec3 left_engine_pos(-3.793, 0, -0.716);
    Vec3 right_engine_pos(-3.793, 0, 0.716);

    double pitch_input = 0, pitch_discrete = 0, pitch_trim = 0, elevator_command = 0;
    bool pitch_analog = true;
    double roll_input = 0, roll_discrete = 0, roll_trim = 0, aileron_command = 0;
    bool roll_analog = true;
    double yaw_input = 0, yaw_discrete = 0, yaw_trim = 0, rudder_command = 0;
    bool yaw_analog = true;

    bool left_engine_switch = false;
    double left_throttle_input = 0, left_throttle_output = 0, left_engine_power_readout = 0, left_thrust_force = 0;
    double left_ab_timer = 0;
    bool right_engine_switch = false;
    double right_throttle_input = 0, right_throttle_output = 0, right_engine_power_readout = 0, right_thrust_force = 0;
    double right_ab_timer = 0;

    bool airbrake_switch = false, flaps_switch = false;
    double airbrake_pos = 0, flaps_pos = 0, slats_pos = 0;
    bool gear_switch = false;
    double gear_pos = 0;
    double wheel_brake = 0;
    int carrier_pos = 0;

    double internal_fuel = 8164.66, external_fuel = 0, total_fuel = internal_fuel;
    double fuel_consumption_since_last_time = 0;
    const double fuel_rate_idle = 0.4;
    const double fuel_rate_mil = 2.2;
    const double fuel_rate_ab = 6.5;

    double atmosphere_density = 1.225, altitude_ASL = 0, altitude_AGL = 0, V_scalar = 0;
    double speed_of_sound = 320, mach = 0;
    double engine_alt_effect = 1, atmosphere_temperature = 273;
    double aoa = 0, alpha = 0, aos = 0, beta = 0, g = 0;
    bool on_ground = false;
    double pitch = 0, pitch_rate = 0, roll = 0, roll_rate = 0, heading = 0, yaw_rate = 0;

    int element_integrity[111];
    double left_wing_integrity = 1.0, right_wing_integrity = 1.0, tail_integrity = 1.0;
    double left_engine_integrity = 1.0, right_engine_integrity = 1.0;
    double total_damage = 1 - (left_wing_integrity + right_wing_integrity + tail_integrity +
        left_engine_integrity + right_engine_integrity) / 5;

    bool invincible = true, infinite_fuel = false, easy_flight = false;
    double shake_amplitude = 0, fm_clock = 0;
    bool sim_initialised = false;

    // FBW state variables
    double ref_roll = 0, ref_fpa = 0, ref_heading = 0;
    double roll_error_i = 0, pitch_error_i = 0, yaw_error_i = 0;
    double last_aileron_cmd = 0, last_elevator_cmd = 0, last_rudder_cmd = 0;
    const double max_aileron_rate = 13.33;

    // New deflection state variables for gradual force application
    double elevator_angle = 0.0;  // Current elevator deflection (radians)
    double tv_angle = 0.0;        // Current thrust vectoring angle (radians)

    // New variables for FPA stabilization
    double fpa_ref = 0.0;         // Reference FPA to maintain when pitch input is neutral
    double fpa_error_i = 0.0;     // Integral term for FPA PI control
    bool autotrim_active = false;

    enum CustomParamIndices {
        ED_FM_AUTOTRIM_STATUS = 69001  // Arbitrary unique index, must not conflict with ED_FM_ enums
    };

    EDPARAM interface;
    void* fm_export_temperature = interface.getParamHandle("FM_TEMPERATURE_C");

    //Autotrim manual data
    double last_pitch_rate = 0.0; // Previous pitch rate (rad/s)
    const double pitch_rate_deadband = 0.0008727; // 0.05 deg/s = 0.0008727 rad/s
    const double max_adjustment_rate = 0.1; // Maximum adjustment per second (tunable)

    const double ias_table[] = { 250.0, 350.0, 450.0, 550.0, 650.0, 750.0, 850.0, 950.0, 1050.0, 1150.0, 1250.0 };
    const int ias_table_size = sizeof(ias_table) / sizeof(double);
    double elevator_baseline = 0.0;

    double autotrim_delay_timer = 0.0; // Timer for autotrim delay (seconds)
    const double autotrim_delay = 1.0; // Delay duration (2 seconds)
    const double pitch_rate_threshold = 0.0698;
    const double autotrim_pitch_rate_threshold = 0.0698;
    static bool ground_baseline_set = false;
    static double transition_timer = 0.0;
    const double transition_duration = 0.2; // seconds
    static double autotrim_blend_timer = 0.0; // Tracks blending for all autotrim activations
    const double autotrim_blend_duration = 0.3; // 0.5s blend for autotrim engagement
    static bool was_autotrim_active = false; // Previous state to detect transitions

    // New variable for periodic check
    double autotrim_check_timer = 0.0; // Timer for periodic autotrim check (seconds)
    const double autotrim_check_interval = 1.5; // Check every 1.5 seconds

    double elevator_reset_timer = 0.0;     // For 5°–15° reset
    double no_input_timer = 0.0;           // For 15°–60° no-input condition
    double neg_no_input_timer = 0.0;       // For -15° to -60° no-input condition
    double baseline_reset_timer = 0.0;     // For baseline decay

    //Animations
    double nose_wheel_rotation = 0.0; // Accumulated rotation (0 to 1)
    double left_wheel_rotation = 0.0;
    double right_wheel_rotation = 0.0;
    double ground_speed_knots = 0.0; // Store ground speed

    // New light state variables
    bool taxi_lights = false;
    bool landing_lights = false;
    bool form_light = false;
    bool nav_white = false;
    bool anti_collision = false;
    bool aar_light = false;
    bool nav_lights = false;              // Controls both 612 and 613
    double anti_collision_timer = 0.0;    // Timer for Anti-Collision light
    bool anti_collision_blink = false;    // Current blink state (on/off)
    double nav_white_timer = 0.0;         // Timer for Nav White light
    bool nav_white_blink = false;         // Current blink state (on/off)
    double nav_lights_timer = 0.0;        // Timer for Nav Lights (612 and 613)
    bool nav_lights_blink = false;        // Current blink state (on/off)
    const double blink_on_time = 0.75;    // On duration in seconds
    const double blink_off_time = 0.75;   // Off duration in seconds
    const double blink_period = blink_on_time + blink_off_time; // Total period = 1.5 seconds

    //global variables to fix respawn issues
    double last_yaw_input = 0.0;
    double last_tv_cmd = 0.0;
    double last_pitch_input = 0.0;
    double last_g = 0.0;

}

void add_local_force(const Vec3& Force, const Vec3& Force_pos) {
    FM::common_force.x += Force.x;
    FM::common_force.y += Force.y;
    FM::common_force.z += Force.z;
    Vec3 delta_pos(Force_pos.x - FM::center_of_mass.x, Force_pos.y - FM::center_of_mass.y, Force_pos.z - FM::center_of_mass.z);
    Vec3 delta_moment = cross(delta_pos, Force);
    FM::common_moment.x += delta_moment.x;
    FM::common_moment.y += delta_moment.y;
    FM::common_moment.z += delta_moment.z;
}

void add_local_moment(const Vec3& Moment) {
    FM::common_moment.x += Moment.x;
    FM::common_moment.y += Moment.y;
    FM::common_moment.z += Moment.z;
}

void ed_fm_add_local_force(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z) {
    x = FM::common_force.x;
    y = FM::common_force.y;
    z = FM::common_force.z;
    pos_x = FM::center_of_mass.x;
    pos_y = FM::center_of_mass.y;
    pos_z = FM::center_of_mass.z;
}

void ed_fm_add_local_moment(double& x, double& y, double& z) {
    x = FM::common_moment.x;
    y = FM::common_moment.y;
    z = FM::common_moment.z;
}

void simulate_fuel_consumption(double dt) {
    double left_fuel_rate = 0.0;
    double right_fuel_rate = 0.0;
    double fuel_alt_factor = FM::atmosphere_density / 1.225;
    double mach_factor = 1.0 + 0.5 * FM::mach; // Simple Mach increase

    if (FM::left_engine_switch) {
        if (FM::left_throttle_output <= 1.025) { // Adjust to match AB transition
            double throttle_factor = (FM::left_throttle_output - 0.67) / (1.025 - 0.67);
            left_fuel_rate = (0.28 + (1.5 - 0.4) * throttle_factor) * fuel_alt_factor * mach_factor; // MIL = 1.5 kg/s
        }
        else {
            double ab_factor = (FM::left_throttle_output - 1.025) / (1.1 - 1.025);
            left_fuel_rate = (1.5 + (6.5 - 1.5) * ab_factor) * fuel_alt_factor * mach_factor; // AB scales to 6.5 kg/s
        }
    }

    if (FM::right_engine_switch) {
        if (FM::right_throttle_output <= 1.025) {
            double throttle_factor = (FM::right_throttle_output - 0.67) / (1.025 - 0.67);
            right_fuel_rate = (0.28 + (1.5 - 0.4) * throttle_factor) * fuel_alt_factor * mach_factor;
        }
        else {
            double ab_factor = (FM::right_throttle_output - 1.025) / (1.1 - 1.025);
            right_fuel_rate = (1.5 + (6.5 - 1.5) * ab_factor) * fuel_alt_factor * mach_factor;
        }
    }

    FM::fuel_consumption_since_last_time = (left_fuel_rate + right_fuel_rate) * dt;

    if (FM::external_fuel > 0) FM::external_fuel -= limit(FM::fuel_consumption_since_last_time, 0, FM::external_fuel);
    else FM::internal_fuel -= limit(FM::fuel_consumption_since_last_time, 0, FM::internal_fuel);
    FM::total_fuel = FM::internal_fuel + FM::external_fuel;
}

void reset_fm_state() {
    // Control inputs and commands
    FM::pitch_input = FM::roll_input = FM::yaw_input = 0.0;
    FM::pitch_discrete = FM::roll_discrete = FM::yaw_discrete = 0.0;
    FM::pitch_analog = FM::roll_analog = FM::yaw_analog = true; // Default to analog
    FM::elevator_command = FM::aileron_command = FM::rudder_command = 0.0;
    FM::last_elevator_cmd = FM::last_aileron_cmd = FM::last_rudder_cmd = 0.0;
    FM::elevator_angle = FM::tv_angle = 0.0;
    FM::pitch_trim = FM::roll_trim = FM::yaw_trim = 0.0;
    FM::elevator_baseline = 0.0;

    // Engine and thrust
    FM::left_engine_switch = FM::right_engine_switch = false;
    FM::left_throttle_input = FM::right_throttle_input = 0.0;
    FM::left_throttle_output = FM::right_throttle_output = FM::idle_rpm; // 0.675
    FM::left_engine_power_readout = FM::right_engine_power_readout = 0.0;
    FM::left_thrust_force = FM::right_thrust_force = 0.0;
    FM::left_ab_timer = FM::right_ab_timer = 0.0;

    // FBW and autotrim
    FM::ref_roll = FM::ref_fpa = FM::ref_heading = 0.0;
    FM::roll_error_i = FM::pitch_error_i = FM::yaw_error_i = 0.0;
    FM::fpa_ref = FM::fpa_error_i = 0.0;
    FM::autotrim_active = false;
    FM::autotrim_delay_timer = FM::autotrim_check_timer = 0.0;
    FM::elevator_reset_timer = FM::no_input_timer = FM::neg_no_input_timer = FM::baseline_reset_timer = 0.0;

    // Motion states
    FM::velocity_world = Vec3(0, 0, 0);
    FM::airspeed = Vec3(0, 0, 0);
    FM::pitch_rate = FM::roll_rate = FM::yaw_rate = 0.0;
    FM::aoa = FM::aos = FM::alpha = FM::beta = 0.0;
    FM::pitch = FM::roll = FM::heading = 0.0;
    FM::g = 0.0;
    FM::V_scalar = 0.0;
    FM::mach = 0.0;

    // Damage and fuel
    FM::left_wing_integrity = FM::right_wing_integrity = FM::tail_integrity = 1.0;
    FM::left_engine_integrity = FM::right_engine_integrity = 1.0;
    FM::internal_fuel = 8164.66;
    FM::external_fuel = 0.0;
    FM::total_fuel = FM::internal_fuel;
    FM::fuel_consumption_since_last_time = 0.0;

    // Misc
    FM::fm_clock = 0.0;
    FM::sim_initialised = false;
    FM::shake_amplitude = 0.0;
    FM::on_ground = false;

    // Reset moved static variables
    FM::last_yaw_input = 0.0;
    FM::last_tv_cmd = 0.0;
    FM::last_pitch_input = 0.0;
    FM::last_g = 0.0;

    // Reset positions (ensure they’re zeroed relative to center_of_mass)
    FM::left_wing_pos = Vec3(0, 0, 0);
    FM::right_wing_pos = Vec3(0, 0, 0);
    FM::tail_pos = Vec3(0, 0, 0);
    FM::elevator_pos = Vec3(0, 0, 0);
    FM::left_aileron_pos = Vec3(0, 0, 0);
    FM::right_aileron_pos = Vec3(0, 0, 0);
    FM::rudder_pos = Vec3(0, 0, 0);
    FM::left_engine_pos = Vec3(0, 0, 0);
    FM::right_engine_pos = Vec3(0, 0, 0);
}

//#########################################
//#       Flight Module Simulation        #
//#########################################

void ed_fm_simulate(double dt) {
    FM::fm_clock += dt;
    FM::common_force = Vec3();
    FM::common_moment = Vec3();

    // Initialization block
    if (!FM::sim_initialised) {
        FM::left_wing_pos = Vec3(FM::center_of_mass.x - 0.5, FM::center_of_mass.y + 0.5, -FM::wingspan / 2);
        FM::right_wing_pos = Vec3(FM::center_of_mass.x - 0.5, FM::center_of_mass.y + 0.5, FM::wingspan / 2);
        FM::tail_pos = Vec3(FM::center_of_mass.x - 0.5, FM::center_of_mass.y, 0);
        FM::elevator_pos = Vec3(-FM::length / 2, FM::center_of_mass.y, 0);
        FM::left_aileron_pos = Vec3(FM::center_of_mass.x, FM::center_of_mass.y, -FM::wingspan * 0.5);
        FM::right_aileron_pos = Vec3(FM::center_of_mass.x, FM::center_of_mass.y, FM::wingspan * 0.5);
        FM::rudder_pos = Vec3(-FM::length / 2, FM::height / 2, 0);
        FM::left_engine_pos = Vec3(-3.793, 0, -0.716);
        FM::right_engine_pos = Vec3(-3.793, 0, 0.716);
        FM::elevator_command = FM::last_elevator_cmd = 0.0;
        FM::aileron_command = FM::last_aileron_cmd = 0.0;
        FM::rudder_command = FM::last_rudder_cmd = 0.0;
        FM::pitch_error_i = FM::roll_error_i = FM::yaw_error_i = 0.0;
        FM::last_yaw_input = 0.0;
        FM::elevator_angle = 0.0;
        FM::tv_angle = 0.0;
        FM::last_tv_cmd = 0.0;
        FM::fpa_ref = 0.0;
        FM::fpa_error_i = 0.0;
        FM::last_pitch_input = 0.0;
        FM::idle_rpm = 0.675;
        FM::autotrim_active = false;
        FM::elevator_baseline = 0.0;
        FM::last_pitch_rate = 0.0;
        FM::autotrim_delay_timer = 0.0;
        FM::autotrim_check_timer = 0.0;
        FM::last_g = 0.0;
        FM::elevator_reset_timer = 0.0;
        FM::no_input_timer = 0.0;
        FM::neg_no_input_timer = 0.0;
        FM::baseline_reset_timer = 0.0;
    }

    // Actuator updates
    FM::gear_pos = limit(actuator(FM::gear_pos, FM::gear_switch, -0.0015, 0.0015), 0, 1);
    FM::airbrake_pos = limit(actuator(FM::airbrake_pos, FM::airbrake_switch, -0.003, 0.004), 0, 1);
    FM::flaps_pos = FM::gear_pos;
    double slat_target = (FM::mach < 0.8) ? (FM::alpha - 10.0) / 10.0 : 0.0;
    FM::slats_pos = limit(actuator(FM::slats_pos, slat_target, -0.003, 0.003), 0, 1);

    // Airspeed and Mach calculation
    FM::airspeed.x = FM::velocity_world.x - FM::wind.x;
    FM::airspeed.y = FM::velocity_world.y - FM::wind.y;
    FM::airspeed.z = FM::velocity_world.z - FM::wind.z;
    FM::V_scalar = sqrt(FM::airspeed.x * FM::airspeed.x + FM::airspeed.y * FM::airspeed.y + FM::airspeed.z * FM::airspeed.z);
    FM::mach = FM::V_scalar / FM::speed_of_sound;

    double ias_ms = FM::V_scalar * sqrt(FM::atmosphere_density / 1.225);
    double ias_knots = ias_ms * 1.94384;

    // Aerodynamic coefficients
    double drag_direction = (fabs(FM::alpha) < 100.0) ? 1.0 : -1.0;
    double CyAlpha_ = lerp(FM_DATA::mach_table, FM_DATA::Cya, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
    double CyMax_ = lerp(FM_DATA::mach_table, FM_DATA::CyMax, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);

    if (fabs(FM::alpha) >= 15.0) {
        double vortex_boost = 0.75 * exp(-pow((fabs(FM::alpha) - 35.0), 2) / (2 * 600.0));
        if (fabs(FM::alpha) > 77.0) vortex_boost = 0;
        CyMax_ += vortex_boost;
    }

    CyMax_ += (FM_DATA::cy_flap * FM::slats_pos);
    double Cy = CyAlpha_ * FM::alpha;
    if (Cy > CyMax_) Cy = CyMax_;
    if (Cy < -CyMax_) Cy = -CyMax_;

    if (fabs(FM::alpha) >= 90.0) {
        double aoa_excess = fabs(FM::alpha) - 90.0;
        double lift_reduction = 1.0 - aoa_excess / 60.0;
        lift_reduction = limit(lift_reduction, 0.0, 1.0);
        Cy *= lift_reduction;
    }

    double CyBeta_ = lerp(FM_DATA::beta_table, FM_DATA::Cy_beta, sizeof(FM_DATA::beta_table) / sizeof(double), fabs(FM::beta));
    if (FM::alpha > 30.0) CyBeta_ *= 1.5;
    double Cy_tail = (0.5 * CyAlpha_ + FM_DATA::Czbe) * FM::beta + (FM::beta < 0 ? -CyBeta_ : CyBeta_);

    double Cx0_ = lerp(FM_DATA::mach_table, FM_DATA::cx0, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
    double Drag = Cx0_ + (FM_DATA::cx_brk * 1.2 * FM::airbrake_pos) + (FM_DATA::cx_flap * FM::flaps_pos) + (FM_DATA::cx_gear * FM::gear_pos);

    double AoA_drag = lerp(FM_DATA::AoA_table, FM_DATA::AoA_drag_factor, sizeof(FM_DATA::AoA_table) / sizeof(double), fabs(FM::alpha));
    Drag += AoA_drag;

    if (FM::gear_pos > 0.0 && ias_knots > 315.0) {
        double speed_excess = ias_knots - 315.0;
        double gear_drag_penalty = 0.02 * (speed_excess / 10.0) * FM::gear_pos;
        Drag += limit(gear_drag_penalty, 0.0, 0.2);
    }

    double AlphaMax_ = lerp(FM_DATA::mach_table, FM_DATA::Aldop, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);

    // Forces and moments
    double q = 0.5 * FM::atmosphere_density * FM::V_scalar * FM::V_scalar;
    double Lift = Cy + FM_DATA::Cy0 + (FM_DATA::cy_flap * FM::flaps_pos);
    double aos_effect = (fabs(FM::aos) < 0.05) ? 0 : sin(FM::aos / 2);

    Vec3 left_wing_forces(-Drag * drag_direction * (-aos_effect + 1) * q * (FM::S / 2) * FM::left_wing_integrity,
        Lift * (-aos_effect / 2 + 1) * q * (FM::S / 2) * FM::left_wing_integrity,
        Cy_tail * q * (FM::S / 2) * FM::left_wing_integrity);
    Vec3 right_wing_forces(-Drag * drag_direction * (aos_effect + 1) * q * (FM::S / 2) * FM::right_wing_integrity,
        Lift * (aos_effect / 2 + 1) * q * (FM::S / 2) * FM::right_wing_integrity,
        -Cy_tail * q * (FM::S / 2) * FM::right_wing_integrity);

    add_local_force(left_wing_forces, FM::left_wing_pos);
    add_local_force(right_wing_forces, FM::right_wing_pos);

    Vec3 tail_force(-Cy_tail * sin(FM::aoa) * (FM::S / 2) * q * FM::tail_integrity,
        0, -Cy_tail * cos(FM::aoa) * q * (FM::S / 2) * FM::tail_integrity);
    add_local_force(tail_force, FM::tail_pos);

    // Flight path and sideslip
    double fpa = atan2(FM::velocity_world.y, sqrt(FM::velocity_world.x * FM::velocity_world.x + FM::velocity_world.z * FM::velocity_world.z));
    double beta = FM::aos * FM::rad_to_deg;

    // Flight control constants
    const double fbw_scale = 1.0;
    const double max_rate = 40.0;
    double beta_gain = (FM::mach > 0.9) ? limit(0.1 * (FM::mach - 0.9) / 0.3, 0.0, 0.1) : 0.0;

    auto clamp = [](double value, double min_val, double max_val) {
        return std::max(min_val, std::min(max_val, value));
        };

    // Input sources
    double pitch_cmd_source = FM::pitch_analog ? FM::pitch_input : FM::pitch_discrete;
    double roll_cmd_source = FM::roll_analog ? FM::roll_input : FM::roll_discrete;
    double yaw_cmd_source = FM::yaw_analog ? FM::yaw_input : FM::yaw_discrete;

    // Takeoff baseline logic with smooth transition
    static bool ground_baseline_set = false;
    static double transition_timer = 0.0;
    const double transition_duration = 0.5; // Smooth transition over 0.5s
    static double autotrim_blend_timer = 0.0;
    const double autotrim_blend_duration = 0.3; // Smooth autotrim blend over 0.3s

    if (FM::on_ground && FM::ground_speed_knots < 130.0 && FM::pitch_trim == 0.0) {
        FM::elevator_baseline = 0.11;
        FM::autotrim_active = false;
        ground_baseline_set = true;
        transition_timer = 0.0;
        autotrim_blend_timer = 0.0; // Assuming this controls another blending aspect, reset here
    }
    else if (!FM::on_ground && ground_baseline_set) {
        transition_timer += dt;
        double blend_factor = (transition_timer < transition_duration) ? (transition_timer / transition_duration) : 1.0;

        // During transition, blend takeoff trim into autotrim
        if (transition_timer <= transition_duration) {
            FM::autotrim_active = true; // Start autotrim early
            double takeoff_contribution = 0.11 * (1.0 - blend_factor); // Decay takeoff trim
            // Autotrim will adjust FM::elevator_command below, using current value as baseline
            FM::elevator_baseline = takeoff_contribution;
        }
        else {
            ground_baseline_set = false; // Transition complete, fully on autotrim
            FM::elevator_baseline = 0.0; // Reset baseline, but not affecting command directly
        }
    }

    // Pitch control
    if (FM::fm_clock < 0.1) {
        FM::elevator_command = FM::aileron_command = FM::rudder_command = 0.0;
    }
    else {
        // Lookup damping coefficients from tables
        double Kd_pitch = lerp(FM_DATA::mach_table, FM_DATA::Kd_pitch, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
        double Kd_roll = lerp(FM_DATA::mach_table, FM_DATA::Kd_roll, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
        double Kd_yaw = lerp(FM_DATA::mach_table, FM_DATA::Kd_yaw, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);

        double pitch_sensitivity = 1.0;
        double tv_sensitivity = 1.2;
        double max_deflection_rate = 2.27;

        if (FM::mach >= 0.67) {
            double mach_diff = FM::mach - 0.67;
            pitch_sensitivity = 1.0 - 0.229 * mach_diff * mach_diff;
            pitch_sensitivity = limit(pitch_sensitivity, 0.3, 1.0);
        }

        if (FM::mach >= 0.67) {
            double mach_diff = FM::mach - 0.67;
            if (FM::mach >= 1.2) {
                tv_sensitivity = 0.0;
            }
            else {
                double range = 1.2 - 0.67;
                tv_sensitivity = 1.0 - (1.0 / (range * range)) * mach_diff * mach_diff;
                tv_sensitivity = limit(tv_sensitivity, 0.0, 1.0);
            }
        }

        double elevator_rate = lerp(FM_DATA::mach_table, FM_DATA::elevator_rate_table, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
        double tv_rate = lerp(FM_DATA::mach_table, FM_DATA::thrust_vector_rate, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);

        double max_elevator_deflection = lerp(FM_DATA::mach_table, FM_DATA::max_elevator_deflection, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
        double max_tv_deflection = lerp(FM_DATA::mach_table, FM_DATA::max_thrust_vector_deflection, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);

        double elevator_cmd = 0.0;
        double tv_pitch_cmd = 0.0;

        double pitch_rate_rad_s = FM::pitch_rate;
        double pitch_rate_change = (FM::pitch_rate - FM::last_pitch_rate) / dt;
        double g_rate = (FM::g - FM::last_g) / dt;
        FM::last_pitch_rate = FM::pitch_rate;
        FM::last_g = FM::g;

        // Auto corrections
        if (fabs(pitch_cmd_source) <= 0.05 && FM::alpha > 15.0 && FM::alpha < 60.0 && FM::pitch_trim == 0.0) {
            FM::no_input_timer += dt;
            if (FM::no_input_timer >= 3.0) {
                FM::baseline_reset_timer = 2.0;
                FM::no_input_timer = 3.0;
            }
        }
        else {
            FM::no_input_timer = 0.0;
        }

        if (fabs(pitch_cmd_source) <= 0.05 && FM::alpha < -15.0 && FM::alpha > -60.0 && FM::pitch_trim == 0.0) {
            FM::neg_no_input_timer += dt;
            if (FM::neg_no_input_timer >= 3.0) {
                FM::baseline_reset_timer = 2.0;
                FM::neg_no_input_timer = 3.0;
            }
        }
        else {
            FM::neg_no_input_timer = 0.0;
        }

        if (fabs(pitch_cmd_source) > 0.05 && fabs(FM::last_pitch_input) <= 0.05) {
            FM::autotrim_active = false;
            FM::elevator_baseline = FM::elevator_command;
            if (fabs(pitch_rate_rad_s) > FM::pitch_rate_threshold) {
                FM::autotrim_delay_timer = FM::autotrim_delay;
            }
            else {
                FM::autotrim_delay_timer = 0.0;
            }
        }
        else if (fabs(pitch_cmd_source) <= 0.05 && fabs(FM::last_pitch_input) > 0.05 &&
            fabs(FM::alpha) <= 15.0 && !FM::on_ground &&
            fabs(FM::roll) <= 1.2217 && FM::pitch_trim == 0.0) {
            if (FM::autotrim_delay_timer > 0.0) {
                FM::autotrim_delay_timer -= dt;
                if (FM::autotrim_delay_timer <= 0.0) {
                    FM::autotrim_active = true;
                    FM::autotrim_delay_timer = 0.0;
                }
            }
            else {
                FM::autotrim_active = true;
            }
            if (FM::pitch_trim == 0.0 &&
                ((FM::alpha >= 5.0 && FM::alpha <= 15.0 && fabs(FM::elevator_command) > 0.04) ||
                    (FM::alpha <= -5.0 && FM::alpha >= -15.0 && fabs(FM::elevator_command) > 0.04))) {
                FM::elevator_reset_timer = 2.0;
            }
        }

        if (!FM::autotrim_active) {
            FM::autotrim_check_timer += dt;
            if (FM::autotrim_check_timer >= FM::autotrim_check_interval &&
                fabs(FM::alpha) <= 15.0 && fabs(pitch_cmd_source) <= 0.05 && !FM::on_ground &&
                fabs(FM::roll) <= 1.2217 && FM::pitch_trim == 0.0) {
                FM::autotrim_active = true;
                FM::autotrim_check_timer = 0.0;
                if (FM::pitch_trim == 0.0 &&
                    ((FM::alpha >= 5.0 && FM::alpha <= 15.0 && fabs(FM::elevator_command) > 0.04) ||
                        (FM::alpha <= -5.0 && FM::alpha >= -15.0 && fabs(FM::elevator_command) > 0.04))) {
                    FM::elevator_reset_timer = 2.0;
                }
            }
        }

        if (FM::elevator_reset_timer > 0.0) {
            double target_elevator = (FM::elevator_command > 0) ? 0.02 : -0.02;
            double decay_rate = (FM::elevator_command - target_elevator) / 2.0;
            FM::elevator_command -= decay_rate * dt;
            FM::elevator_reset_timer -= dt;
            if (FM::elevator_reset_timer <= 0.0 || fabs(FM::elevator_command - target_elevator) < 0.001) {
                FM::elevator_command = target_elevator;
                FM::elevator_reset_timer = 0.0;
            }
        }

        if (FM::baseline_reset_timer > 0.0) {
            double decay_rate = FM::elevator_baseline / 2.0;
            FM::elevator_baseline -= decay_rate * dt;
            FM::baseline_reset_timer -= dt;
            if (FM::baseline_reset_timer <= 0.0 || fabs(FM::elevator_baseline) < 0.001) {
                FM::elevator_baseline = 0.0;
                FM::baseline_reset_timer = 0.0;
            }
            double elevator_cmd_target = FM::elevator_baseline;
            FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd_target - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
            FM::last_elevator_cmd = FM::elevator_command;
        }

        // Autotrim with blending
        if (FM::autotrim_active && !FM::on_ground && fabs(FM::roll) <= 1.2217 && FM::baseline_reset_timer == 0.0) {
            if (transition_timer > 0.0 && autotrim_blend_timer < autotrim_blend_duration) {
                autotrim_blend_timer += dt;
            }
            double blend_factor = (autotrim_blend_timer < autotrim_blend_duration) ? (autotrim_blend_timer / autotrim_blend_duration) : 1.0;

            double target_g = (fabs(FM::roll) > 0.0873) ? 1.0 / cos(FM::roll) : 1.0;
            target_g = limit(target_g, 1.0, 2.0);
            double g_error = target_g - FM::g;
            if (fabs(g_error) < 0.05) {
                elevator_cmd = FM::elevator_command;
            }
            else {
                double base_adjustment = 0.013 * g_error;
                double error_scale = (fabs(g_error) > 0.1) ? 2.0 : 0.5;
                double adjustment = base_adjustment * error_scale;
                double multiplier = 1.0;
                double abs_g_rate = fabs(g_rate);
                if (abs_g_rate > 0.03) multiplier = 3.3;
                else if (abs_g_rate > 0.01) multiplier = 2.2;
                adjustment *= multiplier;
                double damping = -g_rate * 0.15;
                adjustment += damping;
                double max_adjustment = 0.025 * dt;
                adjustment = limit(adjustment, -max_adjustment, max_adjustment);
                elevator_cmd = FM::elevator_command + adjustment;
            }
            FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
            FM::last_elevator_cmd = FM::elevator_command;
        }
        else {
            if (fabs(FM::roll) > 1.2217) {
                FM::autotrim_active = false;
                FM::elevator_command = 0.0;
            }
            double input_cmd = (pitch_cmd_source * fabs(pitch_cmd_source) * 1.1) * pitch_sensitivity;
            input_cmd += -FM::pitch_rate * Kd_pitch;
            elevator_cmd = FM::elevator_baseline + input_cmd;

            // TV at high AOA
            tv_pitch_cmd = (pitch_cmd_source * fabs(pitch_cmd_source) * 1.1) * tv_sensitivity;
            if (FM::alpha > 60.0) tv_pitch_cmd -= (FM::alpha - 60.0) * 0.025;
            if (FM::alpha < -60.0) tv_pitch_cmd += (-FM::alpha - 60.0) * 0.025;
            //testing
            /*if (ias_knots >= 95.0) {
                // Normal limits above 100 IAS
                if (FM::alpha > 60.0) tv_pitch_cmd -= (FM::alpha - 60.0) * 0.025;
                if (FM::alpha < -60.0) tv_pitch_cmd += (-FM::alpha - 60.0) * 0.025;
            }
            else {
                // Expanded limits below 100 IAS: 110° to 145°
                if (FM::alpha > 110.0) {
                    double reduction = (FM::alpha - 110.0) * (tv_pitch_cmd / (145.0 - 110.0));
                    tv_pitch_cmd -= limit(reduction, 0.0, tv_pitch_cmd); // Reduce to 0 by 145°
                }
                if (FM::alpha < -110.0) {
                    double reduction = (-FM::alpha - 110.0) * (-tv_pitch_cmd / (145.0 - 110.0));
                    tv_pitch_cmd += limit(reduction, 0.0, -tv_pitch_cmd); // Increase to 0 by -145°
                }
            }
            */
            
            
            tv_pitch_cmd += -FM::pitch_rate * 0.75;

            FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
            FM::last_elevator_cmd = FM::elevator_command;
        }

        // AoA and G limits
        double max_aoa = AlphaMax_;
        if (ias_knots >= 400.0) {
            double ias_limit_knots[] = { 375.0, 450.0, 650.0, 850.0, 1050.0, 1250.0 };
            double aoa_limit_values[] = { 30.25, 25.8, 18.2, 13.75, 12.7, 10.0 };
            const int ias_limit_size = sizeof(ias_limit_knots) / sizeof(double);
            max_aoa = lerp(ias_limit_knots, aoa_limit_values, ias_limit_size, ias_knots);
            if (ias_knots >= 1250.0) max_aoa = 3.15;

            if (FM::alpha > max_aoa && elevator_cmd > 0) {
                double aoa_error = FM::alpha - max_aoa;
                double aoa_correction = -aoa_error * 0.2;
                elevator_cmd += aoa_correction;
                elevator_cmd = limit(elevator_cmd, -1.0, 1.0);
            }
        }

        if (fabs(FM::alpha) > 60.0) {
            if (FM::alpha > 60.0 && pitch_cmd_source >= 0.0) {
                double alpha_excess = FM::alpha - 60.0;
                double max_pitch_rate = 0.785 * (1.0 - alpha_excess / 20.0);
                elevator_cmd = std::min(elevator_cmd, max_pitch_rate);
                if (FM::alpha >= 80.0) {
                    FM::elevator_command = FM::last_elevator_cmd;
                }
                else {
                    FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
                }
            }
            else if (FM::alpha < -40.0 && pitch_cmd_source < 0.0) {
                double alpha_excess = -FM::alpha - 40.0;
                double max_pitch_rate = 0.785 * (1.0 - alpha_excess / 15.0);
                elevator_cmd = std::max(elevator_cmd, -max_pitch_rate);
                if (FM::alpha <= -55.0) {
                    FM::elevator_command = FM::last_elevator_cmd;
                }
                else {
                    FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
                }
            }
            else {
                FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
            }
        }
        else {
            FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
        }

        const double g_limit_pos = 12.0;
        const double g_limit_neg = -4.0;
        const double g_reduction_factor = 0.1;

        if (FM::g > g_limit_pos && elevator_cmd > 0.0) {
            double g_excess = FM::g - g_limit_pos;
            elevator_cmd -= g_excess * g_reduction_factor;
            elevator_cmd = std::max(elevator_cmd, 0.0);
        }
        else if (FM::g < g_limit_neg && elevator_cmd < 0.0) {
            double g_excess = g_limit_neg - FM::g;
            elevator_cmd += g_excess * g_reduction_factor;
            elevator_cmd = std::min(elevator_cmd, 0.0);
        }

        FM::elevator_command = limit(FM::last_elevator_cmd + limit(elevator_cmd - FM::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
        FM::last_elevator_cmd = FM::elevator_command;

        double tv_command = limit(FM::last_tv_cmd + limit(tv_pitch_cmd - FM::last_tv_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);

        FM::last_pitch_input = pitch_cmd_source;
        FM::last_tv_cmd = tv_command;

        // Control surface deflections
        double target_elevator_angle = -FM::elevator_command * FM::rad(max_elevator_deflection);
        double elevator_step = elevator_rate * dt;
        if (FM::elevator_angle < target_elevator_angle) {
            FM::elevator_angle = std::min<double>(FM::elevator_angle + elevator_step, target_elevator_angle);
        }
        else if (FM::elevator_angle > target_elevator_angle) {
            FM::elevator_angle = std::max<double>(FM::elevator_angle - elevator_step, target_elevator_angle);
        }

        double target_tv_angle = -tv_command * FM::rad(max_tv_deflection);
        double tv_step = tv_rate * dt;
        if (FM::tv_angle < target_tv_angle) {
            FM::tv_angle = std::min<double>(FM::tv_angle + tv_step, target_tv_angle);
        }
        else if (FM::tv_angle > target_tv_angle) {
            FM::tv_angle = std::max<double>(FM::tv_angle - tv_step, target_tv_angle);
        }

        double roll_cmd = roll_cmd_source * fabs(roll_cmd_source);
        double roll_damping = -FM::roll_rate * Kd_roll;
        roll_cmd += roll_damping;
        FM::aileron_command = limit(FM::last_aileron_cmd + limit(roll_cmd - FM::last_aileron_cmd, -FM::max_aileron_rate * dt, FM::max_aileron_rate * dt), -1.0, 1.0);
        FM::last_aileron_cmd = FM::aileron_command;

        double yaw_cmd;
        if (fabs(yaw_cmd_source) < 0.01) {
            yaw_cmd = -FM::yaw_rate * Kd_yaw - clamp(FM::beta, -3.0, 3.0) * clamp(FM::last_yaw_input, 0.0, 0.3);
            yaw_cmd -= beta_gain * FM::beta;
            if (FM::alpha > 10.0) {
                double pitch_yaw_coupling = -FM::pitch_rate * 0.11 * (FM::alpha / AlphaMax_);
                yaw_cmd += limit(pitch_yaw_coupling, -0.5, 0.5);
            }
            FM::last_yaw_input -= dt / 0.5;
            if (FM::last_yaw_input < 0.0) FM::last_yaw_input = 0.0;
        }
        else {
            yaw_cmd = 0.5 * yaw_cmd_source * sqrt(fabs(yaw_cmd_source)) - FM::yaw_rate * Kd_yaw;
            yaw_cmd -= beta_gain * FM::beta * 0.5;
            FM::last_yaw_input = 0.5 * fabs(yaw_cmd_source);
        }
        FM::rudder_command = limit(FM::last_rudder_cmd + limit(yaw_cmd - FM::last_rudder_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
        FM::last_rudder_cmd = FM::rudder_command;

        // Apply control surface forces
        add_local_force(Vec3(0, FM::elevator_angle * q * FM::S * 0.4, 0), FM::elevator_pos);
        double aileron_deflection = FM::aileron_command * FM::rad(30);
        add_local_force(Vec3(0, aileron_deflection * q * FM::S * 0.20, 0), FM::left_aileron_pos);
        add_local_force(Vec3(0, -aileron_deflection * q * FM::S * 0.20, 0), FM::right_aileron_pos);
        double rudder_deflection = FM::rudder_command * FM::rad(25 + (FM::mach < 0.5 ? 5.0 : 0.0));
        add_local_force(Vec3(0, 0, rudder_deflection * q * FM::S * 0.25), FM::rudder_pos);

        double left_tv_force = FM::left_thrust_force * FM::left_throttle_output * sin(FM::tv_angle);
        double right_tv_force = FM::right_thrust_force * FM::right_throttle_output * sin(FM::tv_angle);
        add_local_force(Vec3(FM::left_thrust_force * cos(FM::tv_angle), left_tv_force, 0), FM::left_engine_pos);
        add_local_force(Vec3(FM::right_thrust_force * cos(FM::tv_angle), right_tv_force, 0), FM::right_engine_pos);
    }

    // Thrust definitions
    double idle_thrust = lerp(FM_DATA::mach_table, FM_DATA::idle_thrust, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
    double max_dry_thrust_base = lerp(FM_DATA::mach_table, FM_DATA::max_thrust, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
    double max_ab_thrust_base = lerp(FM_DATA::mach_table, FM_DATA::ab_thrust, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);

    const double static_max_dry_thrust = 112654.0;
    const double static_max_ab_thrust = 155688.0;

    double max_dry_thrust = FM::on_ground ? static_max_dry_thrust : max_dry_thrust_base;
    double max_ab_thrust = FM::on_ground ? static_max_ab_thrust : max_ab_thrust_base;

    double dry_range = max_dry_thrust - idle_thrust;
    double ab_range = max_ab_thrust - max_dry_thrust;
    const double ab_spool_time = 1.1;
    const double spool_up_rate = 0.1383;
    const double spool_down_rate = 0.155;

    FM::left_throttle_input = limit(FM::left_throttle_input, 0, 1);
    FM::right_throttle_input = limit(FM::right_throttle_input, 0, 1);

    double thrust_alt_factor = FM::atmosphere_density / 1.225;

    // Left engine logic
    if (!FM::left_engine_switch) {
        FM::left_throttle_output = 0.0;
        FM::left_engine_power_readout = 0;
        FM::left_ab_timer = 0;
        FM::left_thrust_force = 0.0;
    }
    else {
        double left_target_throttle = 0.67 + (FM::left_throttle_input * 0.43);
        double delta = left_target_throttle - FM::left_throttle_output;
        double rate = (delta > 0) ? spool_up_rate : -spool_down_rate;
        FM::left_throttle_output += limit(delta, -spool_down_rate * dt, spool_up_rate * dt);
        FM::left_throttle_output = limit(FM::left_throttle_output, 0.67, 1.1);
        FM::left_engine_power_readout = FM::left_throttle_output;
        if (FM::left_throttle_output >= 1.035 && left_target_throttle > 1.035) {
            FM::left_ab_timer += dt / ab_spool_time;
        }
        else {
            FM::left_ab_timer -= dt / ab_spool_time;
        }
        FM::left_ab_timer = limit(FM::left_ab_timer, 0, 1);

        if (FM::left_throttle_output <= 1.025) {
            double norm_throttle = (FM::left_throttle_output - 0.67) / 0.355;
            double thrust_factor = norm_throttle * norm_throttle;
            FM::left_thrust_force = (idle_thrust + dry_range * thrust_factor) * thrust_alt_factor * FM::left_engine_integrity;
        }
        else {
            double norm_throttle = (FM::left_throttle_output - 1.025) / 0.075;
            double thrust_factor;
            if (norm_throttle <= 0.0667) {
                thrust_factor = 0.0;
            }
            else {
                double adjusted_throttle = (norm_throttle - 0.0667) / (1.0 - 0.0667);
                thrust_factor = adjusted_throttle * adjusted_throttle;
            }
            FM::left_thrust_force = (max_dry_thrust + ab_range * thrust_factor * FM::left_ab_timer) * thrust_alt_factor * FM::left_engine_integrity;
        }
    }

    // Right engine logic
    if (!FM::right_engine_switch) {
        FM::right_throttle_output = 0.0;
        FM::right_engine_power_readout = 0;
        FM::right_ab_timer = 0;
        FM::right_thrust_force = 0.0;
    }
    else {
        double right_target_throttle = 0.67 + (FM::right_throttle_input * 0.43);
        double delta = right_target_throttle - FM::right_throttle_output;
        double rate = (delta > 0) ? spool_up_rate : -spool_down_rate;
        FM::right_throttle_output += limit(delta, -spool_down_rate * dt, spool_up_rate * dt);
        FM::right_throttle_output = limit(FM::right_throttle_output, 0.67, 1.1);
        FM::right_engine_power_readout = FM::right_throttle_output;
        if (FM::right_throttle_output >= 1.035 && right_target_throttle > 1.035) {
            FM::right_ab_timer += dt / ab_spool_time;
        }
        else {
            FM::right_ab_timer -= dt / ab_spool_time;
        }
        FM::right_ab_timer = limit(FM::right_ab_timer, 0, 1);

        if (FM::right_throttle_output <= 1.025) {
            double norm_throttle = (FM::right_throttle_output - 0.67) / 0.355;
            double thrust_factor = norm_throttle * norm_throttle;
            FM::right_thrust_force = (idle_thrust + dry_range * thrust_factor) * thrust_alt_factor * FM::right_engine_integrity;
        }
        else {
            double norm_throttle = (FM::right_throttle_output - 1.025) / 0.075;
            double thrust_factor;
            if (norm_throttle <= 0.0667) {
                thrust_factor = 0.0;
            }
            else {
                double adjusted_throttle = (norm_throttle - 0.0667) / (1.0 - 0.0667);
                thrust_factor = adjusted_throttle * adjusted_throttle;
            }
            FM::right_thrust_force = (max_dry_thrust + ab_range * thrust_factor * FM::right_ab_timer) * thrust_alt_factor * FM::right_engine_integrity;
        }
    }

    FM::left_engine_power_readout *= FM::left_engine_integrity;
    FM::right_engine_power_readout *= FM::right_engine_integrity;

    // Engine shutdown conditions
    if (FM::internal_fuel <= 0 || FM::altitude_ASL > 24000) {
        FM::left_thrust_force = 0;
        FM::right_thrust_force = 0;
        FM::left_engine_switch = false;
        FM::right_engine_switch = false;
        FM::left_engine_power_readout = 0;
        FM::right_engine_power_readout = 0;
        FM::left_ab_timer = 0;
        FM::right_ab_timer = 0;
    }

    if (!FM::infinite_fuel) simulate_fuel_consumption(dt);

    // Stability moments
    double roll_yaw_moment = -(FM::roll_rate / 2) * (q + 1e5 * 0.5);
    add_local_moment(Vec3(0, roll_yaw_moment, 0));
    double OmxMax_ = lerp(FM_DATA::mach_table, FM_DATA::OmxMax, sizeof(FM_DATA::mach_table) / sizeof(double), FM::mach);
    double roll_limit_factor = pow(limit(fabs(FM::roll_rate) / (OmxMax_ * 1.2), 0.0001, 1.0), 2);
    double roll_rate_limiter = -FM::roll_rate * limit(pow((limit(fabs(FM::roll_rate) / (OmxMax_ + 0.1), 0.0001, 2)), 6) * (q + q + 1e5 * 0.5), -1e7, 1e7);
    add_local_moment(Vec3(roll_rate_limiter, 0, 0));
    double yaw_rate_limiter = -(FM::yaw_rate + FM::aos) * (q + 1e5 * 0.5);
    add_local_moment(Vec3(0, yaw_rate_limiter, 0));

    if (FM::easy_flight) {
        add_local_moment(Vec3(-(FM::roll_rate / 4) * (1 - sqrt(fabs(FM::aileron_command))) * (1e5 + q * 0.5),
            -(FM::yaw_rate + (sin(FM::aoa) / 2)) * (1 - sqrt(fabs(FM::rudder_command))) * (1e5 + q * 0.5),
            -(FM::pitch_rate + (sin(FM::aoa) / 2)) * (1 - sqrt(fabs(FM::elevator_command))) * (1e5 + q * 0.5)));
        add_local_force(Vec3(0, 0, -FM::rudder_command * (1e5 * q * 0.1)), Vec3(FM::center_of_mass.x - 0.2, FM::center_of_mass.y, 0));
    }

    // Ground condition
    FM::on_ground = (FM::gear_pos > 0.5 && FM::altitude_AGL < 50.0 && FM::mach < 0.3);

    // Ground speed
    double ground_vel_x = FM::velocity_world.x - FM::wind.x;
    double ground_vel_z = FM::velocity_world.z - FM::wind.z;
    FM::ground_speed_knots = sqrt(ground_vel_x * ground_vel_x + ground_vel_z * ground_vel_z) * 1.94384;

    // Shake amplitude
    FM::shake_amplitude = 0;
    FM::shake_amplitude += limit((FM_DATA::cx_brk + 1) * FM::airbrake_pos * FM::mach, 0, 2) / 6;
    if (!FM::on_ground) {
        if (fabs(FM::alpha) > 90) FM::shake_amplitude += (fabs(FM::alpha) - 90) / 100;
        if (fabs(FM::beta) > 10) FM::shake_amplitude += (fabs(FM::beta) - 10) / 100;
        if (fabs(FM::g) > 12.5) FM::shake_amplitude += (fabs(FM::g) - 12.5) / 100;
        if (FM::mach > 2.31) FM::shake_amplitude += (FM::mach - 2.31) / 2;
    }

    FM::sim_initialised = true;
}

//#########################################
//#     Flight Module Simulation End      #
//#########################################

void ed_fm_set_atmosphere(double h, double t, double a, double ro, double p, double wind_vx, double wind_vy, double wind_vz) {
    FM::wind = Vec3(wind_vx, wind_vy, wind_vz);
    FM::atmosphere_density = ro;
    FM::speed_of_sound = a;
    FM::altitude_ASL = h;
    FM::engine_alt_effect = FM::atmosphere_density / 1.225;
    FM::atmosphere_temperature = t;
    FM::interface.setParamNumber(FM::fm_export_temperature, t + 273);
}

void ed_fm_set_surface(double h, double h_obj, unsigned surface_type, double normal_x, double normal_y, double normal_z) {
    FM::altitude_AGL = FM::altitude_ASL - (h + h_obj * 0.5);

}

void ed_fm_set_current_mass_state(double mass, double center_of_mass_x, double center_of_mass_y, double center_of_mass_z,
    double moment_of_inertia_x, double moment_of_inertia_y, double moment_of_inertia_z) {
    FM::center_of_mass = Vec3(center_of_mass_x, center_of_mass_y, center_of_mass_z);
    mass = FM::empty_mass + FM::total_fuel; // ~27,864 kg with full fuel
    moment_of_inertia_x = FM::Ixx;  // 30,000 kg·m²
    moment_of_inertia_y = FM::Iyy;  // 350,000 kg·m²
    moment_of_inertia_z = FM::Izz;  // 300,000 kg·m²
}

void ed_fm_set_current_state(double ax, double ay, double az, double vx, double vy, double vz, double px, double py, double pz,
    double omegadotx, double omegadoty, double omegadotz, double omegax, double omegay, double omegaz,
    double quaternion_x, double quaternion_y, double quaternion_z, double quaternion_w) {
    FM::velocity_world = Vec3(vx, vy, vz);
}

void ed_fm_set_current_state_body_axis(double ax, double ay, double az, double vx, double vy, double vz, double wind_vx, double wind_vy, double wind_vz,
    double omegadotx, double omegadoty, double omegadotz, double omegax, double omegay, double omegaz,
    double yaw, double pitch, double roll, double common_angle_of_attack, double common_angle_of_slide) {
    FM::aoa = common_angle_of_attack;
    FM::alpha = FM::aoa * FM::rad_to_deg;
    FM::aos = common_angle_of_slide;
    FM::beta = FM::aos * FM::rad_to_deg;
    FM::g = (ay / 9.81) + 1;
    FM::pitch = pitch;
    FM::roll = roll;
    FM::heading = yaw;
    FM::roll_rate = omegax;
    FM::yaw_rate = omegay;
    FM::pitch_rate = omegaz;
}

void ed_fm_set_command(int command, float value) {
    double ias_ms = FM::V_scalar * sqrt(FM::atmosphere_density / 1.225);
    double ias_knots_local = ias_ms * 1.94384;
    switch (command) {
    case JoystickPitch:
        FM::pitch_input = limit(value, -1, 1);
        FM::pitch_analog = true;
        FM::pitch_discrete = 0;
        break;
    case PitchUp: FM::pitch_discrete = 1; FM::pitch_analog = false; break;
    case PitchUpStop: FM::pitch_discrete = 0; FM::pitch_analog = false; break;
    case PitchDown: FM::pitch_discrete = -1; FM::pitch_analog = false; break;
    case PitchDownStop: FM::pitch_discrete = 0; FM::pitch_analog = false; break;
    case trimUp:
        FM::elevator_baseline = limit(FM::elevator_baseline + 0.01, -1.0, 1.0);
        FM::pitch_trim = 1.0; // Set to non-zero to indicate manual trim
        FM::autotrim_active = false;
        FM::elevator_reset_timer = 0.0; // Reset timer
        break;
    case trimDown:
        FM::elevator_baseline = limit(FM::elevator_baseline - 0.01, -1.0, 1.0);
        FM::pitch_trim = -1.0; // Set to non-zero
        FM::autotrim_active = false;
        FM::elevator_reset_timer = 0.0; // Reset timer
        break;
    case resetTrim:
        FM::pitch_trim = FM::roll_trim = FM::yaw_trim = 0;
        FM::elevator_baseline = 0;
        FM::autotrim_active = !FM::on_ground;;
        FM::fpa_ref = atan2(FM::velocity_world.y, sqrt(FM::velocity_world.x * FM::velocity_world.x + FM::velocity_world.z * FM::velocity_world.z));
        break;

    case JoystickRoll:
        FM::roll_input = limit(value, -1, 1);
        FM::roll_analog = true;
        FM::roll_discrete = 0;
        break;
    case RollLeft: FM::roll_discrete = -1; FM::roll_analog = false; break;
    case RollLeftStop: FM::roll_discrete = 0; FM::roll_analog = false; break;
    case RollRight: FM::roll_discrete = 1; FM::roll_analog = false; break;
    case RollRightStop: FM::roll_discrete = 0; FM::roll_analog = false; break;
    case trimLeft: FM::roll_trim -= 0.001; break;
    case trimRight: FM::roll_trim += 0.001; break;

    case PedalYaw: FM::yaw_input = limit(-value, -1, 1); FM::yaw_discrete = 0; FM::yaw_analog = true; break;
    case rudderleft: FM::yaw_discrete = 1; FM::yaw_analog = false; break;
    case rudderleftstop: FM::yaw_discrete = 0; FM::yaw_analog = false; break;
    case rudderright: FM::yaw_discrete = -1; FM::yaw_analog = false; break;
    case rudderrightstop: FM::yaw_discrete = 0; FM::yaw_analog = false; break;
    case ruddertrimLeft: FM::yaw_trim += 0.001; break;
    case ruddertrimRight: FM::yaw_trim -= 0.001; break;
    case EnginesOn: FM::left_engine_switch = FM::right_engine_switch = true; break;
    case LeftEngineOn: FM::left_engine_switch = true; break;
    case RightEngineOn: FM::right_engine_switch = true; break;
    case EnginesOff: FM::left_engine_switch = FM::right_engine_switch = false; break;
    case LeftEngineOff: FM::left_engine_switch = false; break;
    case RightEngineOff: FM::right_engine_switch = false; break;

    case ThrottleAxis:
        FM::left_throttle_input = FM::right_throttle_input = limit(-value + 1, 0, 2) / 2;
        break;
    case ThrottleAxisLeft:
        FM::left_throttle_input = limit(-value + 1, 0, 2) / 2;
        break;
    case ThrottleAxisRight:
        FM::right_throttle_input = limit(-value + 1, 0, 2) / 2;
        break;
    case ThrottleIncrease: FM::left_throttle_input += 0.0075; FM::right_throttle_input += 0.0075; break;
    case ThrottleLeftUp: FM::left_throttle_input += 0.0075; break;
    case ThrottleRightUp: FM::right_throttle_input += 0.0075; break;
    case ThrottleDecrease: FM::left_throttle_input -= 0.0075; FM::right_throttle_input -= 0.0075; break;
    case ThrottleLeftDown: FM::left_throttle_input -= 0.0075; break;
    case ThrottleRightDown: FM::right_throttle_input -= 0.0075; break;

    case AirBrakes: FM::airbrake_switch = !FM::airbrake_switch; break;
    case AirBrakesOff: FM::airbrake_switch = false; break;
    case AirBrakesOn: FM::airbrake_switch = true; break;

    case flapsToggle: FM::flaps_switch = !FM::flaps_switch; break;
    case flapsDown: FM::flaps_switch = false; break;
    case flapsUp: FM::flaps_switch = true; break;

    case gearToggle:
        if (!FM::on_ground && ias_knots_local <= 275.0) { // Use local IAS
            FM::gear_switch = !FM::gear_switch;
        }
        break;
    case gearDown:
        if (ias_knots_local <= 275.0) {
            FM::gear_switch = true;
        }
        break;
    case gearUp:
        if (ias_knots_local >= 140.0) {
            FM::gear_switch = false;
        }
        break;
    case WheelBrakeOn: FM::wheel_brake = 1; break;
    case WheelBrakeOff: FM::wheel_brake = 0; break;

    case 10505: // Taxi Lights
        FM::taxi_lights = !FM::taxi_lights;
        break;
    case 10506: // Landing Lights
        FM::landing_lights = !FM::landing_lights;
        break;
    case 10507: // Form Light
        FM::form_light = !FM::form_light;
        break;
    case 10508: // Nav White
        FM::nav_white = !FM::nav_white;
        break;
    case 10509: // Anti Collision
        FM::anti_collision = !FM::anti_collision;
        break;
    case 10510: // AAR Light
        FM::aar_light = !FM::aar_light;
        break;
    case 10511: // Nav Lights (both 612 and 613)
        FM::nav_lights = !FM::nav_lights;
        break;
    case 10512: // Toggle All External Lights
        // Check if any light is on; if so, turn all off; otherwise, turn all on
        bool any_on = FM::nav_white || FM::anti_collision_blink || FM::nav_lights_blink;
        FM::nav_white = !any_on;
        FM::anti_collision_blink = !any_on;
        FM::nav_lights_blink = !any_on;
        break;
    }
}

bool ed_fm_change_mass(double& delta_mass, double& delta_mass_pos_x, double& delta_mass_pos_y, double& delta_mass_pos_z,
    double& delta_mass_moment_of_inertia_x, double& delta_mass_moment_of_inertia_y, double& delta_mass_moment_of_inertia_z) {
    if (FM::fuel_consumption_since_last_time > 0) {
        delta_mass = FM::fuel_consumption_since_last_time;
        delta_mass_pos_x = -1.0;
        delta_mass_pos_y = 1.0;
        delta_mass_pos_z = 0;
        delta_mass_moment_of_inertia_x = delta_mass_moment_of_inertia_y = delta_mass_moment_of_inertia_z = 0;
        FM::fuel_consumption_since_last_time = 0;
        return true;
    }
    return false;
}

void ed_fm_set_internal_fuel(double fuel) {
    FM::internal_fuel = 8164.66;
    FM::total_fuel = FM::internal_fuel + FM::external_fuel;
}

double ed_fm_get_internal_fuel() {
    return FM::internal_fuel;
}

void ed_fm_set_external_fuel(int station, double fuel, double x, double y, double z) {
    FM::external_fuel = fuel;
    FM::total_fuel = FM::internal_fuel + FM::external_fuel;
}

double ed_fm_get_external_fuel() {
    return FM::external_fuel;
}

void ed_fm_set_draw_args(EdDrawArgument* drawargs, size_t size) {
    drawargs[0].f = (float)limit(FM::gear_pos, 0, 1);
    drawargs[3].f = (float)limit(FM::gear_pos, 0, 1);
    drawargs[5].f = (float)limit(FM::gear_pos, 0, 1);
    drawargs[83].f = (float)limit(FM::gear_switch, -1, 1);

    drawargs[15].f = (float)limit(FM::elevator_command - (FM::aileron_command * 0.38f), -1, 1); //reduced as TV animation is tied to elevator
    drawargs[16].f = (float)limit(FM::elevator_command + (FM::aileron_command * 0.4f), -1, 1);

    drawargs[11].f = (float)limit(FM::aileron_command, -1, 1);
    drawargs[12].f = (float)limit(-FM::aileron_command, -1, 1);
    drawargs[17].f = (float)limit(FM::rudder_command, -1, 1);
    drawargs[18].f = (float)limit(FM::rudder_command, -1, 1);

    drawargs[182].f = (float)limit(FM::airbrake_pos, 0, 1);

    drawargs[9].f = (float)limit(FM::flaps_pos, 0, 1);
    drawargs[10].f = (float)limit(FM::flaps_pos, 0, 1);

    drawargs[29].f = (float)(FM::left_ab_timer > 0.95 ? 1.0 : 0.0);
    drawargs[28].f = (float)(FM::right_ab_timer > 0.95 ? 1.0 : 0.0);
    if (!FM::left_engine_switch) {
        drawargs[611].f = 1.0f; // Engine off, largest diameter
    }
    else {
        float throttle = FM::left_throttle_output;
        if (throttle < 0.67) {
            drawargs[611].f = 1.0f; // Shouldn't occur if engine is on, but included for safety
        }
        else if (throttle < 0.99) {
            // Interpolate from 0.5 (idle) to 0.0 (70% throttle)
            drawargs[611].f = 0.30f - (0.30f - 0.0f) * (throttle - 0.67f) / (0.99f - 0.67f);
        }
        else {
            // 70% throttle through afterburner, constant at 0.0
            drawargs[611].f = 0.0f;
        }
        drawargs[611].f = limit(drawargs[611].f, 0.0f, 1.0f); // Ensure value stays within valid range
    }

    // Right engine nozzle (index 610)
    if (!FM::right_engine_switch) {
        drawargs[610].f = 1.0f; // Engine off, largest diameter
    }
    else {
        float throttle = FM::right_throttle_output;
        if (throttle < 0.67) {
            drawargs[610].f = 1.0f; // Shouldn't occur if engine is on, but included for safety
        }
        else if (throttle < 0.99) {
            // Interpolate from 0.5 (idle) to 0.0 (70% throttle)
            drawargs[610].f = 0.30f - (0.30f - 0.0f) * (throttle - 0.67f) / (0.99f - 0.67f);
        }
        else {
            // 70% throttle through afterburner, constant at 0.0
            drawargs[610].f = 0.0f;
        }
        drawargs[610].f = limit(drawargs[610].f, 0.0f, 1.0f); // Ensure value stays within valid range
    }
    //Wheel Rotation
    double speed_mps = FM::ground_speed_knots / 1.94384;
    double dt = 1.0 / 60.0;
    double nose_circumference = 3.14159 * 1.95;
    double nose_rps = speed_mps / nose_circumference;
    FM::nose_wheel_rotation += nose_rps * dt * 360.0 / 360.0;
    FM::nose_wheel_rotation = fmod(FM::nose_wheel_rotation, 1.0);
    if (FM::nose_wheel_rotation < 0) FM::nose_wheel_rotation += 1.0;
    double main_circumference = 3.14159 * 2.60;
    double main_rps = speed_mps / main_circumference;
    FM::left_wheel_rotation += main_rps * dt * 360.0 / 360.0;
    FM::right_wheel_rotation += main_rps * dt * 360.0 / 360.0;
    FM::left_wheel_rotation = fmod(FM::left_wheel_rotation, 1.0);
    FM::right_wheel_rotation = fmod(FM::right_wheel_rotation, 1.0);
    if (FM::left_wheel_rotation < 0) FM::left_wheel_rotation += 1.0;
    if (FM::right_wheel_rotation < 0) FM::right_wheel_rotation += 1.0;
    drawargs[619].f = 0.5; //dark tint - testing blackscreen issue
    drawargs[620].f = 0.0; //no garfield - testing blackscreen issue
    drawargs[621].f = 0.2; //visor - testing blackscreen issue
    //lights - interfere with cockpit scripts. placeholder for now
    /*drawargs[604].f = FM::taxi_lights ? 1.0f : 0.0f;        // Taxi Lights
    drawargs[605].f = FM::landing_lights ? 1.0f : 0.0f;     // Landing Lights
    drawargs[606].f = FM::form_light ? 1.0f : 0.0f;         // Form Light
    drawargs[607].f = FM::nav_white ? 1.0f : 0.0f;          // Nav White
    drawargs[608].f = FM::anti_collision ? 1.0f : 0.0f;     // Anti Collision
    drawargs[609].f = FM::aar_light ? 1.0f : 0.0f;          // AAR Light
    drawargs[612].f = FM::nav_lights ? 0.9f : 0.0f;         // Nav Lights
    drawargs[613].f = FM::nav_lights ? 0.95f : 0.0f;        // Nav Lights
    */
}

void ed_fm_configure(const char* cfg_path) {}

double ed_fm_get_param(unsigned index) {
    switch (index) {
    case ED_FM_SUSPENSION_0_WHEEL_YAW:
    {
        double yaw_source = FM::yaw_analog ? FM::yaw_input : FM::yaw_discrete;
        double ground_speed_knots = FM::ground_speed_knots;
        double max_steering_rad = 0.0;

        if (FM::on_ground) {
            if (ground_speed_knots <= 8.0) {
                max_steering_rad = FM::rad(60.0); // ±60° up to 8 knots
            }
            else if (ground_speed_knots <= 30.0) {
                // Taper from 60° at 8 knots to 25° at 30 knots
                double slope = (FM::rad(25.0) - FM::rad(60.0)) / (30.0 - 8.0); // ~-0.072 rad/knot
                max_steering_rad = FM::rad(60.0) + slope * (ground_speed_knots - 8.0);
            }
            else if (ground_speed_knots <= 60.0) {
                max_steering_rad = FM::rad(25.0); // Flat at 25° from 30 to 60 knots
            }
            // Above 60 knots: max_steering_rad = 0.0
        }
        return limit(yaw_source, -1.0, 1.0) * max_steering_rad;
    }
    case ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT: return FM::wheel_brake; // Nose wheel
    case ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT: return FM::wheel_brake; // Rear left
    case ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT: return FM::wheel_brake; // Rear right
    case ED_FM_ANTI_SKID_ENABLE: return true;
    case ED_FM_FC3_STICK_PITCH: return limit(FM::pitch_input / 2, -1.0, 1.0);
    case ED_FM_FC3_STICK_ROLL: return limit(FM::roll_input, -1.0, 1.0);
    case ED_FM_FC3_RUDDER_PEDALS: return limit(-FM::yaw_input, -1.0, 1.0);
    case ED_FM_FC3_THROTTLE_LEFT:
        return FM::left_throttle_output;
    case ED_FM_FC3_THROTTLE_RIGHT:
        return FM::right_throttle_output;
    case ED_FM_FUEL_INTERNAL_FUEL: return FM::internal_fuel;
    case ED_FM_FUEL_TOTAL_FUEL: return FM::total_fuel;
    case ED_FM_OXYGEN_SUPPLY: return 101000.0;
    case ED_FM_FLOW_VELOCITY: return 10.0;

    case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
    case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
    case ED_FM_SUSPENSION_2_GEAR_POST_STATE: return FM::gear_pos;

    case ED_FM_ENGINE_0_RPM:
    case ED_FM_ENGINE_0_RELATED_RPM: return 1;
    case ED_FM_ENGINE_0_THRUST:
    case ED_FM_ENGINE_0_RELATED_THRUST: return 0;

    case ED_FM_ENGINE_1_CORE_RPM:
    case ED_FM_ENGINE_1_RPM: return FM::left_engine_power_readout;
    case ED_FM_ENGINE_1_COMBUSTION: return FM::left_engine_switch ? 1.0 : 0.0;
    case ED_FM_ENGINE_1_RELATED_THRUST:
    case ED_FM_ENGINE_1_CORE_RELATED_THRUST:
    case ED_FM_ENGINE_1_RELATED_RPM: return FM::left_throttle_output;
    case ED_FM_ENGINE_1_CORE_RELATED_RPM: return FM::left_engine_power_readout;  //reads RPM for avionics
    case ED_FM_ENGINE_1_CORE_THRUST:
    case ED_FM_ENGINE_1_THRUST: return FM::left_thrust_force;
    case ED_FM_ENGINE_1_TEMPERATURE: return (pow(FM::left_engine_power_readout, 3) * 300) + FM::atmosphere_temperature;

    case ED_FM_ENGINE_2_CORE_RPM:
    case ED_FM_ENGINE_2_RPM: return FM::right_engine_power_readout;
    case ED_FM_ENGINE_2_COMBUSTION: return FM::right_engine_switch ? 1.0 : 0.0;
    case ED_FM_ENGINE_2_RELATED_THRUST:
    case ED_FM_ENGINE_2_CORE_RELATED_THRUST:
    case ED_FM_ENGINE_2_RELATED_RPM: return FM::right_throttle_output;
    case ED_FM_ENGINE_2_CORE_RELATED_RPM: return FM::right_engine_power_readout; //reads RPM for avionics
    case ED_FM_ENGINE_2_CORE_THRUST:
    case ED_FM_ENGINE_2_THRUST: return FM::right_thrust_force;
    case ED_FM_ENGINE_2_TEMPERATURE: return (pow(FM::right_engine_power_readout, 3) * 300) + FM::atmosphere_temperature;

    }
    return 0;
}

void ed_fm_refueling_add_fuel(double fuel) {}

void ed_fm_unlimited_fuel(bool value) { FM::infinite_fuel = value; }
void ed_fm_set_easy_flight(bool value) { FM::easy_flight = value; }
void ed_fm_set_immortal(bool value) { FM::invincible = value; }

void ed_fm_on_damage(int Element, double element_integrity_factor) {
    if (Element >= 0 && Element < 111) {
        FM::element_integrity[Element] = element_integrity_factor;
    }
    if (!FM::invincible) {
        FM::left_wing_integrity = FM::element_integrity[23] * FM::element_integrity[29] * FM::element_integrity[35];
        FM::right_wing_integrity = FM::element_integrity[24] * FM::element_integrity[30] * FM::element_integrity[36];
        FM::tail_integrity = FM::element_integrity[53] * FM::element_integrity[54] * FM::element_integrity[55] * FM::element_integrity[56] * FM::element_integrity[57];
        FM::left_engine_integrity = FM::element_integrity[13] * FM::element_integrity[17] * FM::element_integrity[103];
        FM::right_engine_integrity = FM::element_integrity[14] * FM::element_integrity[18] * FM::element_integrity[104];
    }
}

void ed_fm_repair() {
    for (int i = 0; i < 111; i++) FM::element_integrity[i] = 1.0;
}

bool ed_fm_pop_simulation_event(ed_fm_simulation_event& out) {
    if (FM::carrier_pos == 1 && FM::left_throttle_output > 0.99) {
        out.event_type = ED_FM_EVENT_CARRIER_CATAPULT;
        out.event_params[0] = 1;
        out.event_params[1] = 2.0;
        out.event_params[2] = 80.0;
        out.event_params[3] = FM_DATA::max_thrust[1] * 0.5 * 2;
        FM::carrier_pos = 2;
        return true;
    }
    return false;
}

bool ed_fm_push_simulation_event(const ed_fm_simulation_event& in) {
    if (in.event_type == ED_FM_EVENT_CARRIER_CATAPULT) {
        if (in.event_params[0] == 1) FM::carrier_pos = 1;
        else if (in.event_params[0] == 2) FM::carrier_pos = 3;
        else if (in.event_params[0] == 3) FM::carrier_pos = 0;
    }
    return false;
}

void ed_fm_cold_start() {
    reset_fm_state();
    FM::sim_initialised = false; // Force re-initialization in ed_fm_simulate
    FM::gear_switch = true;
    FM::gear_pos = 1;
    FM::airbrake_switch = false;
    FM::carrier_pos = 0;
    FM::left_engine_switch = FM::right_engine_switch = false;
    FM::left_throttle_input = FM::right_throttle_input = 0.0;
    FM::left_throttle_output = FM::right_throttle_output = 0.0;
    FM::left_engine_power_readout = FM::right_engine_power_readout = 0.0;
    FM::left_ab_timer = FM::right_ab_timer = 0.0;
    FM::internal_fuel = 8164.66;
    FM::total_fuel = FM::internal_fuel + FM::external_fuel;
    FM::pitch_input = FM::roll_input = FM::yaw_input = 0.0;
    FM::elevator_command = FM::aileron_command = FM::rudder_command = 0.0;
    FM::left_engine_integrity = FM::right_engine_integrity = 1.0; // Reset engine integrity
    ed_fm_repair(); // Reset all damage
}

void ed_fm_hot_start() {
    reset_fm_state();
    FM::gear_switch = true; FM::gear_pos = 1; FM::carrier_pos = 0;
    FM::flaps_pos = 1;
    FM::airbrake_switch = false;
    FM::left_engine_switch = FM::right_engine_switch = true;
    FM::left_throttle_input = FM::right_throttle_input = 0.0;
    FM::left_throttle_output = FM::right_throttle_output = 0.67;
    FM::left_engine_power_readout = FM::right_engine_power_readout = 0.67;
    FM::left_ab_timer = FM::right_ab_timer = 0.0;
    FM::internal_fuel = 8164.66;
    FM::total_fuel = FM::internal_fuel + FM::external_fuel;
    FM::left_engine_integrity = FM::right_engine_integrity = 1.0; // Reset engine integrity
    FM::velocity_world = Vec3(0, 0, 0); // Force zero velocity
    FM::pitch_rate = FM::roll_rate = FM::yaw_rate = 0.0; // Force zero rates
    FM::pitch = FM::roll = FM::heading = 0.0; // Force zero orientation
    ed_fm_repair(); // Reset all damage
}

void ed_fm_hot_start_in_air() {
    reset_fm_state();
    FM::gear_switch = false; FM::gear_pos = 0; FM::carrier_pos = 0;
    FM::flaps_pos = 0;
    FM::airbrake_switch = false;
    FM::left_engine_switch = FM::right_engine_switch = true;
    FM::left_throttle_input = FM::left_throttle_output = 0.67;
    FM::right_throttle_input = FM::right_throttle_output = 0.67;
    FM::left_engine_power_readout = FM::right_engine_power_readout = 0.67;
    FM::left_ab_timer = FM::right_ab_timer = 0.0;
    FM::internal_fuel = 8164.66;
    FM::total_fuel = FM::internal_fuel + FM::external_fuel;
    FM::left_engine_integrity = FM::right_engine_integrity = 1.0; // Reset engine integrity
    FM::velocity_world = Vec3(0, 0, 0); // Force zero velocity
    FM::pitch_rate = FM::roll_rate = FM::yaw_rate = 0.0; // Force zero rates
    FM::pitch = FM::roll = FM::heading = 0.0; // Force zero orientation
    ed_fm_repair(); // Reset all damage
}

void ed_fm_release() {
    FM::fm_clock = 0;
    FM::sim_initialised = false; // Ensure next mission re-initializes
    ed_fm_repair();
}

double ed_fm_get_shake_amplitude() {
    return FM::shake_amplitude;
}

bool ed_fm_add_local_force_component(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z) { return false; }
bool ed_fm_add_global_force_component(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z) { return false; }
bool ed_fm_add_local_moment_component(double& x, double& y, double& z) { return false; }
bool ed_fm_add_global_moment_component(double& x, double& y, double& z) { return false; }
bool ed_fm_enable_debug_info() { return false; }