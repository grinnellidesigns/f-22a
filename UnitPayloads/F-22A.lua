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


local unitPayloads = {
	["name"] = "F-22A",
	["payloads"] = {
		[1] = {
			["displayName"] = "01)  2xAIM9M, 6xAIM-120B",
			["name"] = "01)  2xAIM9M, 6xAIM-120B",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					["num"] = 11,
				},
				[5] = {
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[2] = {
			["displayName"] = "02)  2xAIM9X, 6xAIM-120C",
			["name"] = "02)  2xAIM9X, 6xAIM-120C",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
					["num"] = 1,
				},
				[3] = {
					["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",
					["num"] = 11,
				},
				[4] = {
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					["num"] = 9,
				},
				[5] = {
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					["num"] = 3,
				},
				[9] = {
					["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					["num"] = 5,
				},
				[10] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 2,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[3] = {
			["displayName"] = "03)  2xAIM9X BLK II, 6xAIM-120C7",
			["name"] = "03)  2xAIM9X BLK II, 6xAIM-120C7",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 11,
				},
				[5] = {
					["CLSID"] = "{AIM-120C-7}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-120C-7}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{AIM-120C-7}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-120C-7}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-120C-7}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{AIM-120C-7}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[4] = {
			["displayName"] = "04)  2xAIM9X BLK II, 6xAIM-120C8",
			["name"] = "04)  2xAIM9X BLK II, 6xAIM-120C8",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 11,
				},
				[5] = {
					["CLSID"] = "{AIM-120C-8}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-120C-8}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{AIM-120C-8}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-120C-8}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-120C-8}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{AIM-120C-8}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[5] = {
			["displayName"] = "05)  2xAIM9X BLK II, 6xAIM-120D3",
			["name"] = "05)  2xAIM9X BLK II, 6xAIM-120D3",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 1,
				},
				[4] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 11,
				},
				[5] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[6] = {
			["displayName"] = "06)  External Pylon Configuration",
			["name"] = "08)  External Pylon Configuration",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{LAU_115_2xAIM-120D-3}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LAU_115_2xAIM-120D-3}",
					["num"] = 2,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},		
		[7] = {
			["displayName"] = "07)  Ferry Configuration",
			["name"] = "09)  Ferry Configuration",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					["num"] = 2,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[8] = {
			["displayName"] = "08)  Airshow Configuration",
			["name"] = "10)  Airshow Configuration",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{<CLEAN>}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{A4BCC903-06C8-47bb-9937-A30FEDB4E744}",
					["num"] = 6,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
	},
	["tasks"] = {
	},
	["unitType"] = "F-22A",
}
return unitPayloads		
