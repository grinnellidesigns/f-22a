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

	Copyright (c) 2025: Ash Blythe	
--]]


local unitPayloads = {
	["name"] = "F-22A",
	["payloads"] = {
		[1] = {
			["displayName"] = "01) BFM",
			["name"] = "01) BFM",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[4] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 11,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[2] = {
			["displayName"] = "02) 2xAIM9X BLK II, 6xAIM-260",
			["name"] = "02) 2xAIM9X BLK II, 6xAIM-260",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{AIM-260A}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[3] = {
			["displayName"] = "03) 2xAIM9X BLK II, 6xAIM-260, IRST POD",
			["name"] = "03) 2xAIM9X BLK II, 6xAIM-260, IRST POD",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{AIM-260A}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 5,
				},
				[11] = {
					["CLSID"] = "{F22_IRST}",
					["num"] = 6,
				},				
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[4] = {
			["displayName"] = "04) 2xAIM9X BLK II, 6xAIM-260, IRST POD, VLO TANK",
			["name"] = "04) 2xAIM9X BLK II, 6xAIM-260, IRST POD, VLO TANK",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
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
					["CLSID"] = "{AIM-260A}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 5,
				},
				[11] = {
					["CLSID"] = "{F22_IRST}",
					["num"] = 6,
				},				
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[5] = {
			["displayName"] = "05) 2xAIM9X BLK II, 6xAIM-120D3",
			["name"] = "05) 2xAIM9X BLK II, 6xAIM-120D3",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
			["displayName"] = "06) 2xAIM9X BLK II, 6xAIM-120D3, IRST POD",
			["name"] = "06) 2xAIM9X BLK II, 6xAIM-120D3, IRST POD",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
				[11] = {
					["CLSID"] = "{F22_IRST}",
					["num"] = 6,
				},				
			},
			["tasks"] = {
				[1] = 11,
			},
		},		
		[7] = {
			["displayName"] = "07) 2xAIM9X BLK II, 6xAIM-120D3, IRST POD, VLO TANK",
			["name"] = "07) 2xAIM9X BLK II, 6xAIM-120D3, IRST POD, VLO TANK",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
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
				[11] = {
					["CLSID"] = "{F22_IRST}",
					["num"] = 6,
				},				
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[8] = {
			["displayName"] = "08) 2xAIM9X BLK II, 4xAIM-260, 2xMAKO",
			["name"] = "08) 2xAIM9X BLK II, 4xAIM-260, 2xMAKO",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{AIM-260A}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},
		[9] = {
			["displayName"] = "09) 2xAIM9X BLK II, 4xAIM-260, 2xMAKO, IRST POD",
			["name"] = "09) 2xAIM9X BLK II, 4xAIM-260, 2xMAKO, IRST POD",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{AIM-260A}",
					["num"] = 9,
				},
				[6] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 8,
				},
				[7] = {
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 4,
				},
				[9] = {
					["CLSID"] = "{AIM-260A}",
					["num"] = 3,
				},
				[10] = {
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 5,
				},
				[11] = {
					["CLSID"] = "{F22_IRST}",
					["num"] = 6,
				},				
			},
			["tasks"] = {
				[1] = 11,
			},
		},		
		[10] = {
			["displayName"] = "10) 2xAIM9X BLK II, 4xAIM-120D3, 2xMAKO",
			["name"] = "10) 2xAIM9X BLK II, 4xAIM-120D3, 2xMAKO",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{MAKO_A2A_C}",
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
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},	
		[11] = {
			["displayName"] = "11) 2xAIM9X BLK II, 4xAIM-120D3, 2xMAKO, IRST POD",
			["name"] = "11) 2xAIM9X BLK II, 4xAIM-120D3, 2xMAKO, IRST POD",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{MAKO_A2A_C}",
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
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 5,
				},
				[11] = {
					["CLSID"] = "{F22_IRST}",
					["num"] = 6,
				},				
			},
			["tasks"] = {
				[1] = 11,
			},
		},		
		[12] = {
			["displayName"] = "12) 2xAIM9X BLK II, 4xMAKO",
			["name"] = "12) 2xAIM9X BLK II, 4xMAKO",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 8,
				},
				[6] = {
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 7,
				},
				[7] = {
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 4,
				},
				[8] = {
					["CLSID"] = "{MAKO_A2A_C}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},	
		[13] = {
			["displayName"] = "13) FERRY CONFIG VLO TANK",
			["name"] = "13) FERRY CONFIG VLO TANK",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
					["num"] = 2,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},		
		[14] = {
			["displayName"] = "14) FERRY CONFIG VLO TANK, IRST POD",
			["name"] = "14) FERRY CONFIG VLO TANK, IRST POD",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "{LDTP_FUEL_Tank}",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{IRST_SENSOR_Pod}",
					["num"] = 8,
				},
				[4] = {
					["CLSID"] = "{IRST_SENSOR_Pod}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{F22_IRST}",
					["num"] = 6,
				},				
			},
			["tasks"] = {
				[1] = 11,
			},
		},	
		[15] = {
			["displayName"] = "15) 2xAIM9M, 6xAIM-120B",
			["name"] = "15) 2xAIM9M, 6xAIM-120B",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
		[16] = {
			["displayName"] = "16) 2xAIM9X, 6xAIM-120C",
			["name"] = "16) 2xAIM9X, 6xAIM-120C",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},	
		[17] = {
			["displayName"] = "17) 2xAIM9X BLK II, 6xAIM-120C7",
			["name"] = "17) 2xAIM9X BLK II, 6xAIM-120C7",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
		[18] = {
			["displayName"] = "18) 2xAIM9X BLK II, 6xAIM-120C8",
			["name"] = "18) 2xAIM9X BLK II, 6xAIM-120C8",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
		[19] = {
			["displayName"] = "19) EXT PYLON",
			["name"] = "19) EXT PYLON",
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
		[20] = {
			["displayName"] = "20) FERRY",
			["name"] = "20) FERRY",
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
		[21] = {
			["displayName"] = "21) Airshow Configuration",
			["name"] = "21) Airshow Configuration",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{INV-SMOKE-WHITE}",
					["num"] = 6,
				},
			},
			["tasks"] = {
				[1] = 11,
			},
		},	
		[22] = {
			["displayName"] = "01) 2xGBU-32_JDAM, 2xAIM-120D3, 2xAIM9X BLK II",
			["name"] = "01) 2xGBU-32_JDAM, 2xAIM-120D3, 2xAIM9X BLK II",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 11,
				},
				[7] = {
					["CLSID"] = "{GBU32_JDAM}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{GBU32_JDAM}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 32,
			},
		},
		[23] = {
			["displayName"] = "02) 2xMako ARM, 4xAIM-120D3, 2xAIM9X BLK II",
			["name"] = "02) 2xMako ARM, 4xAIM-120D3, 2xAIM9X BLK II",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 2,
				},
				[3] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 9,
				},
				[4] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 3,
				},
				[5] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 1,
				},
				[6] = {
					["CLSID"] = "{AIM9X-BLKII}",
					["num"] = 11,
				},
				[7] = {
					["CLSID"] = "{MAKO_A2G_C}",
					["num"] = 7,
				},
				[8] = {
					["CLSID"] = "{MAKO_A2G_C}",
					["num"] = 5,
				},
				[9] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 8,
				},
				[10] = {
					["CLSID"] = "{AIM-120D-3}",
					["num"] = 4,
				},
			},
			["tasks"] = {
				[1] = 32,
			},
		},
		[24] = {
			["displayName"] = "03) 4xMako ARM, 2xAIM9X BLK II",
			["name"] = "03) 4xMako ARM, 2xAIM9X BLK II",
			["pylons"] = {
				[1] = {
					["CLSID"] = "<CLEAN>",
					["num"] = 10,
				},
				[2] = {
					["CLSID"] = "<CLEAN>",
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
					["CLSID"] = "{MAKO_A2G_C}",
					["num"] = 7,
				},
				[6] = {
					["CLSID"] = "{MAKO_A2G_C}",
					["num"] = 5,
				},
				[7] = {
					["CLSID"] = "{MAKO_A2G_C}",
					["num"] = 8,
				},
				[8] = {
					["CLSID"] = "{MAKO_A2G_C}",
					["num"] = 4,
				},
			},
			["tasks"] = {
				[1] = 32,
			},
		},
	},
	["tasks"] = {
	},
	["unitType"] = "F-22A",
}
return unitPayloads		
