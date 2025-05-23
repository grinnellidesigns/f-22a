--[[
    Grinnelli Designs F-22A Raptor
    Copyright (C) 2025, "David McMasters"
    
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

local GALLON_TO_KG = 3.785 * 0.81482

declare_loadout({
    category		= CAT_FUEL_TANKS,
    CLSID			= "{LDTP_FUEL_Tank}",
	attribute		=  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
	Picture			= "F22_LDTP.png",
    Weight_Empty	= 180,
	Weight			= 180 + 605 * GALLON_TO_KG,
	Cx_pil			= 0,
	displayName		= _("LDTP Fuel tank 600 gal"),
	

		shape_table_data = 
		{
			{
				name 	= "LDTP_FUEL_Tank",
				file	= "F22_LDTP";
				life	= 1;
				fire	= { 0, 1};
				username	= "LDTP_FUEL_Tank";
				index	= WSTYPE_PLACEHOLDER;
			},
		},


		Elements	=	
				{
					{
						Position	=	{0.0,	0.0,	0.0},
						ShapeName	=	"F22_LDTP",
					}, 
				},

	}
)