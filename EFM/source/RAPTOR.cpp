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

// RAPTOR.cpp : External flight model for Grinnelli Designs F-22A 
#include <math.h>
#include <cmath>
#include <stdio.h>
#include <string>
#include <algorithm>
#include <iostream>
#include <stack>
#include <queue>
#include <vector>

#define EXPORT_ED_FM_PHYSICS_IMP extern "C" __declspec(dllexport)
#include <FM/wHumanCustomPhysicsAPI_ImplementationDeclare.h>
#include <Cockpit/CockpitAPI_Declare.h>

#include "Utility.h"
#include "Inputs.h"
#include "RAPTOR.h"

#define EXPORT __declspec(dllexport)

static CockpitManager cockpit_manager;

struct MassChange
{
    double delta_kg;
    Vec3 pos;
    Vec3 moi;
};

struct DamageEvent {
    int element_number;
    double integrity_factor;
};

std::stack<MassChange> g_mass_changes;
std::queue<DamageEvent> g_damage_events;

void add_local_force(const Vec3& Force, const Vec3& Force_pos) {
    RAPTOR::common_force.x += Force.x;
    RAPTOR::common_force.y += Force.y;
    RAPTOR::common_force.z += Force.z;
    Vec3 delta_pos(Force_pos.x - RAPTOR::center_of_mass.x, Force_pos.y - RAPTOR::center_of_mass.y, Force_pos.z - RAPTOR::center_of_mass.z);
    Vec3 delta_moment = cross(delta_pos, Force);
    RAPTOR::common_moment.x += delta_moment.x;
    RAPTOR::common_moment.y += delta_moment.y;
    RAPTOR::common_moment.z += delta_moment.z;
}

void add_local_moment(const Vec3& Moment) {
    RAPTOR::common_moment.x += Moment.x;
    RAPTOR::common_moment.y += Moment.y;
    RAPTOR::common_moment.z += Moment.z;
}

void ed_fm_add_local_force(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z) {
    x = RAPTOR::common_force.x;
    y = RAPTOR::common_force.y;
    z = RAPTOR::common_force.z;
    pos_x = RAPTOR::center_of_mass.x;
    pos_y = RAPTOR::center_of_mass.y;
    pos_z = RAPTOR::center_of_mass.z;
}

void ed_fm_add_local_moment(double& x, double& y, double& z) {
    x = RAPTOR::common_moment.x;
    y = RAPTOR::common_moment.y;
    z = RAPTOR::common_moment.z;
}

void simulate_fuel_consumption(double dt)
{
    RAPTOR::left_fuel_rate = 0.0;
    RAPTOR::right_fuel_rate = 0.0;

    double left_fuel_rate_kg_s = 0.0;
    double right_fuel_rate_kg_s = 0.0;

    double fuel_alt_factor = RAPTOR::atmosphere_density / 1.225;
    double mach_factor = 1.0 + 0.5 * RAPTOR::mach;

    if (RAPTOR::left_engine_state == RAPTOR::RUNNING) {
        if (RAPTOR::left_throttle_output <= 1.025) {
            double throttle_factor = (RAPTOR::left_throttle_output - 0.67) / (1.025 - 0.67);
            RAPTOR::left_fuel_rate = (0.126 + (1.5 - 0.126) * throttle_factor) * fuel_alt_factor * mach_factor;
        }
        else {
            double ab_factor = (RAPTOR::left_throttle_output - 1.025) / (1.1 - 1.025);
            RAPTOR::left_fuel_rate = (1.5 + (6.5 - 1.5) * ab_factor) * fuel_alt_factor * mach_factor;
        }
        left_fuel_rate_kg_s = RAPTOR::left_fuel_rate;
    }

    if (RAPTOR::right_engine_state == RAPTOR::RUNNING) {
        if (RAPTOR::right_throttle_output <= 1.025) {
            double throttle_factor = (RAPTOR::right_throttle_output - 0.67) / (1.025 - 0.67);
            RAPTOR::right_fuel_rate = (0.126 + (1.5 - 0.126) * throttle_factor) * fuel_alt_factor * mach_factor;
        }
        else {
            double ab_factor = (RAPTOR::right_throttle_output - 1.025) / (1.1 - 1.025);
            RAPTOR::right_fuel_rate = (1.5 + (6.5 - 1.5) * ab_factor) * fuel_alt_factor * mach_factor;
        }
        right_fuel_rate_kg_s = RAPTOR::right_fuel_rate;
    }

    RAPTOR::fuel_consumption_since_last_time = (RAPTOR::left_fuel_rate + RAPTOR::right_fuel_rate) * dt;

    if (RAPTOR::fuel_consumption_since_last_time > 0) {
        double fuel_to_consume = RAPTOR::fuel_consumption_since_last_time;

        if (RAPTOR::external_fuel > 0) {
            double external_consumed = std::min(fuel_to_consume, RAPTOR::external_fuel);
            RAPTOR::external_fuel = std::max(0.0, RAPTOR::external_fuel - external_consumed);
            fuel_to_consume -= external_consumed;
        }

        if (fuel_to_consume > 0) {
            RAPTOR::internal_fuel = std::max(0.0, RAPTOR::internal_fuel - fuel_to_consume);
            double fuel_fraction = std::min(1.0, std::max(0.0, RAPTOR::internal_fuel / RAPTOR::max_internal_fuel));
            g_mass_changes.push({
                fuel_to_consume,
                {-0.32 * (1.0 - fuel_fraction), 0.0, 0.0},
                {0.0, 0.0, 0.0}
                });
        }

        RAPTOR::total_fuel = RAPTOR::internal_fuel + RAPTOR::external_fuel;
    }

    RAPTOR::left_fuel_rate_kg_s = left_fuel_rate_kg_s;
    RAPTOR::right_fuel_rate_kg_s = right_fuel_rate_kg_s;
}

void reset_fm_state() {
    RAPTOR::pitch_input = RAPTOR::roll_input = RAPTOR::yaw_input = 0.0;
    RAPTOR::pitch_discrete = RAPTOR::roll_discrete = RAPTOR::yaw_discrete = 0.0;
    RAPTOR::pitch_analog = RAPTOR::roll_analog = RAPTOR::yaw_analog = true;
    RAPTOR::left_elevon_command = RAPTOR::right_elevon_command = 0.0;
    RAPTOR::left_elevon_angle = RAPTOR::right_elevon_angle = 0.0;
    RAPTOR::last_elevator_cmd = RAPTOR::last_aileron_cmd = RAPTOR::last_rudder_cmd = 0.0;
    RAPTOR::tv_angle = 0.0;
    RAPTOR::pitch_trim = RAPTOR::roll_trim = RAPTOR::yaw_trim = 0.0;
    RAPTOR::beta_integral = 0.0;
    RAPTOR::aileron_animation_command = 0.0;

    RAPTOR::left_engine_state = RAPTOR::OFF;
    RAPTOR::right_engine_state = RAPTOR::OFF;
    RAPTOR::left_engine_switch = RAPTOR::right_engine_switch = false;
    RAPTOR::left_throttle_input = RAPTOR::right_throttle_input = 0.0;
    RAPTOR::left_throttle_output = RAPTOR::right_throttle_output = RAPTOR::idle_rpm;
    RAPTOR::left_engine_power_readout = RAPTOR::right_engine_power_readout = 0.0;
    RAPTOR::left_thrust_force = RAPTOR::right_thrust_force = 0.0;
    RAPTOR::left_ab_timer = RAPTOR::right_ab_timer = 0.0;
    RAPTOR::left_engine_phase = 0.0;
    RAPTOR::right_engine_phase = 0.0;

    RAPTOR::ref_roll = RAPTOR::ref_heading = 0.0;
    RAPTOR::roll_error_i = RAPTOR::yaw_error_i = 0.0;

    RAPTOR::velocity_world = Vec3(0, 0, 0);
    RAPTOR::airspeed = Vec3(0, 0, 0);
    RAPTOR::pitch_rate = RAPTOR::roll_rate = RAPTOR::yaw_rate = 0.0;
    RAPTOR::aoa = RAPTOR::aos = RAPTOR::alpha = RAPTOR::beta = 0.0;
    RAPTOR::pitch = RAPTOR::roll = RAPTOR::heading = 0.0;
    RAPTOR::g = 0.0;
    RAPTOR::V_scalar = 0.0;
    RAPTOR::mach = 0.0;

    RAPTOR::left_wing_integrity = RAPTOR::right_wing_integrity = RAPTOR::tail_integrity = RAPTOR::left_elevon_integrity = RAPTOR::right_elevon_integrity = 1.0;
    RAPTOR::left_engine_integrity = RAPTOR::right_engine_integrity = 1.0;
    RAPTOR::fuel_consumption_since_last_time = 0.0;

    RAPTOR::fm_clock = 0.0;
    RAPTOR::sim_initialised = false;
    RAPTOR::shake_amplitude = 0.0;
    RAPTOR::on_ground = false;

    RAPTOR::last_yaw_input = 0.0;
    RAPTOR::last_tv_cmd = 0.0;
    RAPTOR::last_pitch_input = 0.0;
    RAPTOR::smoothed_pitch_discrete = 0.0;
    RAPTOR::smoothed_roll_discrete = 0.0;

    RAPTOR::autotrim_elevator_cmd = 0.0;
    RAPTOR::is_destroyed = false;
}

