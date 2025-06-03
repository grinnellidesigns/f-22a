--[[
    Grinnelli Designs F-22A Raptor
    Copyright (C) 2025, Ash blythe
    
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
--]]


--v1.1
local MAKO_A2A_C =
{
	category		= CAT_AIR_TO_AIR,
	name			= "MAKO_A2A_C",
	displayName		= _("Mako Multi-Mission Hypersonic Missile - Active Radar AAM"),
	user_name		= _("MAKO-C"),
	display_name_short = "MAKO-C",
	scheme			= "aa_missile_amraam2",
	class_name		= "wAmmunitionSelfHoming",
	model			= "Mako_A2A_C",
    wsTypeOfWeapon  = {4,4,7,WSTYPE_PLACEHOLDER},

	warhead 	= enhanced_a2a_warhead(160, 160),
	warhead_air = enhanced_a2a_warhead(160, 160),
	proximity_fuze = {
		radius		= 30.0,
		arm_delay	= 1.6,
	},	
	
	shape_table_data =
	{
		{
			file  = "Mako_A2A_C";
			life  = 1;
			fire  = {0, 1};
			name  	 = "MAKO_A2A_C";
			username = "MAKC";
			index 	 = WSTYPE_PLACEHOLDER
		},
	},
	
    Escort = 0,
    Head_Type = 2,
	sigma = {1, 1, 1},
    M = 160.0,
    H_max = 25000.0,
    H_min = 1.0,
    Diam = 169.0,
    Cx_pil = 2.5,
    D_max = 30000.0,
    D_min = 500.0,
    Head_Form = 1,
    Life_Time = 340.0,
    Nr_max = 40,
    v_min = 140.0,
    v_mid = 2200.0,
    Mach_max = 7.5,
    t_b = 0.0,
    t_acc = 6.0,
    t_marsh = 4.0,
    Range_max = 280000.0,
    H_min_t = 1.0,
    Fi_start = 0.5,
    Fi_rak = 3.14152,
    Fi_excort = 1.05,
    Fi_search = 1.05,
    OmViz_max = 0.52,
	exhaust = { 1, 1, 1, 1 },
    X_back = -1.9,
    Y_back = 0.0,
    Z_back = 0.0,
    Reflection = 0.03,
    KillDistance = 20.0,
	
	SeekerGen = 4,  
	ccm_k0 = 0.001,  
	loft = 1,
	hoj = 1,
	loft_factor = 4.5,
	PN_gain = 4,
	
	supersonic_A_coef_skew = 0.1, 
	nozzle_exit_area =	0.011,
	
	controller = {
		boost_start = 0.5,
		march_start = 38.5,
	},

	boost = {
        impulse                             = 254,
        fuel_mass                           = 90.6,
        work_time                           = 15.0,
		nozzle_position						= {{-1.65, 0.0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.8,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.8,
		custom_smoke_dissipation_factor		= 0.2,	
	},

	march = {
        impulse                             = 170,
        fuel_mass                           = 18.2,
        work_time                           = 18.0,
		nozzle_position						= {{-1.65, 0.0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.3,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.03,
		custom_smoke_dissipation_factor		= 0.2,
		smoke_opacity_type 					= 0,
	},	
		
	ModelData = {58,    --MODEL PARAMETERS COUNT
				0.32,    --CROSSECTIONAL AREA IN THE DIRECTION OF AIR FLOW (METER SQUARE)

				-- Drag (Сx) --ALL FOLLOWUP VALUES
				0.020,       --BASE DRAG COEFFICIENT AT SUBSONIC SPEED (MACH 0-0.8) 
				0.045,       --PEAK DRAG COEFFICIENT AT MACH 1
				0.008,       --STEEPNESS OF DRAG BEFORE TRANSONIC WAVE CRISIS
				-0.195,      --BASE DRAG COEFFICIENT AT SUPERSONIC SPEED (MACH 1.2-5.0) 
				0.05,        --STEEPNESS OF DRAG AFTER TRANSONIC WAVE CRISIS
				0.65,        --SCALING FACTOR DURING THE DIFFERENT FLIGHT ENVELOPE ABOVE
				
				-- Lift (Cy) 
				1.0,         --LIFT DURING (MACH 0-0.8)
				0.5,         --LIFT DURING (MACH 1.2-5.0) 
				1.0,         --STEEPNESS OF LIFT AFTER TRANSONIC WAVE CRISIS 
				
				0.5,         --MAX AOA IN RADIANS
				0.0,         --ADDITIONAL G'S DURING THRUST VECTORING
				
		        --ENGINE DATA, VALUES FOR TIME, FUEL FLOW AND THRUST
				--t_statr	t_b		t_accel		t_marct.h	t_inertial		t_break		t_end		-- Stage
				-1.0,		-1.0,	6.0,  		4.0,		0.0,			0.0,		1.0e9,      -- time of stage, sec
				0.0,		0.0,	10.5,		2.0,		0.0,			0.0,		0.0,        -- fuel flow rate in second
				0.0,		0.0,	23770.0,    7530.0, 	0.0,			0.0,		0.0,        -- thrust, newtons
				1.0e9,
				340.0,       -- LIFETIME BATTERY	(SEC)	
				0,
				1.0,
				30000.0,     -- RANGE TO TARGET AT LAUNCH, BEYOND THAT MISSILE EXECUTE LOFT
				15000.0,     -- RANGE TRAVELLED TO TARGET AT WHICH LOFTING CONCLUDES
				0.52356,     -- LOFT ANGLE IN RADIANS
				50.0,
				0.0,
				1.19,
				1.0, 
				2.0,		 
		        -- DLZ, LAUNCH INDICATION RANGES (M)
				21.0, 
				-25.0, 
				-3.0, 
				165000.0,    -- TARGET DIRECTLY TOWARDS THE CARRIER AT 5000FT, (900KM/H)(486kts) 
				87500.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 5000FT, (900KM/H)(486kts)
				230000.0,    -- TARGET DIRECTLY TOWARDS THE CARRIER AT 10000FT, (900KM/H)(486kts)
				127500.0,    -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 10000FT, (900KM/H)(486kts)
				110000.0,    -- TARGET DIRECTLY TOWARDS THE CARRIER AT 1000FT, (900KM/H)(486kts)
				55500.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 1000FT, (900KM/H)(486kts)
				4000.0,
				0.4, 
				-0.015,
				0.5,
	},

	fm = {
		mass				= 160.0,
		caliber				= 0.178,
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 0,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.178,
		S					= 0.0240,
		Ix					= 1.24,
		Iy					= 130.12,
		Iz					= 130.12,

		Mxd					= 0.1 * 57.3,
		Mxw					= -15.8,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 	4.2		4.4		4.6		4.8		5.0  |
		Cx0 	= {	0.42,   0.42,   0.42,   0.42,   0.43,   0.65,   0.78,   0.75,   0.71,   0.66,   0.62,   0.59,   0.56,   0.53,   0.50,   0.47,   0.45,   0.42,   0.40,   0.38,   0.36,   0.34,   0.32,   0.31,   0.30,   0.30},
		CxB 	= {	0.018,  0.018,  0.018,  0.018,  0.018,  0.12,   0.137,  0.130,  0.123,  0.114,  0.104,  0.096,  0.088,  0.081,  0.074,  0.068,  0.062,  0.057,  0.052,  0.047,  0.043,  0.039,  0.035,  0.032,  0.029,  0.027},
		K1		= { 0.0025,	0.0025,	0.0025,	0.0025,	0.0025,	0.0024,	0.002,	 0.00172, 0.00151, 0.00135,0.00123, 0.00114, 0.00106, 0.00099,0.00094, 0.00088, 0.00084, 0.00079, 0.00074, 0.0007, 0.00066, 0.00062, 0.00058, 0.00055,0.00052, 0.0005},
		K2		= {-0.0024,-0.0024,-0.0024,-0.0024,-0.0024,-0.0024,-0.00206,-0.00186,-0.00168,-0.0015,-0.00134,-0.00118,-0.00104,-0.0009,-0.00078,-0.00066,-0.00056,-0.00046,-0.00038,-0.0003,-0.00024,-0.00018,-0.00014,-0.0001,-0.00008,-0.00006},
		Cya		= { 0.29,   0.29,   0.29,   0.29,   0.30,   0.38,   0.42,   0.455,  0.465,  0.45,   0.438,  0.428,  0.418,  0.409,  0.40,   0.392,  0.384,  0.377,  0.370,  0.364,  0.358,  0.352,  0.346,  0.340,  0.335,  0.33},
		Cza		= { 0.29,   0.29,   0.29,   0.29,   0.30,   0.38,   0.42,   0.455,  0.465,  0.45,   0.438,  0.428,  0.418,  0.409,  0.40,   0.392,  0.384,  0.377,  0.370,  0.364,  0.358,  0.352,  0.346,  0.340,  0.335,  0.33},
		Mya		= {-0.60,  -0.60,  -0.60,  -0.60,  -0.66,  -0.79,  -0.78,  -0.71,  -0.62,  -0.50,  -0.42,  -0.36,  -0.32,  -0.29,  -0.26,  -0.24,  -0.22,  -0.21,  -0.20,  -0.19,  -0.18,  -0.17,  -0.16,  -0.15,  -0.14,  -0.13},
		Mza		= {-0.60,  -0.60,  -0.60,  -0.60,  -0.66,  -0.79,  -0.78,  -0.71,  -0.62,  -0.50,  -0.42,  -0.36,  -0.32,  -0.29,  -0.26,  -0.24,  -0.22,  -0.21,  -0.20,  -0.19,  -0.18,  -0.17,  -0.16,  -0.15,  -0.14,  -0.13},
		Myw		= {-7.5,   -7.5,   -7.5,   -7.5,   -7.7,   -10.1,  -9.1,   -9.0,   -8.9,   -8.8,   -8.7,   -8.6,   -8.5,   -8.4,   -8.3,   -8.2,   -8.1,   -8.0,   -7.9,   -7.8,   -7.7,   -7.6,   -7.5,   -7.4,   -7.3,   -7.2},
		Mzw		= {-7.5,   -7.5,   -7.5,   -7.5,   -7.7,   -10.1,  -9.1,   -9.0,   -8.9,   -8.8,   -8.7,   -8.6,   -8.5,   -8.4,   -8.3,   -8.2,   -8.1,   -8.0,   -7.9,   -7.8,   -7.7,   -7.6,   -7.5,   -7.4,   -7.3,   -7.2},
		A1trim	= { 28,		28,		28,		28,		28,		31.2,	32.74,	33.39,	33.7,	33.89,	34.04,	34.18,	34.31,	34.44,	34.57,	34.7,	34.83,	34.96,	35.09,	35.22,	35.35,	35.48,	35.61,	35.74,	35.87,	36 },
		A2trim	= { 28,		28,		28,		28,		28,		31.2,	32.74,	33.39,	33.7,	33.89,	34.04,	34.18,	34.31,	34.44,	34.57,	34.7,	34.83,	34.96,	35.09,	35.22,	35.35,	35.48,	35.61,	35.74,	35.87,	36 },

		model_roll = math.rad(45),
		fins_stall = 1,
	},

	sensor = {
		delay						= 1.5,
		op_time						= 340.0,
		FOV							= math.rad(140),
		max_w_LOS					= math.rad(140),
		sens_near_dist				= 100,
		sens_far_dist				= 40000,
		ccm_k0						= 0.01,
		aim_sigma					= 2.0,
		height_error_k				= 10,
		height_error_max_vel		= 30,
		height_error_max_h			= 200,
		hoj							= 1,
	},
	
	gimbal = {
		delay				= 0,
		op_time				= 340.0,
		pitch_max			= math.rad(60),
		yaw_max				= math.rad(60),
		max_tracking_rate	= math.rad(30),
		tracking_gain		= 50,
	},

	autopilot = {
		delay				= 0.2,
		cmd_delay			= 0.8,
		op_time				= 340.0,
		Tf					= 0.1,
		Knav				= 4.0,
		Kd					= 180.0,
		Ka					= 16.0,
		T1					= 309.0,
		Tc					= 0.06,
		Kx					= 0.1,
		Krx					= 2.0,
		gload_limit			= 40.0,
		fins_limit			= math.rad(18),
		fins_limit_x		= math.rad(5),
		null_roll			= math.rad(45),
		accel_coeffs		= { 0, 11.5,-1.2,-0.25, 24.0,
								0.0248 * 0.75 * 0.0091 },

		loft_active			= 1,
		loft_factor			= 4.5,
		loft_sin			= math.sin(30/57.3),
		loft_off_range		= 15000,
		dV0					= 393,
	},

	actuator = {
		Tf					= 0.005,
		D					= 250.0,
		T1					= 0.002,
		T2					= 0.006,
		max_omega			= math.rad(400),
		max_delta			= math.rad(20),
		fin_stall			= 1,
		sim_count			= 4,
	},
}

declare_weapon(MAKO_A2A_C)

declare_loadout({
    category    	= CAT_AIR_TO_AIR,
    CLSID       	= "{MAKO_A2A_C}",	
    Picture     	= "MAKO_A2A_C.png",
    displayName 	= _("Mako Multi-Mission Hypersonic Missile - Active Radar AAM"),
	attribute		= MAKO_A2A_C.wsTypeOfWeapon,
    Count       	= 1,
    Weight      	= 160.0,
    Elements    	= 
	{
		{
			DrawArgs	=
			{
				[1]	=	{1,	1},
				[2]	=	{2,	1},
			},	
			ShapeName	=	"MAKO_A2A_C",
		},
	},	
})