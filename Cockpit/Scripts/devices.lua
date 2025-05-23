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
--]]


local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID-------
devices = {}
devices["AVIONICS"]				= counter()--01
devices["ELECTRICAL_SYSTEM"]	= counter()--02
devices["ENGINE_SYSTEM"]		= counter()--03
devices["WEAPON_SYSTEM"]		= counter()--04
devices["MFD_SYSTEM"]			= counter()--05
devices["PMFD_SYSTEM"]			= counter()--06
devices["ICP_SYSTEM"]			= counter()--07
--devices["FCS"]		  			= counter()--08
