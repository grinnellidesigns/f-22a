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
local AIM_120_C7 =
{
	category		= CAT_AIR_TO_AIR,
	name			= "AIM_120C7",
	displayName		= _("AIM-120C7 - Active Radar AAM"),
	user_name		= _("AIM-120C7"),
	display_name_short = "AIM-120C7",
	scheme			= "aa_missile_amraam2",
	class_name		= "wAmmunitionSelfHoming",
	model			= "AIM-120C7",
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
			file  = "AIM-120C7";
			life  = 1;
			fire  = {0, 1};
			name  	 = "AIM_120C7";
			username = "AIM-120C7";
			index 	 = WSTYPE_PLACEHOLDER
		},
	},
	
    Escort = 0,
    Head_Type = 2,
	sigma = {1, 1, 1},
    M = 161.48,
    H_max = 25000.0,
    H_min = 1.0,
    Diam = 169.0,
    Cx_pil = 2.5,
    D_max = 30000.0,
    D_min = 500.0,
    Head_Form = 1,
    Life_Time = 120.0,
    Nr_max = 40,
    v_min = 140.0,
    v_mid = 2200.0,
    Mach_max = 4.0,
    t_b = 0.4,
    t_acc = 3.0,
    t_marsh = 7.0,
    Range_max = 120000.0,
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
	ccm_k0 = 0.04,  
	loft = 1,
	hoj = 1,
	loft_factor = 4.5,
	PN_gain = 4,
	
	supersonic_A_coef_skew = 0.1, 
	nozzle_exit_area =	0.011,
	
	controller = {
		boost_start = 0,
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
		fuel_mass							= 55.26,
		work_time							= 7.5,
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
			    0.4,    --CROSSECTIONAL AREA IN THE DIRECTION OF AIR FLOW (METER SQUARE)
				
				-- Drag (Сx) --ALL FOLLOWUP VALUES
				0.029,       --BASE DRAG COEFFICIENT AT SUBSONIC SPEED (MACH 0-0.8) 
				0.06,        --PEAK DRAG COEFFICIENT AT MACH 1
				0.01,        --STEEPNESS OF DRAG BEFORE TRANSONIC WAVE CRISIS
				-0.245,      --BASE DRAG COEFFICIENT AT SUPERSONIC SPEED (MACH 1.2-5.0) 
				0.08,        --STEEPNESS OF DRAG AFTER TRANSONIC WAVE CRISIS
				0.7,         --SCALING FACTOR DURING THE DIFFERENT FLIGHT ENVELOPE ABOVE
				
				-- Lift (Cy) 
				1.4,         --LIFT DURING (MACH 0-0.8)
				0.6,         --LIFT DURING (MACH 1.2-5.0)
				1.2,         --STEEPNESS OF LIFT AFTER TRANSONIC WAVE CRISIS
				
				0.5,         --MAX AOA IN RADIANS
				0.0,         --ADDITIONAL G'S DURING THRUST VECTORING
				
		        --ENGINE DATA, VALUES FOR TIME, FUEL FLOW AND THRUST
				--t_statr	t_b		t_accel		t_marct.h	t_inertial		t_break		t_end		 -- Stage
				-1.0,		-1.0,	9.0,  		0.0,		0.0,			0.0,		1.0e9,       -- time of stage, sec
				0.0,		0.0,	6.14,		0.0,		0.0,			0.0,		0.0,         -- fuel flow rate in second
				0.0,		0.0,	15283.0,	0.0,		0.0,			0.0,		0.0,         -- thrust, newtons
				
				1.0e9,      
				120.0,       -- LIFETIME BATTERY	(SEC)	
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
				50000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 5000FT, (900KM/H)(486kts)
				25000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 5000FT, (900KM/H)(486kts)
				90000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 10000FT, (900KM/H)(486kts)
				45000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 10000FT, (900KM/H)(486kts)
				38000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 1000FT, (900KM/H)(486kts)
				19000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 1000FT, (900KM/H)(486kts)
				4000.0,
				0.4, 
				-0.015, 
				0.5,         
	},

	fm = {
		mass				= 161.48,
		caliber				= 0.178,
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 0,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.178,
		S					= 0.0180,
		Ix					= 1.04,
		Iy					= 125.32,
		Iz					= 125.32,

		Mxd					= 0.1 * 57.3,
		Mxw					= -15.8,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 	4.2		4.4		4.6		4.8		5.0 |
		Cx0 	= {	0.468,	0.468,	0.468,	0.468,	0.479,	0.751,	0.88,	0.8572,	0.8132,	0.7645,	0.7205,	0.6808,	0.6447,	0.6119,	0.582,	0.5545,	0.5292,	0.5057,	0.4838,	0.4633,	0.4439,	0.4256,	0.4083,	0.3921,	0.377,	0.364  },
		CxB 	= {	0.021,	0.021,	0.021,	0.021,	0.021,	0.138,	0.153,	0.146,	0.1382,	0.1272,	0.1167,	0.1073,	0.0987,	0.0909,	0.0837,	0.077,	0.0708,	0.065,	0.0595,	0.0544,	0.0495,	0.0449,	0.0406,	0.0364,	0.0324,	0.0286 },
		K1		= { 0.0025,	0.0025,	0.0025,	0.0025,	0.0025,	0.0024,	0.002,	 0.00172, 0.00151, 0.00135,0.00123, 0.00114, 0.00106, 0.00099,0.00094, 0.00088, 0.00084, 0.00079, 0.00074, 0.0007, 0.00066, 0.00062, 0.00058, 0.00055,0.00052, 0.0005  },
		K2		= {-0.0024,-0.0024,-0.0024,-0.0024,-0.0024,-0.0024,-0.00206,-0.00186,-0.00168,-0.0015,-0.00134,-0.00118,-0.00104,-0.0009,-0.00078,-0.00066,-0.00056,-0.00046,-0.00038,-0.0003,-0.00024,-0.00018,-0.00014,-0.0001,-0.00008,-0.00006 },
		Cya		= { 0.318,	0.318,	0.318,	0.318,	0.336,	0.425,	0.467,	0.506,	0.518,	0.503,	0.491,	0.48,	0.471,	0.463,	0.456,	0.45,	0.445,	0.441,	0.438,	0.434,	0.431,	0.429,	0.427,	0.424,	0.423,	0.421 },
		Cza		= { 0.318,	0.318,	0.318,	0.318,	0.336,	0.425,	0.467,	0.506,	0.518,	0.503,	0.491,	0.48,	0.471,	0.463,	0.456,	0.45,	0.445,	0.441,	0.438,	0.434,	0.431,	0.429,	0.427,	0.424,	0.423,	0.421 },
		Mya		= {-0.712, -0.712, -0.712, -0.712, -0.776, -0.916, -0.907, -0.825, -0.7191,-0.5719,-0.4711,-0.4019,-0.3538,-0.3193,-0.2934,-0.2728,-0.2553,-0.2398,-0.2254,-0.2119,-0.199, -0.1868,-0.1754,-0.1649,-0.1557,-0.149 },
		Mza		= {-0.712, -0.712, -0.712, -0.712, -0.776, -0.916, -0.907, -0.825, -0.7191,-0.5719,-0.4711,-0.4019,-0.3538,-0.3193,-0.2934,-0.2728,-0.2553,-0.2398,-0.2254,-0.2119,-0.199, -0.1868,-0.1754,-0.1649,-0.1557,-0.149 },
		Myw		= { -8.8081,-8.8081,-8.8081,-8.8081,-9.0256,-11.32,-10.0494,-10.0967,-10.111,-10.0959,-10.0547,-9.9906,-9.9065,-9.8052,-9.6892,-9.5609,-9.4224,-9.2756,-9.1223,-8.9639,-8.8019,-8.6373,-8.471,-8.3037,-8.1361,-7.9682 },
		Mzw		= { -8.8081,-8.8081,-8.8081,-8.8081,-9.0256,-11.32,-10.0494,-10.0967,-10.111,-10.0959,-10.0547,-9.9906,-9.9065,-9.8052,-9.6892,-9.5609,-9.4224,-9.2756,-9.1223,-8.9639,-8.8019,-8.6373,-8.471,-8.3037,-8.1361,-7.9682 },
		A1trim	= { 28,		28,		28,		28,		28,		31.2,	32.74,	33.39,	33.7,	33.89,	34.04,	34.18,	34.31,	34.44,	34.57,	34.7,	34.83,	34.96,	35.09,	35.22,	35.35,	35.48,	35.61,	35.74,	35.87,	36 },
		A2trim	= { 28,		28,		28,		28,		28,		31.2,	32.74,	33.39,	33.7,	33.89,	34.04,	34.18,	34.31,	34.44,	34.57,	34.7,	34.83,	34.96,	35.09,	35.22,	35.35,	35.48,	35.61,	35.74,	35.87,	36 },

		model_roll = math.rad(45),
		fins_stall = 1,
	},

	sensor = {
		delay						= 1.5,
		op_time						= 120,
		FOV							= math.rad(15),
		max_w_LOS					= math.rad(30),
		sens_near_dist				= 100,
		sens_far_dist				= 40000,
		ccm_k0						= 0.01,
		aim_sigma					= 2.0,
		height_error_k				= 10,
		height_error_max_vel		= 30,
		height_error_max_h			= 250,
		hoj							= 1,
	},
	
	gimbal = {
		delay				= 0,
		op_time				= 120,
		pitch_max			= math.rad(60),
		yaw_max				= math.rad(60),
		max_tracking_rate	= math.rad(30),
		tracking_gain		= 50,
	},

	autopilot = {
		delay				= 0.2,
		cmd_delay			= 0.8,
		op_time				= 120,
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

declare_weapon(AIM_120_C7)

declare_loadout({
    category    	= CAT_AIR_TO_AIR,
    CLSID       	= "{AIM-120C-7}",
    Picture     	= 'AIM-120C7.png',
    displayName 	= _("AIM-120C7 - Active Radar AAM"),
	attribute		= AIM_120_C7.wsTypeOfWeapon,
    Count       	= 1,
    Weight      	= 161.48,
    Elements    	= 
	{
		{
			DrawArgs	=
			{
				[1]	=	{1,	1},
				[2]	=	{2,	1},
			},	
			ShapeName	=	"AIM-120C7",
		},
	},	
})

declare_loadout({
    category        = CAT_AIR_TO_AIR,
    CLSID           = "{LAU_115_2xAIM-120C-7}",
	wsTypeOfWeapon	= AIM_120_C7.wsTypeOfWeapon,
	attribute		= {4,4,32,WSTYPE_PLACEHOLDER},	
    Count           = 2,
    Picture         = "AIM-120C7.png",
    displayName     = _("2x AIM-120C7 - Active Radar AAM"),
    Weight          = 161.48 * 2 + 50,
	Elements = {
	
		{
			ShapeName	=	"LAU-115C+2_LAU127",
			IsAdapter = true,
		},
		
		{
			DrawArgs = {[1] = {1,1},[2] = {2,1},},
			Position	=	{0.5,	-0.06,	0.22},
			ShapeName	=	"AIM-120C7",
			Rotation = {-90,0,0},
		},
		
		{
			DrawArgs = {[1] = {1,1},[2] = {2,1},},
			Position	=	{0.5,	-0.06,	-0.22},
			ShapeName	=	"AIM-120C7",
			Rotation = {90,0,0},
		},
		
	},
    
    JettisonSubmunitionOnly = false,
})
