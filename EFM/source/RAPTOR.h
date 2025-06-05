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

#include <unordered_map>
#include <string>
#include <cstddef> 
#include <array>
#include <map>

    // ----- Aerodynamics, etc. -----

namespace FM_DATA
{
    static inline std::array<double, 13> mach_table = {
        0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4
    };

    double Cy0 = 0.008;

    double Czbe = -0.028;

    double cx_gear = 0.14;
    double cx_brk = 0.062;
    double cx_flap = 0.042;
    double cy_flap = 0.048;

    double cx0[] = { 0.013, 0.0135, 0.014, 0.021, 0.0358, 0.0505, 0.0455, 0.04175, 0.038, 0.037, 0.0368, 0.0362, 0.039 };
    double Cya[] = { 0.015, 0.055, 0.07, 0.065, 0.06, 0.055, 0.05, 0.045, 0.04, 0.0375, 0.035, 0.0325, 0.03 };
    double OmxMax[] = { 1.65, 2.45, 3.25, 4.7, 3.98, 3.2, 2.5, 2.25, 2.0, 1.85, 1.7, 1.5, 1.3 };
    double Aldop[] = { 60, 57.5, 55, 50, 45, 40, 35, 32.5, 30, 30, 30, 30, 30 };
    double CyMax[] = { 1.8, 1.85, 1.9, 1.85, 1.75, 1.6, 1.45, 1.35, 1.25, 1.15, 1.1, 1.05, 1.0 };


    double AoA_table[] = { 0.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0 };
    double AoA_drag_factor[] = { 0.0, 0.005, 0.02, 0.082, 0.17, 0.275, 0.41, 0.58, 0.7, 0.81 };

    double beta_table[] = { 0.0, 5.0, 10.0, 20.0, 30.0 };
    double Cy_beta[] = { 0.0, 0.05, 0.1, 0.2, 0.3 };

    static inline std::array<double, 13> idle_thrust = {
        6000, 8500, 10500, 11500, 12000, 12500, 13000, 13000, 13000, 13000, 13000, 13000, 13000
    };

    static inline std::array<double, 13> max_thrust = {
        115600, 117050, 118500, 127250, 154000, 183800, 245000, 293000, 330000, 230000, 0, 0, 0
    };

    static inline std::array<double, 13> ab_thrust = {
    197000, 215300, 232600, 256500, 275000, 298000, 325000, 355000, 405000, 470000, 535000, 536500, 0
    };