void ed_fm_simulate(double dt) {
    RAPTOR::fm_clock += dt;
    RAPTOR::common_force = Vec3();
    RAPTOR::common_moment = Vec3();

    const double input_slew_rate = 1.33;
    RAPTOR::smoothed_pitch_discrete = slew_rate_limit(RAPTOR::smoothed_pitch_discrete, RAPTOR::pitch_discrete, input_slew_rate, dt);
    RAPTOR::smoothed_roll_discrete = slew_rate_limit(RAPTOR::smoothed_roll_discrete, RAPTOR::roll_discrete, input_slew_rate, dt);
    RAPTOR::smoothed_yaw_discrete = slew_rate_limit(RAPTOR::smoothed_yaw_discrete, RAPTOR::yaw_discrete, input_slew_rate, dt);

    const double ENGINE_INTEGRITY_SHUTDOWN_THRESHOLD = 0.30;
    if (RAPTOR::left_engine_integrity <= ENGINE_INTEGRITY_SHUTDOWN_THRESHOLD &&
        (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::left_engine_state == RAPTOR::STARTING)) {
        RAPTOR::left_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::left_engine_switch = false;
    }
    if (RAPTOR::right_engine_integrity <= ENGINE_INTEGRITY_SHUTDOWN_THRESHOLD &&
        (RAPTOR::right_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::STARTING)) {
        RAPTOR::right_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::right_engine_switch = false;
    }

    if (RAPTOR::is_destroyed) {
        static bool destruction_events_pushed = false;
        if (!destruction_events_pushed) {
            g_damage_events.push({ static_cast<int>(DamageElement::WingOutLeft), RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingOutLeft)] });
            g_damage_events.push({ static_cast<int>(DamageElement::WingOutRight), RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingOutRight)] });
            g_damage_events.push({ static_cast<int>(DamageElement::Tail), RAPTOR::element_integrity[static_cast<size_t>(DamageElement::Tail)] });
            g_damage_events.push({ static_cast<int>(DamageElement::Engine1), RAPTOR::element_integrity[static_cast<size_t>(DamageElement::Engine1)] });
            g_damage_events.push({ static_cast<int>(DamageElement::Engine2), RAPTOR::element_integrity[static_cast<size_t>(DamageElement::Engine2)] });
            g_damage_events.push({ static_cast<int>(DamageElement::WingInLeft), RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingInLeft)] });
            g_damage_events.push({ static_cast<int>(DamageElement::WingInRight), RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingInRight)] });
            destruction_events_pushed = true;
        }
        RAPTOR::common_force = Vec3(0.0, 0.0, 0.0);
        RAPTOR::common_moment = Vec3(0.0, 0.0, 0.0);
        RAPTOR::left_engine_power_readout = 0.0;
        RAPTOR::right_engine_power_readout = 0.0;
        RAPTOR::left_engine_integrity = 0.0;
        RAPTOR::right_engine_integrity = 0.0;
        RAPTOR::left_thrust_force = 0.0;
        RAPTOR::right_thrust_force = 0.0;
        RAPTOR::left_throttle_input = 0.0;
        RAPTOR::right_throttle_input = 0.0;
        RAPTOR::left_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::right_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::left_engine_switch = false;
        RAPTOR::right_engine_switch = false;
        RAPTOR::pitch_input = RAPTOR::roll_input = RAPTOR::yaw_input = 0.0;
        RAPTOR::left_elevon_command = RAPTOR::right_elevon_command = 0.0;
        RAPTOR::aileron_command = RAPTOR::rudder_command = 0.0;
        RAPTOR::left_ab_timer = 0.0;
        RAPTOR::right_ab_timer = 0.0;
        RAPTOR::V_scalar = 0.0;
        RAPTOR::pitch_rate = RAPTOR::roll_rate = RAPTOR::yaw_rate = 0.0;
    }

    cockpit_manager.update(dt);

    RAPTOR::gear_pos = limit(actuator(RAPTOR::gear_pos, RAPTOR::gear_switch, -0.0015, 0.0015), 0, 1);
    RAPTOR::airbrake_pos = limit(actuator(RAPTOR::airbrake_pos, RAPTOR::airbrake_switch, -0.004, 0.004), 0, 1);
    double slat_target = (RAPTOR::mach < 0.8) ? (RAPTOR::alpha - 10.0) / 10.0 : 0.0;
    RAPTOR::slats_pos = limit(actuator(RAPTOR::slats_pos, slat_target, -0.003, 0.003), 0, 1);

    RAPTOR::airspeed.x = RAPTOR::velocity_world.x - RAPTOR::wind.x;
    RAPTOR::airspeed.y = RAPTOR::velocity_world.y - RAPTOR::wind.y;
    RAPTOR::airspeed.z = RAPTOR::velocity_world.z - RAPTOR::wind.z;
    RAPTOR::V_scalar = sqrt(RAPTOR::airspeed.x * RAPTOR::airspeed.x + RAPTOR::airspeed.y * RAPTOR::airspeed.y + RAPTOR::airspeed.z * RAPTOR::airspeed.z);
    RAPTOR::mach = RAPTOR::V_scalar / RAPTOR::speed_of_sound;

    double aoa = RAPTOR::alpha;
    double x_offset;

    double x_offset_normal;
    if (aoa <= 3.5) {
        x_offset_normal = -0.8;
    }
    else if (aoa >= 20.0) {
        x_offset_normal = -0.5;
    }
    else {
        double t = (aoa - 3.5) / (20.0 - 3.5);
        x_offset_normal = -0.8 + t * (-0.5 - (-0.8));
    }

    x_offset = x_offset_normal;

    RAPTOR::left_wing_pos = Vec3(RAPTOR::center_of_mass.x + x_offset, RAPTOR::center_of_mass.y + 0.5, -RAPTOR::wingspan / 2);
    RAPTOR::right_wing_pos = Vec3(RAPTOR::center_of_mass.x + x_offset, RAPTOR::center_of_mass.y + 0.5, RAPTOR::wingspan / 2);

    double ias_ms = RAPTOR::V_scalar * sqrt(RAPTOR::atmosphere_density / 1.225);
    double ias_knots = ias_ms * 1.94384;

    if (RAPTOR::on_ground) {
        if (RAPTOR::ground_speed_knots < 45.0) {
            RAPTOR::flaps_pos = limit(actuator(RAPTOR::flaps_pos, 0.0, -0.006, 0.005), 0, 1);
        }
        else {
            RAPTOR::flaps_pos = limit(actuator(RAPTOR::flaps_pos, 1.0, -0.006, 0.005), 0, 1);
        }
    }
    else {
        if (RAPTOR::gear_pos > 0.5 && ias_knots < 250.0) {
            RAPTOR::flaps_pos = limit(actuator(RAPTOR::flaps_pos, 1.0, -0.006, 0.005), 0, 1);
        }
        else {
            RAPTOR::flaps_pos = limit(actuator(RAPTOR::flaps_pos, 0.0, -0.006, 0.005), 0, 1);
        }
    }

    if (RAPTOR::g >= 6) {
        RAPTOR::g_assist_pos = limit(actuator(RAPTOR::g_assist_pos, 1.0, -0.008, 0.007), 0.0, 1.0);
    }
    else {
        RAPTOR::g_assist_pos = limit(actuator(RAPTOR::g_assist_pos, 0.0, -0.007, 0.006), 0.0, 1.0);
    }

    double drag_direction = (fabs(RAPTOR::alpha) < 100.0) ? 1.0 : -1.0;
    double CyAlpha_ = lerp(FM_DATA::mach_table.data(), FM_DATA::Cya, FM_DATA::mach_table.size(), RAPTOR::mach);
    double CyMax_ = lerp(FM_DATA::mach_table.data(), FM_DATA::CyMax, FM_DATA::mach_table.size(), RAPTOR::mach);

    if (fabs(RAPTOR::alpha) >= 15.0) {
        double vortex_boost = 0.72 * exp(-pow((fabs(RAPTOR::alpha) - 35.0), 2) / (2 * 600.0));
        if (fabs(RAPTOR::alpha) > 65.0) vortex_boost = 0;
        CyMax_ += vortex_boost;
    }

    CyMax_ += (FM_DATA::cy_flap * RAPTOR::slats_pos);
    double Cy = CyAlpha_ * RAPTOR::alpha;
    if (Cy > CyMax_) Cy = CyMax_;
    if (Cy < -CyMax_) Cy = -CyMax_;

    if (fabs(RAPTOR::alpha) >= 90.0) {
        double aoa_excess = fabs(RAPTOR::alpha) - 90.0;
        double lift_reduction = 1.0 - (aoa_excess / 60.0) * 0.9;
        lift_reduction = limit(lift_reduction, 0.1, 1.0);
        Cy *= lift_reduction;
    }

    double CyBeta_ = lerp(FM_DATA::beta_table, FM_DATA::Cy_beta, sizeof(FM_DATA::beta_table) / sizeof(double), fabs(RAPTOR::beta));
    if (RAPTOR::alpha > 30.0) CyBeta_ *= 1.5;
    double Cy_tail = (0.5 * CyAlpha_ + FM_DATA::Czbe) * RAPTOR::beta + (RAPTOR::beta < 0 ? -CyBeta_ : CyBeta_);

    double Cx0_ = lerp(FM_DATA::mach_table.data(), FM_DATA::cx0, FM_DATA::mach_table.size(), RAPTOR::mach);
    double wave_drag_factor = 1.0 + 0.85 * std::max(0.0, (RAPTOR::mach - 0.9) / 0.3) * (1.0 - std::min(1.0, (RAPTOR::mach - 1.2) / 1.0)) * std::max(0.0, 1.0 - RAPTOR::altitude_ASL / 9144.0);
    double Drag = Cx0_ * wave_drag_factor + (FM_DATA::cx_brk * 1.2 * RAPTOR::airbrake_pos) + (FM_DATA::cx_flap * RAPTOR::flaps_pos) + (FM_DATA::cx_gear * RAPTOR::gear_pos);

    double AoA_drag = lerp(FM_DATA::AoA_table, FM_DATA::AoA_drag_factor, sizeof(FM_DATA::AoA_table) / sizeof(double), fabs(RAPTOR::alpha));
    Drag += AoA_drag;

    double gear_drag_penalty = 0.0;
    if (RAPTOR::gear_pos > 0.0) {
        double ias_ms = ias_knots * 0.514444;
        double base_gear_drag_coeff = 0.005;
        double speed_factor = (ias_ms / 100.0) * (ias_ms / 100.0);
        gear_drag_penalty = base_gear_drag_coeff * speed_factor * RAPTOR::gear_pos;
        Drag += gear_drag_penalty;
    }

    double q = 0.5 * RAPTOR::atmosphere_density * RAPTOR::V_scalar * RAPTOR::V_scalar;
    double Lift = Cy + FM_DATA::Cy0 + (FM_DATA::cy_flap * RAPTOR::flaps_pos);
    double aos_effect = (fabs(RAPTOR::aos) < 0.05) ? 0 : sin(RAPTOR::aos / 2);

    if (RAPTOR::on_ground && RAPTOR::ground_speed_knots > 30.0 && RAPTOR::wheel_brake > 0.7) {
        RAPTOR::landing_brake_assist = limit(actuator(RAPTOR::landing_brake_assist, 1.0, -0.008, 0.007), 0.0, 1.0);
        Drag += 0.60;
    }
    else {
        RAPTOR::landing_brake_assist = limit(actuator(RAPTOR::landing_brake_assist, 0.0, -0.008, 0.007), 0.0, 1.0);
    }

    Vec3 left_wing_forces(-Drag * drag_direction * (-aos_effect + 1) * q * (RAPTOR::S / 2) * RAPTOR::left_wing_integrity,
        Lift * (-aos_effect / 2 + 1) * q * (RAPTOR::S / 2) * RAPTOR::left_wing_integrity,
        Cy_tail * q * (RAPTOR::S / 2) * RAPTOR::left_wing_integrity);
    Vec3 right_wing_forces(-Drag * drag_direction * (aos_effect + 1) * q * (RAPTOR::S / 2) * RAPTOR::right_wing_integrity,
        Lift * (aos_effect / 2 + 1) * q * (RAPTOR::S / 2) * RAPTOR::right_wing_integrity,
        -Cy_tail * q * (RAPTOR::S / 2) * RAPTOR::right_wing_integrity);

    add_local_force(left_wing_forces, RAPTOR::left_wing_pos);
    add_local_force(right_wing_forces, RAPTOR::right_wing_pos);

    Vec3 tail_force(-Cy_tail * sin(RAPTOR::aoa) * (RAPTOR::S / 2) * q * RAPTOR::tail_integrity,
        0, -Cy_tail * cos(RAPTOR::aoa) * q * (RAPTOR::S / 2) * RAPTOR::tail_integrity);
    add_local_force(tail_force, RAPTOR::tail_pos);

    const double fbw_scale = 1.0;
    const double max_rate = 40.0;
    double beta_gain = (RAPTOR::mach > 0.9) ? std::clamp(0.1 * (RAPTOR::mach - 0.9) / 0.3, 0.0, 0.1) : 0.0;
    double pitch_cmd_source = RAPTOR::pitch_analog ? RAPTOR::pitch_input : RAPTOR::smoothed_pitch_discrete;
    double roll_cmd_source = RAPTOR::roll_analog ? RAPTOR::roll_input : RAPTOR::smoothed_roll_discrete;
    double yaw_cmd_source = RAPTOR::yaw_analog ? RAPTOR::yaw_input : RAPTOR::smoothed_yaw_discrete;

    double aileron_scale = 1.0;
    if (RAPTOR::mach > 0.75) {
        if (RAPTOR::mach < 1.25) {
            aileron_scale = 1.0 - ((RAPTOR::mach - 0.75) / (1.25 - 0.75)) * (1.0 - 0.3);
        }
        else {
            aileron_scale = 0.3;
        }
    }
    RAPTOR::aileron_animation_command = limit(roll_cmd_source * fabs(roll_cmd_source) * aileron_scale, -1.0, 1.0);

    if (RAPTOR::fm_clock < 0.1) {
        RAPTOR::left_elevon_command = RAPTOR::right_elevon_command = 0.0;
        RAPTOR::aileron_command = RAPTOR::rudder_command = 0.0;
    }
    else {
        double Kd_pitch = lerp(FM_DATA::mach_table.data(), FM_DATA::Kd_pitch, FM_DATA::mach_table.size(), RAPTOR::mach);
        double Kd_roll = lerp(FM_DATA::mach_table.data(), FM_DATA::Kd_roll, FM_DATA::mach_table.size(), RAPTOR::mach);
        double Kd_yaw = lerp(FM_DATA::mach_table.data(), FM_DATA::Kd_yaw, FM_DATA::mach_table.size(), RAPTOR::mach);

        double pitch_sensitivity = 1.0;
        double tv_sensitivity = 1.2;
        double max_deflection_rate = 2.27;

        if (RAPTOR::mach >= 0.67) {
            double mach_diff = RAPTOR::mach - 0.67;
            pitch_sensitivity = 1.0 - 0.229 * mach_diff * mach_diff;
            pitch_sensitivity = limit(pitch_sensitivity, 0.3, 1.0);
        }

        if (RAPTOR::mach >= 0.67) {
            double mach_diff = RAPTOR::mach - 0.67;
            if (RAPTOR::mach >= 1.2) {
                tv_sensitivity = 0.0;
            }
            else {
                double range = 1.2 - 0.67;
                tv_sensitivity = 1.0 - (1.0 / (range * range)) * mach_diff * mach_diff;
                tv_sensitivity = limit(tv_sensitivity, 0.0, 1.0);
            }
        }

        double elevator_rate = lerp(FM_DATA::mach_table.data(), FM_DATA::elevator_rate_table, FM_DATA::mach_table.size(), RAPTOR::mach);
        double tv_rate = lerp(FM_DATA::mach_table.data(), FM_DATA::thrust_vector_rate, FM_DATA::mach_table.size(), RAPTOR::mach);

        double max_elevator_deflection = lerp(FM_DATA::mach_table.data(), FM_DATA::max_elevator_deflection, FM_DATA::mach_table.size(), RAPTOR::mach);
        double max_tv_deflection = lerp(FM_DATA::mach_table.data(), FM_DATA::max_thrust_vector_deflection, FM_DATA::mach_table.size(), RAPTOR::mach);
        if (RAPTOR::on_ground == true) {
            max_tv_deflection = 0;
        }

        const double takeoff_trim_value = 0.25;
        const double takeoff_trim_rate = 0.05;

        double ias_ms = RAPTOR::V_scalar * sqrt(RAPTOR::atmosphere_density / 1.225);
        double ias_knots = ias_ms * 1.94384;

        double pitch_cmd_source = RAPTOR::pitch_analog ? RAPTOR::pitch_input : RAPTOR::smoothed_pitch_discrete;
        bool takeoff_trim_enabled = RAPTOR::on_ground &&
            ias_knots < 170.0 &&
            RAPTOR::pitch_trim == 0.0 &&
            fabs(pitch_cmd_source) < 0.05;

        double target_takeoff_trim = takeoff_trim_enabled ? takeoff_trim_value : 0.0;

        double trim_error = target_takeoff_trim - RAPTOR::takeoff_trim_cmd;
        RAPTOR::takeoff_trim_cmd += limit(trim_error, -takeoff_trim_rate * dt, takeoff_trim_rate * dt);

        const double autotrim_gain = 0.06;
        const double autotrim_max_cmd = 0.28;
        const double autotrim_rate_limit = 0.06;
        const double autotrim_fade_rate = 0.1;
        const double ref_q = 0.5 * 1.225 * 200.0 * 200.0;
        const double input_deadzone = 0.025;

        bool autotrim_disabled = RAPTOR::on_ground ||
            fabs(RAPTOR::roll) > 1.2217 ||
            RAPTOR::manual_trim_applied ||
            RAPTOR::alpha >= 9.0 ||
            ias_knots < 160.0;

        if (!autotrim_disabled) {
            RAPTOR::autotrim_active = true;
            double pitch_rate_deg_s = RAPTOR::pitch_rate * RAPTOR::rad_to_deg;
            double q = 0.5 * RAPTOR::atmosphere_density * RAPTOR::V_scalar * RAPTOR::V_scalar;
            double q_scale = (q > 100.0) ? ref_q / q : 1.0;
            double pitch_cmd_source = RAPTOR::pitch_analog ? RAPTOR::pitch_input : RAPTOR::smoothed_pitch_discrete;

            double pitch_rate_error = 0.0;
            if (pitch_cmd_source < -input_deadzone) {
                if (pitch_rate_deg_s >= 0.0) {
                    pitch_rate_error = 0.0 - pitch_rate_deg_s;
                }
            }
            else if (pitch_cmd_source > input_deadzone) {
                if (pitch_rate_deg_s <= 0.0) {
                    pitch_rate_error = 0.0 - pitch_rate_deg_s;
                }
            }
            else {
                pitch_rate_error = 0.0 - pitch_rate_deg_s;
            }

            double delta_cmd = pitch_rate_error * autotrim_gain * q_scale;
            delta_cmd = limit(delta_cmd, -autotrim_rate_limit * dt, autotrim_rate_limit * dt);
            RAPTOR::autotrim_elevator_cmd = limit(RAPTOR::autotrim_elevator_cmd + delta_cmd, -autotrim_max_cmd, autotrim_max_cmd);
        }
        else {
            RAPTOR::autotrim_active = false;
            if (RAPTOR::autotrim_elevator_cmd > 0) {
                RAPTOR::autotrim_elevator_cmd = std::max(RAPTOR::autotrim_elevator_cmd - autotrim_fade_rate * dt, 0.0);
            }
            else if (RAPTOR::autotrim_elevator_cmd < 0) {
                RAPTOR::autotrim_elevator_cmd = std::min(RAPTOR::autotrim_elevator_cmd + autotrim_fade_rate * dt, 0.0);
            }
        }

        if (fabs(roll_cmd_source) < 0.05) {
            Kd_roll = 0.75;
        }

        double elevator_cmd = (pitch_cmd_source * fabs(pitch_cmd_source) * 1.1) * pitch_sensitivity;
        elevator_cmd += -RAPTOR::pitch_rate * Kd_pitch;
        elevator_cmd += RAPTOR::pitch_trim;
        elevator_cmd += RAPTOR::autotrim_elevator_cmd;
        elevator_cmd += RAPTOR::takeoff_trim_cmd;
        elevator_cmd = limit(elevator_cmd, -1.0, 1.0);

        const double g_reduction_factor = 0.1;

        if (RAPTOR::g > RAPTOR::g_limit_positive && elevator_cmd > 0.0) {
            double g_excess = RAPTOR::g - RAPTOR::g_limit_positive;
            elevator_cmd -= g_excess * g_reduction_factor;
            elevator_cmd = std::max(elevator_cmd, 0.0);
        }
        else if (RAPTOR::g < RAPTOR::g_limit_negative && elevator_cmd < 0.0) {
            double g_excess = RAPTOR::g_limit_negative - RAPTOR::g;
            elevator_cmd += g_excess * g_reduction_factor;
            elevator_cmd = std::min(elevator_cmd, 0.0);
        }

        elevator_cmd = limit(RAPTOR::last_elevator_cmd + limit(elevator_cmd - RAPTOR::last_elevator_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
        RAPTOR::last_elevator_cmd = elevator_cmd;

        double roll_cmd = roll_cmd_source * fabs(roll_cmd_source);
        double roll_damping = -RAPTOR::roll_rate * Kd_roll;
        roll_cmd += roll_damping;
        RAPTOR::aileron_command = limit(RAPTOR::last_aileron_cmd + limit(roll_cmd - RAPTOR::last_aileron_cmd, -FM_DATA::max_aileron_rate * dt, FM_DATA::max_aileron_rate * dt), -1.0, 1.0);
        RAPTOR::last_aileron_cmd = RAPTOR::aileron_command;

        RAPTOR::left_elevon_command = limit(elevator_cmd - RAPTOR::aileron_command, -1.0, 1.0);
        RAPTOR::right_elevon_command = limit(elevator_cmd + RAPTOR::aileron_command, -1.0, 1.0);
        RAPTOR::last_elevator_cmd = elevator_cmd;

        double target_left_elevon_angle = -RAPTOR::left_elevon_command * RAPTOR::rad(max_elevator_deflection);
        double target_right_elevon_angle = -RAPTOR::right_elevon_command * RAPTOR::rad(max_elevator_deflection);
        double elevon_step = elevator_rate * dt;

        if (RAPTOR::left_elevon_angle < target_left_elevon_angle) {
            RAPTOR::left_elevon_angle = std::min<double>(RAPTOR::left_elevon_angle + elevon_step, target_left_elevon_angle);
        }
        else if (RAPTOR::left_elevon_angle > target_left_elevon_angle) {
            RAPTOR::left_elevon_angle = std::max<double>(RAPTOR::left_elevon_angle - elevon_step, target_left_elevon_angle);
        }

        if (RAPTOR::right_elevon_angle < target_right_elevon_angle) {
            RAPTOR::right_elevon_angle = std::min<double>(RAPTOR::right_elevon_angle + elevon_step, target_right_elevon_angle);
        }
        else if (RAPTOR::right_elevon_angle > target_right_elevon_angle) {
            RAPTOR::right_elevon_angle = std::max<double>(RAPTOR::right_elevon_angle - elevon_step, target_right_elevon_angle);
        }

        double tv_pitch_cmd = (pitch_cmd_source * fabs(pitch_cmd_source) * 1.1) * tv_sensitivity;

        if (RAPTOR::alpha > 70.0) tv_pitch_cmd -= (RAPTOR::alpha - 70.0) * 0.0285;
        if (RAPTOR::alpha < -40.0) tv_pitch_cmd += (-RAPTOR::alpha - 40.0) * 0.033;

        if (RAPTOR::gear_pos == 1.0) {
            if (RAPTOR::alpha > 15.0) tv_pitch_cmd -= (RAPTOR::alpha - 15.0) * 0.1;
            if (RAPTOR::alpha < -15.0) tv_pitch_cmd += (-RAPTOR::alpha - 12.0) * 0.1;
        }

        tv_pitch_cmd += -RAPTOR::pitch_rate;

        double tv_command = limit(RAPTOR::last_tv_cmd + limit(tv_pitch_cmd - RAPTOR::last_tv_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
        RAPTOR::last_tv_cmd = tv_command;

        double target_tv_angle = -tv_command * RAPTOR::rad(max_tv_deflection);
        double tv_step = tv_rate * dt;
        if (RAPTOR::tv_angle < target_tv_angle) {
            RAPTOR::tv_angle = std::min<double>(RAPTOR::tv_angle + tv_step, target_tv_angle);
        }
        else if (RAPTOR::tv_angle > target_tv_angle) {
            RAPTOR::tv_angle = std::max<double>(RAPTOR::tv_angle - tv_step, target_tv_angle);
        }

        double yaw_cmd;
        const double beta_integral_gain = 0.06;
        const double beta_integral_limit = 0.01;
        const double beta_integral_decay = 0.07;

        double adverse_yaw_cmd = 0.0;
        if (fabs(yaw_cmd_source) < 0.01) {
            double adverse_yaw_gain = 0.3 * (1.0 - std::min(RAPTOR::mach, 1.0));
            adverse_yaw_cmd = RAPTOR::aileron_command * adverse_yaw_gain * (q / (q + 10000.0));
            adverse_yaw_cmd = limit(adverse_yaw_cmd, -0.3, 0.3);
        }
        if (fabs(yaw_cmd_source) < 0.01) {
            yaw_cmd = -RAPTOR::yaw_rate * Kd_yaw - std::clamp(RAPTOR::beta, -3.0, 3.0) * std::clamp(RAPTOR::last_yaw_input, 0.0, 0.3);
            yaw_cmd -= beta_gain * RAPTOR::beta;
            yaw_cmd += adverse_yaw_cmd;

            if (fabs(RAPTOR::beta) < 3.0 && !RAPTOR::on_ground && fabs(RAPTOR::rudder_command) < 0.9) {
                RAPTOR::beta_integral += RAPTOR::beta * beta_integral_gain * dt;
                RAPTOR::beta_integral = limit(RAPTOR::beta_integral, -beta_integral_limit, beta_integral_limit);
            }
            else {
                RAPTOR::beta_integral *= std::exp(-beta_integral_decay * dt);
            }
            yaw_cmd -= RAPTOR::beta_integral;

            if (RAPTOR::alpha > 10.0) {
                double pitch_yaw_coupling = -RAPTOR::pitch_rate * 0.11 * (RAPTOR::alpha / lerp(FM_DATA::mach_table.data(), FM_DATA::Aldop, FM_DATA::mach_table.size(), RAPTOR::mach));
                yaw_cmd += limit(pitch_yaw_coupling, -0.5, 0.5);
            }
            RAPTOR::last_yaw_input -= dt / 0.5;
            if (RAPTOR::last_yaw_input < 0.0) RAPTOR::last_yaw_input = 0.0;
        }
        else {
            yaw_cmd = 0.5 * yaw_cmd_source * sqrt(fabs(yaw_cmd_source)) - RAPTOR::yaw_rate * Kd_yaw;
            yaw_cmd -= beta_gain * RAPTOR::beta * 0.5;
            yaw_cmd += adverse_yaw_cmd * 0.5;
            RAPTOR::beta_integral *= std::exp(-beta_integral_decay * dt);
            RAPTOR::last_yaw_input = 0.5 * fabs(yaw_cmd_source);
        }

        RAPTOR::rudder_command = limit(RAPTOR::last_rudder_cmd + limit(yaw_cmd - RAPTOR::last_rudder_cmd, -max_rate * dt, max_rate * dt), -1.0, 1.0);
        RAPTOR::last_rudder_cmd = RAPTOR::rudder_command;

        double elevon_force_magnitude = q * RAPTOR::S * 0.20;
        
        double aoa_abs = fabs(RAPTOR::alpha);
        double elevon_aoa_scale = 1.0;
        if (aoa_abs > 30.0) {
            elevon_aoa_scale = 1.0 - (0.9 * (aoa_abs - 30.0) / (60.0 - 30.0));
            elevon_aoa_scale = limit(elevon_aoa_scale, 0.1, 1.0);
        }

        add_local_force(Vec3(0, RAPTOR::left_elevon_angle * elevon_force_magnitude * elevon_aoa_scale * RAPTOR::left_elevon_integrity, 0), RAPTOR::left_elevon_pos);
        add_local_force(Vec3(0, RAPTOR::right_elevon_angle * elevon_force_magnitude * elevon_aoa_scale * RAPTOR::right_elevon_integrity, 0), RAPTOR::right_elevon_pos);

        double aileron_deflection = RAPTOR::aileron_command * RAPTOR::rad(30);
        add_local_force(Vec3(0, aileron_deflection * q * RAPTOR::S * 0.25, 0), RAPTOR::left_aileron_pos);
        add_local_force(Vec3(0, -aileron_deflection * q * RAPTOR::S * 0.25, 0), RAPTOR::right_aileron_pos);
        double rudder_deflection = RAPTOR::rudder_command * RAPTOR::rad(25 + (RAPTOR::mach < 0.5 ? 5.0 : 0.0));
        if (RAPTOR::is_destroyed == true) { rudder_deflection = 0.0; }
        add_local_force(Vec3(0, 0, rudder_deflection * q * RAPTOR::S * 0.3), RAPTOR::rudder_pos);

        double left_tv_force = RAPTOR::left_thrust_force * RAPTOR::left_throttle_output * sin(RAPTOR::tv_angle);
        double right_tv_force = RAPTOR::right_thrust_force * RAPTOR::right_throttle_output * sin(RAPTOR::tv_angle);
        if (RAPTOR::is_destroyed == true) { left_tv_force = right_tv_force = 0.0; }
        add_local_force(Vec3(RAPTOR::left_thrust_force * cos(RAPTOR::tv_angle), left_tv_force, 0), RAPTOR::left_engine_pos);
        add_local_force(Vec3(RAPTOR::right_thrust_force * cos(RAPTOR::tv_angle), right_tv_force, 0), RAPTOR::right_engine_pos);
    }

    double idle_thrust = lerp(FM_DATA::mach_table.data(), FM_DATA::idle_thrust.data(), FM_DATA::mach_table.size(), RAPTOR::mach);
    double max_dry_thrust_base = lerp(FM_DATA::mach_table.data(), FM_DATA::max_thrust.data(), FM_DATA::mach_table.size(), RAPTOR::mach);
    double max_ab_thrust_base = lerp(FM_DATA::mach_table.data(), FM_DATA::ab_thrust.data(), FM_DATA::mach_table.size(), RAPTOR::mach);

    const double static_max_dry_thrust = 112654.0;
    const double static_max_ab_thrust = 155688.0;

    double max_dry_thrust = RAPTOR::on_ground ? static_max_dry_thrust : max_dry_thrust_base;
    double max_ab_thrust = RAPTOR::on_ground ? static_max_ab_thrust : max_ab_thrust_base;

    double dry_range = max_dry_thrust - idle_thrust;
    double ab_range = max_ab_thrust - max_dry_thrust;

    const double ab_spool_time_air = 1.1;
    const double spool_up_rate_air = 0.1285;
    const double spool_down_rate_air = 0.122;
    const double ab_spool_time_ground = 1.65;
    const double spool_up_rate_ground = 0.079;
    const double spool_down_rate_ground = 0.0813;
    const double shutoff_spool_down = 0.041;

    double ab_spool_time = RAPTOR::on_ground ? ab_spool_time_ground : ab_spool_time_air;
    double spool_up_rate = RAPTOR::on_ground ? spool_up_rate_ground : spool_up_rate_air;
    double spool_down_rate = RAPTOR::on_ground ? spool_down_rate_ground : spool_down_rate_air;

    RAPTOR::left_throttle_input = limit(RAPTOR::left_throttle_input, 0, 1);
    RAPTOR::right_throttle_input = limit(RAPTOR::right_throttle_input, 0, 1);

    double thrust_alt_factor = RAPTOR::atmosphere_density / 1.225;
    const double idle_rps = 50.0;
    const double max_rps = 150.0;

    if (RAPTOR::left_engine_state == RAPTOR::OFF) {
        RAPTOR::left_throttle_output = 0.0;
        RAPTOR::left_engine_power_readout = 0.0;
        RAPTOR::left_thrust_force = 0.0;
        RAPTOR::left_ab_timer = 0.0;
        RAPTOR::left_engine_start_timer = 0.0;
    }
    else if (RAPTOR::left_engine_state == RAPTOR::STARTING) {
        RAPTOR::left_engine_start_timer += dt;
        if (RAPTOR::left_engine_start_timer <= RAPTOR::starter_phase_duration) {
            RAPTOR::left_throttle_output = RAPTOR::starter_rate * RAPTOR::left_engine_start_timer;
        }
        else if (RAPTOR::left_engine_start_timer <= RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration) {
            double phase_time = RAPTOR::left_engine_start_timer - RAPTOR::starter_phase_duration;
            RAPTOR::left_throttle_output = RAPTOR::starter_rpm + RAPTOR::ignition_rate * phase_time;
        }
        else if (RAPTOR::left_engine_start_timer <= RAPTOR::engine_start_time) {
            double phase_time = RAPTOR::left_engine_start_timer - (RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration);
            RAPTOR::left_throttle_output = RAPTOR::ignition_rpm + RAPTOR::spool_up_rate * phase_time;
        }
        else {
            RAPTOR::left_throttle_output = RAPTOR::idle_rpm;
            RAPTOR::left_engine_state = RAPTOR::RUNNING;
        }
        RAPTOR::left_throttle_output = limit(RAPTOR::left_throttle_output, 0.0, RAPTOR::idle_rpm);
        RAPTOR::left_engine_power_readout = RAPTOR::left_throttle_output;
        if (RAPTOR::left_engine_start_timer > RAPTOR::starter_phase_duration) {
            double norm_throttle = RAPTOR::left_throttle_output / RAPTOR::idle_rpm;
            RAPTOR::left_thrust_force = idle_thrust * norm_throttle * thrust_alt_factor * RAPTOR::left_engine_integrity;
        }
        else {
            RAPTOR::left_thrust_force = 0.0;
        }
        RAPTOR::left_ab_timer = 0.0;
    }
    else if (RAPTOR::left_engine_state == RAPTOR::RUNNING) {
        double left_target_throttle = 0.67 + (RAPTOR::left_throttle_input * 0.43);
        double delta = left_target_throttle - RAPTOR::left_throttle_output;
        double rate = (delta > 0) ? spool_up_rate : -spool_down_rate;
        RAPTOR::left_throttle_output += limit(delta, -spool_down_rate * dt, spool_up_rate * dt);
        RAPTOR::left_throttle_output = limit(RAPTOR::left_throttle_output, 0.67, 1.1);
        RAPTOR::left_engine_power_readout = RAPTOR::left_throttle_output;
        if (RAPTOR::left_throttle_output >= 1.035 && left_target_throttle > 1.035) {
            RAPTOR::left_ab_timer += dt / ab_spool_time;
        }
        else {
            RAPTOR::left_ab_timer -= dt / ab_spool_time;
        }
        RAPTOR::left_ab_timer = limit(RAPTOR::left_ab_timer, 0, 1);

        if (RAPTOR::left_throttle_output <= 1.025) {
            double norm_throttle = (RAPTOR::left_throttle_output - 0.67) / 0.355;
            double thrust_factor = norm_throttle * norm_throttle;
            RAPTOR::left_thrust_force = (idle_thrust + dry_range * thrust_factor) * thrust_alt_factor * RAPTOR::left_engine_integrity;
        }
        else {
            double norm_throttle = (RAPTOR::left_throttle_output - 1.025) / 0.075;
            double thrust_factor;
            if (norm_throttle <= 0.0667) {
                thrust_factor = 0.0;
            }
            else {
                double adjusted_throttle = (norm_throttle - 0.0667) / (1.0 - 0.0667);
                thrust_factor = adjusted_throttle * adjusted_throttle;
            }
            RAPTOR::left_thrust_force = (max_dry_thrust + ab_range * thrust_factor * RAPTOR::left_ab_timer) * thrust_alt_factor * RAPTOR::left_engine_integrity;
        }
    }
    else if (RAPTOR::left_engine_state == RAPTOR::SHUTDOWN) {
        RAPTOR::left_throttle_output -= shutoff_spool_down * dt;
        if (RAPTOR::left_throttle_output <= 0.0) {
            RAPTOR::left_throttle_output = 0.0;
            RAPTOR::left_engine_state = RAPTOR::OFF;
            RAPTOR::left_engine_switch = false;
        }
        RAPTOR::left_engine_power_readout = RAPTOR::left_throttle_output;
        RAPTOR::left_ab_timer = limit(RAPTOR::left_ab_timer - dt / ab_spool_time, 0, 1);

        if (RAPTOR::left_throttle_output <= 1.025) {
            double norm_throttle = (RAPTOR::left_throttle_output > 0.67 ? (RAPTOR::left_throttle_output - 0.67) / 0.355 : 0.0);
            double thrust_factor = norm_throttle * norm_throttle;
            RAPTOR::left_thrust_force = (idle_thrust + dry_range * thrust_factor) * thrust_alt_factor * RAPTOR::left_engine_integrity;
        }
        else {
            double norm_throttle = (RAPTOR::left_throttle_output - 1.025) / 0.075;
            double thrust_factor;
            if (norm_throttle <= 0.0667) {
                thrust_factor = 0.0;
            }
            else {
                double adjusted_throttle = (norm_throttle - 0.0667) / (1.0 - 0.0667);
                thrust_factor = adjusted_throttle * adjusted_throttle;
            }
            RAPTOR::left_thrust_force = (max_dry_thrust + ab_range * thrust_factor * RAPTOR::left_ab_timer) * thrust_alt_factor * RAPTOR::left_engine_integrity;
        }
        if (RAPTOR::left_throttle_output <= 0.0) {
            RAPTOR::left_thrust_force = 0.0;
        }
    }
    double left_rps = 0.0;
    if (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::left_engine_state == RAPTOR::STARTING) {
        double norm_throttle = (RAPTOR::left_engine_power_readout - 0.67) / (1.1 - 0.67);
        norm_throttle = limit(norm_throttle, 0.0, 1.0);
        left_rps = idle_rps + (max_rps - idle_rps) * norm_throttle;
    }
    else if (RAPTOR::left_engine_state == RAPTOR::SHUTDOWN) {
        double norm_throttle = (RAPTOR::left_engine_power_readout > 0.67 ? (RAPTOR::left_engine_power_readout - 0.67) / (1.1 - 0.67) : 0.0);
        norm_throttle = limit(norm_throttle, 0.0, 1.0);
        left_rps = idle_rps + (max_rps - idle_rps) * norm_throttle;
    }
    RAPTOR::left_engine_phase += left_rps * dt;
    RAPTOR::left_engine_phase -= floor(RAPTOR::left_engine_phase);

    if (RAPTOR::right_engine_state == RAPTOR::OFF) {
        RAPTOR::right_throttle_output = 0.0;
        RAPTOR::right_engine_power_readout = 0.0;
        RAPTOR::right_thrust_force = 0.0;
        RAPTOR::right_ab_timer = 0.0;
        RAPTOR::right_engine_start_timer = 0.0;
    }
    else if (RAPTOR::right_engine_state == RAPTOR::STARTING) {
        RAPTOR::right_engine_start_timer += dt;
        if (RAPTOR::right_engine_start_timer <= RAPTOR::starter_phase_duration) {
            RAPTOR::right_throttle_output = RAPTOR::starter_rate * RAPTOR::right_engine_start_timer;
        }
        else if (RAPTOR::right_engine_start_timer <= RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration) {
            double phase_time = RAPTOR::right_engine_start_timer - RAPTOR::starter_phase_duration;
            RAPTOR::right_throttle_output = RAPTOR::starter_rpm + RAPTOR::ignition_rate * phase_time;
        }
        else if (RAPTOR::right_engine_start_timer <= RAPTOR::engine_start_time) {
            double phase_time = RAPTOR::right_engine_start_timer - (RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration);
            RAPTOR::right_throttle_output = RAPTOR::ignition_rpm + RAPTOR::spool_up_rate * phase_time;
        }
        else {
            RAPTOR::right_throttle_output = RAPTOR::idle_rpm;
            RAPTOR::right_engine_state = RAPTOR::RUNNING;
        }
        RAPTOR::right_throttle_output = limit(RAPTOR::right_throttle_output, 0.0, RAPTOR::idle_rpm);
        RAPTOR::right_engine_power_readout = RAPTOR::right_throttle_output;
        if (RAPTOR::right_engine_start_timer > RAPTOR::starter_phase_duration) {
            double norm_throttle = RAPTOR::right_throttle_output / RAPTOR::idle_rpm;
            RAPTOR::right_thrust_force = idle_thrust * norm_throttle * thrust_alt_factor * RAPTOR::right_engine_integrity;
        }
        else {
            RAPTOR::right_thrust_force = 0.0;
        }
        RAPTOR::right_ab_timer = 0.0;
    }
    else if (RAPTOR::right_engine_state == RAPTOR::RUNNING) {
        double right_target_throttle = 0.67 + (RAPTOR::right_throttle_input * 0.43);
        double delta = right_target_throttle - RAPTOR::right_throttle_output;
        double rate = (delta > 0) ? spool_up_rate : -spool_down_rate;
        RAPTOR::right_throttle_output += limit(delta, -spool_down_rate * dt, spool_up_rate * dt);
        RAPTOR::right_throttle_output = limit(RAPTOR::right_throttle_output, 0.67, 1.1);
        RAPTOR::right_engine_power_readout = RAPTOR::right_throttle_output;
        if (RAPTOR::right_throttle_output >= 1.035 && right_target_throttle > 1.035) {
            RAPTOR::right_ab_timer += dt / ab_spool_time;
        }
        else {
            RAPTOR::right_ab_timer -= dt / ab_spool_time;
        }
        RAPTOR::right_ab_timer = limit(RAPTOR::right_ab_timer, 0, 1);

        if (RAPTOR::right_throttle_output <= 1.025) {
            double norm_throttle = (RAPTOR::right_throttle_output - 0.67) / 0.355;
            double thrust_factor = norm_throttle * norm_throttle;
            RAPTOR::right_thrust_force = (idle_thrust + dry_range * thrust_factor) * thrust_alt_factor * RAPTOR::right_engine_integrity;
        }
        else {
            double norm_throttle = (RAPTOR::right_throttle_output - 1.025) / 0.075;
            double thrust_factor;
            if (norm_throttle <= 0.0667) {
                thrust_factor = 0.0;
            }
            else {
                double adjusted_throttle = (norm_throttle - 0.0667) / (1.0 - 0.0667);
                thrust_factor = adjusted_throttle * adjusted_throttle;
            }
            RAPTOR::right_thrust_force = (max_dry_thrust + ab_range * thrust_factor * RAPTOR::right_ab_timer) * thrust_alt_factor * RAPTOR::right_engine_integrity;
        }
    }
    else if (RAPTOR::right_engine_state == RAPTOR::SHUTDOWN) {
        RAPTOR::right_throttle_output -= shutoff_spool_down * dt;
        if (RAPTOR::right_throttle_output <= 0.0) {
            RAPTOR::right_throttle_output = 0.0;
            RAPTOR::right_engine_state = RAPTOR::OFF;
            RAPTOR::right_engine_switch = false;
        }
        RAPTOR::right_engine_power_readout = RAPTOR::right_throttle_output;
        RAPTOR::right_ab_timer = limit(RAPTOR::right_ab_timer - dt / ab_spool_time, 0, 1);

        if (RAPTOR::right_throttle_output <= 1.025) {
            double norm_throttle = (RAPTOR::right_throttle_output > 0.67 ? (RAPTOR::right_throttle_output - 0.67) / 0.355 : 0.0);
            double thrust_factor = norm_throttle * norm_throttle;
            RAPTOR::right_thrust_force = (idle_thrust + dry_range * thrust_factor) * thrust_alt_factor * RAPTOR::right_engine_integrity;
        }
        else {
            double norm_throttle = (RAPTOR::right_throttle_output - 1.025) / 0.075;
            double thrust_factor;
            if (norm_throttle <= 0.0667) {
                thrust_factor = 0.0;
            }
            else {
                double adjusted_throttle = (norm_throttle - 0.0667) / (1.0 - 0.0667);
                thrust_factor = adjusted_throttle * adjusted_throttle;
            }
            RAPTOR::right_thrust_force = (max_dry_thrust + ab_range * thrust_factor * RAPTOR::right_ab_timer) * thrust_alt_factor * RAPTOR::right_engine_integrity;
        }
        if (RAPTOR::right_throttle_output <= 0.0) {
            RAPTOR::right_thrust_force = 0.0;
        }
    }

    double right_rps = 0.0;
    if (RAPTOR::right_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::STARTING) {
        double norm_throttle = (RAPTOR::right_engine_power_readout - 0.67) / (1.1 - 0.67);
        norm_throttle = limit(norm_throttle, 0.0, 1.0);
        right_rps = idle_rps + (max_rps - idle_rps) * norm_throttle;
    }
    else if (RAPTOR::right_engine_state == RAPTOR::SHUTDOWN) {
        double norm_throttle = (RAPTOR::right_engine_power_readout > 0.67 ? (RAPTOR::right_engine_power_readout - 0.67) / (1.1 - 0.67) : 0.0);
        norm_throttle = limit(norm_throttle, 0.0, 1.0);
        right_rps = idle_rps + (max_rps - idle_rps) * norm_throttle;
    }
    RAPTOR::right_engine_phase += right_rps * dt;
    RAPTOR::right_engine_phase -= floor(RAPTOR::right_engine_phase);

    if (RAPTOR::internal_fuel <= 25 && (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::left_engine_state == RAPTOR::STARTING)) {
        RAPTOR::left_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::left_engine_switch = false;
    }
    if (RAPTOR::internal_fuel <= 25 && (RAPTOR::right_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::STARTING)) {
        RAPTOR::right_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::right_engine_switch = false;
    }

    if (RAPTOR::left_engine_integrity <= 0.25 && (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::left_engine_state == RAPTOR::STARTING)) {
        RAPTOR::left_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::left_engine_switch = false;
    }
    if (RAPTOR::right_engine_integrity <= 0.25 && (RAPTOR::right_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::STARTING)) {
        RAPTOR::right_engine_state = RAPTOR::SHUTDOWN;
        RAPTOR::right_engine_switch = false;
    }

    RAPTOR::left_engine_power_readout *= RAPTOR::left_engine_integrity;
    RAPTOR::right_engine_power_readout *= RAPTOR::right_engine_integrity;

    if (!RAPTOR::infinite_fuel) simulate_fuel_consumption(dt);

    double roll_yaw_moment = -(RAPTOR::roll_rate / 2) * (q + 1e5 * 0.5);
    add_local_moment(Vec3(0, roll_yaw_moment, 0));
    double OmxMax_ = lerp(FM_DATA::mach_table.data(), FM_DATA::OmxMax, FM_DATA::mach_table.size(), RAPTOR::mach);
    double roll_rate_ratio = std::fabs(RAPTOR::roll_rate) / (OmxMax_ + 0.1);
    double clamped_ratio = std::clamp(roll_rate_ratio, 0.0001, 2.0);
    double amplified_ratio = std::pow(clamped_ratio, 6);
    double dynamic_pressure_term = 2.0 * q + 50000.0;
    double scaling_factor = amplified_ratio * dynamic_pressure_term;
    double clamped_scaling = std::clamp(scaling_factor, -1e7, 1e7);
    double roll_rate_limiter = -RAPTOR::roll_rate * clamped_scaling;

    add_local_moment(Vec3(roll_rate_limiter, 0, 0));
    double yaw_rate_limiter = -(RAPTOR::yaw_rate + RAPTOR::aos) * (q + 1e5 * 0.5);
    add_local_moment(Vec3(0, yaw_rate_limiter, 0));

    RAPTOR::on_ground = (RAPTOR::gear_pos > 0.5 && RAPTOR::altitude_AGL < 50.0 && RAPTOR::mach < 0.3);

    double ground_vel_x = RAPTOR::velocity_world.x - RAPTOR::wind.x;
    double ground_vel_z = RAPTOR::velocity_world.z - RAPTOR::wind.z;
    RAPTOR::ground_speed_knots = sqrt(ground_vel_x * ground_vel_x + ground_vel_z * ground_vel_z) * 1.94384;

    RAPTOR::shake_amplitude = 0;
    RAPTOR::shake_amplitude += limit((FM_DATA::cx_brk + 1) * RAPTOR::airbrake_pos * RAPTOR::mach, 0, 2) / 6;
    if (!RAPTOR::on_ground) {
        if (fabs(RAPTOR::alpha) > 90) RAPTOR::shake_amplitude += (fabs(RAPTOR::alpha) - 90) / 100;
        if (fabs(RAPTOR::beta) > 10) RAPTOR::shake_amplitude += (fabs(RAPTOR::beta) - 10) / 100;
        if (fabs(RAPTOR::g) > 9.5) RAPTOR::shake_amplitude += (fabs(RAPTOR::g) - 9.5) / 100;
        if (RAPTOR::mach > 2.31) RAPTOR::shake_amplitude += (RAPTOR::mach - 2.31) / 2;
    }

    RAPTOR::sim_initialised = true;
}

void ed_fm_set_atmosphere(double h, double t, double a, double ro, double p, double wind_vx, double wind_vy, double wind_vz) {
    RAPTOR::wind = Vec3(wind_vx, wind_vy, wind_vz);
    RAPTOR::atmosphere_density = ro;
    RAPTOR::speed_of_sound = a;
    RAPTOR::altitude_ASL = h;
    RAPTOR::engine_alt_effect = RAPTOR::atmosphere_density / 1.225;
    RAPTOR::atmosphere_temperature = t;
}

void ed_fm_set_surface(double h, double h_obj, unsigned surface_type, double normal_x, double normal_y, double normal_z) {
    RAPTOR::altitude_AGL = RAPTOR::altitude_ASL - (h + h_obj * 0.5);
}

void ed_fm_set_current_mass_state(double mass, double center_of_mass_x, double center_of_mass_y, double center_of_mass_z, double moment_of_inertia_x, double moment_of_inertia_y, double moment_of_inertia_z)
{
    RAPTOR::center_of_mass.x = center_of_mass_x;
    RAPTOR::center_of_mass.y = center_of_mass_y;
    RAPTOR::center_of_mass.z = center_of_mass_z;

}

void ed_fm_set_current_state(double ax, double ay, double az, double vx, double vy, double vz, double px, double py, double pz,
    double omegadotx, double omegadoty, double omegadotz, double omegax, double omegay, double omegaz,
    double quaternion_x, double quaternion_y, double quaternion_z, double quaternion_w) {
    RAPTOR::velocity_world = Vec3(vx, vy, vz);
}

void ed_fm_set_current_state_body_axis(double ax, double ay, double az, double vx, double vy, double vz, double wind_vx, double wind_vy, double wind_vz,
    double omegadotx, double omegadoty, double omegadotz, double omegax, double omegay, double omegaz,
    double yaw, double pitch, double roll, double common_angle_of_attack, double common_angle_of_slide) {
    RAPTOR::aoa = common_angle_of_attack;
    RAPTOR::alpha = RAPTOR::aoa * RAPTOR::rad_to_deg;
    RAPTOR::aos = common_angle_of_slide;
    RAPTOR::beta = RAPTOR::aos * RAPTOR::rad_to_deg;
    RAPTOR::g = (ay / 9.81) + 1;
    RAPTOR::pitch = pitch;
    RAPTOR::roll = roll;
    RAPTOR::heading = yaw;
    RAPTOR::roll_rate = omegax;
    RAPTOR::yaw_rate = omegay;
    RAPTOR::pitch_rate = omegaz;
}

void ed_fm_set_command(int command, float value) {
    double ias_ms = RAPTOR::V_scalar * sqrt(RAPTOR::atmosphere_density / 1.225);
    double ias_knots_local = ias_ms * 1.94384;
    switch (command) {
    case JoystickPitch:
        RAPTOR::pitch_input = limit(value, -1, 1);
        RAPTOR::pitch_analog = true;
        RAPTOR::pitch_discrete = 0;
        break;
    case PitchUp: RAPTOR::pitch_discrete = 1; RAPTOR::pitch_analog = false; break;
    case PitchUpStop: RAPTOR::pitch_discrete = 0; RAPTOR::pitch_analog = false; break;
    case PitchDown: RAPTOR::pitch_discrete = -1; RAPTOR::pitch_analog = false; break;
    case PitchDownStop: RAPTOR::pitch_discrete = 0; RAPTOR::pitch_analog = false; break;
    case trimUp:
        if (!RAPTOR::manual_trim_applied) {
            RAPTOR::pitch_trim += RAPTOR::autotrim_elevator_cmd;
            RAPTOR::autotrim_elevator_cmd = 0.0;
            RAPTOR::manual_trim_applied = true;
        }
        RAPTOR::pitch_trim = limit(RAPTOR::pitch_trim + 0.01, -1.0, 1.0);
        break;
    case trimDown:
        if (!RAPTOR::manual_trim_applied) {
            RAPTOR::pitch_trim += RAPTOR::autotrim_elevator_cmd;
            RAPTOR::autotrim_elevator_cmd = 0.0;
            RAPTOR::manual_trim_applied = true;
        }
        RAPTOR::pitch_trim = limit(RAPTOR::pitch_trim - 0.01, -1.0, 1.0);
        break;
    case resetTrim:
        RAPTOR::autotrim_elevator_cmd = limit(RAPTOR::pitch_trim, -0.2, 0.2);
        RAPTOR::pitch_trim = RAPTOR::roll_trim = RAPTOR::yaw_trim = 0;
        RAPTOR::manual_trim_applied = false;
        break;

    case JoystickRoll:
        RAPTOR::roll_input = limit(value, -1, 1);
        RAPTOR::roll_analog = true;
        RAPTOR::roll_discrete = 0;
        break;
    case RollLeft: RAPTOR::roll_discrete = -1; RAPTOR::roll_analog = false; break;
    case RollLeftStop: RAPTOR::roll_discrete = 0; RAPTOR::roll_analog = false; break;
    case RollRight: RAPTOR::roll_discrete = 1; RAPTOR::roll_analog = false; break;
    case RollRightStop: RAPTOR::roll_discrete = 0; RAPTOR::roll_analog = false; break;
    case trimLeft: RAPTOR::roll_trim -= 0.001; break;
    case trimRight: RAPTOR::roll_trim += 0.001; break;
    case PedalYaw: RAPTOR::yaw_input = limit(-value, -1, 1); RAPTOR::yaw_discrete = 0; RAPTOR::yaw_analog = true; break;
    case rudderleft: RAPTOR::yaw_discrete = 1; RAPTOR::yaw_analog = false; break;
    case rudderleftstop: RAPTOR::yaw_discrete = 0; RAPTOR::yaw_analog = false; break;
    case rudderright: RAPTOR::yaw_discrete = -1; RAPTOR::yaw_analog = false; break;
    case rudderrightstop: RAPTOR::yaw_discrete = 0; RAPTOR::yaw_analog = false; break;
    case ruddertrimLeft: RAPTOR::yaw_trim += 0.001; break;
    case ruddertrimRight: RAPTOR::yaw_trim -= 0.001; break;
    case EnginesOn:
        if (RAPTOR::internal_fuel > 25) {
            if (RAPTOR::left_engine_state == RAPTOR::OFF || RAPTOR::left_engine_state == RAPTOR::SHUTDOWN) {
                RAPTOR::left_engine_switch = true;
                RAPTOR::left_engine_state = RAPTOR::STARTING;
                RAPTOR::left_throttle_output = std::max(RAPTOR::left_throttle_output, 0.0);
                double time = 0.0;
                if (RAPTOR::left_throttle_output <= RAPTOR::starter_rpm) {
                    time = RAPTOR::left_throttle_output / RAPTOR::starter_rate;
                }
                else if (RAPTOR::left_throttle_output <= RAPTOR::ignition_rpm) {
                    time = (RAPTOR::left_throttle_output - RAPTOR::starter_rpm) / RAPTOR::ignition_rate + RAPTOR::starter_phase_duration;
                }
                else {
                    time = (RAPTOR::left_throttle_output - RAPTOR::ignition_rpm) / RAPTOR::spool_up_rate + (RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration);
                }
                RAPTOR::left_engine_start_timer = std::min(time, RAPTOR::engine_start_time);
            }
            if (RAPTOR::right_engine_state == RAPTOR::OFF || RAPTOR::right_engine_state == RAPTOR::SHUTDOWN) {
                RAPTOR::right_engine_switch = true;
                RAPTOR::right_engine_state = RAPTOR::STARTING;
                RAPTOR::right_throttle_output = std::max(RAPTOR::right_throttle_output, 0.0);
                double time = 0.0;
                if (RAPTOR::right_throttle_output <= RAPTOR::starter_rpm) {
                    time = RAPTOR::right_throttle_output / RAPTOR::starter_rate;
                }
                else if (RAPTOR::right_throttle_output <= RAPTOR::ignition_rpm) {
                    time = (RAPTOR::right_throttle_output - RAPTOR::starter_rpm) / RAPTOR::ignition_rate + RAPTOR::starter_phase_duration;
                }
                else {
                    time = (RAPTOR::right_throttle_output - RAPTOR::ignition_rpm) / RAPTOR::spool_up_rate + (RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration);
                }
                RAPTOR::right_engine_start_timer = std::min(time, RAPTOR::engine_start_time);
            }
        }
        break;
    case LeftEngineOn:
        if (RAPTOR::internal_fuel > 25) {
            if (RAPTOR::left_engine_state == RAPTOR::OFF || RAPTOR::left_engine_state == RAPTOR::SHUTDOWN) {
                RAPTOR::left_engine_switch = true;
                RAPTOR::left_engine_state = RAPTOR::STARTING;
                RAPTOR::left_throttle_output = std::max(RAPTOR::left_throttle_output, 0.0);
                double time = 0.0;
                if (RAPTOR::left_throttle_output <= RAPTOR::starter_rpm) {
                    time = RAPTOR::left_throttle_output / RAPTOR::starter_rate;
                }
                else if (RAPTOR::left_throttle_output <= RAPTOR::ignition_rpm) {
                    time = (RAPTOR::left_throttle_output - RAPTOR::starter_rpm) / RAPTOR::ignition_rate + RAPTOR::starter_phase_duration;
                }
                else {
                    time = (RAPTOR::left_throttle_output - RAPTOR::ignition_rpm) / RAPTOR::spool_up_rate + (RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration);
                }
                RAPTOR::left_engine_start_timer = std::min(time, RAPTOR::engine_start_time);
            }
        }
        break;
    case RightEngineOn:
        if (RAPTOR::internal_fuel > 25) {
            if (RAPTOR::right_engine_state == RAPTOR::OFF || RAPTOR::right_engine_state == RAPTOR::SHUTDOWN) {
                RAPTOR::right_engine_switch = true;
                RAPTOR::right_engine_state = RAPTOR::STARTING;
                RAPTOR::right_throttle_output = std::max(RAPTOR::right_throttle_output, 0.0);
                double time = 0.0;
                if (RAPTOR::right_throttle_output <= RAPTOR::starter_rpm) {
                    time = RAPTOR::right_throttle_output / RAPTOR::starter_rate;
                }
                else if (RAPTOR::right_throttle_output <= RAPTOR::ignition_rpm) {
                    time = (RAPTOR::right_throttle_output - RAPTOR::starter_rpm) / RAPTOR::ignition_rate + RAPTOR::starter_phase_duration;
                }
                else {
                    time = (RAPTOR::right_throttle_output - RAPTOR::ignition_rpm) / RAPTOR::spool_up_rate + (RAPTOR::starter_phase_duration + RAPTOR::ignition_phase_duration);
                }
                RAPTOR::right_engine_start_timer = std::min(time, RAPTOR::engine_start_time);
            }
        }
        break;
    case EnginesOff:
        if (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::left_engine_state == RAPTOR::STARTING) {
            RAPTOR::left_engine_state = RAPTOR::SHUTDOWN;
        }
        RAPTOR::left_engine_switch = false;
        if (RAPTOR::right_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::STARTING) {
            RAPTOR::right_engine_state = RAPTOR::SHUTDOWN;
        }
        RAPTOR::right_engine_switch = false;
        break;
    case LeftEngineOff:
        if (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::left_engine_state == RAPTOR::STARTING) {
            RAPTOR::left_engine_state = RAPTOR::SHUTDOWN;
        }
        RAPTOR::left_engine_switch = false;
        break;
    case RightEngineOff:
        if (RAPTOR::right_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::STARTING) {
            RAPTOR::right_engine_state = RAPTOR::SHUTDOWN;
        }
        RAPTOR::right_engine_switch = false;
        break;

    case ThrottleAxis:
        RAPTOR::left_throttle_input = RAPTOR::right_throttle_input = limit(-value + 1, 0, 2) / 2;
        break;
    case ThrottleAxisLeft:
        RAPTOR::left_throttle_input = limit(-value + 1, 0, 2) / 2;
        break;
    case ThrottleAxisRight:
        RAPTOR::right_throttle_input = limit(-value + 1, 0, 2) / 2;
        break;
    case ThrottleIncrease: RAPTOR::left_throttle_input += 0.0075; RAPTOR::right_throttle_input += 0.0075; break;
    case ThrottleLeftUp: RAPTOR::left_throttle_input += 0.0075; break;
    case ThrottleRightUp: RAPTOR::right_throttle_input += 0.0075; break;
    case ThrottleDecrease: RAPTOR::left_throttle_input -= 0.0075; RAPTOR::right_throttle_input -= 0.0075; break;
    case ThrottleLeftDown: RAPTOR::left_throttle_input -= 0.0075; break;
    case ThrottleRightDown: RAPTOR::right_throttle_input -= 0.0075; break;
    case AirBrakes: RAPTOR::airbrake_switch = !RAPTOR::airbrake_switch; break;
    case AirBrakesOff: RAPTOR::airbrake_switch = false; break;
    case AirBrakesOn: RAPTOR::airbrake_switch = true; break;
    case flapsToggle: RAPTOR::flaps_switch = !RAPTOR::flaps_switch; break;
    case flapsDown: RAPTOR::flaps_switch = false; break;
    case flapsUp: RAPTOR::flaps_switch = true; break;
    case gearToggle:
        if (ias_knots_local >= 100.0) {
            if (RAPTOR::gear_switch) {
                RAPTOR::gear_switch = false;
            }
            else if (ias_knots_local <= 275.0) {

                RAPTOR::gear_switch = true;
            }
        }
        break;
    case gearDown:
        if (ias_knots_local <= 275.0) {
            RAPTOR::gear_switch = true;
        }
        break;
    case gearUp:
        if (ias_knots_local >= 100.0) {
            RAPTOR::gear_switch = false;
        }
        break;
    case WheelBrakeOn:  RAPTOR::wheel_brake = 1; break;
    case WheelBrakeOff: RAPTOR::wheel_brake = 0; break;

    }
}

bool ed_fm_change_mass(double& delta_mass, double& delta_mass_pos_x, double& delta_mass_pos_y, double& delta_mass_pos_z,
    double& delta_mass_moment_of_inertia_x, double& delta_mass_moment_of_inertia_y, double& delta_mass_moment_of_inertia_z)
{
    if (!g_mass_changes.empty()) {
        MassChange const& change = g_mass_changes.top();
        delta_mass = change.delta_kg;
        delta_mass_pos_x = change.pos.x;
        delta_mass_pos_y = change.pos.y;
        delta_mass_pos_z = change.pos.z;
        delta_mass_moment_of_inertia_x = change.moi.x;
        delta_mass_moment_of_inertia_y = change.moi.y;
        delta_mass_moment_of_inertia_z = change.moi.z;
        g_mass_changes.pop();
        return true;
    }
    return false;
}

void ed_fm_set_internal_fuel(double fuel) {
    RAPTOR::internal_fuel = fuel;
}

double ed_fm_get_internal_fuel() {
    return RAPTOR::internal_fuel;
}

void ed_fm_set_external_fuel(int station, double fuel, double x, double y, double z) {
    if (fuel > 0 && RAPTOR::external_fuel_stations.find(station) == RAPTOR::external_fuel_stations.end()) {
        RAPTOR::external_fuel_stations[station] = 1850.0;
        RAPTOR::external_tanks_equipped = true;
    }
    else if (fuel <= 0) {
        RAPTOR::external_fuel_stations.erase(station);
        RAPTOR::external_tanks_equipped = !RAPTOR::external_fuel_stations.empty();
    }
    else {
        RAPTOR::external_fuel_stations[station] = fuel;
        RAPTOR::external_tanks_equipped = true;
    }

    RAPTOR::external_fuel = 0.0;
    for (const auto& [s, fuel_qty] : RAPTOR::external_fuel_stations) {
        RAPTOR::external_fuel += fuel_qty;
    }

    RAPTOR::total_fuel = RAPTOR::internal_fuel + RAPTOR::external_fuel;
}

double ed_fm_get_external_fuel() {
    return RAPTOR::external_fuel;
}

void ed_fm_set_fc3_cockpit_draw_args_v2(float* data, size_t size) {
    cockpit_manager.updateDrawArgs(data, size);
}

void ed_fm_set_draw_args_v2(float* data, size_t size) {
    data[0] = (float)limit(RAPTOR::gear_pos, 0, 1);
    data[3] = (float)limit(RAPTOR::gear_pos, 0, 1);
    data[5] = (float)limit(RAPTOR::gear_pos, 0, 1);
    data[15] = (float)limit(RAPTOR::right_elevon_angle / -RAPTOR::rad(18.0), -1.0, 1.0);
    data[16] = (float)limit(RAPTOR::left_elevon_angle / -RAPTOR::rad(18.0), -1.0, 1.0);
    double max_tv_deflection_rad = RAPTOR::rad(lerp(FM_DATA::mach_table.data(), FM_DATA::max_thrust_vector_deflection, FM_DATA::mach_table.size(), RAPTOR::mach));
    if (max_tv_deflection_rad == 0.0) {
        data[622] = 0.0f;
        data[623] = 0.0f;
    }
    else {
        data[622] = (float)limit((-RAPTOR::tv_angle / max_tv_deflection_rad) * 1.25, -1.0, 1.0);
        data[623] = (float)limit((-RAPTOR::tv_angle / max_tv_deflection_rad) * 1.25, -1.0, 1.0);
    }
    data[17] = (float)limit(RAPTOR::rudder_command, -1, 1);
    data[18] = (float)limit(RAPTOR::rudder_command, -1, 1);
    data[21] = (float)limit(RAPTOR::airbrake_pos, 0, 1);
    if (RAPTOR::landing_brake_assist >= 1.0f) {
        data[182] = 0.0f;
    }
    else {
        data[182] = (float)limit(RAPTOR::airbrake_pos, 0, 1);
    }
    data[184] = (float)limit(RAPTOR::airbrake_pos, 0, 1);

    static float current_left_flap = (float)RAPTOR::flaps_pos;
    static float current_right_flap = (float)RAPTOR::flaps_pos;
    static float current_left_aileron = (float)RAPTOR::aileron_command;
    static float current_right_aileron = (float)-RAPTOR::aileron_command;
    static float current_left_rudder = (float)RAPTOR::rudder_command;
    static float current_right_rudder = (float)RAPTOR::rudder_command;

    auto rate_limit = [](float current, float target, float rate_per_second, float dt) -> float {
        float delta = target - current;
        float max_change = rate_per_second * dt;
        return current + std::clamp(delta, -max_change, max_change);
        };

    const float flap_actuator_rate = 0.4f;
    const float control_surface_rate = 2.0f;
    const float rate = 0.0189f;

    if (RAPTOR::landing_brake_assist >= 1.0f && RAPTOR::on_ground) {
        current_left_flap = (float)limit(rate_limit(current_left_flap, -1.0f, flap_actuator_rate, rate), -1.0f, 1.0f);
        current_right_flap = (float)limit(rate_limit(current_right_flap, -1.0f, flap_actuator_rate, rate), -1.0f, 1.0f);
        data[9] = current_left_flap;
        data[10] = current_right_flap;
        current_left_aileron = (float)limit(rate_limit(current_left_aileron, 1.0f, control_surface_rate, rate), -1.0f, 1.0f);
        current_right_aileron = (float)limit(rate_limit(current_right_aileron, 1.0f, control_surface_rate, rate), -1.0f, 1.0f);
        data[11] = current_left_aileron;
        data[12] = current_right_aileron;
        current_left_rudder = (float)limit(rate_limit(current_left_rudder, 1.0f, control_surface_rate, rate), -1.0f, 1.0f);
        current_right_rudder = (float)limit(rate_limit(current_right_rudder, -1.0f, control_surface_rate, rate), -1.0f, 1.0f);
        data[17] = current_left_rudder;
        data[18] = current_right_rudder;
    }
    else {
        float target_left_aileron = (RAPTOR::g_assist_pos > 0.0f) ? RAPTOR::g_assist_pos : (float)limit(RAPTOR::aileron_animation_command, -1, 1);
        float target_right_aileron = (RAPTOR::g_assist_pos > 0.0f) ? RAPTOR::g_assist_pos : (float)limit(-RAPTOR::aileron_animation_command, -1, 1);
        current_left_aileron = (float)limit(rate_limit(current_left_aileron, target_left_aileron, control_surface_rate, rate), -1.0f, 1.0f);
        current_right_aileron = (float)limit(rate_limit(current_right_aileron, target_right_aileron, control_surface_rate, rate), -1.0f, 1.0f);
        data[11] = current_left_aileron;
        data[12] = current_right_aileron;

        current_left_rudder = (float)limit(rate_limit(current_left_rudder, (float)RAPTOR::rudder_command, control_surface_rate, rate), -1.0f, 1.0f);
        current_right_rudder = (float)limit(rate_limit(current_right_rudder, (float)RAPTOR::rudder_command, control_surface_rate, rate), -1.0f, 1.0f);
        data[17] = current_left_rudder;
        data[18] = current_right_rudder;

        if (RAPTOR::flaps_pos > 0.0f) {
            current_left_flap = (float)limit(rate_limit(current_left_flap, (float)RAPTOR::flaps_pos, control_surface_rate, rate), -1.0f, 1.0f);
            current_right_flap = (float)limit(rate_limit(current_right_flap, (float)RAPTOR::flaps_pos, control_surface_rate, rate), -1.0f, 1.0f);
            data[9] = current_left_flap;
            data[10] = current_right_flap;
        }
        else {
            float flap_target_left = (float)limit(-RAPTOR::aileron_animation_command, -1, 1);
            float flap_target_right = (float)limit(RAPTOR::aileron_animation_command, -1, 1);
            current_left_flap = (float)limit(rate_limit(current_left_flap, flap_target_left, control_surface_rate, rate), -1.0f, 1.0f);
            current_right_flap = (float)limit(rate_limit(current_right_flap, flap_target_right, control_surface_rate, rate), -1.0f, 1.0f);
            data[9] = current_left_flap;
            data[10] = current_right_flap;
        }
    }

    float lef_flap = (float)limit((RAPTOR::flaps_pos + RAPTOR::slats_pos) / 2.0, 0.0, 1.0);
    data[603] = lef_flap;

    if (RAPTOR::left_engine_state == RAPTOR::OFF) {
        data[29] = 0.0f;
    }
    else if (RAPTOR::left_engine_state == RAPTOR::RUNNING && RAPTOR::left_ab_timer > 0.95) {
        data[29] = 1.0f;
    }
    else {
        data[29] = 0.0f;
    }

    if (RAPTOR::right_engine_state == RAPTOR::OFF) {
        data[28] = 0.0f;
    }
    else if (RAPTOR::right_engine_state == RAPTOR::RUNNING && RAPTOR::right_ab_timer > 0.95) {
        data[28] = 1.0f;
    }
    else {
        data[28] = 0.0f;
    }

    if (RAPTOR::left_engine_state == RAPTOR::OFF) {
        data[611] = 1.0f;
    }
    else {
        float rpm = static_cast<float>(RAPTOR::left_engine_power_readout);
        if (rpm >= 0.67f) {
            data[611] = 0.0f;
        }
        else {
            data[611] = (0.67f - rpm) / (0.67f - 0.0f);
        }
    }
    data[611] = static_cast<float>(limit(data[611], 0.0f, 1.0f));

    float rpml = static_cast<float>(RAPTOR::left_engine_power_readout);
    if (rpml <= 0.70f) {
        data[90] = 1.0f;
    }
    else if (rpml <= 0.90f) {
        data[90] = (0.90f - rpml) / (0.90f - 0.70f);
    }
    else if (rpml <= 1.035f) {
        data[90] = 0.0f;
    }
    else {
        float rpm_factor = (rpml - 1.035f) / (1.1f - 1.035f);
        data[90] = limit(rpm_factor, 0.0f, 1.0f);
    }
    data[90] = static_cast<float>(limit(data[90], 0.0f, 1.0f));

    if (RAPTOR::right_engine_state == RAPTOR::OFF) {
        data[610] = 1.0f;
    }
    else {
        float rpm = static_cast<float>(RAPTOR::right_engine_power_readout);
        if (rpm >= 0.67f) {
            data[610] = 0.0f;
        }
        else {
            data[610] = (0.67f - rpm) / (0.67f - 0.0f);
        }
    }
    data[610] = static_cast<float>(limit(data[610], 0.0f, 1.0f));

    float rpmr = static_cast<float>(RAPTOR::right_engine_power_readout);
    if (rpmr <= 0.70f) {
        data[89] = 1.0f;
    }
    else if (rpmr <= 0.90f) {
        data[89] = (0.90f - rpmr) / (0.90f - 0.70f);
    }
    else if (rpmr <= 1.035f) {
        data[89] = 0.0f;
    }
    else {
        float rpm_factor = (rpmr - 1.035f) / (1.1f - 1.035f);
        data[89] = limit(rpm_factor, 0.0f, 1.0f);
    }
    data[89] = static_cast<float>(limit(data[89], 0.0f, 1.0f));

    if (size > 325) {
        if (RAPTOR::right_engine_state == RAPTOR::OFF) {
            data[324] = 0.0;
        }
        else {
            data[324] = static_cast<float>(RAPTOR::right_engine_phase);
        }

        if (RAPTOR::left_engine_state == RAPTOR::OFF) {
            data[325] = 0.0;
        }
        else {
            data[325] = static_cast<float>(RAPTOR::left_engine_phase);
        }
    }

    data[604] = RAPTOR::taxi_lights ? 1.0f : 0.0f;
    data[605] = RAPTOR::landing_lights ? 1.0f : 0.0f;
    data[606] = RAPTOR::form_light ? 1.0f : 0.0f;
    data[607] = RAPTOR::nav_white ? (RAPTOR::nav_white_blink ? (RAPTOR::nav_white_timer < 0.1f ? 1.0f : 0.0f) : 1.0f) : 0.0f;
    data[608] = RAPTOR::anti_collision ? (RAPTOR::anti_collision_blink ? (RAPTOR::anti_collision_timer < 0.1f ? 1.0f : 0.0f) : 1.0f) : 0.0f;
    data[609] = RAPTOR::aar_light ? 1.0f : 0.0f;
    data[612] = RAPTOR::nav_lights ? 1.0f : 0.0f;
    data[613] = RAPTOR::nav_lights ? 1.0f : 0.0f;

    if (RAPTOR::is_destroyed == true) {
        data[114] = 1.0f;
    }
}

void ed_fm_configure(const char* cfg_path) {
    if (!RAPTOR::sim_initialised) {
        cockpit_manager.initialize();
        RAPTOR::left_wing_pos = Vec3(RAPTOR::center_of_mass.x - 0.8, RAPTOR::center_of_mass.y + 0.5, -RAPTOR::wingspan / 2);
        RAPTOR::right_wing_pos = Vec3(RAPTOR::center_of_mass.x - 0.8, RAPTOR::center_of_mass.y + 0.5, RAPTOR::wingspan / 2);
        RAPTOR::tail_pos = Vec3(RAPTOR::center_of_mass.x - 0.7, RAPTOR::center_of_mass.y, 0);
        RAPTOR::left_elevon_pos = Vec3(-RAPTOR::length / 2, RAPTOR::center_of_mass.y, -RAPTOR::wingspan * 0.25);
        RAPTOR::right_elevon_pos = Vec3(-RAPTOR::length / 2, RAPTOR::center_of_mass.y, RAPTOR::wingspan * 0.25);
        RAPTOR::left_aileron_pos = Vec3(RAPTOR::center_of_mass.x, RAPTOR::center_of_mass.y, -RAPTOR::wingspan * 0.5);
        RAPTOR::right_aileron_pos = Vec3(RAPTOR::center_of_mass.x, RAPTOR::center_of_mass.y, RAPTOR::wingspan * 0.5);
        RAPTOR::rudder_pos = Vec3(-RAPTOR::length / 2, RAPTOR::height / 2, 0);
        RAPTOR::left_engine_pos = Vec3(-3.793, 0.0, -0.716);
        RAPTOR::right_engine_pos = Vec3(-3.793, 0.0, 0.716);
        RAPTOR::left_elevon_command = RAPTOR::right_elevon_command = 0.0;
        RAPTOR::left_elevon_angle = RAPTOR::right_elevon_angle = 0.0;
        RAPTOR::aileron_command = RAPTOR::last_aileron_cmd = 0.0;
        RAPTOR::rudder_command = RAPTOR::last_rudder_cmd = 0.0;
        RAPTOR::roll_error_i = RAPTOR::yaw_error_i = 0.0;
        RAPTOR::last_yaw_input = 0.0;
        RAPTOR::tv_angle = 0.0;
        RAPTOR::last_tv_cmd = 0.0;
        RAPTOR::last_pitch_input = 0.0;
        RAPTOR::idle_rpm = 0.675;
    }
}

double ed_fm_get_param(unsigned index) {
    switch (index) {
    case ED_FM_SUSPENSION_0_WHEEL_YAW:
    {
        double yaw_source = RAPTOR::yaw_analog ? RAPTOR::yaw_input : RAPTOR::yaw_discrete;
        double ground_speed_knots = RAPTOR::ground_speed_knots;
        double max_steering_rad = 0.0;

        if (RAPTOR::on_ground) {
            if (ground_speed_knots <= 8.0) {
                max_steering_rad = RAPTOR::rad(60.0);
            }
            else if (ground_speed_knots <= 30.0) {
                double slope = (RAPTOR::rad(25.0) - RAPTOR::rad(60.0)) / (30.0 - 8.0);
                max_steering_rad = RAPTOR::rad(60.0) + slope * (ground_speed_knots - 8.0);
            }
            else if (ground_speed_knots <= 60.0) {
                max_steering_rad = RAPTOR::rad(25.0);
            }
        }
        return limit(yaw_source, -1.0, 1.0) * max_steering_rad;
    }
    case ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT: return RAPTOR::wheel_brake;
    case ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT: return RAPTOR::wheel_brake;
    case ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT: return RAPTOR::wheel_brake;
    case ED_FM_ANTI_SKID_ENABLE: return true;
    case ED_FM_FC3_STICK_PITCH: return limit(RAPTOR::pitch_input / 2, -1.0, 1.0);
    case ED_FM_FC3_STICK_ROLL: return limit(RAPTOR::roll_input, -1.0, 1.0);
    case ED_FM_FC3_RUDDER_PEDALS: return limit(-RAPTOR::yaw_input, -1.0, 1.0);
    case ED_FM_FC3_THROTTLE_LEFT: return RAPTOR::left_throttle_output;
    case ED_FM_FC3_THROTTLE_RIGHT: return RAPTOR::right_throttle_output;
    case ED_FM_FUEL_INTERNAL_FUEL: return RAPTOR::internal_fuel;
    case ED_FM_FUEL_TOTAL_FUEL: return RAPTOR::total_fuel;
    case ED_FM_OXYGEN_SUPPLY: return 101000.0;
    case ED_FM_FLOW_VELOCITY: return 10.0;

    case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
    case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
    case ED_FM_SUSPENSION_2_GEAR_POST_STATE: return RAPTOR::gear_pos;

    case ED_FM_ENGINE_0_RPM: return 0;
    case ED_FM_ENGINE_0_RELATED_RPM: return 0;
    case ED_FM_ENGINE_0_THRUST: return 0;
    case ED_FM_ENGINE_0_RELATED_THRUST: return 0;

    case ED_FM_ENGINE_1_CORE_RPM: return RAPTOR::left_throttle_input;
    case ED_FM_ENGINE_1_RPM: return RAPTOR::left_engine_power_readout;
    case ED_FM_ENGINE_1_COMBUSTION: return RAPTOR::left_engine_integrity;
    case ED_FM_ENGINE_1_RELATED_THRUST: return limit(RAPTOR::left_engine_power_readout * 0.35, 0.0, 0.9);
    case ED_FM_ENGINE_1_CORE_RELATED_THRUST: {
        double max_dry_thrust = lerp(FM_DATA::mach_table.data(), FM_DATA::max_thrust.data(), FM_DATA::mach_table.size(), RAPTOR::mach);
        double max_dry_core_thrust = max_dry_thrust * 0.7;
        double core_thrust = RAPTOR::left_thrust_force * (RAPTOR::left_throttle_output > 1.025 ? 0.6 : 0.7);
        return max_dry_core_thrust > 0 ? limit(core_thrust / max_dry_core_thrust, 0.0, 2.0) : 0.0;
    }
    case ED_FM_ENGINE_1_RELATED_RPM: return limit(RAPTOR::left_engine_power_readout * 0.35, 0.0, 0.9);
    case ED_FM_ENGINE_1_CORE_RELATED_RPM: return RAPTOR::left_engine_power_readout;
    case ED_FM_ENGINE_1_CORE_THRUST: return RAPTOR::left_thrust_force * (RAPTOR::left_throttle_output > 1.025 ? 0.6 : 0.7);
    case ED_FM_ENGINE_1_THRUST: return RAPTOR::left_thrust_force;
    case ED_FM_ENGINE_1_TEMPERATURE: return (pow(RAPTOR::left_engine_power_readout, 3) * 375) + RAPTOR::atmosphere_temperature;
    case ED_FM_ENGINE_1_FUEL_FLOW: return (RAPTOR::left_fuel_rate_kg_s);

    case ED_FM_ENGINE_2_CORE_RPM: return RAPTOR::right_throttle_input;
    case ED_FM_ENGINE_2_RPM: return RAPTOR::right_engine_power_readout;
    case ED_FM_ENGINE_2_COMBUSTION: return RAPTOR::right_engine_integrity;
    case ED_FM_ENGINE_2_RELATED_THRUST: return limit(RAPTOR::right_engine_power_readout * 0.35, 0.0, 0.9);
    case ED_FM_ENGINE_2_CORE_RELATED_THRUST: {
        double max_dry_thrust = lerp(FM_DATA::mach_table.data(), FM_DATA::max_thrust.data(), FM_DATA::mach_table.size(), RAPTOR::mach);
        double max_dry_core_thrust = max_dry_thrust * 0.7;
        double core_thrust = RAPTOR::right_thrust_force * (RAPTOR::right_throttle_output > 1.025 ? 0.6 : 0.7);
        return max_dry_core_thrust > 0 ? limit(core_thrust / max_dry_core_thrust, 0.0, 2.0) : 0.0;
    }
    case ED_FM_ENGINE_2_RELATED_RPM: return limit(RAPTOR::right_engine_power_readout * 0.35, 0.0, 0.9);
    case ED_FM_ENGINE_2_CORE_RELATED_RPM: return RAPTOR::right_engine_power_readout;
    case ED_FM_ENGINE_2_CORE_THRUST: return RAPTOR::right_thrust_force * (RAPTOR::right_throttle_output > 1.025 ? 0.6 : 0.7);
    case ED_FM_ENGINE_2_THRUST: return RAPTOR::right_thrust_force;
    case ED_FM_ENGINE_2_TEMPERATURE: return (pow(RAPTOR::right_engine_power_readout, 3) * 375) + RAPTOR::atmosphere_temperature;
    case ED_FM_ENGINE_2_FUEL_FLOW: return (RAPTOR::right_fuel_rate_kg_s);

    case ED_FM_STICK_FORCE_CENTRAL_PITCH: return 0.0;
    case ED_FM_STICK_FORCE_FACTOR_PITCH: return 1.0;
    case ED_FM_STICK_FORCE_CENTRAL_ROLL: return 0.0;
    case ED_FM_STICK_FORCE_FACTOR_ROLL: return 1.0;
    case ED_FM_CAN_ACCEPT_FUEL_FROM_TANKER: return 1.0;
    }
    return 0;
}

void ed_fm_refueling_add_fuel(double fuel)
{
    if (fuel > 0) {
        double dt = 0.006;
        double fuel_to_add = std::min(fuel, 100.0 * dt);

        double internal_space = RAPTOR::max_internal_fuel - RAPTOR::internal_fuel;
        double internal_added = std::min(fuel_to_add, internal_space);
        if (internal_added > 0) {
            RAPTOR::internal_fuel += internal_added * 10;
            double fuel_fraction = std::min(1.0, std::max(0.0, RAPTOR::internal_fuel / RAPTOR::max_internal_fuel));
            g_mass_changes.push({
                -internal_added,
                {-0.32 * (1.0 - fuel_fraction), 0.0, 0.0},
                {0.0, 0.0, 0.0}
                });
        }

        double remaining_fuel = fuel_to_add - internal_added;
        if (remaining_fuel > 0 && !RAPTOR::external_fuel_stations.empty()) {
            size_t num_refuelable_stations = 0;
            for (const auto& [station, fuel_qty] : RAPTOR::external_fuel_stations) {
                if ((station == 2 || station == 10) && fuel_qty > 0 && fuel_qty < 1850.0) {
                    num_refuelable_stations++;
                }
            }
            if (num_refuelable_stations > 0) {
                double fuel_per_station = remaining_fuel / num_refuelable_stations;
                for (auto& [station, fuel_qty] : RAPTOR::external_fuel_stations) {
                    if ((station == 2 || station == 10) && fuel_qty > 0 && fuel_qty < 1850.0) {
                        double space = 1850.0 - fuel_qty;
                        double added = std::min(fuel_per_station, space);
                        fuel_qty += added;
                    }
                }
                RAPTOR::external_fuel = 0.0;
                for (const auto& [station, fuel_qty] : RAPTOR::external_fuel_stations) {
                    if (station == 2 || station == 10) {
                        RAPTOR::external_fuel += fuel_qty;
                    }
                }
            }
        }

        RAPTOR::total_fuel = RAPTOR::internal_fuel + RAPTOR::external_fuel;
    }
}


void ed_fm_unlimited_fuel(bool value) { RAPTOR::infinite_fuel = value; }
void ed_fm_set_easy_flight(bool value) { RAPTOR::easy_flight = value; }
void ed_fm_set_immortal(bool value) { RAPTOR::invincible = value; }

void ed_fm_on_damage(int Element, double element_integrity_factor) {
    if (Element >= 0 && Element < 111) {
        RAPTOR::element_integrity[Element] = element_integrity_factor;
    }
    g_damage_events.push({ Element, element_integrity_factor });
    if (!RAPTOR::invincible) {
        RAPTOR::left_wing_integrity = RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingOutLeft)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingCentreLeft)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingInLeft)];
        RAPTOR::right_wing_integrity = RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingOutRight)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingCentreRight)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::WingInRight)];
        RAPTOR::tail_integrity = RAPTOR::element_integrity[static_cast<size_t>(DamageElement::RudderLeft)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::RudderRight)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::Tail)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::TailLeft)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::TailRight)];
        RAPTOR::left_engine_integrity = RAPTOR::element_integrity[static_cast<size_t>(DamageElement::NacelleLeftBottom)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::NacelleLeft)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::Engine1)];
        RAPTOR::right_engine_integrity = RAPTOR::element_integrity[static_cast<size_t>(DamageElement::NacelleRightBottom)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::NacelleRight)] *
            RAPTOR::element_integrity[static_cast<size_t>(DamageElement::Engine2)];

        if (RAPTOR::left_engine_integrity <= 0.2 &&
            RAPTOR::right_engine_integrity <= 0.2 &&
            RAPTOR::left_wing_integrity <= 0.2 ||
            RAPTOR::right_wing_integrity <= 0.2 &&
            RAPTOR::tail_integrity <= 0.2) {
            RAPTOR::is_destroyed = true;
        }

    }
}

