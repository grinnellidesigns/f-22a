--[[
    Grinnelli Designs F-22A Raptor
    Copyright (C) 2025, Ash Blythe
    
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


--v1.0
local AIM_120_D3 =
{
	category		= CAT_AIR_TO_AIR,
	name			= "AIM_120D3",
	displayName		= _("AIM-120D3 AMRAAM - Active Radar AAM"),
	user_name		= _("AIM-120D3"),
	display_name_short = "AIM-120D3",
	scheme			= "aa_missile_amraam2",
	class_name		= "wAmmunitionSelfHoming",
	model			= "AIM-120D",
    wsTypeOfWeapon  = {4,4,7,WSTYPE_PLACEHOLDER},

	warhead 	= predefined_warhead("AIM_120"),
	warhead_air = predefined_warhead("AIM_120"),
	proximity_fuze = {
		radius		= 9.0,
		arm_delay	= 1.6,
	},
	
	shape_table_data =
	{
		{
			file  = "AIM-120D";
			life  = 1;
			fire  = {0, 1};
			name  	 = "AIM_120D3";
			username = "AIM-120D3";
			index 	 = WSTYPE_PLACEHOLDER
		},
	},
	
    Escort = 0,
    Head_Type = 2,
	sigma = {1, 1, 1},
    M = 175.0,
    H_max = 25000.0,
    H_min = 1.0,
    Diam = 169.0,
    Cx_pil = 2.5,
    D_max = 30000.0,
    D_min = 500.0,
    Head_Form = 1,
    Life_Time = 170.0,
    Nr_max = 40,
    v_min = 140.0,
    v_mid = 2200.0,
    Mach_max = 5.0,
    t_b = 0.4,
    t_acc = 3.0,
    t_marsh = 11.0,
    Range_max = 180000.0,
    H_min_t = 1.0,
    Fi_start = 0.5,
    Fi_rak = 3.14152,
    Fi_excort = 1.05,
    Fi_search = 1.05,
    OmViz_max = 0.52,
    exhaust = {0.8, 0.8, 0.8, 0.05 };
    X_back = -1.98,
    Y_back = 0.0,
    Z_back = 0.0,
    Reflection = 0.05,
    KillDistance = 20.0,
	
	SeekerGen = 4,  
	ccm_k0 = 0.01,  
	loft = 1,
	hoj = 1,
	loft_factor = 4.5,
	PN_gain = 4,
	
	supersonic_A_coef_skew = 0.1, 
	nozzle_exit_area =	0.011,
	
	controller = {
		boost_start = 0.0,
		march_start = 0.4,
	},

	boost = {
		impulse								= 0,
		fuel_mass							= 0,
		work_time							= 0.1,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.4,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.03,
		custom_smoke_dissipation_factor		= 0.2,
	},

	march = {
		impulse								= 254,
		fuel_mass							= 75.51,
		work_time							= 11.5,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.4,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.03,
		custom_smoke_dissipation_factor		= 0.2,
		smoke_opacity_type 					= 1,
	},	
		
	ModelData = {58,    --MODEL PARAMETERS COUNT
				0.5,    --CROSSECTIONAL AREA IN THE DIRECTION OF AIR FLOW (METER SQUARE)

				-- Drag (Сx) --ALL FOLLOWUP VALUES
				0.026,       --BASE DRAG COEFFICIENT AT SUBSONIC SPEED (MACH 0-0.8) 
				0.053,       --PEAK DRAG COEFFICIENT AT MACH 1
				0.01,        --STEEPNESS OF DRAG BEFORE TRANSONIC WAVE CRISIS
				-0.245,      --BASE DRAG COEFFICIENT AT SUPERSONIC SPEED (MACH 1.2-5.0) 
				0.075,       --STEEPNESS OF DRAG AFTER TRANSONIC WAVE CRISIS
				0.7,         --SCALING FACTOR DURING THE DIFFERENT FLIGHT ENVELOPE ABOVE
				
				-- Lift (Cy) 
				1.5,         --LIFT DURING (MACH 0-0.8)
				0.6,         --LIFT DURING (MACH 1.2-5.0) 
				1.2,         --STEEPNESS OF LIFT AFTER TRANSONIC WAVE CRISIS 
				
				0.5,         --MAX AOA IN RADIANS
				0.0,         --ADDITIONAL G'S DURING THRUST VECTORING
				
		        --ENGINE DATA, VALUES FOR TIME, FUEL FLOW AND THRUST
				--t_statr	t_b		t_accel		t_marct.h	t_inertial		t_break		t_end		-- Stage
				-1.0,		-1.0,	13.0,  		0.0,		0.0,			0.0,		1.0e9,      -- time of stage, sec
				0.0,		0.0,	5.8,		0.0,		0.0,			0.0,		0.0,        -- fuel flow rate in second
				0.0,		0.0,	14458,	    0.0,		0.0,			0.0,		0.0,        -- thrust, newtons
				
				1.0e9,
				170.0,       -- LIFETIME BATTERY	(SEC)	
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
				74000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 5000FT, (900KM/H)(486kts) 
				37000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 5000FT, (900KM/H)(486kts)
				124000.0,    -- TARGET DIRECTLY TOWARDS THE CARRIER AT 10000FT, (900KM/H)(486kts)
				62000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 10000FT, (900KM/H)(486kts)
				54000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 1000FT, (900KM/H)(486kts)
				27000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 1000FT, (900KM/H)(486kts)
				4000.0,
				0.4, 
				-0.015,
				0.5,
	},

	fm = {
		mass				= 175.0,
		caliber				= 0.178,
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 0,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.178,
		S					= 0.0248,
		Ix					= 1.30,
		Iy					= 150,
		Iz					= 150,

		Mxd					= 0.1 * 57.3,
		Mxw					= -15.8,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 	4.2		4.4		4.6		4.8		5.0 |
		Cx0 	= {	0.515,	0.515,	0.515,	0.515,	0.527,	0.85,	0.949,	0.905,	0.8605,	0.8094,	0.7636,	0.7204,	0.6813,	0.6458,	0.6135,	0.5839,	0.5567,	0.5316,	0.5082,	0.4864,	0.4659,	0.4468,	0.4288,	0.4121,	0.3968,	0.384  },
		CxB 	= {	0.021,	0.021,	0.021,	0.021,	0.021,	0.138,	0.153,	0.146,	0.1382,	0.1272,	0.1167,	0.1073,	0.0987,	0.0909,	0.0837,	0.077,	0.0708,	0.065,	0.0595,	0.0544,	0.0495,	0.0449,	0.0406,	0.0364,	0.0324,	0.0286 },
		K1		= { 0.0039,	0.0039,	0.0039,	0.0039,	0.0039,	0.0048,	0.004,	0.00325,	0.002845,	0.002602,	0.002378,	0.002176,	0.001994,	0.001832,	0.001689,	0.001564,	0.001456,	0.001366,	0.00129,	0.001229,	0.001182,	0.001147,	0.001123,	0.001108,	0.001101,	0.0011 },
		K2		= { -0.0041,-0.0041,-0.0041,-0.0041,-0.0041,-0.0049,-0.0042,-0.0036,	-0.003121,	-0.002725,	-0.002408,	-0.00213,	-0.001888,	-0.001677,	-0.001494,	-0.001334,	-0.001196,	-0.001077,	-0.000973,	-0.000884,	-0.000808,	-0.000743,	-0.000689,	-0.000646,	-0.000615,	-0.0006 },
		Cya		= { 0.345,	0.345,	0.345,	0.345,	0.357,	0.401,	0.448,	0.495,	0.513,	0.506,	0.5,	0.495,	0.49,	0.486,	0.482,	0.478,	0.474,	0.471,	0.468,	0.465,	0.462,	0.46,	0.457,	0.455,	0.453,	0.451 },
		Cza		= { 0.345,	0.345,	0.345,	0.345,	0.357,	0.401,	0.448,	0.495,	0.513,	0.506,	0.5,	0.495,	0.49,	0.486,	0.482,	0.478,	0.474,	0.471,	0.468,	0.465,	0.462,	0.46,	0.457,	0.455,	0.453,	0.451 },
		Mya		= { -1.316,-1.316,	-1.316,	-1.316,	-1.458,	-1.982,	-1.418,	-1.0883,-0.9411,-0.8255,-0.733,	-0.6574,-0.5942,-0.5403,-0.4935,-0.4525,-0.4164,-0.3846,-0.3568,-0.3328,-0.3125,-0.2959,-0.283,-0.2739,-0.2683,-0.2665 },
		Mza		= { -1.316,-1.316,	-1.316,	-1.316,	-1.458,	-1.982,	-1.418,	-1.0883,-0.9411,-0.8255,-0.733,	-0.6574,-0.5942,-0.5403,-0.4935,-0.4525,-0.4164,-0.3846,-0.3568,-0.3328,-0.3125,-0.2959,-0.283,-0.2739,-0.2683,-0.2665 },
		Myw		= { -16.3145,-16.3145,-16.3145,-16.3145,-16.8944,-19.8659,-18.1868,-17.1716,-16.504,-15.88,-15.2958,-14.7478,-14.2328,-13.7477,-13.2901,-12.8574,-12.4477,-12.0593,-11.6911,-11.3421,-11.0121,-10.7015,-10.4118,-10.1458,-9.9098,-9.7256 },
		Mzw		= { -16.3145,-16.3145,-16.3145,-16.3145,-16.8944,-19.8659,-18.1868,-17.1716,-16.504,-15.88,-15.2958,-14.7478,-14.2328,-13.7477,-13.2901,-12.8574,-12.4477,-12.0593,-11.6911,-11.3421,-11.0121,-10.7015,-10.4118,-10.1458,-9.9098,-9.7256 },
		A1trim	= { 24,		24,		24,		24,		23.5,	23,		25.16,	27.23,	29.04,	30.6,	31.93,	33.08,	34.07,	34.95,	35.74,	36.45,	37.09,	37.68,	38.2,	38.66,	39.06,	39.39,	39.66,	39.85,	39.96,	40 },
		A2trim	= { 24,		24,		24,		24,		23.5,	23,		25.16,	27.23,	29.04,	30.6,	31.93,	33.08,	34.07,	34.95,	35.74,	36.45,	37.09,	37.68,	38.2,	38.66,	39.06,	39.39,	39.66,	39.85,	39.96,	40 },

		model_roll = math.rad(45),
		fins_stall = 1,
	},

	sensor = {
		delay						= 1.5,
		op_time						= 170,
		FOV							= math.rad(90),
		max_w_LOS					= math.rad(30),
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
		op_time				= 170,
		pitch_max			= math.rad(60),
		yaw_max				= math.rad(60),
		max_tracking_rate	= math.rad(30),
		tracking_gain		= 50,
	},

	autopilot = {
		delay				= 0.8,
		cmd_delay 			= 0.8,
		op_time				= 170,
		Tf					= 0.1,
		Knav				= 4.0,
		Kd					= 110.0,
		Ka					= 22.0,
		T1					= 292.0,
		Tc					= 0.04,
		Kx					= 0.1,
		Krx					= 2.0,
		gload_limit			= 40.0,
		fins_limit			= math.rad(30),
		fins_limit_x		= math.rad(5),
		null_roll			= math.rad(45),
		accel_coeffs		= { 0, 3.4, -0.4, -0.2, 13.6,
								0.0248 * 1.0 * 0.009 },

		loft_active			= 1,
		loft_factor			= 4.5,
		loft_sin			= math.sin(30/57.3),
		loft_off_range		= 15000,
		dV0					= 347,
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

declare_weapon(AIM_120_D3)

declare_loadout({
    category    	= CAT_AIR_TO_AIR,
    CLSID       	= "{AIM-120D-3}",
    Picture     	= 'AIM-120D.png',
    displayName 	= _("AIM-120D3 - AMRAAM - Active Radar AAM"),
	attribute		= AIM_120_D3.wsTypeOfWeapon, 
    Count       	= 1,
    Weight      	= 175.0,
    Elements    	= 
	{
		{
			DrawArgs	=
			{
				[1]	=	{1,	1},
				[2]	=	{2,	1},
			},	
			ShapeName	=	"AIM-120D",
		},
	},	
})

declare_loadout({
    category        = CAT_AIR_TO_AIR,
    CLSID           = "{LAU_115_2xAIM-120D-3}",
	wsTypeOfWeapon	= AIM_120_D3.wsTypeOfWeapon,
	attribute		= {4,4,32,WSTYPE_PLACEHOLDER},	
    Count           = 2,
    Picture         = "AIM-120D.png",
    displayName     = _("2x AIM-120D3 AMRAAM - Active Radar AAM"),
    Weight          = 175 * 2 + 50,
	Elements = {
	
		{
			ShapeName	=	"LAU-115C+2_LAU127",
			IsAdapter = true,
		},
		
		{
			DrawArgs = {[1] = {1,1},[2] = {2,1},},
			Position	=	{0.5,	-0.06,	0.22},
			ShapeName	=	"AIM-120D",
			Rotation = {-90,0,0},
		},
		
		{
			DrawArgs = {[1] = {1,1},[2] = {2,1},},
			Position	=	{0.5,	-0.06,	-0.22},
			ShapeName	=	"AIM-120D",
			Rotation = {90,0,0},
		},
		
	},
    
    JettisonSubmunitionOnly = false,
})
