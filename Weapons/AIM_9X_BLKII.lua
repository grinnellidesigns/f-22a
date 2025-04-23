--[[
    Veloci4 Missiles
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


--v1.0
local AIM9X_BLKII =
{
	category		= CAT_AIR_TO_AIR,
	name			= "AIM9X_BLKII", 
	user_name		= _("AIM9X-BLKII"),
	display_name_short = "AIM-9XII",
	wsTypeOfWeapon 	= {wsType_Weapon,wsType_Missile,wsType_AA_Missile,WSTYPE_PLACEHOLDER},
    Escort = 0,
    Head_Type = 1,   
	sigma = {1, 1, 1},
    M = 84.46,
    H_max = 18000.0,
    H_min = -1,
    Diam = 127.0,
    Cx_pil = AIM_9_CX_PIL,
    D_max = 20000.0,
    D_min = 50.0,
    Head_Form = 0,
    Life_Time = 80.0,
    Nr_max = 70,
    v_min = 100.0,
    v_mid = 750.0,
    Mach_max = 3.1,
    t_b = 0.0,
    t_acc = 6.0,
    t_marsh = 0.0,
    Range_max = 29000.0,
    H_min_t = 1.0,
    Fi_start = 3.14152,
    Fi_rak = 3.14152,
    Fi_excort = 2.50,
    Fi_search = 2.0,
    OmViz_max = 1.10,
    warhead = predefined_warhead("AIM_9"),
    exhaust = { 0.7, 0.7, 0.7, 0.08 },
	smoke_opacity_type = 1,
    X_back = -1.6,
    Y_back = 0.0,
    Z_back = 0.0,
    Reflection = 0.03,
    KillDistance = 9.0,

	SeekerGen = 4,  
	SeekerSensivityDistance = 29000, 
	ccm_k0 = 0.001,  
	SeekerCooled = true,
	x_wing_anim = -1,
	PN_gain = 6,
	SeekerGen = 4,

	shape_table_data =
	{
		{
			name	 = "AIM9X_BLKII",
			file	 = "aim-9x",
			life	 = 1,
			fire	 = { 0, 1},
			username = "AIM9X-BLKII",
			index 	 = WSTYPE_PLACEHOLDER,
		},
	},
	
	supersonic_A_coef_skew = 0.3, 
	nozzle_exit_area =	0.0068, 

	ModelData = {58,  --MODEL PARAMETERS
		0.35,   
		
		-- Drag (Сx) 
		0.04, 
		0.08, 
		0.02,
		0.05, 
		1.2,  
		1.0, --Additional g’s due to thrust vectoring/rocket motors 
		
		-- Lift (Cy) 
		1.2, 
		0.8, 
		1.0,  
		
		0.5, 
		2.0, 
		
		--ENGINE DATA, VALUES FOR TIME, FUEL FLOW AND THRUST
		--t_statr		t_b		t_accel		t_march		t_inertial		t_break		t_end	 -- Stage
		-1.0,		   -1.0,	8.0,  		0.0,		0.0,			0.0,		1.0e9,   -- time of stage in sec
		0.0,		    0.0,	6.0,		0.0,		0.0,			0.0,		0.0,     -- fuel flow rate in second, kg/sec
		0.0,		    0.0,	14802.0,	0.0,	    0.0,			0.0,		0.0,     -- thrust in newtons
		
		1.0e9, 
		80.0, --LIFETIME (FM)
		0, 
		0.45, 
		1.0e9, 
		1.0e9, 
		0.0, 
		30.0, 
		0.0, 
		2.2, 
		1.0, 
		1.0, 
		--DLZ--LAUNCH PAARAMETER TABLE==
		9.0,
		-13.0, 
		-2.1, 
		16500.0,  --HEAD ON,     5000  (M) ALTITUDE AT 900 (KPH)
		6500.0,   --TAIL CHASE,  5000  (M) ALTITUDE AT 900 (KPH)
		29000.0,  --HEAD ON,     10000 (M) ALTITUDE AT 900 (KPH) 
		12000.0,  --TAIL CHASE,  10000 (M) ALTITUDE AT 900 (KPH)
		11500.0,  --HEAD ON,     1000  (M) ALTITUDE AT 900 (KPH)
		3500.0,   --TAIL CHASE,  1000  (M) ALTITUDE AT 900 (KPH)
		2500.0, 
		0.55, 
		-0.01, 
		0.5, 
	},	
}

declare_weapon(AIM9X_BLKII)

declare_loadout(
	{		
		category		= CAT_AIR_TO_AIR,
		CLSID			= "{AIM9X-BLKII}",
		attribute		= {wsType_Weapon, wsType_Missile, wsType_Container, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon	= AIM9X_BLKII.wsTypeOfWeapon,
		Count			= 1,
		Picture			= "AIM-9XX.png",
		displayName		= _("AIM9X-BLKII Sidewinder IR AAM"),
		Weight			= 85.5,
		Elements		={
			[1] =
			{
				DrawArgs	=	
				{
					[1]	=	{1,	1},
					[2]	=	{2,	1},
				},
				Position	=	{0,	0,	0},
				ShapeName	=	"aim-9x",
			},
		},
})

declare_loadout({
    category        = CAT_AIR_TO_AIR,
    CLSID           = "{LAU_115_2xAIM9X-II}",
	wsTypeOfWeapon	= AIM9X_BLKII.wsTypeOfWeapon,
	attribute		= {4,4,32,WSTYPE_PLACEHOLDER},	
    Count           = 2,
    Picture         = "AIM-9XX.png",
    displayName     = _("2x AIM9X-BLKII Sidewinder IR AAM"),
    Weight          = 85.5 * 2 + 50,
	Elements = {
	
		{
			ShapeName	=	"LAU-115C+2_LAU127",
			IsAdapter = true,
		},
		
		{
			DrawArgs = {[1] = {1,1},[2] = {2,1},},
			Position	=	{0.5,	-0.06,	0.22},
			ShapeName	=	"aim-9x",
			Rotation = {-90,0,0},
		},
		
		{
			DrawArgs = {[1] = {1,1},[2] = {2,1},},
			Position	=	{0.5,	-0.06,	-0.22},
			ShapeName	=	"aim-9x",
			Rotation = {90,0,0},
		},
		
	},
    
    JettisonSubmunitionOnly = false,
})