    double elevator_rate_table[] = { 1.396, 1.396, 1.30, 1.016, 0.912, 0.912, 0.912, 0.942, 1.105, 1.105, 1.105, 1.105, 1.105 };
    double max_elevator_deflection[] = { 30.0, 28.0, 21.5, 13.8, 11.5, 11.0, 11.0, 11.0, 13.0, 13.0, 13.0, 13.0, 13.0 };
    const double max_aileron_rate = 14.55;
    double max_thrust_vector_deflection[] = { 20.0, 20.0, 17.0, 11.5, 6.0, 4.0, 2.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0 };
    double thrust_vector_rate[] = { 1.396, 1.3905, 1.189, 0.855, 0.759, 0.737, 0.601, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
    double Kd_pitch[] = { 0.675, 0.668, 0.654, 0.80, 1.25, 1.95, 2.2, 2.5, 2.8, 2.8, 2.8, 2.8, 2.8 };
    double Kd_roll[] = { 0.50, 0.35, 0.33, 0.29, 0.33, 0.37, 0.42, 0.52, 0.62, 0.74, 0.85, 0.88, 0.81 };
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
    Vec3 left_engine_pos(-4.793, 0, -0.716);
    Vec3 right_engine_pos(-4.793, 0, 0.716);

    double pitch_input = 0, pitch_discrete = 0, pitch_trim = 0;
    double left_elevon_command = 0, right_elevon_command = 0;
    double left_elevon_angle = 0.0, right_elevon_angle = 0.0;
    bool pitch_analog = true;
    double roll_input = 0, roll_discrete = 0, roll_trim = 0, aileron_command = 0;
    double left_aileron_angle = 0.0;
    double right_aileron_angle = 0.0;
    bool roll_analog = true;
    double yaw_input = 0, yaw_discrete = 0, yaw_trim = 0, rudder_command = 0;
    bool yaw_analog = true;
    static double beta_integral = 0.0;

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
    double landing_brake_assist = 0;

    const double max_internal_fuel = 8200.0;
    const double max_external_fuel = 3700.0;
    const double ground_refuel_rate = 45.36;
    const double min_usable_fuel = 25.0;
    double internal_fuel = 0, external_fuel = 0, total_fuel = internal_fuel + external_fuel;
    double fuel_consumption_since_last_time = 0;
    const double fuel_rate_idle = 0.108;
    const double fuel_rate_mil = 2.2;
    const double fuel_rate_ab = 6.5;
    double left_fuel_rate = 0.0;
    double right_fuel_rate = 0.0;
    double left_fuel_rate_kg_s;
    double right_fuel_rate_kg_s;
    bool external_tanks_equipped = false;
    std::map<int, double> external_fuel_stations;

    double atmosphere_density = 1.225, altitude_ASL = 0, altitude_AGL = 0, V_scalar = 0;
    double speed_of_sound = 320, mach = 0;
    double engine_alt_effect = 1, atmosphere_temperature = 273;
    double aoa = 0, alpha = 0, aos = 0, beta = 0, g = 0;
    bool on_ground = false;
    double pitch = 0, pitch_rate = 0, roll = 0, roll_rate = 0, heading = 0, yaw_rate = 0;

    double element_integrity[111];
    double left_wing_integrity = 1.0, right_wing_integrity = 1.0, tail_integrity = 1.0, left_elevon_integrity = 1.0, right_elevon_integrity = 1.0;
    double left_engine_integrity = 1.0, right_engine_integrity = 1.0;
    double total_damage = 1 - (left_wing_integrity + right_wing_integrity + tail_integrity +
        left_engine_integrity + right_engine_integrity + left_elevon_integrity + right_elevon_integrity) / 7;
    bool is_destroyed = false;

    bool invincible = true, infinite_fuel = false, easy_flight = false;
    double shake_amplitude = 0, fm_clock = 0;
    bool sim_initialised = false;

    double ref_roll = 0, ref_heading = 0;
    double roll_error_i = 0, yaw_error_i = 0;
    double last_aileron_cmd = 0, last_elevator_cmd = 0, last_rudder_cmd = 0;
    bool autotrim_active = false;
    double last_g = 0.0;
    double autotrim_elevator_cmd = 0.0;
    bool manual_trim_applied = false;
    double takeoff_trim_cmd = 0.0;
    double tv_angle = 0.0;

    double g_assist_pos = 0;
    double g_limit_positive = 11.0;
    double g_limit_negative = -4.0;

    double last_yaw_input = 0.0;
    double last_tv_cmd = 0.0;
    double last_pitch_input = 0.0;
    double ground_speed_knots = 0.0;

    enum EngineState { OFF, STARTING, RUNNING, SHUTDOWN };
    EngineState left_engine_state = OFF;
    EngineState right_engine_state = OFF;
    double left_engine_start_timer = 0.0;
    double right_engine_start_timer = 0.0;

    const double engine_start_time = 44.0;
    const double starter_phase_duration = 11.0;
    const double ignition_phase_duration = 18.0;
    const double spool_up_phase_duration = 15.0;
    const double starter_rpm = 0.2;
    const double ignition_rpm = 0.4;
    const double starter_rate = starter_rpm / starter_phase_duration;
    const double ignition_rate = (ignition_rpm - starter_rpm) / ignition_phase_duration;
    const double spool_up_rate = (idle_rpm - ignition_rpm) / spool_up_phase_duration;
    double left_engine_phase = 0.0;
    double right_engine_phase = 0.0;

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
    const double blink_on_time = 0.10;
    const double blink_off_time = 1.50;
    const double blink_period = blink_on_time + blink_off_time;
    static double aileron_animation_command;

    static double smoothed_pitch_discrete;
    static double smoothed_roll_discrete;
    static double smoothed_yaw_discrete;

}