void ed_fm_repair() {
    for (int i = 0; i < 111; i++) RAPTOR::element_integrity[i] = 1;
    while (!g_damage_events.empty()) g_damage_events.pop();
}

bool ed_fm_pop_simulation_event(ed_fm_simulation_event& out) {

    if (!g_damage_events.empty()) {
        DamageEvent event = g_damage_events.front();
        g_damage_events.pop();
        out.event_type = ED_FM_EVENT_STRUCTURE_DAMAGE;
        out.event_params[0] = static_cast<double>(event.element_number);
        out.event_params[1] = event.integrity_factor;
        out.event_message[0] = '\0';

        return true;
    }
    out.event_type = ED_FM_EVENT_INVALID;
    return false;
}

bool ed_fm_push_simulation_event(const ed_fm_simulation_event& in) {

    return false;
}

void ed_fm_cold_start() {
    reset_fm_state();
    RAPTOR::sim_initialised = false;
    RAPTOR::gear_switch = true;
    RAPTOR::gear_pos = 1;
    RAPTOR::airbrake_switch = false;
    RAPTOR::left_engine_switch = false;
    RAPTOR::right_engine_switch = false;
    RAPTOR::left_engine_state = RAPTOR::OFF;
    RAPTOR::right_engine_state = RAPTOR::OFF;
    RAPTOR::left_throttle_input = RAPTOR::right_throttle_input = 0.0;
    RAPTOR::left_throttle_output = RAPTOR::right_throttle_output = 0.0;
    RAPTOR::left_engine_power_readout = RAPTOR::right_engine_power_readout = 0.0;
    RAPTOR::left_ab_timer = RAPTOR::right_ab_timer = 0.0;
    RAPTOR::left_engine_start_timer = RAPTOR::right_engine_start_timer = 0.0;
    RAPTOR::left_engine_phase = 0.0;
    RAPTOR::right_engine_phase = 0.0;
    RAPTOR::total_fuel = RAPTOR::internal_fuel + RAPTOR::external_fuel;
    RAPTOR::pitch_input = RAPTOR::roll_input = RAPTOR::yaw_input = 0.0;
    RAPTOR::left_elevon_command = RAPTOR::right_elevon_command = RAPTOR::aileron_command = RAPTOR::rudder_command = 0.0;
    RAPTOR::left_engine_integrity = RAPTOR::right_engine_integrity = 1.0;
    RAPTOR::manual_trim_applied = false;
    ed_fm_repair();
    while (!g_damage_events.empty()) g_damage_events.pop();
    cockpit_manager.initialize();
}

