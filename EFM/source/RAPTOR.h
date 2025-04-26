/*    Grinnelli Designs F-22A Raptor
    Copyright (C) 2025, Branden Hooper

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see https://www.gnu.org/licenses.
    */

    // RAPTOR.h : External Flight Model for light model for Grinnelli Designs F-22A

#pragma once

#include <map>
#include <string>
#include <cstddef> 

    // ----- Aerodynamics, etc. -----
namespace FM_DATA
{
    double mach_table[] = { 0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4 };

    // Zero-lift side-force coefficient. Represents lateral force at zero AoA (small for symmetry)
    double Cy0 = 0.008;

    // Pitch damping or elevator effectiveness coefficient.
    double Czbe = -0.028;

    //Drag and Lift for external surfaces
    double cx_gear = 0.155;
    double cx_brk = 0.062;
    double cx_flap = 0.051;
    double cy_flap = 0.112;

    // Zero-lift drag coefficient (parasitic drag) as a function of Mach.
    double cx0[] = { 0.013, 0.0135, 0.014, 0.021, 0.0378, 0.0505, 0.0455, 0.04175, 0.038, 0.037, 0.0368, 0.0362, 0.039 };

    // Lift curve slope vs. Mach. Defines how much lift increases per degree of AoA.
    double Cya[] = { 0.08, 0.075, 0.07, 0.065, 0.06, 0.055, 0.05, 0.045, 0.04, 0.0375, 0.035, 0.0325, 0.03 };

    // Maximum roll rate vs. Mach. Indicates roll agility.
    double OmxMax[] = { 1.65, 2.45, 3.25, 4.7, 3.98, 3.2, 2.5, 2.25, 2.0, 1.85, 1.7, 1.5, 1.3 };


    // Critical angle of attack (degrees) vs. Mach. Beyond this AoA, the wing stalls (lift drops).
    double Aldop[] = { 60, 57.5, 55, 50, 45, 40, 35, 32.5, 30, 30, 30, 30, 30 };

    // Maximum lift coefficient vs. Mach. Represents peak lift capability before stall
    double CyMax[] = { 1.8, 1.85, 1.9, 1.85, 1.75, 1.6, 1.45, 1.35, 1.25, 1.15, 1.1, 1.05, 1.0 };


    //Reactions
    double AoA_table[] = { 0.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0 };
    double AoA_drag_factor[] = { 0.0, 0.006, 0.024, 0.10, 0.24, 0.375, 0.47, 0.60, 0.71, 1.0 };

    //Misc.
    double beta_table[] = { 0.0, 5.0, 10.0, 20.0, 30.0 }; // Sideslip angle (deg)
    double Cy_beta[] = { 0.0, 0.05, 0.1, 0.2, 0.3 }; // Side-force coefficient

    //Thrust - per engine
    double idle_thrust[] = {
        6000,
        5980,
        5900,
        6000,
        6150,
        6300,
        7000,
        7900,
        9100,
        9900,
        10500,
        11000,
        11600
    };

    double max_thrust[] = {
        115600, // Mach 0.0 (~26,000 lbf total, real MIL)
        117050,
        118500, // Mach 0.4 (slight dip, engine efficiency)
        127250, // Mach 0.6 (minimum before ram boost)
        154000, // Mach 0.8 (ram effect kicks in)
        183800, // Mach 1.0 (transonic boost)
        245000, // Mach 1.2 (supersonic rise)
        293000,
        330000, // Mach 1.6 (supercruise tuned for M1.76)
        230000, // Mach 1.8 (supercruise tuned for M1.76)
        0, // Mach 2.0
        0, // Mach 2.2
        0  // Mach 2.4
    };

    double ab_thrust[] = {
        197000, // Mach 0.0 (~40,000 lbf total, real AB+)
        215300, // Mach 0.2
        232600, // Mach 0.4 (slight dip, engine efficiency)
        256500, // Mach 0.6 (minimum before ram boost)
        275000, // Mach 0.8 (ram effect kicks in)
        298000, // Mach 1.0 (transonic boost)
        325000, // Mach 1.2 (supersonic rise)
        355000, // Mach 1.4
        405000, // Mach 1.6
        470000, // Mach 1.8
        535000, // Mach 2.0
        536500, // Mach 2.2 
        0  // Mach 2.4
    };

