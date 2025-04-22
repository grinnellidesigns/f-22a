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

--[[
To do: had to copy all input lua file data from DCS install lua files. Adding any custom command/keybinds broke many axis/keybinds in the original file.
]]

-- Kneeboard setup
local kneeboard_id = 100
if devices and devices.KNEEBOARD then
    kneeboard_id = devices.KNEEBOARD
end

-- Thrust assignments for axis commands
local thrust_common, thrust_left, thrust_right = MultiEngineDefaultDeviceAssignmentForThrust()

-- Define all command IDs as local variables
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
local B_BRAKE       = 10058

-- Left MFD
local LMFD_OSB_01 = 10061
local LMFD_OSB_02 = 10062
local LMFD_OSB_03 = 10063
local LMFD_OSB_04 = 10064
local LMFD_OSB_05 = 10065
local LMFD_OSB_06 = 10066
local LMFD_OSB_07 = 10067
local LMFD_OSB_08 = 10068
local LMFD_OSB_09 = 10069
local LMFD_OSB_10 = 10070
local LMFD_OSB_11 = 10071
local LMFD_OSB_12 = 10072
local LMFD_OSB_13 = 10073
local LMFD_OSB_14 = 10074
local LMFD_OSB_15 = 10075
local LMFD_OSB_16 = 10076
local LMFD_OSB_17 = 10077
local LMFD_OSB_18 = 10078
local LMFD_OSB_19 = 10079
local LMFD_OSB_20 = 10080

-- Right MFD
local RMFD_OSB_01 = 10091
local RMFD_OSB_02 = 10092
local RMFD_OSB_03 = 10093
local RMFD_OSB_04 = 10094
local RMFD_OSB_05 = 10095
local RMFD_OSB_06 = 10096
local RMFD_OSB_07 = 10097
local RMFD_OSB_08 = 10098
local RMFD_OSB_09 = 10099
local RMFD_OSB_10 = 10100
local RMFD_OSB_11 = 10101
local RMFD_OSB_12 = 10102
local RMFD_OSB_13 = 10103
local RMFD_OSB_14 = 10104
local RMFD_OSB_15 = 10105
local RMFD_OSB_16 = 10106
local RMFD_OSB_17 = 10107
local RMFD_OSB_18 = 10108
local RMFD_OSB_19 = 10109
local RMFD_OSB_20 = 10110

-- Center MFD
local CMFD_OSB_01 = 10111
local CMFD_OSB_02 = 10112
local CMFD_OSB_03 = 10113
local CMFD_OSB_04 = 10114
local CMFD_OSB_05 = 10115
local CMFD_OSB_06 = 10116
local CMFD_OSB_07 = 10117
local CMFD_OSB_08 = 10118
local CMFD_OSB_09 = 10119
local CMFD_OSB_10 = 10120
local CMFD_OSB_11 = 10121
local CMFD_OSB_12 = 10122
local CMFD_OSB_13 = 10123
local CMFD_OSB_14 = 10124
local CMFD_OSB_15 = 10125
local CMFD_OSB_16 = 10126
local CMFD_OSB_17 = 10127
local CMFD_OSB_18 = 10128
local CMFD_OSB_19 = 10129
local CMFD_OSB_20 = 10130

-- PMFD
local PMFD_OSB_01 = 10131
local PMFD_OSB_02 = 10132
local PMFD_OSB_03 = 10133
local PMFD_OSB_04 = 10134
local PMFD_OSB_05 = 10135
local PMFD_OSB_06 = 10136
local PMFD_OSB_07 = 10137
local PMFD_OSB_08 = 10138
local PMFD_OSB_09 = 10139
local PMFD_OSB_10 = 10140
local PMFD_OSB_11 = 10141
local PMFD_OSB_12 = 10142
local PMFD_OSB_13 = 10143
local PMFD_OSB_14 = 10144
local PMFD_OSB_15 = 10145
local PMFD_OSB_16 = 10146
local PMFD_OSB_17 = 10147
local PMFD_OSB_18 = 10148
local PMFD_OSB_19 = 10149
local PMFD_OSB_20 = 10150

local LIGHT_TAXI      = 10151
local LIGHT_TAXI_T    = 10152
local LIGHT_LANDING   = 10153
local LIGHT_LANDING_T = 10154

