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
	
--]]

--[[
To do: had to copy all input lua file data from DCS install lua files. Adding any custom command/keybinds broke many axis/keybinds in the original file.
]]

local kneeboard_id = 100
if devices and devices.KNEEBOARD then
	kneeboard_id = devices.KNEEBOARD
end


local SelectLeft    = 10000
local SelectRight   = 10001
local SelectCenter  = 10002
local SelectAll     = 10003
local SelectStep    = 10004
local Dogfight      = 10005
local AirORIDE      = 10006
local MasterArm     = 10007
local MasterArm_T   = 10008
local Battery       = 10009
local Battery_T     = 10010
local L_GEN         = 10011
local L_GEN_T       = 10012
local R_GEN         = 10013
local R_GEN_T       = 10014
local AAR           = 10015
local AAR_T         = 10016
local DayNight      = 10017
local DayNight_T    = 10018
local Park          = 10019
local Park_T        = 10020
local Detent_F      = 10021
local Detent_S      = 10022
local Brakes        = 10023  
local AirORIDE_T    = 10024    
local APU           = 10025   
local PICKLE        = 10026
local SMFD_Swap     = 10027  
local L_cutoff      = 10028
local R_cutoff      = 10029  
local FCSCenter     = 10030
local FCSNoseUp     = 10031
local FCSNoseDn     = 10032
local FCSRel        = 10033
local FCSMode       = 10034
local FCSAOA        = 10035
local FCSG          = 10036
local FCSStep       = 10037
local BrakesON      = 10038
local BrakesOFF     = 10039
local FCSpitch      = 10040
local ICP_COM1      = 10041
local ICP_COM2      = 10042
local ICP_NAV       = 10043
local ICP_STPT      = 10044
local ICP_ALT       = 10045
local ICP_HUD       = 10046
local ICP_AP        = 10047
local ICP_OP1       = 10048
local ICP_OP2       = 10049
local ICP_OP3       = 10050
local ICP_OP4       = 10051
local ICP_OP5       = 10052
local ICP_OTHR      = 10053
local CLIPBOARD_L   = 10054
local CLIPBOARD_R   = 10055
local L_BRAKE       = 10056
local R_BRAKE       = 10057
--Left MFD
    local LMFD_OSB_01    = 10061
    local LMFD_OSB_02    = 10062
    local LMFD_OSB_03    = 10063
    local LMFD_OSB_04    = 10064
    local LMFD_OSB_05    = 10065
    local LMFD_OSB_06    = 10066
    local LMFD_OSB_07    = 10067
    local LMFD_OSB_08    = 10068
    local LMFD_OSB_09    = 10069
    local LMFD_OSB_10    = 10070
    local LMFD_OSB_11    = 10071
    local LMFD_OSB_12    = 10072
    local LMFD_OSB_13    = 10073
    local LMFD_OSB_14    = 10074
    local LMFD_OSB_15    = 10075
    local LMFD_OSB_16    = 10076
    local LMFD_OSB_17    = 10077
    local LMFD_OSB_18    = 10078
    local LMFD_OSB_19    = 10079
    local LMFD_OSB_20    = 10080
--Right MFD
    local RMFD_OSB_01    = 10091
    local RMFD_OSB_02    = 10092
    local RMFD_OSB_03    = 10093
    local RMFD_OSB_04    = 10094
    local RMFD_OSB_05    = 10095
    local RMFD_OSB_06    = 10096
    local RMFD_OSB_07    = 10097
    local RMFD_OSB_08    = 10098
    local RMFD_OSB_09    = 10099
    local RMFD_OSB_10    = 10100
    local RMFD_OSB_11    = 10101
    local RMFD_OSB_12    = 10102
    local RMFD_OSB_13    = 10103
    local RMFD_OSB_14    = 10104
    local RMFD_OSB_15    = 10105
    local RMFD_OSB_16    = 10106
    local RMFD_OSB_17    = 10107
    local RMFD_OSB_18    = 10108
    local RMFD_OSB_19    = 10109
    local RMFD_OSB_20    = 10110
--Center MFD
    local CMFD_OSB_01    = 10111
    local CMFD_OSB_02    = 10112
    local CMFD_OSB_03    = 10113
    local CMFD_OSB_04    = 10114
    local CMFD_OSB_05    = 10115
    local CMFD_OSB_06    = 10116
    local CMFD_OSB_07    = 10117
    local CMFD_OSB_08    = 10118
    local CMFD_OSB_09    = 10119
    local CMFD_OSB_10    = 10120
    local CMFD_OSB_11    = 10121
    local CMFD_OSB_12    = 10122
    local CMFD_OSB_13    = 10123
    local CMFD_OSB_14    = 10124
    local CMFD_OSB_15    = 10125
    local CMFD_OSB_16    = 10126
    local CMFD_OSB_17    = 10127
    local CMFD_OSB_18    = 10128
    local CMFD_OSB_19    = 10129
    local CMFD_OSB_20    = 10130
--PMFD
    local PMFD_OSB_01    = 10131
    local PMFD_OSB_02    = 10132
    local PMFD_OSB_03    = 10133
    local PMFD_OSB_04    = 10134
    local PMFD_OSB_05    = 10135
    local PMFD_OSB_06    = 10136
    local PMFD_OSB_07    = 10137
    local PMFD_OSB_08    = 10138
    local PMFD_OSB_09    = 10139
    local PMFD_OSB_10    = 10140
    local PMFD_OSB_11    = 10141
    local PMFD_OSB_12    = 10142
    local PMFD_OSB_13    = 10143
    local PMFD_OSB_14    = 10144
    local PMFD_OSB_15    = 10145
    local PMFD_OSB_16    = 10146
    local PMFD_OSB_17    = 10147
    local PMFD_OSB_18    = 10148
    local PMFD_OSB_19    = 10149
    local PMFD_OSB_20    = 10150

    local LIGHT_TAXI      = 10151
    local LIGHT_TAXI_T    = 10152
    local LIGHT_LANDING   = 10153
    local LIGHT_LANDING_T = 10154