    //FBW Limits
    //Elevator
    double elevator_rate_table[] = { 1.396, 1.396, 1.30, 1.036, 0.912, 0.912, 0.912, 0.912, 0.912, 0.912, 0.912, 0.912, 0.912 };
    double max_elevator_deflection[] = { 30.0, 28.0, 21.5, 13.8, 11.5, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0 };

    //Aileron
    const double max_aileron_rate = 15.55;

    //Thrust Vectoring Nozzles
    double max_thrust_vector_deflection[] = { 20.0, 20.0, 17.0, 11.5, 6.0, 4.0, 2.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0 };
    double thrust_vector_rate[] = { 1.396, 1.3905, 1.385, 0.915, 0.791, 0.737, 0.601, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };

    // Damping tables
    double Kd_pitch[] = { 0.635, 0.662, 0.654, 0.72, 1.1, 1.95, 2.2, 2.5, 3.75, 3.0, 3.1, 3.15, 3.158 };
    double Kd_roll[] = { 0.50, 0.39, 0.35, 0.31, 0.33, 0.37, 0.42, 0.52, 0.62, 0.74, 0.85, 0.88, 0.81 };
    double Kd_yaw[] = { 2.0, 2.0, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0 };

}

// ----- EFM Data -----
namespace RAPTOR {
    Vec3 common_force, common_moment, center_of_mass, wind, velocity_world, airspeed;
    double const pi = 3.1415926535897932384626433832795;
    double const rad_to_deg = 180.0 / pi;
    inline double rad(double deg) { return deg * pi / 180.0; }

    double const S = 78.06;
    double const wingspan = 13.56, length = 18.92, height = 5.08;
    double idle_rpm = 0.675;
    double const empty_mass = 19700;

    Vec3 left_wing_pos(center_of_mass.x - 0.8, center_of_mass.y + 0.5, -wingspan / 2);
    Vec3 right_wing_pos(center_of_mass.x - 0.8, center_of_mass.y + 0.5, wingspan / 2);
    Vec3 tail_pos(center_of_mass.x - 0.9, center_of_mass.y, 0);
    Vec3 left_elevon_pos(-length / 2, center_of_mass.y, -wingspan * 0.25);
    Vec3 right_elevon_pos(-length / 2, center_of_mass.y, wingspan * 0.25);
    Vec3 left_aileron_pos(center_of_mass.x, center_of_mass.y, -wingspan * 0.5);
    Vec3 right_aileron_pos(center_of_mass.x, center_of_mass.y, wingspan * 0.5);
    Vec3 rudder_pos(-length / 2, height / 2, 0);
    Vec3 left_engine_pos(-3.793, 0, -0.716);
    Vec3 right_engine_pos(-3.793, 0, 0.716);

    double pitch_input = 0, pitch_discrete = 0, pitch_trim = 0;
    double left_elevon_command = 0, right_elevon_command = 0;
    double left_elevon_angle = 0.0, right_elevon_angle = 0.0;
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

    const double max_internal_fuel = 8165.0; 
    const double ground_refuel_rate = 45.36;
    const double min_usable_fuel = 25.0;
    double internal_fuel = 0, external_fuel = 0, total_fuel = internal_fuel + external_fuel;
    double fuel_consumption_since_last_time = 0;
    const double fuel_rate_idle = 0.108;
    const double fuel_rate_mil = 2.2;
    const double fuel_rate_ab = 6.5;

    double atmosphere_density = 1.225, altitude_ASL = 0, altitude_AGL = 0, V_scalar = 0;
    double speed_of_sound = 320, mach = 0;
    double engine_alt_effect = 1, atmosphere_temperature = 273;
    double aoa = 0, alpha = 0, aos = 0, beta = 0, g = 0;
    bool on_ground = false;
    double pitch = 0, pitch_rate = 0, roll = 0, roll_rate = 0, heading = 0, yaw_rate = 0;