void ed_fm_hot_start() {
    reset_fm_state();
    RAPTOR::gear_switch = true;
    RAPTOR::gear_pos = 1;
    RAPTOR::flaps_pos = 0;
    RAPTOR::airbrake_switch = false;
    RAPTOR::left_engine_switch = RAPTOR::right_engine_switch = true;
    RAPTOR::left_engine_state = RAPTOR::RUNNING;
    RAPTOR::right_engine_state = RAPTOR::RUNNING;
    RAPTOR::left_throttle_input = RAPTOR::right_throttle_input = 0.0;
    RAPTOR::left_throttle_output = RAPTOR::right_throttle_output = 0.67;
    RAPTOR::left_engine_power_readout = RAPTOR::right_engine_power_readout = 0.67;
    RAPTOR::left_engine_phase = 0.0;
    RAPTOR::right_engine_phase = 0.0;
    RAPTOR::left_ab_timer = RAPTOR::right_ab_timer = 0.0;
    RAPTOR::left_engine_start_timer = RAPTOR::right_engine_start_timer = 0.0;
    RAPTOR::total_fuel = RAPTOR::internal_fuel + RAPTOR::external_fuel;
    RAPTOR::left_engine_integrity = RAPTOR::right_engine_integrity = 1.0;
    RAPTOR::velocity_world = Vec3(0, 0, 0);
    RAPTOR::pitch_rate = RAPTOR::roll_rate = RAPTOR::yaw_rate = 0.0;
    RAPTOR::pitch = RAPTOR::roll = RAPTOR::heading = 0.0;
    RAPTOR::manual_trim_applied = false;
    ed_fm_repair();
    while (!g_damage_events.empty()) g_damage_events.pop();
    cockpit_manager.initialize();

}

