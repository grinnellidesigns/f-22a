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
local GBU_32_JDAM =
{
	category		= CAT_AIR_TO_AIR,
	name			= "GBU32_JDAM",
	displayName		= _("GBU32 - JDAM"),
	user_name		= _("GBU32-JDAM"),
	display_name_short = "GBU32-JDAM",
	model			= "gbu-32",
    wsTypeOfWeapon  = {wsType_Weapon,wsType_Missile,wsType_AA_Missile, WSTYPE_PLACEHOLDER},

	warhead = {
		caliber = 360.0,
		concrete_factors = { 1, 1, 1 },
		concrete_obj_factor = 0,
		cumulative_factor = 0,
		cumulative_thickness = 0,
		expl_mass = 460,
		mass = 460,
		obj_factors = { 1, 1 },
		other_factors = { 1, 1, 1 },
		piercing_mass = 460
	},
	
	shape_table_data =
	{
		{
			file  = "gbu-32";
			life  = 1;
			fire  = {0, 1};
			name  	 = "GBU32-JDAM";
			username = "GBU32-JDAM";
			index 	 = WSTYPE_PLACEHOLDER
		},
	},
	
    Escort = 0,
    Head_Type = 6,
	sigma = {1, 1, 1},
    M = 460,
    H_max = 10000.0,
    H_min = 1.0,
    Diam = 360.0,
    Cx_pil = 0.00035,
    D_max = 12000.0,
    D_min = 100.0,
    Head_Form = 1,
    Life_Time = 120.0,
    Nr_max = 0,
    v_min = 1.0,
    v_mid = 1000.0,
    Mach_max = 1.0,
    t_b = 0.0,
    t_acc = 0.0,
    t_marsh = 0.0,
    Range_max = 12000.0,
    H_min_t = 1.0,
    Fi_start = 0.5,
    Fi_rak = 3.14152,
    Fi_excort = 1.05,
    Fi_search = 1.05,
    OmViz_max = 0.52,
    exhaust = {0.0, 0.0, 0.0, 0.0 };
    X_back = -1.98,
    Y_back = 0.0,
    Z_back = 0.0,
    Reflection = 0.08,
    KillDistance = 20.0,
	ccm_k0 = 0.0,  
	loft = 0,
	hoj = 0,
	loft_factor = 0,

	PN_coeffs = {3, 			
				3000.0 ,1.0,		
				5000.0, 0.5,		
				10000.0, 0.2};		
		
	ModelData = {58,    --MODEL PARAMETERS COUNT
				0.4,    --CROSSECTIONAL AREA IN THE DIRECTION OF AIR FLOW (METER SQUARE)

				-- Drag (Сx) --ALL FOLLOWUP VALUES
				0.026,       --BASE DRAG COEFFICIENT AT SUBSONIC SPEED (MACH 0-0.8) 
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
				-1.0,		-1.0,	0.0,  		0.0,		0.0,			0.0,		1.0e9,       -- time of stage, sec
				0.0,		0.0,	0.0,		0.0,		0.0,			0.0,		0.0,         -- fuel flow rate in second
				0.0,		0.0,	0.0,	    0.0,		0.0,			0.0,		0.0,         -- thrust, newtons
				
				1.0e9,      
				120.0,       -- LIFETIME BATTERY	(SEC)	
				0,          
				1.0,         
				30000.0,     -- RANGE TO TARGET AT LAUNCH, BEYOND THAT MISSILE EXECUTE LOFT
				15000.0,     -- RANGE TRAVELLED TO TARGET AT WHICH LOFTING CONCLUDES
				0.0,         -- LOFT ANGLE IN RADIANS
				50.0,
				0.0,
				1.19, 
				1.0, 
				2.0,
				-- DLZ, LAUNCH INDICATION RANGES (M)
				21.0, 
				-25.0, 
				-3.0, 
				12000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 5000FT, (900KM/H)(486kts)
				12000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 5000FT, (900KM/H)(486kts)
				12000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 10000FT, (900KM/H)(486kts)
				12000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 10000FT, (900KM/H)(486kts)
				12000.0,     -- TARGET DIRECTLY TOWARDS THE CARRIER AT 1000FT, (900KM/H)(486kts)
				12000.0,     -- TARGET DIRECTLY AWAY FROM THE CARRIER AT 1000FT, (900KM/H)(486kts)
				4000.0,
				0.4, 
				-0.015, 
				0.5,         
	},

}

declare_weapon(GBU_32_JDAM)

declare_loadout({
    category    	= CAT_AIR_TO_AIR,
    CLSID       	= "{GBU32_JDAM}",
    Picture     	= 'gbu32.png',
    displayName 	= _("GBU32 - JDAM"),
	attribute		= GBU_32_JDAM.wsTypeOfWeapon,
    Count       	= 1,
    Weight      	= 460,
    Elements    	= 
	{
		{
			DrawArgs	=
			{
				[1]	=	{1,	1},
				[2]	=	{2,	1},
			},	
			ShapeName	=	"gbu-32",
		},
	},	
})