return {

keyCommands = {

  
--SMFD Both    
    {down = SMFD_Swap,                  name = _('SMFD Page Swap'),                       category = _('F-22A Systems')},
--MFD LEFT
    {down = LMFD_OSB_01,                name = _('MFD Left OSB 1'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_02,                name = _('MFD Left OSB 2'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_03,                name = _('MFD Left OSB 3'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_04,                name = _('MFD Left OSB 4'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_05,                name = _('MFD Left OSB 5'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_06,                name = _('MFD Left OSB 6'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_07,                name = _('MFD Left OSB 7'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_08,                name = _('MFD Left OSB 8'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_09,                name = _('MFD Left OSB 9'),                       category = _('F-22A MFD Left')},
    {down = LMFD_OSB_10,                name = _('MFD Left OSB 10'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_11,                name = _('MFD Left OSB 11'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_12,                name = _('MFD Left OSB 12'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_13,                name = _('MFD Left OSB 13'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_14,                name = _('MFD Left OSB 14'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_15,                name = _('MFD Left OSB 15'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_16,                name = _('MFD Left OSB 16'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_17,                name = _('MFD Left OSB 17'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_18,                name = _('MFD Left OSB 18'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_19,                name = _('MFD Left OSB 19'),                      category = _('F-22A MFD Left')},
    {down = LMFD_OSB_20,                name = _('MFD Left OSB 20'),                      category = _('F-22A MFD Left')},
--MFD RIGHT
    {down = RMFD_OSB_01,                name = _('MFD Right OSB 1'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_02,                name = _('MFD Right OSB 2'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_03,                name = _('MFD Right OSB 3'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_04,                name = _('MFD Right OSB 4'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_05,                name = _('MFD Right OSB 5'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_06,                name = _('MFD Right OSB 6'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_07,                name = _('MFD Right OSB 7'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_08,                name = _('MFD Right OSB 8'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_09,                name = _('MFD Right OSB 9'),                      category = _('F-22A MFD Right')},
    {down = RMFD_OSB_10,                name = _('MFD Right OSB 10'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_11,                name = _('MFD Right OSB 11'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_12,                name = _('MFD Right OSB 12'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_13,                name = _('MFD Right OSB 13'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_14,                name = _('MFD Right OSB 14'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_15,                name = _('MFD Right OSB 15'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_16,                name = _('MFD Right OSB 16'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_17,                name = _('MFD Right OSB 17'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_18,                name = _('MFD Right OSB 18'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_19,                name = _('MFD Right OSB 19'),                     category = _('F-22A MFD Right')},
    {down = RMFD_OSB_20,                name = _('MFD Right OSB 20'),                     category = _('F-22A MFD Right')},
--MFD RIGHT
    {down = CMFD_OSB_01,                name = _('MFD Center OSB 1'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_02,                name = _('MFD Center OSB 2'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_03,                name = _('MFD Center OSB 3'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_04,                name = _('MFD Center OSB 4'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_05,                name = _('MFD Center OSB 5'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_06,                name = _('MFD Center OSB 6'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_07,                name = _('MFD Center OSB 7'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_08,                name = _('MFD Center OSB 8'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_09,                name = _('MFD Center OSB 9'),                     category = _('F-22A MFD Center')},
    {down = CMFD_OSB_10,                name = _('MFD Center OSB 10'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_11,                name = _('MFD Center OSB 11'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_12,                name = _('MFD Center OSB 12'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_13,                name = _('MFD Center OSB 13'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_14,                name = _('MFD Center OSB 14'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_15,                name = _('MFD Center OSB 15'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_16,                name = _('MFD Center OSB 16'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_17,                name = _('MFD Center OSB 17'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_18,                name = _('MFD Center OSB 18'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_19,                name = _('MFD Center OSB 19'),                    category = _('F-22A MFD Center')},
    {down = CMFD_OSB_20,                name = _('MFD Center OSB 20'),                    category = _('F-22A MFD Center')},
--PMFD
    {down = PMFD_OSB_01,                name = _('PMFD OSB 1'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_02,                name = _('PMFD OSB 2'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_03,                name = _('PMFD OSB 3'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_04,                name = _('PMFD OSB 4'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_05,                name = _('PMFD OSB 5'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_06,                name = _('PMFD OSB 6'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_07,                name = _('PMFD OSB 7'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_08,                name = _('PMFD OSB 8'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_09,                name = _('PMFD OSB 9'),                           category = _('F-22A PMFD')},
    {down = PMFD_OSB_10,                name = _('PMFD OSB 10'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_11,                name = _('PMFD OSB 11'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_12,                name = _('PMFD OSB 12'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_13,                name = _('PMFD OSB 13'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_14,                name = _('PMFD OSB 14'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_15,                name = _('PMFD OSB 15'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_16,                name = _('PMFD OSB 16'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_17,                name = _('PMFD OSB 17'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_18,                name = _('PMFD OSB 18'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_19,                name = _('PMFD OSB 19'),                          category = _('F-22A PMFD')},
    {down = PMFD_OSB_20,                name = _('PMFD OSB 20'),                          category = _('F-22A PMFD')}, 
--CLIPBOARD BINDS
    {down = CLIPBOARD_L,                name = _('Clipboard Left Show/Hide'),            category = _('F-22A Systems')},
    {down = CLIPBOARD_R,                name = _('Clipboard Right Show/Hide'),           category = _('F-22A Systems')},    
--F-22 Weapons
    {down = Detent_F, up = Detent_F,    name = _('Weapons: Trigger First Detent'),       category = _('F-22A HOTAS')},
    {down = Detent_S, up = Detent_S,    name = _('Weapons: Trigger Second Detent'),      category = _('F-22A HOTAS')},
    {down = PICKLE, up = PICKLE,        name = _('Weapons: Release'),                    category = _('F-22A HOTAS')},
--ICP BINDS
    {down = ICP_COM1,                   name = _('ICP COMM 1'),                          category = _('F-22A ICP')},
    {down = ICP_COM2,                   name = _('ICP COMM 2'),                          category = _('F-22A ICP')},
    {down = ICP_NAV,                    name = _('ICP NAV'),                             category = _('F-22A ICP')},
    {down = ICP_STPT,                   name = _('ICP STPT'),                            category = _('F-22A ICP')},
    {down = ICP_ALT,                    name = _('ICP ALT'),                             category = _('F-22A ICP')},
    {down = ICP_HUD,                    name = _('ICP HUD'),                             category = _('F-22A ICP')},
    {down = ICP_AP,                     name = _('ICP AP'),                              category = _('F-22A ICP')},
    {down = ICP_OTHR,                   name = _('ICP OTHR'),                            category = _('F-22A ICP')},
    {down = ICP_OP1,                    name = _('ICP Option 1'),                        category = _('F-22A ICP')},
    {down = ICP_OP2,                    name = _('ICP Option 2'),                        category = _('F-22A ICP')},
    {down = ICP_OP3,                    name = _('ICP Option 3'),                        category = _('F-22A ICP')},
    {down = ICP_OP4,                    name = _('ICP Option 4'),                        category = _('F-22A ICP')},
    {down = ICP_OP5,                    name = _('ICP Option 5'),                        category = _('F-22A ICP')},
--F-22 CUSTOM BINDS
    {down = SelectLeft,                 name = _('Weapon Bay Select Left'),             category = _('F-22A HOTAS')},
    {down = SelectRight,                name = _('Weapon Bay Select Right'),            category = _('F-22A HOTAS')},
    {down = SelectCenter,               name = _('Weapon Bay Select Center'),           category = _('F-22A HOTAS')},
    {down = SelectAll,                  name = _('Weapon Bay Select All'),              category = _('F-22A HOTAS')},
    {down = SelectStep,                 name = _('Weapon Bay Select Toggle'),           category = _('F-22A HOTAS')},
    {down = AirORIDE, up = AirORIDE,    name = _('Weapon Bay Override (AIR)'),          category = _('F-22A HOTAS')},
    {down = AirORIDE_T,                 name = _('Weapon Bay Override Toggle (AIR)'),   category = _('F-22A HOTAS')},
    {down = Dogfight,                   name = _('Dogfight MFD Override'),              category = _('F-22A HOTAS')},
    {down = APU, up = APU,              name = _('APU Start'),                          category = _('F-22A HOTAS')},

    {down = L_cutoff, up = L_cutoff,   name = _('Throttle (Left) - OFF/IDLE'),          category = _('F-22A HOTAS')},
    {down = R_cutoff, up = R_cutoff,   name = _('Throttle (Right) - OFF/IDLE'),         category = _('F-22A HOTAS')},
--Special Switch Functionality
    {down = Battery, up = Battery,      name = _('Battery On/Off'),                     category = _('F-22A Systems')},
    {down = Battery_T,                  name = _('Battery Toggle'),                     category = _('F-22A Systems')},
    {down = MasterArm, up = MasterArm,  name = _('Master Arm On/Off'),                  category = _('F-22A Systems')},
    {down = MasterArm_T,                name = _('Master Arm Toggle'),                  category = _('F-22A Systems')},
    {down = DayNight, up = DayNight,    name = _('Day/Night Mode'),                     category = _('F-22A Systems')},
    {down = DayNight_T,                 name = _('Day/Night Mode Toggle'),              category = _('F-22A Systems')},
    {down = L_GEN, up = L_GEN,          name = _('Left Generator On/Off'),              category = _('F-22A Systems')},
    {down = L_GEN_T,                    name = _('Left Generator Toggle'),              category = _('F-22A Systems')},
    {down = R_GEN, up = R_GEN,          name = _('Right Generator On/Off'),             category = _('F-22A Systems')},
    {down = R_GEN_T,                    name = _('Right Generator Toggle'),             category = _('F-22A Systems')},
    {down = AAR,   up = AAR,            name = _('Air-Air Refuel Open/Close'),          category = _('F-22A Systems')},
    {down = AAR_T,                      name = _('Air-Air Refuel Toggle'),              category = _('F-22A Systems')},
    {down = Park, up = Park,            name = _('Parking Brake On/Off'),               category = _('F-22A Systems')},
    {down = Park_T,                     name = _('Parking Brake Toggle'),               category = _('F-22A Systems')},
    {down = LIGHT_TAXI, up = LIGHT_TAXI,        name = _('Taxi Light On/Off'),          category = _('F-22A Systems')},   
    {down = LIGHT_TAXI_T,               name = _('Taxi Light Toggle'),                  category = _('F-22A Systems')},
    {down = LIGHT_LANDING, up = LIGHT_LANDING,  name = _('Landing Light On/Off'),       category = _('F-22A Systems')},   
    {down = LIGHT_LANDING_T,            name = _('Landing Light Toggle'),               category = _('F-22A Systems')}, 

    {down = BrakesON, up = BrakesOFF,   name = _('Wheel Brakes Both'), 	                category = _('F-22A Systems')},
    {down = L_BRAKE,  up = BrakesOFF,   name = _('Wheel Brakes Left'),                  category = _('F-22A Systems')},
    {down = R_BRAKE,  up = BrakesOFF,   name = _('Wheel Brakes Right'),                 category = _('F-22A Systems')},
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Autopilot
    {combos = {{key = 'A'}, {key = '1', reformers = {'LAlt'}}}, down = iCommandPlaneAutopilot,  name = _('Autopilot - Attitude Hold'),  category = _('Autopilot')},
    {combos = {{key = 'H'}, {key = '2', reformers = {'LAlt'}}}, down = iCommandPlaneStabHbar,   name = _('Autopilot - Altitude Hold'),  category = _('Autopilot')},
    {combos = {{key = '9', reformers = {'LAlt'}}},              down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'),        category = _('Autopilot')},    
--Flight Control
    {combos = {{key = 'T', reformers = {'LAlt'}}}, down = iCommandPlaneTrimOn, up = iCommandPlaneTrimOff, name = _('T/O Trim'), category = _('Flight Control')},

-- Systems
    {combos = {{key = 'R', reformers = {'LCtrl'}}},  down = iCommandPlaneAirRefuel,                                                                                 name = _('Refueling Boom'),                      category = _('Systems')},
    {combos = {{key = 'R', reformers = {'LAlt'}}},   down = iCommandPlaneJettisonFuelTanks,                                                                         name = _('Jettison Fuel Tanks'),                 category = _('Systems')},
    {combos = {{key = 'S'}},                         down = iCommandPlane_HOTAS_NoseWheelSteeringButton, up = iCommandPlane_HOTAS_NoseWheelSteeringButton,          name = _('Nose Gear Maneuvering Range'),         category = _('Systems')},
    {combos = {{key = 'Q', reformers = {'LAlt'}}},   down = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, up = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff,    name = _('Nose Wheel Steering'),                 category = _('Systems')},
    {combos = {{key = 'A', reformers = {'LCtrl'}}},  down = iCommandPlaneWheelBrakeLeftOn, up = iCommandPlaneWheelBrakeLeftOff,                                     name = _('Wheel Brake Left On/Off'),             category = _('Systems')},
    {combos = {{key = 'A', reformers = {'LAlt'}}},   down = iCommandPlaneWheelBrakeRightOn, up = iCommandPlaneWheelBrakeRightOff,                                   name = _('Wheel Brake Right On/Off'),            category = _('Systems')},
	{combos = {{key = 'C', reformers = {'RCtrl'}}},	down = iCommandPlaneFonar, name = _('Canopy Open/Close'), category = _('Systems')},
-- Modes
    {combos = {{key = '2'}}, down = iCommandPlaneModeBVR,   name = _('(2) Beyond Visual Range Mode'),                       category = _('Modes')},
    {combos = {{key = '3'}}, down = iCommandPlaneModeVS,    name = _('(3) Close Air Combat Vertical Scan Mode'),            category = _('Modes')},
    {combos = {{key = '4'}}, down = iCommandPlaneModeBore,  name = _('(4) Close Air Combat Bore Mode'),                     category = _('Modes')},
    {combos = {{key = '6'}}, down = iCommandPlaneModeFI0,   name = _('(6) Longitudinal Missile Aiming Mode/FLOOD mode'),    category = _('Modes')},
-- Sensors
    {combos = {{key = 'Enter'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'),                           category = _('Sensors')},
    {combos = {{key = 'Back'}},  down = iCommandSensorReset,                                     name = _('Radar - Return To Search/NDTWS'),        category = _('Sensors')},
    {down = iCommandRefusalTWS,                                                                  name = _('Unlock TWS Target'),                     category = _('Sensors')},
    {combos = {{key = 'I'}}, down = iCommandPlaneRadarOnOff,                                     name = _('Radar On/Off'),                          category = _('Sensors')},
    {combos = {{key = 'I', reformers = {'RAlt'}}}, down = iCommandPlaneRadarChangeMode,          name = _('Radar RWS/TWS Mode Select'),             category = _('Sensors')},
    {combos = {{key = 'I', reformers = {'RCtrl'}}}, down = iCommandPlaneRadarCenter,             name = _('Target Designator To Center'),           category = _('Sensors')},
    {combos = {{key = 'I', reformers = {'RShift'}}}, down = iCommandPlaneChangeRadarPRF,         name = _('Radar Pulse Repeat Frequency Select'),   category = _('Sensors')},

    {combos = {{key = ';'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
    {combos = {{key = '.'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
    {combos = {{key = ','}}, pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
    {combos = {{key = '/'}}, pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},

    {combos = {{key = ';', reformers = {'RShift'}}}, pressed = iCommandSelecterUp,    up = iCommandSelecterStop, name = _('Scan Zone Up'),    category = _('Sensors')},
    {combos = {{key = '.', reformers = {'RShift'}}}, pressed = iCommandSelecterDown,  up = iCommandSelecterStop, name = _('Scan Zone Down'),  category = _('Sensors')},
    {combos = {{key = ',', reformers = {'RShift'}}}, pressed = iCommandSelecterLeft,  up = iCommandSelecterStop, name = _('Scan Zone Left'),  category = _('Sensors')},
    {combos = {{key = '/', reformers = {'RShift'}}}, pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},

    {combos = {{key = '='}}, down = iCommandPlaneZoomIn,  name = _('Display Zoom In'),  category = _('Sensors')},
    {combos = {{key = '-'}}, down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},

    {combos = {{key = '-', reformers = {'RCtrl'}}}, down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
    {combos = {{key = '=', reformers = {'RCtrl'}}}, down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},

    {combos = {{key = '=', reformers = {'RAlt'}}}, pressed = iCommandPlaneIncreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Increase'), category = _('Sensors')},
    {combos = {{key = '-', reformers = {'RAlt'}}}, pressed = iCommandPlaneDecreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Decrease'), category = _('Sensors')},

    {combos = {{key = 'R', reformers = {'RShift'}}}, down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
    {combos = {{key = ',', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
    {combos = {{key = '.', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},
-- Weapons                                                                        
    {combos = {{key = 'V', reformers = {'LCtrl'}}}, down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
    -- {combos = {{key = 'Space', reformers = {'RAlt'}}}, down = iCommandPlanePickleOn,	up = iCommandPlanePickleOff, name = _('Weapon Release'), category = _('Weapons')},
    {combos = {{key = 'C', reformers = {'LShift'}}}, down = iCommandChangeGunRateOfFire, name = _('Cannon Rate Of Fire / Cut Of Burst select'), category = _('Weapons')},

-- Debug
{combos = {{key = '`', reformers = {'LAlt'}}},		down = ICommandToggleConsole,	name = _('Toggle Console'),		category = _('Debug')},

-- General (Gameplay)
{combos = {{key = '\''}},										down = iCommandScoresWindowToggle,				name = _('Score window'),							category = _('General')},

{combos = {{key = 'Y',	 reformers = {'LCtrl'}}},				down = iCommandInfoOnOff,						name = _('Info bar view toggle'),					category = _('General')},
{combos = {{key = 'Tab', reformers = {'RCtrl', 'RShift'}}},		down = iCommandRecoverHuman,					name = _('Get new plane - respawn'),				category = _('General')},
{combos = {{key = 'J',	 reformers = {'RAlt'}}},				down = iCommandPlaneJump,						name = _('Jump into selected aircraft'),			category = _('General')},
{combos = {{key = 'Y',	 reformers = {'LAlt'}}},				down = iCommandViewCoordinatesInLinearUnits,	name = _('Info bar coordinate units toggle'),		category = _('General')},
{combos = {{key = 'C',	 reformers = {'LAlt'}}},				down = iCommandCockpitClickModeOnOff,			name = _('Clickable mouse cockpit mode On/Off'),	category = _('General')},
{combos = {{key = 'S',	 reformers = {'LCtrl'}}},				down = iCommandSoundOnOff,						name = _('Sound On/Off'),							category = _('General')},
{combos = {{key = '\'',	 reformers = {'LAlt'}}}, 				down = iCommandMissionResourcesManagement,		name = _('Rearming and Refueling Window'),			category = _('General')},
{combos = {{key = 'B',	 reformers = {'LAlt'}}},				down = iCommandViewBriefing,					name = _('View briefing on/off'),					category = _('General')},
{combos = {{key = 'Enter', reformers = {'RCtrl'}}},				down = iCommandPlane_ShowControls,				name = _('Show controls indicator'),				category = _('General')},

-- Communications
{combos = {{key = 'E', reformers = {'LWin'}}},					down = iCommandPlaneDoAndHome,					name = _('Flight - Complete mission and RTB'),		category = _('Communications')},
{																down = iCommandPlaneReturnToBase,				name = _('Flight - RTB'),							category = _('Communications')},
{combos = {{key = 'R', reformers = {'LWin'}}},					down = iCommandPlaneDoAndBack,					name = _('Flight - Complete mission and rejoin'),	category = _('Communications')},
{combos = {{key = 'T', reformers = {'LWin'}}},					down = iCommandPlaneFormation,					name = _('Toggle Formation'),						category = _('Communications')},
{combos = {{key = 'Y', reformers = {'LWin'}}},					down = iCommandPlaneJoinUp,						name = _('Join Up Formation'),						category = _('Communications')},
{combos = {{key = 'Q', reformers = {'LWin'}}},					down = iCommandPlaneAttackMyTarget,				name = _('Attack My Target'),						category = _('Communications')},
{combos = {{key = 'W', reformers = {'LWin'}}},					down = iCommandPlaneCoverMySix,					name = _('Cover Me'),								category = _('Communications')},
{combos = {{key = 'U', reformers = {'LWin'}}},					down = iCommandAWACSHomeBearing,				name = _('Request AWACS Home Airbase'),				category = _('Communications')},
{combos = {{key = 'O', reformers = {'LWin'}}},					down = iCommandAWACSBanditBearing,				name = _('Request AWACS Bogey Dope'),				category = _('Communications'), features = {"AWACS Bogey Dope"}},
{combos = {{key = 'G', reformers = {'LWin'}}},					down = iCommandPlane_EngageGroundTargets,		name = _('Flight - Attack ground targets'),			category = _('Communications')},
{combos = {{key = 'D', reformers = {'LWin'}}},					down = iCommandPlane_EngageAirDefenses,			name = _('Flight - Attack air defenses'),			category = _('Communications')},
{combos = {{key = 'B', reformers = {'LWin'}}},					down = iCommandPlane_EngageBandits,				name = _('Flight - Engage Bandits'),				category = _('Communications')},
{combos = defaultDeviceAssignmentFor("radio_menu"),										down = iCommandToggleCommandMenu,				name = _('Communication menu'),						category = _('Communications')},
{combos = {{key = '\\', reformers = {'LShift'}}},				down = ICommandSwitchDialog,					name = _('Switch dialog'),							category = _('Communications')},
{combos = {{key = '\\', reformers = {'LCtrl'}}},				down = ICommandSwitchToCommonDialog,			name = _('Switch to main menu'),					category = _('Communications')},

-- View
{combos = {{key = 'Num4'}},								pressed = iCommandViewLeftSlow,			up = iCommandViewStopSlow,				name = _('View Left slow'),										category = _('View')},
{combos = {{key = 'Num6'}},								pressed = iCommandViewRightSlow,		up = iCommandViewStopSlow,				name = _('View Right slow'),									category = _('View')},
{combos = {{key = 'Num8'}},								pressed = iCommandViewUpSlow,			up = iCommandViewStopSlow,				name = _('View Up slow'),										category = _('View')},
{combos = {{key = 'Num2'}},								pressed = iCommandViewDownSlow,			up = iCommandViewStopSlow,				name = _('View Down slow'),										category = _('View')},
{combos = {{key = 'Num9'}},								pressed = iCommandViewUpRightSlow,		up = iCommandViewStopSlow,				name = _('View Up Right slow'),									category = _('View')},
{combos = {{key = 'Num3'}},								pressed = iCommandViewDownRightSlow,	up = iCommandViewStopSlow,				name = _('View Down Right slow'),								category = _('View')},
{combos = {{key = 'Num1'}},								pressed = iCommandViewDownLeftSlow,		up = iCommandViewStopSlow,				name = _('View Down Left slow'),								category = _('View')},
{combos = {{key = 'Num7'}},								pressed = iCommandViewUpLeftSlow,		up = iCommandViewStopSlow,				name = _('View Up Left slow'),									category = _('View')},
{combos = {{key = 'Num5'}},								pressed = iCommandViewCenter,													name = _('View Center'),										category = _('View')},
{combos = {{key = 'Num5', reformers = {'RCtrl'}}},	down = iCommandViewCameraReturn, name = _('Return Camera'),	category = _('View')},
{combos = {{key = 'Num5', reformers = {'RAlt'}}},	down = iCommandViewCameraBaseReturn, name = _('Return Camera Base'), category = _('View')},
{combos = {{key = 'Num5', reformers = {'RShift'}}},	down = iCommandViewCameraCenter, name = _('Center Camera View'), category = _('View')},

{combos = {{key = 'Num*'}},								pressed = iCommandViewForwardSlow,		up = iCommandViewForwardSlowStop,		name = _('Zoom in slow'),										category = _('View')},
{combos = {{key = 'Num/'}},								pressed = iCommandViewBackSlow,			up = iCommandViewBackSlowStop,			name = _('Zoom out slow'),										category = _('View')},
{combos = {{key = 'NumEnter'}},							down = iCommandViewAngleDefault,												name = _('Zoom normal'),										category = _('View')},
{combos = {{key = 'Num*', reformers = {'RCtrl'}}},		pressed = iCommandViewExternalZoomIn,	up = iCommandViewExternalZoomInStop,	name = _('Zoom external in'),									category = _('View')},
{combos = {{key = 'Num/', reformers = {'RCtrl'}}},		pressed = iCommandViewExternalZoomOut,	up = iCommandViewExternalZoomOutStop,	name = _('Zoom external out'),									category = _('View')},
{combos = {{key = 'NumEnter', reformers = {'RCtrl'}}},	down = iCommandViewExternalZoomDefault,											name = _('Zoom external normal'),								category = _('View')},
{combos = {{key = 'Num*', reformers = {'LAlt'}}},		down = iCommandViewSpeedUp,														name = _('F11 Camera moving forward'),							category = _('View')},
{combos = {{key = 'Num/', reformers = {'LAlt'}}},		down = iCommandViewSlowDown,													name = _('F11 Camera moving backward'),							category = _('View')},

{combos = {{key = 'F1'}},								down = iCommandViewCockpit,														name = _('F1 Cockpit view'),									category = _('View')},
{combos = {{key = 'F1', reformers = {'LCtrl'}}},		down = iCommandNaturalViewCockpitIn,											name = _('F1 Natural head movement view'),						category = _('View')},
{combos = {{key = 'F1', reformers = {'LAlt'}}},			down = iCommandViewHUDOnlyOnOff,												name = _('F1 HUD only view switch'),							category = _('View')},
{combos = {{key = 'F2'}},								down = iCommandViewAir,															name = _('F2 Aircraft view'),									category = _('View')},
{combos = {{key = 'F2', reformers = {'LCtrl'}}},		down = iCommandViewMe,															name = _('F2 View own aircraft'),								category = _('View')},
{combos = {{key = 'F2', reformers = {'RAlt'}}},			down = iCommandViewFromTo,														name = _('F2 Toggle camera position'),							category = _('View')},
{combos = {{key = 'F2', reformers = {'LAlt'}}},			down = iCommandViewLocal,														name = _('F2 Toggle local camera control'),						category = _('View')},
{combos = {{key = 'F3'}},								down = iCommandViewTower,														name = _('F3 Fly-By view'),										category = _('View')},
{combos = {{key = 'F3', reformers = {'LCtrl'}}},		down = iCommandViewTowerJump,													name = _('F3 Fly-By jump view'),								category = _('View')},
{combos = {{key = 'F4'}},								down = iCommandViewRear,														name = _('F4 Camera mounted on object'),									category = _('View')},
{combos = {{key = 'F4', reformers = {'LCtrl'}}},		down = iCommandViewChase,														name = _('F4 Chase view'),										category = _('View')},
{combos = {{key = 'F4', reformers = {'LShift'}}},		down = iCommandViewChaseArcade,													name = _('F4 Arcade Chase view'),								category = _('View')},
{combos = {{key = 'F5'}},								down = iCommandViewFight,														name = _('F5 nearest AC view'),									category = _('View')},
{combos = {{key = 'F5', reformers = {'LCtrl'}}},		down = iCommandViewFightGround,													name = _('F5 Ground hostile view'),								category = _('View')},
{combos = {{key = 'F6'}},								down = iCommandViewWeapons,														name = _('F6 Released weapon view'),							category = _('View')},
{combos = {{key = 'F6', reformers = {'LCtrl'}}},		down = iCommandViewWeaponAndTarget,												name = _('F6 Weapon to target view'),							category = _('View')},
{combos = {{key = 'F7'}},								down = iCommandViewGround,														name = _('F7 Ground unit view'),								category = _('View')},
{combos = {{key = 'F9'}},								down = iCommandViewNavy,														name = _('F9 Ship view'),										category = _('View')},
{combos = {{key = 'F9', reformers = {'LAlt'}}},			down = iCommandViewLndgOfficer,													name = _('F9 Landing signal officer view'),						category = _('View')},
{combos = {{key = 'F10'}}, 								down = iCommandViewAWACS,														name = _('F10 Theater map view'),								category = _('View')},
{combos = {{key = 'F10', reformers = {'LCtrl'}}},		down = iCommandViewAWACSJump,													name = _('F10 Jump to theater map view over current point'),	category = _('View')},
{combos = {{key = 'F10', reformers = {'RShift'}}},		down = iCommandViewAWACSDialog,													name = _('Theater map dialog on/off'),	category = _('View')},
{combos = {{key = 'F11'}},								down = iCommandViewFree,														name = _('F11 Airport free camera'),							category = _('View')},
{combos = {{key = 'F11', reformers = {'LCtrl'}}},		down = iCommandViewFreeJump,													name = _('F11 Jump to free camera'),							category = _('View')},
{combos = {{key = 'F11', reformers = {'RAlt', 'RCtrl', 'RShift'}}},	down = iCommandViewCameraInputLayer,	name = _('Camera local input layer toggle'),	category = _('View')},
{combos = {{key = 'F12'}},								down = iCommandViewStatic,														name = _('F12 Static object view'),								category = _('View')},
{combos = {{key = 'F12', reformers = {'LCtrl'}}},		down = iCommandViewMirage,														name = _('F12 Civil traffic view'),								category = _('View')},
{combos = {{key = 'F12', reformers = {'LShift'}}},		down = iCommandViewLocomotivesToggle,											name = _('F12 Trains/cars toggle'),								category = _('View')},
{combos = {{key = 'F1', reformers = {'LWin'}}},			down = iCommandViewPitHeadOnOff,												name = _('F1 Head shift movement on / off'),					category = _('View')},

{combos = {{key = 'Num8', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltUpSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative up slow'), category = _('View')},
{combos = {{key = 'Num2', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltDownSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative down slow'), category = _('View')},
{combos = {{key = 'Num4', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltLeftSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative left slow'), category = _('View')},
{combos = {{key = 'Num6', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltRightSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative right slow'), category = _('View')},
{combos = {{key = 'Num9', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltUpRightSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative up right slow'), category = _('View')},
{combos = {{key = 'Num3', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltDownRightSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative down right slow'), category = _('View')},
{combos = {{key = 'Num1', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltDownLeftSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative down left slow'), category = _('View')},
{combos = {{key = 'Num7', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltUpLeftSlow, up = iCommandViewCameraAltStopSlow, name = _('Camera alternative up left slow'), category = _('View')},
{combos = {{key = 'Num*', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltForwardSlow, up = iCommandViewCameraAltForwardStopSlow, name = _('Camera alternative forward slow'), category = _('View')},
{combos = {{key = 'Num/', reformers = {'RAlt','RCtrl'}}}, pressed = iCommandViewCameraAltBackSlow, up = iCommandViewCameraAltBackStopSlow, name = _('Camera alternative backward slow'), category = _('View')},

{combos = {{key = 'Num5', reformers = {'RAlt','RCtrl'}}}, down = iCommandViewCameraAltCenter, name = _('Camera alternative center'), category = _('View')},

{combos = {{key = 'Num8', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltUp, up = iCommandViewCameraAltStop, name = _('Camera alternative up'), category = _('View')},
{combos = {{key = 'Num2', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltDown, up = iCommandViewCameraAltStop, name = _('Camera alternative down'), category = _('View')},
{combos = {{key = 'Num4', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltLeft, up = iCommandViewCameraAltStop, name = _('Camera alternative left'), category = _('View')},
{combos = {{key = 'Num6', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltRight, up = iCommandViewCameraAltStop, name = _('Camera alternative right'), category = _('View')},
{combos = {{key = 'Num9', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltUpRight, up = iCommandViewCameraAltStop, name = _('Camera alternative up right'), category = _('View')},
{combos = {{key = 'Num3', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltDownRight, up = iCommandViewCameraAltStop, name = _('Camera alternative down right'), category = _('View')},
{combos = {{key = 'Num1', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltDownLeft, up = iCommandViewCameraAltStop, name = _('Camera alternative down left'), category = _('View')},
{combos = {{key = 'Num7', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltUpLeft, up = iCommandViewCameraAltStop, name = _('Camera alternative up left'), category = _('View')},
{combos = {{key = 'Num*', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltForward, up = iCommandViewCameraAltForwardStop, name = _('Camera alternative forward'), category = _('View')},
{combos = {{key = 'Num/', reformers = {'RAlt','RCtrl','RShift'}}}, pressed = iCommandViewCameraAltBack, up = iCommandViewCameraAltBackStop, name = _('Camera alternative backward'), category = _('View')},

-- Experimental object free camera
{combos = {{key = 'F2', reformers = {'RCtrl'}}}, 		down = iCommandViewObject, name = _('Object local camera'), category = _('View')},
{combos = {{key = 'F2', reformers = {'RCtrl', 'RShift'}}}, 		down = iCommandViewObjectWithPosition, name = _('Object camera with position inheritance'), category = _('View')},
{combos = {{key = '=', reformers = {'RCtrl', 'RAlt', 'RShift'}}}, 			down = iCommandViewBookmarksEditor, name = _('Camera bookmarks editor'), category = _('View')},
{combos = {{key = '-', reformers = {'RCtrl', 'RAlt', 'RShift'}}}, 			down = iCommandViewBookmarksMenu, name = _('Camera bookmarks menu bar'), category = _('View')},
{combos = {{key = 'O', reformers = {'RCtrl', 'RAlt', 'RShift'}}}, 			down = iCommandViewPieMenu, name = _('Pie menu'), category = _('View')},
-- Experimental wingman camera
{combos = {{key = 'F4', reformers = {'LAlt'}}}, 		down = iCommandViewWingman, name = _('Wingman camera'), category = _('View')},
-- Aircraft carrier cameras
{combos = {{key = 'F9', reformers = {'RAlt', 'RCtrl', 'RShift'}}},	down = iCommandViewSupercarrier, name = _('Supercarrier camera'), category = _('View')},
{combos = {{key = 'F9', reformers = {'LCtrl'}}}, down = iCommandViewSupercarrierJump, name = _('Jump to Supercarrier view'), category = _('View')},
{combos = {{key = 'F9', reformers = {'RCtrl'}}}, 		down = iCommandViewCatapult		 , name = _('Aircraft carrier catapult camera'), category = _('View')},
{combos = {{key = 'F9', reformers = {'RCtrl', 'RAlt'}}}, 		down = iCommandViewCatapultCrew, name = _('Aircraft carrier catapult crew camera'),	category = _('View')},
--{combos = {{key = 'F11', reformers = {'RCtrl', 'RShift'}}},	down = iCommandViewAirdromeRoom,	name = _('Airdrome Briefing Room camera'),	category = _('View')},
-- Camera position to/from clipboard 
{combos = {{key = ',', reformers = {'RAlt', 'RCtrl'}}}, 			down = iCommandViewCameraToClipboard, name = _('Unload camera position to clipboard'), category = _('View')},
{combos = {{key = '.', reformers = {'RAlt', 'RCtrl'}}}, 			down = iCommandViewClipboardToCamera, name = _('Load camera position from clipboard'), category = _('View')},

{combos = {{key = ']', reformers = {'LShift'}}},		down = iCommandViewFastKeyboard,												name = _('Keyboard Rate Fast'),									category = _('View')},
{combos = {{key = ']', reformers = {'LCtrl'}}},			down = iCommandViewSlowKeyboard,												name = _('Keyboard Rate Slow'),									category = _('View')},
{combos = {{key = ']', reformers = {'LAlt'}}},			down = iCommandViewNormalKeyboard,												name = _('Keyboard Rate Normal'),								category = _('View')},
{combos = {{key = '[', reformers = {'LShift'}}},		down = iCommandViewFastMouse,													name = _('Mouse Rate Fast'),									category = _('View')},
{combos = {{key = '[', reformers = {'LCtrl'}}},			down = iCommandViewSlowMouse,													name = _('Mouse Rate Slow'),									category = _('View')},
{combos = {{key = '[', reformers = {'LAlt'}}},			down = iCommandViewNormalMouse,													name = _('Mouse Rate Normal'),									category = _('View')},

-- Cockpit view
{combos = {{key = 'L', reformers = {'LAlt'}}},				down = 3256,	cockpit_device_id = 0,	value_down = 1.0,						name = _('Flashlight'),						category = _('View Cockpit')},

{combos = {{key = 'Num0'}},									down = iCommandViewTempCockpitOn,		up = iCommandViewTempCockpitOff,		name = _('Cockpit panel view in'),			category = _('View Cockpit')},
{combos = {{key = 'Num0', reformers = {'RCtrl'}}},			down = iCommandViewTempCockpitToggle,											name = _('Cockpit panel view toggle'),		category = _('View Cockpit')},
--// Save current cockpit camera angles for fast numpad jumps
{combos = {{key = 'Num0', reformers = {'RAlt'}}},			down = iCommandViewSaveAngles,													name = _('Save Cockpit Angles'),			category = _('View Cockpit')},
{combos = {{key = 'Num8', reformers = {'RShift'}}},			pressed = iCommandViewUp,					up = iCommandViewStop,				name = _('View up'),						category = _('View Cockpit')},
{combos = {{key = 'Num2', reformers = {'RShift'}}},			pressed = iCommandViewDown,					up = iCommandViewStop,				name = _('View down'),						category = _('View Cockpit')},
{combos = {{key = 'Num4', reformers = {'RShift'}}},			pressed = iCommandViewLeft,					up = iCommandViewStop,				name = _('View left'),						category = _('View Cockpit')},
{combos = {{key = 'Num6', reformers = {'RShift'}}},			pressed = iCommandViewRight,				up = iCommandViewStop,				name = _('View right'),						category = _('View Cockpit')},
{combos = {{key = 'Num9', reformers = {'RShift'}}},			pressed = iCommandViewUpRight,				up = iCommandViewStop,				name = _('View up right'),					category = _('View Cockpit')},
{combos = {{key = 'Num3', reformers = {'RShift'}}},			pressed = iCommandViewDownRight,			up = iCommandViewStop,				name = _('View down right'),				category = _('View Cockpit')},
{combos = {{key = 'Num1', reformers = {'RShift'}}},			pressed = iCommandViewDownLeft,				up = iCommandViewStop,				name = _('View down left'),					category = _('View Cockpit')},
{combos = {{key = 'Num7', reformers = {'RShift'}}},			pressed = iCommandViewUpLeft,				up = iCommandViewStop,				name = _('View up left'),					category = _('View Cockpit')},

-- Cockpit Camera Motion (Передвижение камеры в кабине)
{combos = {{key = 'Num8', reformers = {'RCtrl','RShift'}}},	pressed = iCommandViewPitCameraMoveUp,		up = iCommandViewPitCameraMoveStop,	name = _('Cockpit Camera Move Up'),			category = _('View Cockpit')},
{combos = {{key = 'Num2', reformers = {'RCtrl','RShift'}}},	pressed = iCommandViewPitCameraMoveDown,	up = iCommandViewPitCameraMoveStop,	name = _('Cockpit Camera Move Down'),		category = _('View Cockpit')},
{combos = {{key = 'Num4', reformers = {'RCtrl','RShift'}}},	pressed = iCommandViewPitCameraMoveLeft,	up = iCommandViewPitCameraMoveStop,	name = _('Cockpit Camera Move Left'),		category = _('View Cockpit')},
{combos = {{key = 'Num6', reformers = {'RCtrl','RShift'}}},	pressed = iCommandViewPitCameraMoveRight,	up = iCommandViewPitCameraMoveStop,	name = _('Cockpit Camera Move Right'),		category = _('View Cockpit')},
{combos = {{key = 'Num*', reformers = {'RCtrl','RShift'}}},	pressed = iCommandViewPitCameraMoveForward,	up = iCommandViewPitCameraMoveStop,	name = _('Cockpit Camera Move Forward'),	category = _('View Cockpit')},
{combos = {{key = 'Num/', reformers = {'RCtrl','RShift'}}, {key = 'Num-', reformers = {'RCtrl','RShift'}}},	pressed = iCommandViewPitCameraMoveBack,	up = iCommandViewPitCameraMoveStop,	name = _('Cockpit Camera Move Back'),	category = _('View Cockpit')},
{combos = {{key = 'Num5', reformers = {'RCtrl','RShift'}}},	down = iCommandViewPitCameraMoveCenter,											name = _('Cockpit Camera Move Center'),		category = _('View Cockpit')},
{combos = {{key = 'F1', reformers = {'LShift'}}},			down = iCommandViewTransposeModeOn,			up = iCommandViewTransposeModeOff,	name = _('Camera transpose mode (press and hold)'),	category = _('View Cockpit')},

{combos = {{key = 'Num8', reformers = {'RCtrl'}}},			down = iCommandViewCameraUp,				up = iCommandViewCameraCenter,		name = _('Glance up'),						category = _('View Cockpit')},
{combos = {{key = 'Num2', reformers = {'RCtrl'}}},			down = iCommandViewCameraDown,				up = iCommandViewCameraCenter,		name = _('Glance down'),					category = _('View Cockpit')},
{combos = {{key = 'Num4', reformers = {'RCtrl'}}},			down = iCommandViewCameraLeft,				up = iCommandViewCameraCenter,		name = _('Glance left'),					category = _('View Cockpit')},
{combos = {{key = 'Num6', reformers = {'RCtrl'}}},			down = iCommandViewCameraRight,				up = iCommandViewCameraCenter,		name = _('Glance right'),					category = _('View Cockpit')},
{combos = {{key = 'Num7', reformers = {'RCtrl'}}},			down = iCommandViewCameraUpLeft,			up = iCommandViewCameraCenter,		name = _('Glance up-left'),					category = _('View Cockpit')},
{combos = {{key = 'Num1', reformers = {'RCtrl'}}},			down = iCommandViewCameraDownLeft,			up = iCommandViewCameraCenter,		name = _('Glance down-left'),				category = _('View Cockpit')},
{combos = {{key = 'Num9', reformers = {'RCtrl'}}},			down = iCommandViewCameraUpRight,			up = iCommandViewCameraCenter,		name = _('Glance up-right'),				category = _('View Cockpit')},
{combos = {{key = 'Num3', reformers = {'RCtrl'}}},			down = iCommandViewCameraDownRight,			up = iCommandViewCameraCenter,		name = _('Glance down-right'),				category = _('View Cockpit')},
{combos = {{key = 'Z', reformers = {'LAlt','LShift'}}},		down = iCommandViewPanToggle,													name = _('Camera pan mode toggle'),			category = _('View Cockpit')},

{combos = {{key = 'Num8', reformers = {'RAlt'}}},			down = iCommandViewCameraUpSlow,												name = _('Camera snap view up'),			category = _('View Cockpit')},
{combos = {{key = 'Num2', reformers = {'RAlt'}}},			down = iCommandViewCameraDownSlow,												name = _('Camera snap view down'),			category = _('View Cockpit')},
{combos = {{key = 'Num4', reformers = {'RAlt'}}},			down = iCommandViewCameraLeftSlow,												name = _('Camera snap view left'),			category = _('View Cockpit')},
{combos = {{key = 'Num6', reformers = {'RAlt'}}},			down = iCommandViewCameraRightSlow,												name = _('Camera snap view right'),			category = _('View Cockpit')},
{combos = {{key = 'Num7', reformers = {'RAlt'}}},			down = iCommandViewCameraUpLeftSlow,											name = _('Camera snap view up-left'),		category = _('View Cockpit')},
{combos = {{key = 'Num1', reformers = {'RAlt'}}},			down = iCommandViewCameraDownLeftSlow,											name = _('Camera snap view down-left'),		category = _('View Cockpit')},
{combos = {{key = 'Num9', reformers = {'RAlt'}}},			down = iCommandViewCameraUpRightSlow,											name = _('Camera snap view up-right'),		category = _('View Cockpit')},
{combos = {{key = 'Num3', reformers = {'RAlt'}}},			down = iCommandViewCameraDownRightSlow,											name = _('Camera snap view down-right'),	category = _('View Cockpit')},

{combos = {{key = 'Num0', reformers = {'LWin'}}},			down = iCommandViewSnapView0,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  0'),			category = _('View Cockpit')},
{combos = {{key = 'Num1', reformers = {'LWin'}}},			down = iCommandViewSnapView1,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  1'),			category = _('View Cockpit')},
{combos = {{key = 'Num2', reformers = {'LWin'}}},			down = iCommandViewSnapView2,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  2'),			category = _('View Cockpit')},
{combos = {{key = 'Num3', reformers = {'LWin'}}},			down = iCommandViewSnapView3,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  3'),			category = _('View Cockpit')},
{combos = {{key = 'Num4', reformers = {'LWin'}}},			down = iCommandViewSnapView4,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  4'),			category = _('View Cockpit')},
{combos = {{key = 'Num5', reformers = {'LWin'}}},			down = iCommandViewSnapView5,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  5'),			category = _('View Cockpit')},
{combos = {{key = 'Num6', reformers = {'LWin'}}},			down = iCommandViewSnapView6,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  6'),			category = _('View Cockpit')},
{combos = {{key = 'Num7', reformers = {'LWin'}}},			down = iCommandViewSnapView7,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  7'),			category = _('View Cockpit')},
{combos = {{key = 'Num8', reformers = {'LWin'}}},			down = iCommandViewSnapView8,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  8'),			category = _('View Cockpit')},
{combos = {{key = 'Num9', reformers = {'LWin'}}},			down = iCommandViewSnapView9,				up = iCommandViewSnapViewStop,		name = _('Custom Snap View  9'),			category = _('View Cockpit')},

{combos = {{key = 'Num*', reformers = {'RShift'}}},			pressed = iCommandViewForward,				up = iCommandViewForwardStop,		name = _('Zoom in'),						category = _('View Cockpit')},
{combos = {{key = 'Num/', reformers = {'RShift'}}},			pressed = iCommandViewBack,					up = iCommandViewBackStop,			name = _('Zoom out'),						category = _('View Cockpit')},

-- Extended view
{combos = {{key = 'J', reformers = {'LShift'}}},			down = iCommandViewCameraJiggle,	name = _('Camera jiggle toggle'),					category = _('View Extended'), features = {"Camera jiggle"}},
{combos = {{key = 'K', reformers = {'LAlt'}}},				down = iCommandViewKeepTerrain,		name = _('Keep terrain camera altitude'),			category = _('View Extended')},
{combos = {{key = 'Home', reformers = {'RCtrl','RShift'}}},	down = iCommandViewFriends,			name = _('View friends mode'),						category = _('View Extended')},
{combos = {{key = 'End', reformers = {'RCtrl','RShift'}}},	down = iCommandViewEnemies,			name = _('View enemies mode'),						category = _('View Extended')},
{combos = {{key = 'Delete', reformers = {'RCtrl'}}},		down = iCommandViewAll,				name = _('View all mode'),							category = _('View Extended')},
{combos = {{key = 'Num+', reformers = {'RCtrl'}}},			down = iCommandViewPlus,			name = _('Toggle tracking launched weapon'),		category = _('View Extended')},
{combos = {{key = 'PageDown', reformers = {'LCtrl'}}},		down = iCommandViewSwitchForward,	name = _('Objects switching direction forward '),	category = _('View Extended')},
{combos = {{key = 'PageUp', reformers = {'LCtrl'}}},		down = iCommandViewSwitchReverse,	name = _('Objects switching direction reverse '),	category = _('View Extended')},
{combos = {{key = 'Delete', reformers = {'LAlt'}}},			down = iCommandViewObjectIgnore,	name = _('Object exclude '),						category = _('View Extended')},
{combos = {{key = 'Insert', reformers = {'LAlt'}}},			down = iCommandViewObjectsAll,		name = _('Objects all excluded - include'),			category = _('View Extended')},

-- Padlock
{combos = {{key = 'Num.'}},							down = iCommandViewLock,				name = _('Lock View (cycle padlock)'),	category = _('View Padlock')},
{combos = {{key = 'NumLock'}},						down = iCommandViewUnlock,				name = _('Unlock view (stop padlock)'),	category = _('View Padlock')},
{combos = {{key = 'Num.', reformers = {'RShift'}}},	down = iCommandAllMissilePadlock,		name = _('All missiles padlock'),		category = _('View Padlock')},
{combos = {{key = 'Num.', reformers = {'RAlt'}}},	down = iCommandThreatMissilePadlock,	name = _('Threat missile padlock'),		category = _('View Padlock')},
{combos = {{key = 'Num.', reformers = {'RCtrl'}}},	down = iCommandViewTerrainLock,			name = _('Lock terrain view'),			category = _('View Padlock')},

-- Labels
{combos = {{key = 'F10', reformers = {'LShift'}}},	down = iCommandMarkerState,				name = _('All Labels'),					category = _('Labels')},
{combos = {{key = 'F2', reformers = {'LShift'}}},	down = iCommandMarkerStatePlane,		name = _('Aircraft Labels'),			category = _('Labels')},
{combos = {{key = 'F6', reformers = {'LShift'}}},	down = iCommandMarkerStateRocket,		name = _('Missile Labels'),				category = _('Labels')},
{combos = {{key = 'F9', reformers = {'LShift'}}},	down = iCommandMarkerStateShip,			name = _('Vehicle & Ship Labels'),		category = _('Labels')},

--Kneeboard
{combos = {{key = 'K', reformers = {'RShift'}}},	down = iCommandPlaneShowKneeboard,																				name = _('Kneeboard ON/OFF'),						category = _('Kneeboard')},
{combos = {{key = 'K'}},							down = iCommandPlaneShowKneeboard,	up = iCommandPlaneShowKneeboard,	value_down = 1.0,	value_up = -1.0,	name = _('Kneeboard glance view'),					category = _('Kneeboard')},
{combos = {{key = ']'}},							down = 3001,	cockpit_device_id = kneeboard_id,						value_down = 1.0,						name = _('Kneeboard Next Page'),					category = _('Kneeboard')},
{combos = {{key = '['}},							down = 3002,	cockpit_device_id = kneeboard_id,						value_down = 1.0,						name = _('Kneeboard Previous Page'),				category = _('Kneeboard')},
{combos = {{key = 'K', reformers = {'RCtrl'}}},		down = 3003,	cockpit_device_id = kneeboard_id,						value_down = 1.0,						name = _('Kneeboard current position mark point'),	category = _('Kneeboard')},
--shortcuts navigation
{	down = 3004,	cockpit_device_id = kneeboard_id,						value_down =  1.0,						name = _('Kneeboard Make Shortcut'),				category = _('Kneeboard')},
{	down = 3005,	cockpit_device_id = kneeboard_id,						value_down =  1.0,						name = _('Kneeboard Next Shortcut'),				category = _('Kneeboard')},
{	down = 3005,	cockpit_device_id = kneeboard_id,						value_down = -1.0,						name = _('Kneeboard Previous Shortcut'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 0,							name = _('Kneeboard Jump To Shortcut  1'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 1,							name = _('Kneeboard Jump To Shortcut  2'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 2,							name = _('Kneeboard Jump To Shortcut  3'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 3,							name = _('Kneeboard Jump To Shortcut  4'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 4,							name = _('Kneeboard Jump To Shortcut  5'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 5,							name = _('Kneeboard Jump To Shortcut  6'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 6,							name = _('Kneeboard Jump To Shortcut  7'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 7,							name = _('Kneeboard Jump To Shortcut  8'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 8,							name = _('Kneeboard Jump To Shortcut  9'),			category = _('Kneeboard')},
{	down = iCommandPlaneKneeboardJumpBookmark,								value_down = 9,							name = _('Kneeboard Jump To Shortcut 10'),			category = _('Kneeboard')},

-- General (Gameplay)
{combos = {{key = 'U'}},							down = iCommandPlaneShipTakeOff,			name = _('Ship Take Off Position'),		category = _('General') , features = {"shiptakeoff"}},
{combos = {{key = 'P', reformers = {'RShift'}}},	down = iCommandCockpitShowPilotOnOff,		name = _('Show Pilot Body'),			category = _('General')},

-- Flight Control
{combos = defaultDeviceAssignmentFor("pitch_up"), down = iCommandPlaneUpStart,			up = iCommandPlaneUpStop,			name = _('Aircraft Pitch Down'),	category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("pitch_down"), down = iCommandPlaneDownStart,		up = iCommandPlaneDownStop,			name = _('Aircraft Pitch Up'),		category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("roll_left"), down = iCommandPlaneLeftStart,		up = iCommandPlaneLeftStop,			name = _('Aircraft Bank Left'),		category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("roll_right"), down = iCommandPlaneRightStart,		up = iCommandPlaneRightStop,		name = _('Aircraft Bank Right'),	category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("rudder_left"), down = iCommandPlaneLeftRudderStart,	up = iCommandPlaneLeftRudderStop,	name = _('Aircraft Rudder Left'),	category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("rudder_right"), down = iCommandPlaneRightRudderStart,	up = iCommandPlaneRightRudderStop,	name = _('Aircraft Rudder Right'),	category = _('Flight Control')},


{combos = defaultDeviceAssignmentFor("plane_trim_up"),		pressed = iCommandPlaneTrimUp,		up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'),			category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("plane_trim_down"),	pressed = iCommandPlaneTrimDown,	up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'),		category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("plane_trim_left"),	pressed = iCommandPlaneTrimLeft,	up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'),	category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("plane_trim_right"),	pressed = iCommandPlaneTrimRight,	up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'),	category = _('Flight Control')},
{combos = {{key = 'Z', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimLeftRudder,	up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'),		category = _('Flight Control')},
{combos = {{key = 'X', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimRightRudder,	up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'),		category = _('Flight Control')},

{combos = defaultDeviceAssignmentFor("thrust_up"), pressed = iCommandThrottleIncrease,		up = iCommandThrottleStop,  name = _('Throttle Up'),		category = _('Flight Control')},
{combos = defaultDeviceAssignmentFor("thrust_down"), pressed = iCommandThrottleDecrease,	up = iCommandThrottleStop,  name = _('Throttle Down'),		category = _('Flight Control')},
{combos = {{key = 'Num+', reformers = {'RAlt'}}}, 	pressed = iCommandThrottle1Increase,	up = iCommandThrottle1Stop, name = _('Throttle Left Up'),	category = _('Flight Control'), features = {"TwinEngineAircraft"}},
{combos = {{key = 'Num-', reformers = {'RAlt'}}}, 	pressed = iCommandThrottle1Decrease,	up = iCommandThrottle1Stop, name = _('Throttle Left Down'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
{combos = {{key = 'Num+', reformers = {'RShift'}}}, pressed = iCommandThrottle2Increase,	up = iCommandThrottle2Stop, name = _('Throttle Right Up'),	category = _('Flight Control'), features = {"TwinEngineAircraft"}},
{combos = {{key = 'Num-', reformers = {'RShift'}}}, pressed = iCommandThrottle2Decrease,	up = iCommandThrottle2Stop, name = _('Throttle Right Down'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},

{combos = {{key = 'PageUp'}},							down = iCommandPlaneAUTIncreaseRegime,		name = _('Throttle Step Up'),			category = _('Flight Control')},
{combos = {{key = 'PageDown'}},							down = iCommandPlaneAUTDecreaseRegime,		name = _('Throttle Step Down'),			category = _('Flight Control')},
{combos = {{key = 'PageUp', reformers = {'RAlt'}}},		down = iCommandPlaneAUTIncreaseRegimeLeft,	name = _('Throttle Step Up Left'),		category = _('Flight Control'), features = {"TwinEngineAircraft"}},
{combos = {{key = 'PageDown', reformers = {'RAlt'}}},	down = iCommandPlaneAUTDecreaseRegimeLeft,	name = _('Throttle Step Down Left'),	category = _('Flight Control'), features = {"TwinEngineAircraft"}},
{combos = {{key = 'PageUp', reformers = {'RShift'}}},	down = iCommandPlaneAUTIncreaseRegimeRight, name = _('Throttle Step Up Right'),		category = _('Flight Control'), features = {"TwinEngineAircraft"}},
{combos = {{key = 'PageDown', reformers = {'RShift'}}}, down = iCommandPlaneAUTDecreaseRegimeRight, name = _('Throttle Step Down Right'),	category = _('Flight Control'), features = {"TwinEngineAircraft"}},

-- Systems
{combos = {{key = 'L', reformers = {'RShift'}}},	down = iCommandPowerOnOff,					name = _('Electric Power Switch'),					category = _('Systems')},
{combos = defaultDeviceAssignmentFor("airbrake"),	down = iCommandPlaneAirBrake,				name = _('Airbrake'),								category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'B', reformers = {'LShift'}}},	down = iCommandPlaneAirBrakeOn,				name = _('Airbrake On'),							category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'B', reformers = {'LCtrl'}}},		down = iCommandPlaneAirBrakeOff,			name = _('Airbrake Off'),							category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'T'}},							down = iCommandPlaneWingtipSmokeOnOff,		name = _('Smoke'),									category = _('Systems'), features = {"smoke"}},
{combos = {{key = 'L'}},							down = iCommandPlaneCockpitIllumination,	name = _('Illumination Cockpit'),					category = _('Systems')},
{combos = {{key = 'L', reformers = {'RCtrl'}}},		down = iCommandPlaneLightsOnOff,			name = _('Navigation lights'),						category = _('Systems')},
{combos = {{key = 'L', reformers = {'RAlt'}}},		down = iCommandPlaneHeadLightOnOff,			name = _('Gear Light Near/Far/Off'),				category = _('Systems')},
{combos = {{key = 'F'}},							down = iCommandPlaneFlaps,					name = _('Flaps Up/Down'),							category = _('Systems')},
{combos = defaultDeviceAssignmentFor("plane_flaps_on"), down = iCommandPlaneFlapsOn,			name = _('Flaps Landing Position'),					category = _('Systems')},
{combos = defaultDeviceAssignmentFor("plane_flaps_off"), down = iCommandPlaneFlapsOff,			name = _('Flaps Up'),								category = _('Systems')},
{combos = defaultDeviceAssignmentFor("plane_gear"), down = iCommandPlaneGear,					name = _('Landing Gear Up/Down'),					category = _('Systems')},
{combos = {{key = 'G', reformers = {'LCtrl'}}},		down = iCommandPlaneGearUp,					name = _('Landing Gear Up'),						category = _('Systems')},
{combos = {{key = 'G', reformers = {'LShift'}}},	down = iCommandPlaneGearDown,				name = _('Landing Gear Down'),						category = _('Systems')},
{combos = defaultDeviceAssignmentFor("wheel_brake"), down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff, name = _('Wheel Brake On'),	category = _('Systems')},
{combos = {{key = 'C', reformers = {'LCtrl'}}},		down = iCommandPlaneFonar,					name = _('Canopy Open/Close'),						category = _('Systems')},
{combos = {{key = 'P'}},							down = iCommandPlaneParachute,				name = _('Dragging Chute'),							category = _('Systems') , features = {"dragchute"}},
{combos = {{key = 'N', reformers = {'RShift'}}},	down = iCommandPlaneResetMasterWarning,		name = _('Audible Warning Reset'),					category = _('Systems')	, features = {"modern"}},
{combos = {{key = 'W', reformers = {'LCtrl'}}},		down = iCommandPlaneJettisonWeapons,up = iCommandPlaneJettisonWeaponsUp, name = _('Weapons Jettison'), category = _('Systems')},
{combos = defaultDeviceAssignmentFor("plane_eject"), down = iCommandPlaneEject,					name = _('Eject (3 times)'),						category = _('Systems')},
{combos = {{key = 'C', reformers = {'RShift'}}},	down = iCommandFlightClockReset,			name = _('Flight Clock Start/Stop/Reset'),			category = _('Systems') , features = {"flightclock", "flightclockstart"}},
{combos = {{key = 'C', reformers = {'RAlt'}}},		down = iCommandClockElapsedTimeReset,		name = _('Elapsed Time Clock Start/Stop/Reset'),	category = _('Systems') , features = {"flightclock"}},
{combos = {{key = 'Home', reformers = {'RShift'}}}, down = iCommandEnginesStart,				name = _('Engines Start'),							category = _('Systems')},
{combos = {{key = 'End', reformers = {'RShift'}}},	down = iCommandEnginesStop,					name = _('Engines Stop'),							category = _('Systems')},
{combos = {{key = 'Home', reformers = {'RAlt'}}},	down = iCommandLeftEngineStart,				name = _('Engine Left Start'),						category = _('Systems') , features = {"TwinEngineAircraft"}},
{combos = {{key = 'End', reformers = {'RAlt'}}},	down = iCommandLeftEngineStop,				name = _('Engine Left Stop'),						category = _('Systems') , features = {"TwinEngineAircraft"}},
{combos = {{key = 'Home', reformers = {'RCtrl'}}},	down = iCommandRightEngineStart,			name = _('Engine Right Start'),						category = _('Systems') , features = {"TwinEngineAircraft"}},
{combos = {{key = 'End', reformers = {'RCtrl'}}},	down = iCommandRightEngineStop,				name = _('Engine Right Stop'),						category = _('Systems') , features = {"TwinEngineAircraft"}},
{combos = {{key = 'H', reformers = {'RCtrl'}}},		down = iCommandBrightnessILS,				name = _('HUD Color'),								category = _('Systems') , features = {"HUDcolor"}},
{combos = {{key = 'H', reformers = {'RCtrl','RShift'}}}, pressed = iCommandHUDBrightnessUp,		name = _('HUD Brightness up'),						category = _('Systems') , features = {"HUDbrightness"}},
{combos = {{key = 'H', reformers = {'RShift','RAlt'}}}, pressed = iCommandHUDBrightnessDown,	name = _('HUD Brightness down'),					category = _('Systems') , features = {"HUDbrightness"}},
{combos = {{key = 'R'}},							down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff, name = _('Fuel Dump'),					category = _('Systems') , features = {"fueldump"}},

{combos = {{key = '=', reformers = {'RShift'}}}, pressed = iCommandAltimeterPressureIncrease,	up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Increase'), category = _('Systems')},
{combos = {{key = '-', reformers = {'RShift'}}}, pressed = iCommandAltimeterPressureDecrease, up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Decrease'), category = _('Systems')},

-- Modes
{combos = {{key = '`', reformers = {'LCtrl'}}},		down = iCommandPlaneChangeTarget,			name = _('Next Waypoint, Airfield Or Target'),		category = _('Modes')},
{combos = {{key = '`', reformers = {'LShift'}}},	down = iCommandPlaneUFC_STEER_DOWN,			name = _('Previous Waypoint, Airfield Or Target'),	category = _('Modes')},

{combos = defaultDeviceAssignmentFor("plane_mode_nav"),		down = iCommandPlaneModeNAV,	name = _('(1) Navigation Modes'),						category = _('Modes')},
{combos = defaultDeviceAssignmentFor("plane_mode_bvr"),		down = iCommandPlaneModeBVR,	name = _('(2) Air-to-Air Beyond Visual Range Modes'),	category = _('Modes'),features = {"a2aBVR"}},
{combos = defaultDeviceAssignmentFor("plane_mode_ground"),	down = iCommandPlaneModeGround,	name = _('(7) Air-to-Ground Modes'),					category = _('Modes'),features = {"a2g"}},

-- Weapons
{combos = defaultDeviceAssignmentFor("fire"), down = iCommandPlaneFire,	up = iCommandPlaneFireOff,		name = _('Weapon Fire'),		category = _('Weapons')},
{combos = defaultDeviceAssignmentFor("plane_change_weapon"), down = iCommandPlaneChangeWeapon,			name = _('Weapon Change'),		category = _('Weapons')},
{combos = {{key = 'C'}},						down = iCommandPlaneModeCannon,							name = _('Cannon'),				category = _('Weapons')},
{combos = {{key = 'W', reformers = {'LAlt'}}},	down = iCommandPlaneLaunchPermissionOverride,			name = _('Launch Permission Override'), category = _('Weapons') , features = {"LaunchPermissionOverride"}},

-- Countermeasures
{combos = {{key = 'Q', reformers = {'LShift'}}},	down = iCommandPlaneDropSnar,			name = _('Countermeasures Continuously Dispense'),					category = _('Countermeasures') , features = {"Countermeasures"}},
{combos = defaultDeviceAssignmentFor("drop_countermeasures"), down = iCommandPlaneDropSnarOnce, up = iCommandPlaneDropSnarOnceOff, name = _('Countermeasures Release'),	category = _('Countermeasures') , features = {"Countermeasures"}},
{combos = {{key = 'Delete'}}, 						down = iCommandPlaneDropFlareOnce, name = _('Countermeasures Flares Dispense'),						category = _('Countermeasures') , features = {"Countermeasures"}},
{combos = {{key = 'Insert'}}, 						down = iCommandPlaneDropChaffOnce, name = _('Countermeasures Chaff Dispense'),							category = _('Countermeasures') , features = {"Countermeasures"}},
{combos = defaultDeviceAssignmentFor("electronic_countermeasures"), down = iCommandActiveJamming, name = _('ECM'),													category = _('Countermeasures') , features = {"ECM"}},

-- Communications
{combos = {{key = 'I', reformers = {'LWin'}}},											down = iCommandAWACSTankerBearing,	name = _('Request AWACS Available Tanker'),	category = _('Communications')},
{combos = {{key = '\\', reformers = {'RShift'}}, {key = 'M', reformers = {'RShift'}}},	down = iCommandToggleReceiveMode,	name = _('Receive Mode'),					category = _('Communications')},

-- Cockpit Camera Motion (Передвижение камеры в кабине)
{combos = {{key = 'N', reformers = {'RAlt'}}},	down = iCommandViewLeftMirrorOn ,	up = iCommandViewLeftMirrorOff ,	name = _('Mirror Left On'),		category = _('View Cockpit') , features = {"Mirrors"}},
{combos = {{key = 'M', reformers = {'RAlt'}}},	down = iCommandViewRightMirrorOn,	up = iCommandViewRightMirrorOff,	name = _('Mirror Right On'),	category = _('View Cockpit') , features = {"Mirrors"}},
{combos = {{key = 'M' }},						down = iCommandToggleMirrors,											name = _('Toggle Mirrors'),		category = _('View Cockpit') , features = {"Mirrors"}},

-- Auto Lock On 
-- {combos = {{key = 'F5', reformers = {'RAlt'}}}, 	down = iCommandAutoLockOnNearestAircraft,	name = _('Auto lock on nearest aircraft'),			category = _('Simplifications')},
-- {combos = {{key = 'F6', reformers = {'RAlt'}}},		down = iCommandAutoLockOnCenterAircraft,		name = _('Auto lock on center aircraft'),			category = _('Simplifications')},
-- {combos = {{key = 'F7', reformers = {'RAlt'}}},		down = iCommandAutoLockOnNextAircraft,			name = _('Auto lock on next aircraft'),				category = _('Simplifications')},
-- {combos = {{key = 'F8', reformers = {'RAlt'}}},		down = iCommandAutoLockOnPreviousAircraft,		name = _('Auto lock on previous aircraft'),			category = _('Simplifications')},
-- {combos = {{key = 'F9', reformers = {'RAlt'}}},		down = iCommandAutoLockOnNearestSurfaceTarget,	name = _('Auto lock on nearest surface target'),	category = _('Simplifications')},
-- {combos = {{key = 'F10', reformers = {'RAlt'}}},	down = iCommandAutoLockOnCenterSurfaceTarget,	name = _('Auto lock on center surface target'),		category = _('Simplifications')},
-- {combos = {{key = 'F11', reformers = {'RAlt'}}},	down = iCommandAutoLockOnNextSurfaceTarget,		name = _('Auto lock on next surface target'),		category = _('Simplifications')},
-- {combos = {{key = 'F12', reformers = {'RAlt'}}},	down = iCommandAutoLockOnPreviousSurfaceTarget, name = _('Auto lock on previous surface target'),	category = _('Simplifications')},

}
}