-- Return the complete bindings table
return {
    forceFeedback = {
        trimmer = 1.0,
        shake = 0.5,
        swapAxes = false,
        invertX = false,
        invertY = false,
    },

    keyCommands = {
        -- SMFD Both    
        {down = SMFD_Swap, name = _('SMFD Page Swap'), category = _('F-22A Systems')},    
        -- MFD LEFT    
        {down = LMFD_OSB_01, name = _('MFD Left OSB 1'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_02, name = _('MFD Left OSB 2'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_03, name = _('MFD Left OSB 3'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_04, name = _('MFD Left OSB 4'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_05, name = _('MFD Left OSB 5'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_06, name = _('MFD Left OSB 6'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_07, name = _('MFD Left OSB 7'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_08, name = _('MFD Left OSB 8'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_09, name = _('MFD Left OSB 9'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_10, name = _('MFD Left OSB 10'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_11, name = _('MFD Left OSB 11'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_12, name = _('MFD Left OSB 12'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_13, name = _('MFD Left OSB 13'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_14, name = _('MFD Left OSB 14'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_15, name = _('MFD Left OSB 15'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_16, name = _('MFD Left OSB 16'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_17, name = _('MFD Left OSB 17'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_18, name = _('MFD Left OSB 18'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_19, name = _('MFD Left OSB 19'), category = _('F-22A MFD Left')},
        {down = LMFD_OSB_20, name = _('MFD Left OSB 20'), category = _('F-22A MFD Left')},
        -- MFD RIGHT
        {down = RMFD_OSB_01, name = _('MFD Right OSB 1'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_02, name = _('MFD Right OSB 2'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_03, name = _('MFD Right OSB 3'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_04, name = _('MFD Right OSB 4'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_05, name = _('MFD Right OSB 5'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_06, name = _('MFD Right OSB 6'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_07, name = _('MFD Right OSB 7'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_08, name = _('MFD Right OSB 8'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_09, name = _('MFD Right OSB 9'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_10, name = _('MFD Right OSB 10'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_11, name = _('MFD Right OSB 11'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_12, name = _('MFD Right OSB 12'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_13, name = _('MFD Right OSB 13'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_14, name = _('MFD Right OSB 14'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_15, name = _('MFD Right OSB 15'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_16, name = _('MFD Right OSB 16'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_17, name = _('MFD Right OSB 17'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_18, name = _('MFD Right OSB 18'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_19, name = _('MFD Right OSB 19'), category = _('F-22A MFD Right')},
        {down = RMFD_OSB_20, name = _('MFD Right OSB 20'), category = _('F-22A MFD Right')},
        -- MFD CENTER
        {down = CMFD_OSB_01, name = _('MFD Center OSB 1'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_02, name = _('MFD Center OSB 2'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_03, name = _('MFD Center OSB 3'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_04, name = _('MFD Center OSB 4'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_05, name = _('MFD Center OSB 5'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_06, name = _('MFD Center OSB 6'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_07, name = _('MFD Center OSB 7'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_08, name = _('MFD Center OSB 8'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_09, name = _('MFD Center OSB 9'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_10, name = _('MFD Center OSB 10'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_11, name = _('MFD Center OSB 11'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_12, name = _('MFD Center OSB 12'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_13, name = _('MFD Center OSB 13'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_14, name = _('MFD Center OSB 14'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_15, name = _('MFD Center OSB 15'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_16, name = _('MFD Center OSB 16'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_17, name = _('MFD Center OSB 17'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_18, name = _('MFD Center OSB 18'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_19, name = _('MFD Center OSB 19'), category = _('F-22A MFD Center')},
        {down = CMFD_OSB_20, name = _('MFD Center OSB 20'), category = _('F-22A MFD Center')},
        -- PMFD
        {down = PMFD_OSB_01, name = _('PMFD OSB 1'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_02, name = _('PMFD OSB 2'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_03, name = _('PMFD OSB 3'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_04, name = _('PMFD OSB 4'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_05, name = _('PMFD OSB 5'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_06, name = _('PMFD OSB 6'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_07, name = _('PMFD OSB 7'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_08, name = _('PMFD OSB 8'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_09, name = _('PMFD OSB 9'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_10, name = _('PMFD OSB 10'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_11, name = _('PMFD OSB 11'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_12, name = _('PMFD OSB 12'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_13, name = _('PMFD OSB 13'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_14, name = _('PMFD OSB 14'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_15, name = _('PMFD OSB 15'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_16, name = _('PMFD OSB 16'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_17, name = _('PMFD OSB 17'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_18, name = _('PMFD OSB 18'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_19, name = _('PMFD OSB 19'), category = _('F-22A PMFD')},
        {down = PMFD_OSB_20, name = _('PMFD OSB 20'), category = _('F-22A PMFD')},  
        -- CLIPBOARD BINDS               
        {down = CLIPBOARD_L, name = _('Clipboard Left Show/Hide'), category = _('F-22A Systems')},
        {down = CLIPBOARD_R, name = _('Clipboard Right Show/Hide'), category = _('F-22A Systems')},
        -- ICP BINDS
        {down = ICP_COM1, name = _('ICP COMM 1'), category = _('F-22A ICP')},
        {down = ICP_COM2, name = _('ICP COMM 2'), category = _('F-22A ICP')},
        {down = ICP_NAV, name = _('ICP NAV'), category = _('F-22A ICP')},
        {down = ICP_STPT, name = _('ICP STPT'), category = _('F-22A ICP')},
        {down = ICP_ALT, name = _('ICP ALT'), category = _('F-22A ICP')},
        {down = ICP_HUD, name = _('ICP HUD'), category = _('F-22A ICP')},
        {down = ICP_AP, name = _('ICP AP'), category = _('F-22A ICP')},
        {down = ICP_OTHR, name = _('ICP OTHR'), category = _('F-22A ICP')},
        {down = ICP_OP1, name = _('ICP Option 1'), category = _('F-22A ICP')},
        {down = ICP_OP2, name = _('ICP Option 2'), category = _('F-22A ICP')},
        {down = ICP_OP3, name = _('ICP Option 3'), category = _('F-22A ICP')},
        {down = ICP_OP4, name = _('ICP Option 4'), category = _('F-22A ICP')},
        {down = ICP_OP5, name = _('ICP Option 5'), category = _('F-22A ICP')},
        -- F-22 Weapons
        {down = Detent_F, up = Detent_F, name = _('Weapons: Trigger First Detent'), category = _('F-22A HOTAS')},
        {down = Detent_S, up = Detent_S, name = _('Weapons: Trigger Second Detent'), category = _('F-22A HOTAS')},
        {down = PICKLE, up = PICKLE, name = _('Weapons: Release'), category = _('F-22A HOTAS')},
        -- F-22 CUSTOM BINDS
        {down = SelectLeft, name = _('Weapon Bay: Select Left'), category = _('F-22A HOTAS')},
        {down = SelectRight, name = _('Weapon Bay: Select Right'), category = _('F-22A HOTAS')},
        {down = SelectCenter, name = _('Weapon Bay: Select Center'), category = _('F-22A HOTAS')},
        {down = SelectAll, name = _('Weapon Bay: Select All'), category = _('F-22A HOTAS')},
        {down = SelectStep, name = _('Weapon Bay: Select Toggle'), category = _('F-22A HOTAS')},
        {down = AirORIDE, up = AirORIDE, name = _('Weapon Bay: Override (AIR)'), category = _('F-22A HOTAS')},
        {down = AirORIDE_T, name = _('Weapon Bay: Override Toggle (AIR)'), category = _('F-22A HOTAS')},
        {down = Dogfight, name = _('Dogfight MFD Override'), category = _('F-22A HOTAS')},
        {down = APU, up = APU, name = _('APU Start'), category = _('F-22A HOTAS')},
        {down = L_cutoff, up = L_cutoff, name = _('Throttle (Left) - OFF/IDLE'), category = _('F-22A HOTAS')},
        {down = R_cutoff, up = R_cutoff, name = _('Throttle (Right) - OFF/IDLE'), category = _('F-22A HOTAS')},
        -- Special Switch Functionality
        {down = Battery, up = Battery, name = _('Battery On/Off'), category = _('F-22A Systems')},
        {down = Battery_T, name = _('Battery Toggle'), category = _('F-22A Systems')},
        {down = MasterArm, up = MasterArm, name = _('Master Arm On/Off'), category = _('F-22A Systems')},
        {down = MasterArm_T, name = _('Master Arm Toggle'), category = _('F-22A Systems')},
        {down = DayNight, up = DayNight, name = _('Day/Night Mode'), category = _('F-22A Systems')},
        {down = DayNight_T, name = _('Day/Night Mode Toggle'), category = _('F-22A Systems')},
        {down = L_GEN, up = L_GEN, name = _('Generator Left On/Off'), category = _('F-22A Systems')},
        {down = L_GEN_T, name = _('Generator Left Toggle'), category = _('F-22A Systems')},
        {down = R_GEN, up = R_GEN, name = _('Generator Right On/Off'), category = _('F-22A Systems')},
        {down = R_GEN_T, name = _('Generator Right Toggle'), category = _('F-22A Systems')},
        {down = AAR, up = AAR, name = _('Air-Air Refuel Open/Close'), category = _('F-22A Systems')},
        {down = AAR_T, name = _('Air-Air Refuel Toggle'), category = _('F-22A Systems')},
        {down = Park, up = Park, name = _('Parking Brake On/Off'), category = _('F-22A Systems')},
        {down = Park_T, name = _('Parking Brake Toggle'), category = _('F-22A Systems')},
        {down = LIGHT_TAXI, up = LIGHT_TAXI, name = _('Taxi Light On/Off'), category = _('F-22A Systems')},   
        {down = LIGHT_TAXI_T, name = _('Taxi Light Toggle'), category = _('F-22A Systems')},
        {down = LIGHT_LANDING, up = LIGHT_LANDING, name = _('Landing Light On/Off'), category = _('F-22A Systems')},   
        {down = LIGHT_LANDING_T, name = _('Landing Light Toggle'), category = _('F-22A Systems')},   
        -- EFM Systems
        {down = 95, name = "F-22: Trim Up", category = "Flight Control"},
        {down = 96, name = "F-22: Trim Down", category = "Flight Control"},
        {down = 97, name = "F-22: Reset Trim", category = "Flight Control"},
        {down = 10500, value_down = 1.0, name = _('F-22: Altitude Hold Toggle'), category = _('F-22 EFM Commands')},
        {down = 10501, value_down = 1.0, name = _('F-22: Attitude Hold Toggle'), category = _('F-22 EFM Commands')},
        {down = 10502, value_down = 1.0, name = _('F-22: Auto Throttle Toggle'), category = _('F-22 EFM Commands')},
        {down = 10503, value_down = 1.0, name = _('F-22: Autopilot Disengage'), category = _('F-22 EFM Commands')},
		{ down = 10505, name = _("Taxi Lights Toggle"), category = _("External Lights") },
		{ down = 10506, name = _("Landing Lights Toggle"), category = _("External Lights") },
		{ down = 10507, name = _("Formation Light Toggle"), category = _("External Lights") },
		{ down = 10508, name = _("Navigation White Light Toggle"), category = _("External Lights") },
		{ down = 10509, name = _("Anti-Collision Light Toggle"), category = _("External Lights") },
		{ down = 10510, name = _("AAR Light Toggle"), category = _("External Lights") },
		{ down = 10511, name = _("Navigation Lights Toggle"), category = _("External Lights") },
		{ down = 10512, name = _("Master External Lights Toggle"), category = _("External Lights") },
        -- Systems (base)
        {down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = _('Systems')},
        {down = iCommandPlaneJettisonFuelTanks, name = _('Jettison Fuel Tanks'), category = _('Systems')},
        {down = iCommandPlane_HOTAS_NoseWheelSteeringButton, up = iCommandPlane_HOTAS_NoseWheelSteeringButton, name = _('Nose Gear Maneuvering Range'), category = _('Systems')},
        {down = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, up = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, name = _('Nose Wheel Steering'), category = _('Systems')},
        {down = iCommandPlaneWheelBrakeLeftOn, up = iCommandPlaneWheelBrakeLeftOff, name = _('Wheel Brake Left On/Off'), category = _('Systems')},
        {down = iCommandPlaneWheelBrakeRightOn, up = iCommandPlaneWheelBrakeRightOff, name = _('Wheel Brake Right On/Off'), category = _('Systems')},  
        -- Modes
        {down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
        {down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
        {down = iCommandPlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
        {down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode/FLOOD mode'), category = _('Modes')},
        -- Sensors
        {down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
        {down = iCommandSensorReset, name = _('Radar - Return To Search/NDTWS'), category = _('Sensors')},
        {down = iCommandRefusalTWS, name = _('Unlock TWS Target'), category = _('Sensors')},
        {down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
        {down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
        {down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
        {down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},
        {pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
        {pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
        {pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
        {pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
        {pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
        {pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
        {pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
        {pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
        {down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
        {down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
        {down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
        {down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
        {pressed = iCommandPlaneIncreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Increase'), category = _('Sensors')},
        {pressed = iCommandPlaneDecreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Decrease'), category = _('Sensors')},
        {down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
        {down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
        {down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},
        -- Weapons (base)
        {down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
        {down = iCommandChangeGunRateOfFire, name = _('Cannon Rate Of Fire / Cut Of Burst select'), category = _('Weapons')},
        -- Gameplay (base)
        {down = iCommandPlaneShipTakeOff, name = _('Ship Take Off Position'), category = _('General'), features = {"shiptakeoff"}},
        {down = iCommandCockpitShowPilotOnOff, name = _('Show Pilot Body'), category = _('General')},
        -- Flight Control (base)
        {down = iCommandPlaneUpStart, up = iCommandPlaneUpStop, name = _('Aircraft Pitch Down'), category = _('Flight Control')},
        {down = iCommandPlaneDownStart, up = iCommandPlaneDownStop, name = _('Aircraft Pitch Up'), category = _('Flight Control')},
        {down = iCommandPlaneLeftStart, up = iCommandPlaneLeftStop, name = _('Aircraft Bank Left'), category = _('Flight Control')},
        {down = iCommandPlaneRightStart, up = iCommandPlaneRightStop, name = _('Aircraft Bank Right'), category = _('Flight Control')},
        {down = iCommandPlaneLeftRudderStart, up = iCommandPlaneLeftRudderStop, name = _('Aircraft Rudder Left'), category = _('Flight Control')},
        {down = iCommandPlaneRightRudderStart, up = iCommandPlaneRightRudderStop, name = _('Aircraft Rudder Right'), category = _('Flight Control')},
        {pressed = iCommandPlaneTrimUp, up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'), category = _('Flight Control')},
        {pressed = iCommandPlaneTrimDown, up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'), category = _('Flight Control')},
        {pressed = iCommandPlaneTrimLeft, up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'), category = _('Flight Control')},
        {pressed = iCommandPlaneTrimRight, up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'), category = _('Flight Control')},
        {pressed = iCommandPlaneTrimLeftRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'), category = _('Flight Control')},
        {pressed = iCommandPlaneTrimRightRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'), category = _('Flight Control')},
        {pressed = iCommandThrottleIncrease, up = iCommandThrottleStop, name = _('Throttle Up'), category = _('Flight Control')},
        {pressed = iCommandThrottleDecrease, up = iCommandThrottleStop, name = _('Throttle Down'), category = _('Flight Control')},
        {pressed = iCommandThrottle1Increase, up = iCommandThrottle1Stop, name = _('Throttle Left Up'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        {pressed = iCommandThrottle1Decrease, up = iCommandThrottle1Stop, name = _('Throttle Left Down'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        {pressed = iCommandThrottle2Increase, up = iCommandThrottle2Stop, name = _('Throttle Right Up'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        {pressed = iCommandThrottle2Decrease, up = iCommandThrottle2Stop, name = _('Throttle Right Down'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        {down = iCommandPlaneAUTIncreaseRegime, name = _('Throttle Step Up'), category = _('Flight Control')},
        {down = iCommandPlaneAUTDecreaseRegime, name = _('Throttle Step Down'), category = _('Flight Control')},
        {down = iCommandPlaneAUTIncreaseRegimeLeft, name = _('Throttle Step Up Left'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        {down = iCommandPlaneAUTDecreaseRegimeLeft, name = _('Throttle Step Down Left'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        {down = iCommandPlaneAUTIncreaseRegimeRight, name = _('Throttle Step Up Right'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        {down = iCommandPlaneAUTDecreaseRegimeRight, name = _('Throttle Step Down Right'), category = _('Flight Control'), features = {"TwinEngineAircraft"}},
        -- Systems (base continued)
        {down = iCommandPowerOnOff, name = _('Electric Power Switch'), category = _('Systems')},
        {down = iCommandPlaneAirBrake, name = _('Airbrake'), category = _('Systems'), features = {"airbrake"}},
        {down = iCommandPlaneAirBrakeOn, name = _('Airbrake On'), category = _('Systems'), features = {"airbrake"}},
        {down = iCommandPlaneAirBrakeOff, name = _('Airbrake Off'), category = _('Systems'), features = {"airbrake"}},
        {down = iCommandPlaneWingtipSmokeOnOff, name = _('Smoke'), category = _('Systems'), features = {"smoke"}},
        {down = iCommandPlaneCockpitIllumination, name = _('Illumination Cockpit'), category = _('Systems')},
        {down = iCommandPlaneLightsOnOff, name = _('Navigation lights'), category = _('Systems')},
        {down = iCommandPlaneHeadLightOnOff, name = _('Gear Light Near/Far/Off'), category = _('Systems')},
        {down = iCommandPlaneFlaps, name = _('Flaps Up/Down'), category = _('Systems')},
        {down = iCommandPlaneFlapsOn, name = _('Flaps Landing Position'), category = _('Systems')},
        {down = iCommandPlaneFlapsOff, name = _('Flaps Up'), category = _('Systems')},
        {down = iCommandPlaneGear, name = _('Landing Gear Up/Down'), category = _('Systems')},
        {down = iCommandPlaneGearUp, name = _('Landing Gear Up'), category = _('Systems')},
        {down = iCommandPlaneGearDown, name = _('Landing Gear Down'), category = _('Systems')},
        {down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff, name = _('Wheel Brake On'), category = _('Systems')},
        {down = iCommandPlaneFonar, name = _('Canopy Open/Close'), category = _('Systems')},
        {down = iCommandPlaneParachute, name = _('Dragging Chute'), category = _('Systems'), features = {"dragchute"}},
        {down = iCommandPlaneResetMasterWarning, name = _('Audible Warning Reset'), category = _('Systems'), features = {"modern"}},
        {down = iCommandPlaneJettisonWeapons, up = iCommandPlaneJettisonWeaponsUp, name = _('Weapons Jettison'), category = _('Systems')},
        {down = iCommandPlaneEject, name = _('Eject (3 times)'), category = _('Systems')},
        {down = iCommandFlightClockReset, name = _('Flight Clock Start/Stop/Reset'), category = _('Systems'), features = {"flightclock", "flightclockstart"}},
        {down = iCommandClockElapsedTimeReset, name = _('Elapsed Time Clock Start/Stop/Reset'), category = _('Systems'), features = {"flightclock"}},
        {down = iCommandEnginesStart, name = _('Engines Start'), category = _('Systems')},
        {down = iCommandEnginesStop, name = _('Engines Stop'), category = _('Systems')},
        {down = iCommandLeftEngineStart, name = _('Engine Left Start'), category = _('Systems'), features = {"TwinEngineAircraft"}},
        {down = iCommandLeftEngineStop, name = _('Engine Left Stop'), category = _('Systems'), features = {"TwinEngineAircraft"}},
        {down = iCommandRightEngineStart, name = _('Engine Right Start'), category = _('Systems'), features = {"TwinEngineAircraft"}},
        {down = iCommandRightEngineStop, name = _('Engine Right Stop'), category = _('Systems'), features = {"TwinEngineAircraft"}},
        {down = iCommandBrightnessILS, name = _('HUD Color'), category = _('Systems'), features = {"HUDcolor"}},
        {pressed = iCommandHUDBrightnessUp, name = _('HUD Brightness up'), category = _('Systems'), features = {"HUDbrightness"}},
        {pressed = iCommandHUDBrightnessDown, name = _('HUD Brightness down'), category = _('Systems'), features = {"HUDbrightness"}},
        {down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff, name = _('Fuel Dump'), category = _('Systems'), features = {"fueldump"}},
        {pressed = iCommandAltimeterPressureIncrease, up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Increase'), category = _('Systems')},
        {pressed = iCommandAltimeterPressureDecrease, up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Decrease'), category = _('Systems')},
        -- Modes (base continued)
        {down = iCommandPlaneChangeTarget, name = _('Next Waypoint, Airfield Or Target'), category = _('Modes')},
        {down = iCommandPlaneUFC_STEER_DOWN, name = _('Previous Waypoint, Airfield Or Target'), category = _('Modes')},
        {combos = defaultDeviceAssignmentFor("plane_mode_nav"), down = iCommandPlaneModeNAV, name = _('(1) Navigation Modes'), category = _('Modes')},
        {combos = defaultDeviceAssignmentFor("plane_mode_bvr"), down = iCommandPlaneModeBVR, name = _('(2) Air-to-Air Beyond Visual Range Modes'), category = _('Modes'), features = {"a2aBVR"}},
        {combos = defaultDeviceAssignmentFor("plane_mode_ground"), down = iCommandPlaneModeGround, name = _('(7) Air-to-Ground Modes'), category = _('Modes'), features = {"a2g"}},
        -- Weapons (base continued)
        {combos = defaultDeviceAssignmentFor("fire"), down = iCommandPlaneFire, up = iCommandPlaneFireOff, name = _('Weapon Fire'), category = _('Weapons')},
        {combos = {{key = 'JOY_BTN4'}}, down = iCommandPlaneChangeWeapon, name = _('Weapon Change'), category = _('Weapons')},
        {combos = {{key = 'JOY_BTN5'}}, down = iCommandPlaneModeCannon, name = _('Cannon'), category = _('Weapons')},
        {down = iCommandPlaneLaunchPermissionOverride, name = _('Launch Permission Override'), category = _('Weapons'), features = {"LaunchPermissionOverride"}},
        -- Countermeasures
        {down = iCommandPlaneDropSnar, name = _('Countermeasures Continuously Dispense'), category = _('Countermeasures'), features = {"Countermeasures"}},
        {down = iCommandPlaneDropSnarOnce, up = iCommandPlaneDropSnarOnceOff, name = _('Countermeasures Release'), category = _('Countermeasures'), features = {"Countermeasures"}},
        {down = iCommandPlaneDropFlareOnce, name = _('Countermeasures Flares Dispense'), category = _('Countermeasures'), features = {"Countermeasures"}},
        {down = iCommandPlaneDropChaffOnce, name = _('Countermeasures Chaff Dispense'), category = _('Countermeasures'), features = {"Countermeasures"}},
        {down = iCommandActiveJamming, name = _('ECM'), category = _('Countermeasures'), features = {"ECM"}},
        -- Communications
        {down = iCommandAWACSTankerBearing, name = _('Request AWACS Available Tanker'), category = _('Communications')},
        {down = iCommandToggleReceiveMode, name = _('Receive Mode'), category = _('Communications')},
        -- Cockpit Camera Motion
        {down = iCommandViewLeftMirrorOn, up = iCommandViewLeftMirrorOff, name = _('Mirror Left On'), category = _('View Cockpit'), features = {"Mirrors"}},
        {down = iCommandViewRightMirrorOn, up = iCommandViewRightMirrorOff, name = _('Mirror Right On'), category = _('View Cockpit'), features = {"Mirrors"}},
        {down = iCommandToggleMirrors, name = _('Toggle Mirrors'), category = _('View Cockpit'), features = {"Mirrors"}},
        -- Common Joystick Bindings
        {down = iCommandScoresWindowToggle, name = _('Score window'), category = _('General')},
        {down = iCommandInfoOnOff, name = _('Info bar view toggle'), category = _('General')},
        {down = iCommandRecoverHuman, name = _('Get new plane - respawn'), category = _('General')},
        {down = iCommandPlaneJump, name = _('Jump into selected aircraft'), category = _('General')},
        {down = iCommandViewCoordinatesInLinearUnits, name = _('Info bar coordinate units toggle'), category = _('General')},
        {down = iCommandCockpitClickModeOnOff, name = _('Clickable mouse cockpit mode On/Off'), category = _('General')},
        {down = iCommandSoundOnOff, name = _('Sound On/Off'), category = _('General')},
        {down = iCommandMissionResourcesManagement, name = _('Rearming and Refueling Window'), category = _('General')},
        {down = iCommandViewBriefing, name = _('View briefing on/off'), category = _('General')},
        {down = iCommandPlane_ShowControls, name = _('Show controls indicator'), category = _('General')},
        -- Communications (continued)
        {down = iCommandPlaneDoAndHome, name = _('Flight - Complete mission and RTB'), category = _('Communications')},
        {down = iCommandPlaneReturnToBase, name = _('Flight - RTB'), category = _('Communications')},
        {down = iCommandPlaneDoAndBack, name = _('Flight - Complete mission and rejoin'), category = _('Communications')},
        {down = iCommandPlaneFormation, name = _('Toggle Formation'), category = _('Communications')},
        {down = iCommandPlaneJoinUp, name = _('Join Up Formation'), category = _('Communications')},
        {down = iCommandPlaneAttackMyTarget, name = _('Attack My Target'), category = _('Communications')},
        {down = iCommandPlaneCoverMySix, name = _('Cover Me'), category = _('Communications')},
        {down = iCommandAWACSHomeBearing, name = _('Request AWACS Home Airbase'), category = _('Communications')},
        {down = iCommandAWACSBanditBearing, name = _('Request AWACS Bogey Dope'), category = _('Communications'), features = {"AWACS Bogey Dope"}},
        {down = iCommandPlane_EngageGroundTargets, name = _('Flight - Attack ground targets'), category = _('Communications')},
        {down = iCommandPlane_EngageAirDefenses, name = _('Flight - Attack air defenses'), category = _('Communications')},
        {down = iCommandPlane_EngageBandits, name = _('Flight - Engage Bandits'), category = _('Communications')},
        {down = iCommandToggleCommandMenu, name = _('Communication menu'), category = _('Communications')},
        {down = ICommandSwitchDialog, name = _('Switch dialog'), category = _('Communications')},
        {down = ICommandSwitchToCommonDialog, name = _('Switch to main menu'), category = _('Communications')},
        -- View
        {combos = {{key = 'JOY_BTN_POV1_L'}}, pressed = iCommandViewLeftSlow, up = iCommandViewStopSlow, name = _('View Left slow'), category = _('View')},
        {combos = {{key = 'JOY_BTN_POV1_R'}}, pressed = iCommandViewRightSlow, up = iCommandViewStopSlow, name = _('View Right slow'), category = _('View')},
        {combos = {{key = 'JOY_BTN_POV1_U'}}, pressed = iCommandViewUpSlow, up = iCommandViewStopSlow, name = _('View Up slow'), category = _('View')},
        {combos = {{key = 'JOY_BTN_POV1_D'}}, pressed = iCommandViewDownSlow, up = iCommandViewStopSlow, name = _('View Down slow'), category = _('View')},
        {combos = {{key = 'JOY_BTN_POV1_UR'}}, pressed = iCommandViewUpRightSlow, up = iCommandViewStopSlow, name = _('View Up Right slow'), category = _('View')},
        {combos = {{key = 'JOY_BTN_POV1_DR'}}, pressed = iCommandViewDownRightSlow, up = iCommandViewStopSlow, name = _('View Down Right slow'), category = _('View')},
        {combos = {{key = 'JOY_BTN_POV1_DL'}}, pressed = iCommandViewDownLeftSlow, up = iCommandViewStopSlow, name = _('View Down Left slow'), category = _('View')},
        {combos = {{key = 'JOY_BTN_POV1_UL'}}, pressed = iCommandViewUpLeftSlow, up = iCommandViewStopSlow, name = _('View Up Left slow'), category = _('View')},
        {pressed = iCommandViewCenter, name = _('View Center'), category = _('View')},
        {pressed = iCommandViewForwardSlow, up = iCommandViewForwardSlowStop, name = _('Zoom in slow'), category = _('View')},
        {pressed = iCommandViewBackSlow, up = iCommandViewBackSlowStop, name = _('Zoom out slow'), category = _('View')},
        {down = iCommandViewAngleDefault, name = _('Zoom normal'), category = _('View')},
        {pressed = iCommandViewExternalZoomIn, up = iCommandViewExternalZoomInStop, name = _('Zoom external in'), category = _('View')},
        {pressed = iCommandViewExternalZoomOut, up = iCommandViewExternalZoomOutStop, name = _('Zoom external out'), category = _('View')},
        {down = iCommandViewExternalZoomDefault, name = _('Zoom external normal'), category = _('View')},
        {down = iCommandViewSpeedUp, name = _('F11 Camera moving forward'), category = _('View')},
        {down = iCommandViewSlowDown, name = _('F11 Camera moving backward'), category = _('View')},
        {down = iCommandViewCockpit, name = _('F1 Cockpit view'), category = _('View')},
        {down = iCommandNaturalViewCockpitIn, name = _('F1 Natural head movement view'), category = _('View')},
        {down = iCommandViewHUDOnlyOnOff, name = _('F1 HUD only view switch'), category = _('View')},
        {down = iCommandViewAir, name = _('F2 Aircraft view'), category = _('View')},
        {down = iCommandViewMe, name = _('F2 View own aircraft'), category = _('View')},
        {down = iCommandViewFromTo, name = _('F2 Toggle camera position'), category = _('View')},
        {down = iCommandViewLocal, name = _('F2 Toggle local camera control'), category = _('View')},
        {down = iCommandViewTower, name = _('F3 Fly-By view'), category = _('View')},
        {down = iCommandViewTowerJump, name = _('F3 Fly-By jump view'), category = _('View')},
        {down = iCommandViewRear, name = _('F4 Camera mounted on object'), category = _('View')},
        {down = iCommandViewChase, name = _('F4 Chase view'), category = _('View')},
        {down = iCommandViewChaseArcade, name = _('F4 Arcade Chase view'), category = _('View')},
        {down = iCommandViewFight, name = _('F5 nearest AC view'), category = _('View')},
        {down = iCommandViewFightGround, name = _('F5 Ground hostile view'), category = _('View')},
        {down = iCommandViewWeapons, name = _('F6 Released weapon view'), category = _('View')},
        {down = iCommandViewWeaponAndTarget, name = _('F6 Weapon to target view'), category = _('View')},
        {down = iCommandViewGround, name = _('F7 Ground unit view'), category = _('View')},
        {down = iCommandViewNavy, name = _('F9 Ship view'), category = _('View')},
        {down = iCommandViewLndgOfficer, name = _('F9 Landing signal officer view'), category = _('View')},
        {down = iCommandViewAWACS, name = _('F10 Theater map view'), category = _('View')},
        {down = iCommandViewAWACSJump, name = _('F10 Jump to theater map view over current point'), category = _('View')},
        {down = iCommandViewFree, name = _('F11 Airport free camera'), category = _('View')},
        {down = iCommandViewFreeJump, name = _('F11 Jump to free camera'), category = _('View')},
        {down = iCommandViewStatic, name = _('F12 Static object view'), category = _('View')},
        {down = iCommandViewMirage, name = _('F12 Civil traffic view'), category = _('View')},
        {down = iCommandViewLocomotivesToggle, name = _('F12 Trains/cars toggle'), category = _('View')},
        {down = iCommandViewPitHeadOnOff, name = _('F1 Head shift movement on / off'), category = _('View')},
        {down = iCommandViewFastKeyboard, name = _('Keyboard Rate Fast'), category = _('View')},
        {down = iCommandViewSlowKeyboard, name = _('Keyboard Rate Slow'), category = _('View')},
        {down = iCommandViewNormalKeyboard, name = _('Keyboard Rate Normal'), category = _('View')},
        {down = iCommandViewFastMouse, name = _('Mouse Rate Fast'), category = _('View')},
        {down = iCommandViewSlowMouse, name = _('Mouse Rate Slow'), category = _('View')},
        {down = iCommandViewNormalMouse, name = _('Mouse Rate Normal'), category = _('View')},
        -- Cockpit view
        {down = 3256, cockpit_device_id = 0, value_down = 1.0, name = _('Flashlight'), category = _('View Cockpit')},
        {down = iCommandViewTempCockpitOn, up = iCommandViewTempCockpitOff, name = _('Cockpit panel view in'), category = _('View Cockpit')},
        {down = iCommandViewTempCockpitToggle, name = _('Cockpit panel view toggle'), category = _('View Cockpit')},
        {down = iCommandViewSaveAngles, name = _('Save Cockpit Angles'), category = _('View Cockpit')},
        {pressed = iCommandViewUp, up = iCommandViewStop, name = _('View up'), category = _('View Cockpit')},
        {pressed = iCommandViewDown, up = iCommandViewStop, name = _('View down'), category = _('View Cockpit')},
        {pressed = iCommandViewLeft, up = iCommandViewStop, name = _('View left'), category = _('View Cockpit')},
        {pressed = iCommandViewRight, up = iCommandViewStop, name = _('View right'), category = _('View Cockpit')},
        {pressed = iCommandViewUpRight, up = iCommandViewStop, name = _('View up right'), category = _('View Cockpit')},
        {pressed = iCommandViewDownRight, up = iCommandViewStop, name = _('View down right'), category = _('View Cockpit')},
        {pressed = iCommandViewDownLeft, up = iCommandViewStop, name = _('View down left'), category = _('View Cockpit')},
        {pressed = iCommandViewUpLeft, up = iCommandViewStop, name = _('View up left'), category = _('View Cockpit')},
        {pressed = iCommandViewPitCameraMoveUp, up = iCommandViewPitCameraMoveStop, name = _('Cockpit Camera Move Up'), category = _('View Cockpit')},
        {pressed = iCommandViewPitCameraMoveDown, up = iCommandViewPitCameraMoveStop, name = _('Cockpit Camera Move Down'), category = _('View Cockpit')},
        {pressed = iCommandViewPitCameraMoveLeft, up = iCommandViewPitCameraMoveStop, name = _('Cockpit Camera Move Left'), category = _('View Cockpit')},
        {pressed = iCommandViewPitCameraMoveRight, up = iCommandViewPitCameraMoveStop, name = _('Cockpit Camera Move Right'), category = _('View Cockpit')},
        {pressed = iCommandViewPitCameraMoveForward, up = iCommandViewPitCameraMoveStop, name = _('Cockpit Camera Move Forward'), category = _('View Cockpit')},
        {pressed = iCommandViewPitCameraMoveBack, up = iCommandViewPitCameraMoveStop, name = _('Cockpit Camera Move Back'), category = _('View Cockpit')},
        {down = iCommandViewPitCameraMoveCenter, name = _('Cockpit Camera Move Center'), category = _('View Cockpit')},
        {down = iCommandViewTransposeModeOn, up = iCommandViewTransposeModeOff, name = _('Camera transpose mode (press and hold)'), category = _('View Cockpit')},
        {down = iCommandViewCameraUp, up = iCommandViewCameraCenter, name = _('Glance up'), category = _('View Cockpit')},
        {down = iCommandViewCameraDown, up = iCommandViewCameraCenter, name = _('Glance down'), category = _('View Cockpit')},
        {down = iCommandViewCameraLeft, up = iCommandViewCameraCenter, name = _('Glance left'), category = _('View Cockpit')},
        {down = iCommandViewCameraRight, up = iCommandViewCameraCenter, name = _('Glance right'), category = _('View Cockpit')},
        {down = iCommandViewCameraUpLeft, up = iCommandViewCameraCenter, name = _('Glance up-left'), category = _('View Cockpit')},
        {down = iCommandViewCameraDownLeft, up = iCommandViewCameraCenter, name = _('Glance down-left'), category = _('View Cockpit')},
        {down = iCommandViewCameraUpRight, up = iCommandViewCameraCenter, name = _('Glance up-right'), category = _('View Cockpit')},
        {down = iCommandViewCameraDownRight, up = iCommandViewCameraCenter, name = _('Glance down-right'), category = _('View Cockpit')},
        {down = iCommandViewPanToggle, name = _('Camera pan mode toggle'), category = _('View Cockpit')},
        {down = iCommandViewCameraUpSlow, name = _('Camera snap view up'), category = _('View Cockpit')},
        {down = iCommandViewCameraDownSlow, name = _('Camera snap view down'), category = _('View Cockpit')},
        {down = iCommandViewCameraLeftSlow, name = _('Camera snap view left'), category = _('View Cockpit')},
        {down = iCommandViewCameraRightSlow, name = _('Camera snap view right'), category = _('View Cockpit')},
        {down = iCommandViewCameraUpLeftSlow, name = _('Camera snap view up-left'), category = _('View Cockpit')},
        {down = iCommandViewCameraDownLeftSlow, name = _('Camera snap view down-left'), category = _('View Cockpit')},
        {down = iCommandViewCameraUpRightSlow, name = _('Camera snap view up-right'), category = _('View Cockpit')},
        {down = iCommandViewCameraDownRightSlow, name = _('Camera snap view down-right'), category = _('View Cockpit')},
        {down = iCommandViewCameraCenter, name = _('Center Camera View'), category = _('View')},
        {down = iCommandViewCameraReturn, name = _('Return Camera'), category = _('View')},
        {down = iCommandViewCameraBaseReturn, name = _('Return Camera Base'), category = _('View')},
        {down = iCommandViewSnapView0, up = iCommandViewSnapViewStop, name = _('Custom Snap View  0'), category = _('View Cockpit')},
        {down = iCommandViewSnapView1, up = iCommandViewSnapViewStop, name = _('Custom Snap View  1'), category = _('View Cockpit')},
        {down = iCommandViewSnapView2, up = iCommandViewSnapViewStop, name = _('Custom Snap View  2'), category = _('View Cockpit')},
        {down = iCommandViewSnapView3, up = iCommandViewSnapViewStop, name = _('Custom Snap View  3'), category = _('View Cockpit')},
        {down = iCommandViewSnapView4, up = iCommandViewSnapViewStop, name = _('Custom Snap View  4'), category = _('View Cockpit')},
        {down = iCommandViewSnapView5, up = iCommandViewSnapViewStop, name = _('Custom Snap View  5'), category = _('View Cockpit')},
        {down = iCommandViewSnapView6, up = iCommandViewSnapViewStop, name = _('Custom Snap View  6'), category = _('View Cockpit')},
        {down = iCommandViewSnapView7, up = iCommandViewSnapViewStop, name = _('Custom Snap View  7'), category = _('View Cockpit')},
        {down = iCommandViewSnapView8, up = iCommandViewSnapViewStop, name = _('Custom Snap View  8'), category = _('View Cockpit')},
        {down = iCommandViewSnapView9, up = iCommandViewSnapViewStop, name = _('Custom Snap View  9'), category = _('View Cockpit')},
        {pressed = iCommandViewForward, up = iCommandViewForwardStop, name = _('Zoom in'), category = _('View Cockpit')},
        {pressed = iCommandViewBack, up = iCommandViewBackStop, name = _('Zoom out'), category = _('View Cockpit')},
        -- Extended view
        {down = iCommandViewCameraJiggle, name = _('Camera jiggle toggle'), category = _('View Extended')},
        {down = iCommandViewKeepTerrain, name = _('Keep terrain camera altitude'), category = _('View Extended')},
        {down = iCommandViewFriends, name = _('View friends mode'), category = _('View Extended')},
        {down = iCommandViewEnemies, name = _('View enemies mode'), category = _('View Extended')},
        {down = iCommandViewAll, name = _('View all mode'), category = _('View Extended')},
        {down = iCommandViewPlus, name = _('Toggle tracking launched weapon'), category = _('View Extended')},
        {down = iCommandViewSwitchForward, name = _('Objects switching direction forward '), category = _('View Extended')},
        {down = iCommandViewSwitchReverse, name = _('Objects switching direction reverse '), category = _('View Extended')},
        {down = iCommandViewObjectIgnore, name = _('Object exclude '), category = _('View Extended')},
        {down = iCommandViewObjectsAll, name = _('Objects all excluded - include'), category = _('View Extended')},
        -- Padlock
        {down = iCommandViewLock, name = _('Lock View (cycle padlock)'), category = _('View Padlock')},
        {down = iCommandViewUnlock, name = _('Unlock view (stop padlock)'), category = _('View Padlock')},
        {down = iCommandAllMissilePadlock, name = _('All missiles padlock'), category = _('View Padlock')},
        {down = iCommandThreatMissilePadlock, name = _('Threat missile padlock'), category = _('View Padlock')},
        {down = iCommandViewTerrainLock, name = _('Lock terrain view'), category = _('View Padlock')},
        -- Labels
        {down = iCommandMarkerState, name = _('All Labels'), category = _('Labels')},
        {down = iCommandMarkerStatePlane, name = _('Aircraft Labels'), category = _('Labels')},
        {down = iCommandMarkerStateRocket, name = _('Missile Labels'), category = _('Labels')},
        {down = iCommandMarkerStateShip, name = _('Vehicle & Ship Labels'), category = _('Labels')},
        -- Kneeboard
        {down = iCommandPlaneShowKneeboard, name = _('Kneeboard ON/OFF'), category = _('Kneeboard')},
        {down = iCommandPlaneShowKneeboard, up = iCommandPlaneShowKneeboard, value_down = 1.0, value_up = -1.0, name = _('Kneeboard glance view'), category = _('Kneeboard')},
        {down = 3001, cockpit_device_id = kneeboard_id, value_down = 1.0, name = _('Kneeboard Next Page'), category = _('Kneeboard')},
        {down = 3002, cockpit_device_id = kneeboard_id, value_down = 1.0, name = _('Kneeboard Previous Page'), category = _('Kneeboard')},
        {down = 3003, cockpit_device_id = kneeboard_id, value_down = 1.0, name = _('Kneeboard current position mark point'), category = _('Kneeboard')},
        {down = 3004, cockpit_device_id = kneeboard_id, value_down = 1.0, name = _('Kneeboard Make Shortcut'), category = _('Kneeboard')},
        {down = 3005, cockpit_device_id = kneeboard_id, value_down = 1.0, name = _('Kneeboard Next Shortcut'), category = _('Kneeboard')},
        {down = 3005, cockpit_device_id = kneeboard_id, value_down = -1.0, name = _('Kneeboard Previous Shortcut'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 0, name = _('Kneeboard Jump To Shortcut  1'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 1, name = _('Kneeboard Jump To Shortcut  2'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 2, name = _('Kneeboard Jump To Shortcut  3'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 3, name = _('Kneeboard Jump To Shortcut  4'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 4, name = _('Kneeboard Jump To Shortcut  5'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 5, name = _('Kneeboard Jump To Shortcut  6'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 6, name = _('Kneeboard Jump To Shortcut  7'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 7, name = _('Kneeboard Jump To Shortcut  8'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 8, name = _('Kneeboard Jump To Shortcut  9'), category = _('Kneeboard')},
        {down = iCommandPlaneKneeboardJumpBookmark, value_down = 9, name = _('Kneeboard Jump To Shortcut 10'), category = _('Kneeboard')},
		
		
    },

    axisCommands = {
        {action = iCommandViewHorizontalAbs, name = _('Absolute Camera Horizontal View')},
        {action = iCommandViewVerticalAbs, name = _('Absolute Camera Vertical View')},
        {action = iCommandViewZoomAbs, name = _('Zoom View')},
        {action = iCommandViewRollAbs, name = _('Absolute Roll Shift Camera View')},
        {action = iCommandViewHorTransAbs, name = _('Absolute Horizontal Shift Camera View')},
        {action = iCommandViewVertTransAbs, name = _('Absolute Vertical Shift Camera View')},
        {action = iCommandViewLongitudeTransAbs, name = _('Absolute Longitude Shift Camera View')},
        {combos = defaultDeviceAssignmentFor("roll"), action = iCommandPlaneRoll, name = _('Roll')},
        {combos = defaultDeviceAssignmentFor("pitch"), action = iCommandPlanePitch, name = _('Pitch')},
        {combos = defaultDeviceAssignmentFor("rudder"), action = iCommandPlaneRudder, name = _('Rudder')},
        {combos = thrust_common, action = iCommandPlaneThrustCommon, name = _('Thrust')},
        {combos = thrust_left, action = iCommandPlaneThrustLeft, name = _('Thrust Left'), features = {"TwinEngineAircraft"}},
        {combos = thrust_right, action = iCommandPlaneThrustRight, name = _('Thrust Right'), features = {"TwinEngineAircraft"}},
        --{combos = thrust_left, action = iCommandPlaneThrottleAxisLeft, name = _('F-22: Thrust Left')},
        --{combos = thrust_right, action = iCommandPlaneThrottleAxisRight, name = _('F-22: Thrust Right')},
		--{action = 2005, name = _('F-22: Thrust Left'), category = _('Flight Control'), features = {"TwinEngineAircraft"}}, -- ThrottleAxisLeft
		--{action = 2006, name = _('F-22: Thrust Right'), category = _('Flight Control'), features = {"TwinEngineAircraft"}}, -- ThrottleAxisRight
		
        -- F-22A Custom Axis
        {action = B_BRAKE, name = _('F-22: Wheel Brake Both')},
        {action = L_BRAKE, name = _('F-22: Wheel Brake Left')},
        {action = R_BRAKE, name = _('F-22: Wheel Brake Right')},
        -- Core
        {action = iCommandPlaneSelecterHorizontalAbs, name = _('TDC Slew Horizontal')},
        {action = iCommandPlaneSelecterVerticalAbs, name = _('TDC Slew Vertical')},
        {action = iCommandPlaneRadarHorizontalAbs, name = _('Radar Horizontal')},
        {action = iCommandPlaneRadarVerticalAbs, name = _('Radar Vertical')},
        {action = iCommandPlaneMFDZoomAbs, name = _('MFD Range')},
        {action = iCommandPlaneBase_DistanceAbs, name = _('Base/Distance')},
    }
}