    double element_integrity[111];
    double left_wing_integrity = 1.0, right_wing_integrity = 1.0, tail_integrity = 1.0;
    double left_engine_integrity = 1.0, right_engine_integrity = 1.0;
    double total_damage = 1 - (left_wing_integrity + right_wing_integrity + tail_integrity +
        left_engine_integrity + right_engine_integrity) / 5;

    bool invincible = true, infinite_fuel = false, easy_flight = false;
    double shake_amplitude = 0, fm_clock = 0;
    bool sim_initialised = false;

    // FBW state variables
    double ref_roll = 0, ref_heading = 0;
    double roll_error_i = 0, yaw_error_i = 0;
    double last_aileron_cmd = 0, last_elevator_cmd = 0, last_rudder_cmd = 0;
    bool autotrim_active = false;
    double last_g = 0.0;
    double autotrim_elevator_cmd = 0.0;
    bool manual_trim_applied = false;
    double takeoff_trim_cmd = 0.0;
    double g_limit_positive = 12.0;
    double g_limit_negative = -4.5;
    double Kp_g = 0.1;
    double tv_angle = 0.0;

    // Global variables for state persistence
    double last_yaw_input = 0.0;
    double last_tv_cmd = 0.0;
    double last_pitch_input = 0.0;
    double ground_speed_knots = 0.0;

    //Engine Start Sequence
    enum EngineState { OFF, STARTING, RUNNING, SHUTDOWN };
    EngineState left_engine_state = OFF;
    EngineState right_engine_state = OFF;
    double left_engine_start_timer = 0.0;
    double right_engine_start_timer = 0.0;

    // Engine parameters
    const double engine_start_time = 30.0;
    const double starter_phase_duration = 8.0;
    const double ignition_phase_duration = 12.0;
    const double spool_up_phase_duration = 10.0;
    const double starter_rpm = 0.2;
    const double ignition_rpm = 0.4;
    const double starter_rate = starter_rpm / starter_phase_duration;
    const double ignition_rate = (ignition_rpm - starter_rpm) / ignition_phase_duration;
    const double spool_up_rate = (idle_rpm - ignition_rpm) / spool_up_phase_duration;
    double left_engine_phase = 0.0; 
    double right_engine_phase = 0.0;

    //Lights
    bool taxi_lights = false;
    bool landing_lights = false;
    bool form_light = false;
    bool nav_white = false;
    bool anti_collision = false;
    bool aar_light = false;
    bool nav_lights = false;
    double anti_collision_timer = 0.0;
    bool anti_collision_blink = false;
    double nav_white_timer = 0.0;
    bool nav_white_blink = false;
    double nav_lights_timer = 0.0;
    bool nav_lights_blink = false;
    const double blink_on_time = 1.0;
    const double blink_off_time = 1.0;
    const double blink_period = blink_on_time + blink_off_time;
}

// ----- Cockpit Logic -----

class CockpitManager {
public:
    CockpitManager();
    ~CockpitManager() = default;

    // Initialize parameter handles and states for cold/hot start
    void initialize();

    // Update logic at 0.006s intervals (ed_fm_simulate rate)
    void update(double dt);

    // Set cockpit draw arguments (lighting, switches)
    void updateDrawArgs(float* drawargs, size_t size);

private:
    EDPARAM param_api_; // Parameter API
    std::map<std::string, void*> param_handles_; // Handles for APU_POWER, AAR, AAR_READY, etc.
    std::map<int, float> draw_args_; // Input args (709, 712-715), output args (604-613)

    // Helper functions for light logic
    void updateGearLights(double dt);
    void updateTaxiLandingLights(double dt);
    void updateAARLight(double dt);
    void updateFormationLights(double dt);
    void updateNavAntiCollisionLights(double dt);

    // Utility to get parameter with fallback
    double getParameter(const std::string& name, double fallback_value = 0.0);
};