void ed_fm_hot_start_in_air() {
    reset_fm_state();
    RAPTOR::gear_switch = false;
    RAPTOR::gear_pos = 0;
    RAPTOR::flaps_pos = 0;
    RAPTOR::airbrake_switch = false;
    RAPTOR::left_engine_switch = RAPTOR::right_engine_switch = true;
    RAPTOR::left_engine_state = RAPTOR::RUNNING;
    RAPTOR::right_engine_state = RAPTOR::RUNNING;
    RAPTOR::left_throttle_input = RAPTOR::left_throttle_output = 0.70;
    RAPTOR::right_throttle_input = RAPTOR::right_throttle_output = 0.70;
    RAPTOR::left_engine_power_readout = RAPTOR::right_engine_power_readout = 0.70;
    RAPTOR::left_ab_timer = RAPTOR::right_ab_timer = 0.0;
    RAPTOR::left_engine_start_timer = RAPTOR::right_engine_start_timer = 0.0;
    RAPTOR::left_engine_phase = 0.0;
    RAPTOR::right_engine_phase = 0.0;
    RAPTOR::total_fuel = RAPTOR::internal_fuel + RAPTOR::external_fuel;
    RAPTOR::left_engine_integrity = RAPTOR::right_engine_integrity = 1.0;
    RAPTOR::velocity_world = Vec3(0, 0, 0);
    RAPTOR::pitch_rate = RAPTOR::roll_rate = RAPTOR::yaw_rate = 0.0;
    RAPTOR::pitch = RAPTOR::roll = RAPTOR::heading = 0.0;
    RAPTOR::autotrim_active = true;
    RAPTOR::manual_trim_applied = false;
    ed_fm_repair();
    while (!g_damage_events.empty()) g_damage_events.pop();
    cockpit_manager.initialize();
}

