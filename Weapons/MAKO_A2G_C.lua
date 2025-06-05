--[[
    Grinnelli Designs F-22A Raptor
    Copyright (C) 2025, David McMasters
    
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

	Copyright (c) 2025: Ash Blythe		
--]]


--v1.1
MAKO_A2G_C = {
	category		= CAT_AIR_TO_AIR,
	name			  = "MAKO_A2G_C",
	displayName		  = _("Mako Multi-Mission Hypersonic Missile - Anti Radiation"),
	display_name_short = "MAKO-AG-C",
	user_name		= _("MAKO-AG-C"),
	mass			= 590,
	model			= 'MAKO_A2G_C',
	wsTypeOfWeapon  = {4,4,7,WSTYPE_PLACEHOLDER},	
	Escort 			= 0,
	Head_Type 		= 3,  
	sigma 			= {1, 1, 1},
	M 				= 590.0,   
	H_max 			= 30000.0,  
	H_min 			= -1,  
	Diam 			= 231.0,
	Cx_pil 			= 1,   
	D_max 			= 300000.0, 
	D_min 			= 3000.0,
	Head_Form 		= 1, 
	Life_Time 		= 400.0,   
	Nr_max 			= 20,  
	v_min 			= 170.0,
	v_mid 			= 1000.0,  
	Mach_max 		= 6.0,  
	t_b 			= 2.0,
	t_acc 			= 16.0,
	t_marsh         = 38.0,  
	Range_max 		= 300000.0, 
	H_min_t 		= 0.0,
    Fi_start 		= 0.5236,
    Fi_rak 			= 3.14152,
    Fi_excort 		= 1.05,
    Fi_search 		= 1.05,
    OmViz_max 		= 0.52,
	exhaust 		= { 1, 1, 1, 1 },
	X_back 			= -1.75,  
	Y_back 			= 0.0, 
	Z_back 			= 0.0,  
	Reflection 		= 0.15, 
	KillDistance 	= 7.0, 
	
	warhead 	= predefined_warhead("WDU_37B"),
	warhead_air = predefined_warhead("WDU_37B"),	

	proximity_fuze = {
		radius		= 20,
		arm_delay	= 3.0,
	},		

	shape_table_data = 
	{
		{

			name	 = "MAKO_A2G_C";
			file  	 = "MAKO_A2G_C";   		
			life  	 = 1;
			fire  	 = { 0, 1};
			username = _("MKGC");
			index = WSTYPE_PLACEHOLDER;
		},
	},

    class_name      = "wAmmunitionSelfHoming",
    scheme          = "anti_radiation_missile_ramjet",
	
	autopilot = {
		K 							= 50,
		K_loft_err 					= 1,
		Kd 							= 0.1,
		Ki 							= 0,
		Kix 						= 0,
		Ks 							= 10,
		Kw 							= 1.5,
		Kx 							= 0,
		PN_dist_data 				= {2000,1,500,1},
		add_err_val 				= 0.025,
		conv_input 					= 0,
		delay 						= 1,
		fins_limit 					= 1.05,
		fins_q_div 					= 1,
		loft_active_by_default 		= 1,
		loft_angle 					= 0.1,
		loft_trig_angle 			= 0.15,
		op_time 					= 400,
		rotated_WLOS_input 			= 0,
		w_limit 					= 0.18
	},
	
	boost = {
		boost_factor 						= 0,
		boost_time 							= 0,
		custom_smoke_dissipation_factor 	= 0.2,
		effect_type 						= 0,
		fuel_mass 							= 240,
		impulse 							= 350,
		nozzle_orientationXYZ 				= {{0,0,0}},
		nozzle_position 					= {{-1.75,0,0}},
		smoke_color 						= {0.8,0.8,0.8},
		smoke_transparency 					= 0.8,
		tail_width 							= 0.8,
		work_time 							= 10.5
	},

    controller = {
        boost_start = 0.8,
        march_start = 10.8,
    },
	

	fm = {
		mass        	= 590,  
		caliber     	= 0.36,  
		cx_coeff    	= {1, 0.3, 0.65, 0.023, 1.6},
		L           	= 6.6,
		I           	= 1 / 12 * 707.0 * 6.6 * 6.6,
		Ma          	= 3,
		Mw          	= 10,
		wind_sigma		= 0.0,
		wind_time		= 0.0,
		Sw				= 1.7,
		dCydA			= {0.07, 0.036},
		A				= 0.08,
		maxAoa			= 0.2,
		finsTau			= 0.08,
		Ma_x			= 1.2,
		Ma_z			= 3,
		Mw_x			= 2.7,	
	},
	
	fuze_proximity = {
		ignore_inp_armed	= 1,
	},	
  
	march = {
		AEC 								= 1.4,
		AFR_stoich 							= 14.7,
		LHVof_fuel 							= 43000000,
		Tchamb_max 							= 3200,
		boost_factor 						= 0,
		boost_time 							= 0,
		custom_smoke_dissipation_factor 	= 0.45,
		effect_type 						= 1,
		fuel_mass 							= 600,
		impulse 							= 0,
		inlet_area 							= 0.04,
		min_start_speed 					= 480,
		nozzle_orientationXYZ 				= {{0,0,0}},
		nozzle_position 					= {{-1.85,0,0}},
		smoke_color 						= {0.9,0.9,0.9},
		smoke_transparency 					= 0.05,
		tail_width 							= 0.2,
		work_time 							= 0
	},
  
	seeker = {
		FOV 							= 1.05,
		abs_err_val 					= 2,
		aim_y_offset 					= 2.5,
		ang_err_val 					= 1.3962634015955E-4,
		blind_rad_val 					= 0.1,
		calc_aim_dist 					= 500000,
		delay 							= 1.5,
		err_correct_time 				= 2.5,
		keep_aim_time 					= 4,
		lock_manual_target_types_only 	= 0,
		max_w_LOS 						= 1.05,
		op_time 						= 400,
		pos_memory_time 				= 40,
		sens_far_dist 					= 500000,
		sens_near_dist 					= 100
	},

}

declare_weapon(MAKO_A2G_C)

declare_loadout(
	{
		category		= CAT_AIR_TO_AIR,
		Picture			= "MAKO_A2A_C.png",
		wsTypeOfWeapon  = MAKO_A2G_C.wsTypeOfWeapon,		
		displayName		= _("Mako Multi-Mission Hypersonic Missile - Anti Radiation"),
		CLSID       	= '{MAKO_A2G_C}',
		attribute		= MAKO_A2G_C.wsTypeOfWeapon,
		Count			= 1,
		Weight			= MAKO_A2G_C.mass,
		Cx_pil			= 0.001, 	
		Elements		=
	{
		[1]	=	
		{
				DrawArgs	=
				{
					[1]	=	{1,	1},
					[2]	=	{2,	1},
				}, 
				Position	=	{0,	0,	0},
				ShapeName	=	"MAKO_A2G_C",
					},
		},   
})