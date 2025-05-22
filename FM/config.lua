--[[
    Grinnelli Designs F-22A Raptor
    Copyright (c) 2025: Branden Hooper
    
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
	
	CONTRIBUTORS:

	
	
--]]

-- NOSEGEAR
local nose_amortizer_min_length                 = 0.0
local nose_amortizer_max_length                 = 0.57 
local nose_amortizer_basic_length               = 0.50
local nose_amortizer_reduce_length              = 0.317

local nose_amortizer_spring_force_factor        = 4000000
local nose_amortizer_spring_force_factor_rate   = 9

local nose_amortizer_static_force               = 129000

local nose_amortizer_direct_damper_force_factor = 19000
local nose_amortizer_back_damper_force_factor   = 38000

local nose_wheel_moment_of_inertia              = 1.1

local nose_wheel_kz_factor                      = 0.3
local nose_noise_k                              = 0.45


-- MAINGEAR
local main_amortizer_min_length                 = 0.00
local main_amortizer_max_length                 = 0.56
local main_amortizer_basic_length               = 0.55
local main_amortizer_reduce_length              = 0.1

local main_amortizer_spring_force_factor        = 6000000
local main_amortizer_spring_force_factor_rate   = 3.0 

local main_amortizer_static_force               = 102500

local main_amortizer_direct_damper_force_factor = 42000 
local main_amortizer_back_damper_force_factor   = 52000 

local main_damper_coeff                         = 150.0

local main_wheel_moment_of_inertia              = 3.2  

local wheel_static_friction_factor_COMMON       = 1.0 
local wheel_side_friction_factor_COMMON         = 1.1
local wheel_roll_friction_factor_COMMON         = 0.153
local wheel_glide_friction_factor_COMMON        = 0.22

local wheel_static_friction_factor_NOSE         = 0.6 
local wheel_side_friction_factor_NOSE           = 1.1
local wheel_roll_friction_factor_NOSE           = 0.08
local wheel_glide_friction_factor_NOSE          = 0.04

local brake_moment_main                         = 16000

local wheel_radius_factor                       = 1.0

local main_wheel_kz_factor                      = 0.35
local main_noise_k                              = 0.6