    // ----- Damage Elements -----

enum class DamageElement : size_t {
    NoseCenter = 0,
    NoseLeft = 1,
    NoseRight = 2,
    Cockpit = 3,
    CabinLeft = 4,
    CabinRight = 5,
    CabinBottom = 6,
    Gun = 7,
    FrontGear = 8,
    FuselageLeft = 9,
    FuselageRight = 10,
    EngineInLeft = 11,
    EngineInRight = 12,
    NacelleLeftBottom = 13,
    NacelleRightBottom = 14,
    GearLeft = 15,
    GearRight = 16,
    NacelleLeft = 17,
    NacelleRight = 18,
    AirbrakeLeft = 19,
    AirbrakeRight = 20,
    SlatOutLeft = 21,
    SlatOutRight = 22,
    WingOutLeft = 23,
    WingOutRight = 24,
    AileronLeft = 25,
    AileronRight = 26,
    SlatCentreLeft = 27,
    SlatCentreRight = 28,
    WingCentreLeft = 29,
    WingCentreRight = 30,
    FlapOutLeft = 31,
    FlapOutRight = 32,
    SlatInLeft = 33,
    SlatInRight = 34,
    WingInLeft = 35,
    WingInRight = 36,
    FlapInLeft = 37,
    FlapInRight = 38,
    FinTopLeft = 39,
    FinTopRight = 40,
    FinCentreLeft = 41,
    FinCentreRight = 42,
    FinBottomLeft = 43,
    FinBottomRight = 44,
    StabilizerOutLeft = 45,
    StabilizerOutRight = 46,
    StabilizerInLeft = 47,
    StabilizerInRight = 48,
    ElevatorOutLeft = 49,
    ElevatorOutRight = 50,
    ElevatorInLeft = 51,
    ElevatorInRight = 52,
    RudderLeft = 53,
    RudderRight = 54,
    Tail = 55,
    TailLeft = 56,
    TailRight = 57,
    TailBottom = 58,
    NoseBottom = 59,
    Pitot = 60,
    FuelTankFrontLeft = 61,
    FuelTankBackRight = 62,
    Rotor = 63,
    Blade1In = 64,
    Blade1Centre = 65,
    Blade1Out = 66,
    Blade2In = 67,
    Blade2Centre = 68,
    Blade2Out = 69,
    Blade3In = 70,
    Blade3Centre = 71,
    Blade3Out = 72,
    Blade4In = 73,
    Blade4Centre = 74,
    Blade4Out = 75,
    Blade5In = 76,
    Blade5Centre = 77,
    Blade5Out = 78,
    Blade6In = 79,
    Blade6Centre = 80,
    Blade6Out = 81,
    FuselageBottom = 82,
    WheelNose = 83,
    WheelLeft = 84,
    WheelRight = 85,
    Payload1 = 86,
    Payload2 = 87,
    Payload3 = 88,
    Payload4 = 89,
    Crew1 = 90,
    Crew2 = 91,
    Crew3 = 92,
    Crew4 = 93,
    ArmorNoseLeft = 94,
    ArmorNoseRight = 95,
    ArmorLeft = 96,
    ArmorRight = 97,
    Hook = 98,
    TailTop = 100,
    FlapCentreLeft = 101,
    FlapCentreRight = 102,
    Engine1 = 103,
    Engine2 = 104,
    Engine3 = 105,
    Engine4 = 106,
    Engine5 = 107,
    Engine6 = 108,
    Engine7 = 109,
    Engine8 = 110,
    WingL00 = 111,
    WingL01 = 112,
    WingL02 = 113,
    WingL03 = 114,
    WingL04 = 115,
    WingL05 = 116,
    WingL06 = 117,
    WingL07 = 118,
    WingL08 = 119,
    WingL09 = 120,
    WingL10 = 121,
    WingL11 = 122,
    WingR00 = 123,
    WingR01 = 124,
    WingR02 = 125,
    WingR03 = 126,
    WingR04 = 127,
    WingR05 = 128,
    WingR06 = 129,
    WingR07 = 130,
    WingR08 = 131,
    WingR09 = 132,
    WingR10 = 133,
    WingR11 = 134,
    LaunchBar = 135,
    TailRotor = 136
};

    // ----- Cockpit Logic -----

class CockpitManager {
public:
    CockpitManager();
    ~CockpitManager() = default;

    void initialize();

    void update(double dt);

    void updateDrawArgs(float* drawargs, size_t size);

private:
    EDPARAM param_api_;
    std::unordered_map<std::string, void*> param_handles_;
    std::unordered_map<int, float> draw_args_;

    void updateGearLights(double dt);
    void updateTaxiLandingLights(double dt);
    void updateAARLight(double dt);
    void updateFormationLights(double dt);
    void updateNavAntiCollisionLights(double dt);

    double getParameter(const std::string& name, double fallback_value = 0.0);
};