void ed_fm_release() {
    RAPTOR::fm_clock = 0;
    RAPTOR::sim_initialised = false;
    ed_fm_repair();
}

double ed_fm_get_shake_amplitude() {
    return RAPTOR::shake_amplitude;
}

bool ed_fm_add_local_force_component(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z) { return false; }
bool ed_fm_add_global_force_component(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z) { return false; }
bool ed_fm_add_local_moment_component(double& x, double& y, double& z) { return false; }
bool ed_fm_add_global_moment_component(double& x, double& y, double& z) { return false; }
bool ed_fm_enable_debug_info() { return false; }

bool ed_fm_LERX_vortex_update(unsigned idx, LERX_vortex& out) {
    if (idx > 1) {
        return false; 
    }

    float vortex_strength = 0.0f;
    if (fabs(RAPTOR::alpha) >= 8.0f && RAPTOR::mach < 1.65f) { 
        vortex_strength = 0.72f * exp(-pow(RAPTOR::alpha - 35.0f, 2) / (2 * 600.0f));
        if (RAPTOR::alpha > 70.0f) {
            vortex_strength = 0.0f;
        }
        float aoa_factor = (fabs(RAPTOR::alpha) - 8.0f) / (15.0f - 8.0f);
        aoa_factor = std::max(0.0f, std::min(aoa_factor, 0.85f));
        vortex_strength *= aoa_factor;
        float humidity_factor = RAPTOR::atmosphere_density / 1.225f;
        vortex_strength *= (1.0f + humidity_factor * 0.5f);
        vortex_strength *= std::min(static_cast<float>(RAPTOR::V_scalar / 100.0), 1.0f);
        vortex_strength *= 0.70f;
    }

    if (vortex_strength <= 0.01f) {
        out.spline = nullptr;
        out.spline_points_count = 0;
        return true;
    }

    const unsigned num_points = 10;
    static std::vector<LERX_vortex_spline_point> spline_points(num_points);

    float start_x = RAPTOR::left_wing_pos.x + 6.0f;
    float start_z = (idx == 0) ? -1.2f : 1.2f;
    float start_y = RAPTOR::left_wing_pos.y + 0.025f;

    for (unsigned i = 0; i < num_points; ++i) {
        auto& point = spline_points[i];
        float t = static_cast<float>(i) / (num_points - 1);

        point.pos[0] = start_x - t * 8.0f;
        point.pos[1] = start_y + t * (idx == 0 ? 0.75f : 0.75f);
        point.pos[2] = start_z + t * 0.0f; 

        point.vel[0] = -RAPTOR::V_scalar * (1.0f - t);
        point.vel[1] = 0.0f;
        point.vel[2] = 0.0f;

        point.radius = 0.22f + 0.42f * sinf(t * 3.14159f);

        point.opacity = vortex_strength * (1.0f - t);
    }

    out.opacity = vortex_strength;
    out.explosion_start = 9.0f; 
    out.spline = spline_points.data();
    out.spline_points_count = num_points;
    out.spline_point_size_in_bytes = sizeof(LERX_vortex_spline_point);
    out.version = 1; 

    return true; 
}