suspension =
{
    -- NOSEGEAR
    {
        anti_skid_installed = true,  

        mass                                    = 60.0,  
        damage_element                          = 83,
        moment_of_inertia                       = {12.0, 0.6, 12.0},  
        wheel_axle_offset                       = 0.0,
        self_attitude                           = true,
        yaw_limit                               = math.rad(60.0),  

        amortizer_min_length                    = nose_amortizer_min_length,
        amortizer_max_length                    = nose_amortizer_max_length,
        amortizer_basic_length                  = nose_amortizer_basic_length,
        amortizer_reduce_length                 = nose_amortizer_reduce_length,

        amortizer_spring_force_factor           = nose_amortizer_spring_force_factor,
        amortizer_spring_force_factor_rate      = nose_amortizer_spring_force_factor_rate,

        amortizer_static_force                  = nose_amortizer_static_force,
        amortizer_direct_damper_force_factor    = nose_amortizer_direct_damper_force_factor,
        amortizer_back_damper_force_factor      = nose_amortizer_back_damper_force_factor,

        wheel_radius                            = 0.2935,  
        wheel_static_friction_factor            = wheel_static_friction_factor_NOSE,
        wheel_side_friction_factor              = wheel_side_friction_factor_NOSE,
        wheel_roll_friction_factor              = wheel_roll_friction_factor_NOSE,
        wheel_glide_friction_factor             = wheel_glide_friction_factor_NOSE,
        wheel_damage_force_factor               = 300.0,  
        wheel_damage_speed                      = 220.0,  
        wheel_brake_moment_max                  = 200.0,
        wheel_moment_of_inertia                 = nose_wheel_moment_of_inertia,
        wheel_kz_factor                         = nose_wheel_kz_factor,
        noise_k                                 = nose_noise_k,

        damper_coeff                            = main_damper_coeff,

        arg_amortizer                           = 1,
        arg_wheel_rotation                      = 101,
        arg_wheel_yaw                           = 2,
        collision_shell_name                    = "WHEEL_F",
    },

    -- MAINGEAR LEFT
    {
        anti_skid_installed = true,  

        mass                                    = 250.0, 
        damage_element                          = 84,
        moment_of_inertia                       = {120.0, 12.0, 120.0},
        wheel_axle_offset                       = 0.0,
        yaw_limit                               = 0.0,
        self_attitude                           = false,

        --amortizer_min_length                    = main_amortizer_min_length,
        amortizer_max_length                    = main_amortizer_max_length,
        amortizer_basic_length                  = main_amortizer_basic_length,
        amortizer_reduce_length                 = main_amortizer_reduce_length,

        amortizer_spring_force_factor           = main_amortizer_spring_force_factor,
        amortizer_spring_force_factor_rate      = main_amortizer_spring_force_factor_rate,

        amortizer_static_force                  = main_amortizer_static_force,
        amortizer_direct_damper_force_factor    = main_amortizer_direct_damper_force_factor,
        amortizer_back_damper_force_factor      = main_amortizer_back_damper_force_factor,

        wheel_radius                            = 0.411, 
        wheel_static_friction_factor            = wheel_static_friction_factor_COMMON,
        wheel_side_friction_factor              = wheel_side_friction_factor_COMMON,
        wheel_roll_friction_factor              = wheel_roll_friction_factor_COMMON,
        wheel_glide_friction_factor             = wheel_glide_friction_factor_COMMON,
        wheel_damage_force_factor               = 350.0,  
        wheel_damage_speed                      = 240.0,  
        wheel_brake_moment_max                  = brake_moment_main,
        wheel_moment_of_inertia                 = main_wheel_moment_of_inertia,
        wheel_kz_factor                         = main_wheel_kz_factor,
        noise_k                                 = main_noise_k,

        damper_coeff                            = main_damper_coeff,

        arg_amortizer                           = 6,
        arg_wheel_rotation                      = 102,
        arg_wheel_yaw                           = -1,
        collision_shell_name                    = "WHEEL_L",
    },

    -- MAINGEAR RIGHT
    {
        anti_skid_installed                     = true,  

        mass                                    = 250.0, 
        damage_element                          = 85,
        moment_of_inertia                       = {120.0, 12.0, 120.0},
        wheel_axle_offset                       = 0.0,
        yaw_limit                               = 0.0,
        self_attitude                           = false,

        --amortizer_min_length                    = main_amortizer_min_length,
        amortizer_max_length                    = main_amortizer_max_length,
        amortizer_basic_length                  = main_amortizer_basic_length,
        amortizer_reduce_length                 = main_amortizer_reduce_length,

        amortizer_spring_force_factor           = main_amortizer_spring_force_factor,
        amortizer_spring_force_factor_rate      = main_amortizer_spring_force_factor_rate,

        amortizer_static_force                  = main_amortizer_static_force,
        amortizer_direct_damper_force_factor    = main_amortizer_direct_damper_force_factor, 
        amortizer_back_damper_force_factor      = main_amortizer_back_damper_force_factor,

        wheel_radius                            = 0.411,  
        wheel_static_friction_factor            = wheel_static_friction_factor_COMMON,
        wheel_side_friction_factor              = wheel_side_friction_factor_COMMON,
        wheel_roll_friction_factor              = wheel_roll_friction_factor_COMMON,
        wheel_glide_friction_factor             = wheel_glide_friction_factor_COMMON,
        wheel_damage_force_factor               = 350.0,  
        wheel_damage_speed                      = 240.0,  
        wheel_brake_moment_max                  = brake_moment_main,
        wheel_moment_of_inertia                 = main_wheel_moment_of_inertia,
        wheel_kz_factor                         = main_wheel_kz_factor,
        noise_k                                 = main_noise_k,

        damper_coeff                            = main_damper_coeff,

        arg_amortizer                           = 4,
        arg_wheel_rotation                      = 103,
        arg_wheel_yaw                           = -1,
        collision_shell_name                    = "WHEEL_R",
    },
}