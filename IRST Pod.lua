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

local declare_pod = function (tbl)
	tbl.category = CAT_PODS
	if	tbl.ShapeName then 
		tbl.Elements = {{ ShapeName = tbl.ShapeName}}
	end
	declare_loadout(tbl)
end

declare_pod({
	CLSID			= "{F22_IRST}",
	Picture			= "F22_Sensor_Pod.png",
	attribute		= {4,	15,	45,	WSTYPE_PLACEHOLDER},
    Count           = 2,	
	Weight			= 0,
	Cx_pil			= 0.00070256637315,
	displayName		= _("IRST Sensor Pod"),
	shape_table_data =
	{
		{
			file	= "F22_IRST";
			life = 1,
			fire = { 0, 1},
			username	= "F22_IRST";
			index = WSTYPE_PLACEHOLDER,
		},
	},
	Elements = {
	
		{
			ShapeName	=	"null",
			IsAdapter = true,
		},
		
		{
			DrawArgs = {[1] = {1,1},[2] = {2,1},},
			Position	=	{0.170, 0.229, -8.94},
			ShapeName	=	"F22_IRST",
			Rotation = {0,0,0},
		},	
	},

	Sensors	 = 
	{
		IRST  = {"IRST-21"}		
	}
})