//########################################################################################################
//########################################################################################################
//########################################################################################################

    // ----- Cockpit Logic -----

inline float limit(float value, float min_val, float max_val) {
    if (value < min_val) return min_val;
    if (value > max_val) return max_val;
    return value;
}

CockpitManager::CockpitManager() {
    draw_args_[709] = 0.0f;
    draw_args_[712] = 0.0f;
    draw_args_[713] = 0.0f;
    draw_args_[714] = 0.0f;
    draw_args_[715] = 0.0f;
}

void CockpitManager::initialize() {
    param_handles_["APU_POWER"] = param_api_.getParamHandle("APU_POWER");
    param_handles_["BATTERY_POWER"] = param_api_.getParamHandle("BATTERY_POWER");
    param_handles_["MAIN_POWER"] = param_api_.getParamHandle("MAIN_POWER");
    param_handles_["WoW"] = param_api_.getParamHandle("WoW");
    param_handles_["AAR"] = param_api_.getParamHandle("AAR");
    param_handles_["N_GEAR_LIGHT"] = param_api_.getParamHandle("N_GEAR_LIGHT");
    param_handles_["R_GEAR_LIGHT"] = param_api_.getParamHandle("R_GEAR_LIGHT");
    param_handles_["L_GEAR_LIGHT"] = param_api_.getParamHandle("L_GEAR_LIGHT");
    param_handles_["TAXI_SWITCH"] = param_api_.getParamHandle("TAXI_SWITCH");
    param_handles_["NAV_LIGHT_SWITCH"] = param_api_.getParamHandle("NAV_LIGHT_SWITCH");
    param_handles_["FORM_KNOB"] = param_api_.getParamHandle("FORM_KNOB");
    param_handles_["AAR_KNOB"] = param_api_.getParamHandle("AAR_KNOB");
    param_handles_["AAR_READY"] = param_api_.getParamHandle("AAR_READY");


    draw_args_[709] = static_cast<float>(getParameter("TAXI_SWITCH", 0.0));
    draw_args_[712] = static_cast<float>(getParameter("AAR", 0.0));
    draw_args_[713] = static_cast<float>(getParameter("AAR_KNOB", 0.0));
    draw_args_[714] = static_cast<float>(getParameter("FORM_KNOB", 0.0));
    draw_args_[715] = static_cast<float>(getParameter("NAV_LIGHT_SWITCH", 0.0));


    param_api_.setParamNumber(param_handles_["MAIN_POWER"], (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::RUNNING) ? 1.0 : 0.0);
    param_api_.setParamNumber(param_handles_["BATTERY_POWER"], (RAPTOR::left_engine_switch || RAPTOR::right_engine_switch) ? 1.0 : 0.0);
}

