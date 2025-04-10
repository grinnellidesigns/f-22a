--[[
    Grinnelli Designs F-22A Raptor
    Copyright (C) 2024, Joseph Grinnelli
    
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

	Copyright (c) 2025: Branden Hooper
	Changes:
	Removed AIM-120C and added Meteor and AIM-260
	
--]]

local unitPayloads = {
	["name"] = "F-22A",
	["payloads"] = {
		[1] = {
			["name"] = "Stealthy Air-to-Air | AIM-260 x6  AIM-9X x2",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}", --AIM-9x
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}", --AIM-9x
					["num"] = 11,
				},
				[3] = {
					["CLSID"] = "{AIM260-JATM}", --AIM-120C
					["num"] = 3,
				},
				[4] = {
					["CLSID"] = "{AIM260-JATM}", --AIM-120C
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{AIM260-JATM}", --AIM-120C
					["num"] = 5,
				},
				[6] = {
					["CLSID"] = "{AIM260-JATM}", --AIM-120C
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{AIM260-JATM}", --AIM-120C
					["num"] = 8,
				},
				[8] = {
					["CLSID"] = "{AIM260-JATM}", --AIM-120C
					["num"] = 9,
				},
				[9] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[10] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},	
			},
			["tasks"] = {
				[1] = 10,
				[2] = 11,
				[3] = 18,
				[4] = 19,
				[5] = 15,
			},
		},
		[2] = {
			["name"] = "Clean",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},	
			},
			["tasks"] = {
				[1] = 10,
				[2] = 11,
				[3] = 18,
				[4] = 19,
				[5] = 15,
			},
		},
		
		[3] = {
			["name"] = "Ferry Configuration",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}", --External Tank Left
					["num"] = 2,
				},
				[2] = {
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}", --External Tank Right
					["num"] = 10,
				},
			},
			["tasks"] = {
				[1] = 10,
				[2] = 11,
				[3] = 18,
				[4] = 19,
				[5] = 15,
			},
		},
		[4] = {
			["name"] = "Airshow Smoke (fictional)",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{A4BCC903-06C8-47bb-9937-A30FEDB4E744}",--Smoke White
					["num"] = 6,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},	
			},
			["tasks"] = {
				[1] = 10,
				[2] = 11,
				[3] = 18,
				[4] = 19,
				[5] = 15,
			},
		},
	},
	["tasks"] = {
		
	},
	["unitType"] = "F-22A",
}
return unitPayloads