void CockpitManager::update(double dt) {
    updateGearLights(dt);
    updateTaxiLandingLights(dt);
    updateAARLight(dt);
    updateFormationLights(dt);
    updateNavAntiCollisionLights(dt);
}

void CockpitManager::updateDrawArgs(float* data, size_t size) {
    auto setArg = [&](int index, float value) {
        if (index >= 0 && static_cast<size_t>(index) < size) {
            data[index] = value;
        }
        };

    setArg(709, static_cast<float>(getParameter("TAXI_SWITCH", 0.0)));
    setArg(712, static_cast<float>(getParameter("AAR", 0.0)));
    setArg(713, static_cast<float>(getParameter("AAR_KNOB", 0.0)));
    setArg(714, static_cast<float>(getParameter("FORM_KNOB", 0.0)));
    setArg(715, static_cast<float>(getParameter("NAV_LIGHT_SWITCH", 0.0)));
}

double CockpitManager::getParameter(const std::string& name, double fallback_value) {
    if (!RAPTOR::sim_initialised) {
        bool engines_on = (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::RUNNING);
        if (name == "NAV_LIGHT_SWITCH") {
            if (engines_on) {
                if (name == "NAV_LIGHT_SWITCH") return 0.3;
            }
            return 0.0;
        }
        if (name == "TAXI_SWITCH") {
            if (engines_on && RAPTOR::gear_pos == 1.0) {
                if (name == "NAV_LIGHT_SWITCH") return 0.3;
                if (name == "TAXI_SWITCH") return RAPTOR::gear_pos == 1.0 ? -1.0 : 0.0;
            }
            return 0.0;
        }
    }
    auto it = param_handles_.find(name);
    if (it == param_handles_.end()) {
        return fallback_value;
    }

    double result = param_api_.getParamNumber(it->second);
    if (result != result) {
        if (name == "WoW") {
            return RAPTOR::on_ground ? 1.0 : 0.0;
        }
        else if (name == "MAIN_POWER") {
            return (RAPTOR::left_engine_state == RAPTOR::RUNNING || RAPTOR::right_engine_state == RAPTOR::RUNNING) ? 1.0 : 0.0;
        }
        else if (name == "BATTERY_POWER") {
            return (RAPTOR::left_engine_switch || RAPTOR::right_engine_switch) ? 1.0 : 0.0;
        }
        return fallback_value;
    }
    return result;
}

void CockpitManager::updateGearLights(double dt) {
    double battery_power = getParameter("BATTERY_POWER");
    double nose_gear = RAPTOR::gear_pos;
    double right_gear = RAPTOR::gear_pos;
    double left_gear = RAPTOR::gear_pos;

    double nose_gear_light = (nose_gear >= 1.0 && battery_power >= 1.0) ? 1.0 : 0.0;
    double right_gear_light = (right_gear >= 1.0 && battery_power >= 1.0) ? 1.0 : 0.0;
    double left_gear_light = (left_gear >= 1.0 && battery_power >= 1.0) ? 1.0 : 0.0;

    param_api_.setParamNumber(param_handles_["N_GEAR_LIGHT"], nose_gear_light);
    param_api_.setParamNumber(param_handles_["R_GEAR_LIGHT"], right_gear_light);
    param_api_.setParamNumber(param_handles_["L_GEAR_LIGHT"], left_gear_light);
}

void CockpitManager::updateTaxiLandingLights(double dt) {
    double taxi_switch = getParameter("TAXI_SWITCH");
    double main_power = getParameter("MAIN_POWER");
    double nose_gear = RAPTOR::gear_pos;

    RAPTOR::taxi_lights = false;
    RAPTOR::landing_lights = false;

    if (taxi_switch == -1.0 && main_power >= 1.0 && nose_gear >= 1.0) {
        RAPTOR::taxi_lights = true;
    }
    else if (taxi_switch == 1.0 && main_power >= 1.0 && nose_gear >= 1.0) {
        RAPTOR::landing_lights = true;
    }
}

void CockpitManager::updateAARLight(double dt) {
    double aar = getParameter("AAR");
    double aar_knob = getParameter("AAR_KNOB");
    double main_power = getParameter("MAIN_POWER");
    double aar_ready = getParameter("AAR_READY");

    RAPTOR::aar_light = (aar >= 1.0 && aar_ready >= 1.0 && main_power >= 1.0 && aar_knob > 0.0);
}

void CockpitManager::updateFormationLights(double dt) {
    double form_knob = getParameter("FORM_KNOB");
    double main_power = getParameter("MAIN_POWER");

    RAPTOR::form_light = (main_power >= 1.0 && form_knob > 0.0);
}

void CockpitManager::updateNavAntiCollisionLights(double dt) {
    double light_switch = getParameter("NAV_LIGHT_SWITCH");
    double main_power = getParameter("MAIN_POWER");

    static double flash_timer = 0.0;
    flash_timer += dt;
    if (flash_timer >= 1.50) {
        flash_timer = 0.0;
    }
    RAPTOR::nav_white_timer = flash_timer;
    RAPTOR::anti_collision_timer = flash_timer;
    float flash_on = (flash_timer > 0.25) ? 1.0f : 0.0f;

    RAPTOR::nav_white = false;
    RAPTOR::anti_collision = false;
    RAPTOR::nav_lights = false;
    RAPTOR::nav_white_blink = false;
    RAPTOR::anti_collision_blink = false;

    if (main_power < 1.0 || light_switch <= 0.0) {
        flash_timer = 0.0;
        RAPTOR::nav_white_timer = 0.0;
        RAPTOR::anti_collision_timer = 0.0;
        return;
    }

    if (light_switch < 0.15) {
        RAPTOR::nav_white = true;
        RAPTOR::anti_collision = true;
        RAPTOR::nav_white_blink = true;
        RAPTOR::anti_collision_blink = true;
    }
    else if (light_switch < 0.25) {
        RAPTOR::nav_white = true;
        RAPTOR::anti_collision = true;
        RAPTOR::nav_lights = true;
        RAPTOR::anti_collision_blink = true;
    }
    else if (light_switch < 0.35) {
        RAPTOR::nav_white = true;
        RAPTOR::nav_lights = true;
        RAPTOR::nav_white_blink = true;
    }
    else {
        RAPTOR::nav_white = true;
        RAPTOR::nav_lights = true;
    }
}