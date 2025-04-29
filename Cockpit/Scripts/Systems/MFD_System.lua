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


dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local sensor_data		= get_base_data()

local update_time_step = 0.006 --0.006
make_default_activity(update_time_step)

local LMFD = {
    L_OSB_1           = device_commands.Button_1, 
    L_OSB_2           = device_commands.Button_2, 
    L_OSB_3           = device_commands.Button_3, 
    L_OSB_4           = device_commands.Button_4, 
    L_OSB_5           = device_commands.Button_5, 
    L_OSB_6           = device_commands.Button_6, 
    L_OSB_7           = device_commands.Button_7, 
    L_OSB_8           = device_commands.Button_8, 
    L_OSB_9           = device_commands.Button_9,
    L_OSB_10          = device_commands.Button_10, 
    L_OSB_11          = device_commands.Button_11, 
    L_OSB_12          = device_commands.Button_12, 
    L_OSB_13          = device_commands.Button_13,
    L_OSB_14          = device_commands.Button_14, 
    L_OSB_15          = device_commands.Button_15, 
    L_OSB_16          = device_commands.Button_16, 
    L_OSB_17          = device_commands.Button_17, 
    L_OSB_18          = device_commands.Button_18,
    L_OSB_19          = device_commands.Button_19,
    L_OSB_20          = device_commands.Button_20,
}
local RMFD = {
    R_OSB_1           = device_commands.Button_21, 
    R_OSB_2           = device_commands.Button_22, 
    R_OSB_3           = device_commands.Button_23, 
    R_OSB_4           = device_commands.Button_24, 
    R_OSB_5           = device_commands.Button_25, 
    R_OSB_6           = device_commands.Button_26, 
    R_OSB_7           = device_commands.Button_27, 
    R_OSB_8           = device_commands.Button_28, 
    R_OSB_9           = device_commands.Button_29,
    R_OSB_10          = device_commands.Button_30, 
    R_OSB_11          = device_commands.Button_31, 
    R_OSB_12          = device_commands.Button_32, 
    R_OSB_13          = device_commands.Button_33,
    R_OSB_14          = device_commands.Button_34, 
    R_OSB_15          = device_commands.Button_35, 
    R_OSB_16          = device_commands.Button_36, 
    R_OSB_17          = device_commands.Button_37, 
    R_OSB_18          = device_commands.Button_38,
    R_OSB_19          = device_commands.Button_39,
    R_OSB_20          = device_commands.Button_40,
}
local CMFD = {
    C_OSB_1           = device_commands.Button_41, 
    C_OSB_2           = device_commands.Button_42, 
    C_OSB_3           = device_commands.Button_43, 
    C_OSB_4           = device_commands.Button_44, 
    C_OSB_5           = device_commands.Button_45, 
    C_OSB_6           = device_commands.Button_46, 
    C_OSB_7           = device_commands.Button_47, 
    C_OSB_8           = device_commands.Button_48, 
    C_OSB_9           = device_commands.Button_49,
    C_OSB_10          = device_commands.Button_50, 
    C_OSB_11          = device_commands.Button_51, 
    C_OSB_12          = device_commands.Button_52, 
    C_OSB_13          = device_commands.Button_53,
    C_OSB_14          = device_commands.Button_54, 
    C_OSB_15          = device_commands.Button_55, 
    C_OSB_16          = device_commands.Button_56, 
    C_OSB_17          = device_commands.Button_57, 
    C_OSB_18          = device_commands.Button_58,
    C_OSB_19          = device_commands.Button_59,
    C_OSB_20          = device_commands.Button_60,
}
local parameters = {
    APU_RPM_STATE		      = get_param_handle("APU_RPM_STATE"),
    MAIN_POWER		          = get_param_handle("MAIN_POWER"),
    MFD_OPACITY		          = get_param_handle("MFD_OPACITY"),
    GROUND_ORIDE              = get_param_handle("GROUND_ORIDE"),
    BAY_OPTION                = get_param_handle("BAY_OPTION"), 
    RPM_L                     = get_param_handle("RPM_L"),
    COORD                     = get_param_handle("COORD"),
    RPM_R                     = get_param_handle("RPM_R"),
    EGT_L                     = get_param_handle("EGT_L"),
    EGT_R                     = get_param_handle("EGT_R"),
    OIL_L                     = get_param_handle("OIL_L"),
    OIL_R                     = get_param_handle("OIL_R"),
    ADI_PITCH                 = get_param_handle("ADI_PITCH"),
    FPM                       = get_param_handle("FPM"),
    FUELT                     = get_param_handle("FUELT"),
    FUEL                      = get_param_handle("FUEL"),
    TANK_OPACITY              = get_param_handle("TANK_OPACITY"),
    FCS_RA                    = get_param_handle("FCS_RA"),
    FCS_LA                    = get_param_handle("FCS_LA"),
    FCS_RR                    = get_param_handle("FCS_RR"),
    FCS_LR                    = get_param_handle("FCS_LR"),
    FCS_RE                    = get_param_handle("FCS_RE"),
    FCS_LE                    = get_param_handle("FCS_LE"),
    FCS_LF                    = get_param_handle("FCS_LF"),
    FCS_RF                    = get_param_handle("FCS_RF"),
    FCS_SB                    = get_param_handle("FCS_SB"),
    FCS_LEF                   = get_param_handle("FCS_LEF"),
    ILSN_VIS                  = get_param_handle("ILSN_VIS"),
    NAV_VIS                   = get_param_handle("NAV_VIS"),
    ILS_FLAG                  = get_param_handle("ILS_FLAG"), 
    ILS_VERT                  = get_param_handle("ILS_VERT"),
    ILS_HORIZON               = get_param_handle("ILS_HORIZON"),
    HSI_COMPASS               = get_param_handle("HSI_COMPASS"),
    HSI_CRS_POINTER           = get_param_handle("HSI_CRS_POINTER"),
    HSI_DEVIATION             = get_param_handle("HSI_DEVIATION"),
    HSI_WP_POINTER            = get_param_handle("HSI_WP_POINTER"),
    ILS_NAV                   = get_param_handle("ILS_NAV"),
    MILE_1                    = get_param_handle("MILE_1"),
    MILE_2                    = get_param_handle("MILE_2"),
    MILE_3                    = get_param_handle("MILE_3"),
    MILE_4                    = get_param_handle("MILE_4"),
    COURSE_1                  = get_param_handle("COURSE_1"),
    COURSE_2                  = get_param_handle("COURSE_2"), 
    COURSE_3                  = get_param_handle("COURSE_3"),
    TO_FROM                   = get_param_handle("TO_FROM"),  
    R_EGT_COLOR               = get_param_handle("R_EGT_COLOR"),
    R_RPM_COLOR               = get_param_handle("R_RPM_COLOR"),
    R_OIL_COLOR               = get_param_handle("R_OIL_COLOR"),
    R_HYD_COLOR               = get_param_handle("R_HYD_COLOR"),
    R_FF_VALUE                = get_param_handle("R_FF_VALUE"),
    R_HYD_VALUE               = get_param_handle("R_HYD_VALUE"),
    R_NOZZLE_POS              = get_param_handle("R_NOZZLE_POS"),
    L_EGT_COLOR               = get_param_handle("L_EGT_COLOR"),
    L_RPM_COLOR               = get_param_handle("L_RPM_COLOR"),
    L_OIL_COLOR               = get_param_handle("L_OIL_COLOR"),
    L_HYD_COLOR               = get_param_handle("L_HYD_COLOR"),
    L_FF_VALUE                = get_param_handle("L_FF_VALUE"),
    L_NOZZLE_POS              = get_param_handle("L_NOZZLE_POS"),
    L_HYD_VALUE               = get_param_handle("L_HYD_VALUE"),
    LMFD_ENG_PAGE             = get_param_handle("LMFD_ENG_PAGE"),
    LMFD_MENU_PAGE            = get_param_handle("LMFD_MENU_PAGE"),
    LMFD_FCS_PAGE             = get_param_handle("LMFD_FCS_PAGE"),
    LMFD_FUEL_PAGE            = get_param_handle("LMFD_FUEL_PAGE"),
    LMFD_ADI_PAGE             = get_param_handle("LMFD_ADI_PAGE"),
    LMFD_BAY_PAGE             = get_param_handle("LMFD_BAY_PAGE"),
    LMFD_CHECKLIST_PAGE       = get_param_handle("LMFD_CHECKLIST_PAGE"),
    LMFD_SMS_PAGE             = get_param_handle("LMFD_SMS_PAGE"),
    LMFD_HSI_PAGE             = get_param_handle("LMFD_HSI_PAGE"),
    LMFD_PAGE                 = get_param_handle("LMFD_PAGE"),
    RMFD_ENG_PAGE             = get_param_handle("RMFD_ENG_PAGE"),
    RMFD_MENU_PAGE            = get_param_handle("RMFD_MENU_PAGE"),
    RMFD_FCS_PAGE             = get_param_handle("RMFD_FCS_PAGE"),
    RMFD_FUEL_PAGE            = get_param_handle("RMFD_FUEL_PAGE"),
    RMFD_ADI_PAGE             = get_param_handle("RMFD_ADI_PAGE"),
    RMFD_BAY_PAGE             = get_param_handle("RMFD_BAY_PAGE"),
    RMFD_CHECKLIST_PAGE       = get_param_handle("RMFD_CHECKLIST_PAGE"),
    RMFD_RWR_PAGE             = get_param_handle("RMFD_RWR_PAGE"),
    RMFD_HSI_PAGE             = get_param_handle("RMFD_HSI_PAGE"),
    RMFD_PAGE                 = get_param_handle("RMFD_PAGE"),
    CMFD_PAGE                 = get_param_handle("CMFD_PAGE"),
    LMFD_MASK                 = get_param_handle("LMFD_MASK"),
    RMFD_MASK                 = get_param_handle("RMFD_MASK"),
    CMFD_MASK                 = get_param_handle("CMFD_MASK"),
    BAY_STATION               = get_param_handle("BAY_STATION"),
    CMFD_ENG_PAGE             = get_param_handle("CMFD_ENG_PAGE"),
    CMFD_MENU_PAGE            = get_param_handle("CMFD_MENU_PAGE"),
    CMFD_FCS_PAGE             = get_param_handle("CMFD_FCS_PAGE"),
    CMFD_FUEL_PAGE            = get_param_handle("CMFD_FUEL_PAGE"),
    CMFD_ADI_PAGE             = get_param_handle("CMFD_ADI_PAGE"),
    CMFD_BAY_PAGE             = get_param_handle("CMFD_BAY_PAGE"),
    CMFD_CHECKLIST_PAGE       = get_param_handle("CMFD_CHECKLIST_PAGE"),
    CMFD_HSI_PAGE             = get_param_handle("CMFD_HSI_PAGE"),
    DOGFIGHT			      = get_param_handle("DOGFIGHT"),
    CABINPRESS			      = get_param_handle("CABINPRESS"),
    HUD_MODE			      = get_param_handle("HUD_MODE"),
    FCS_AUTO                  = get_param_handle("FCS_AUTO"),
    FCS_MODE                  = get_param_handle("FCS_MODE"),
    FCS_STATE                 = get_param_handle("FCS_STATE"),
    DAY_NIGHT	              = get_param_handle("DAY_NIGHT"),
}

dev:listen_command(10000)--Left Bay Select
dev:listen_command(10001)--Right Bay Select
dev:listen_command(10002)--Center Bay Select
dev:listen_command(10003)--All Bay Select
dev:listen_command(10004)--Step Select
dev:listen_command(10005)--Dogfight Mode

dev:listen_command(10061)--LMFD_OSB_01
dev:listen_command(10062)--LMFD_OSB_02
dev:listen_command(10063)--LMFD_OSB_03
dev:listen_command(10064)--LMFD_OSB_04
dev:listen_command(10065)--LMFD_OSB_05
dev:listen_command(10066)--LMFD_OSB_06
dev:listen_command(10067)--LMFD_OSB_07
dev:listen_command(10068)--LMFD_OSB_08
dev:listen_command(10069)--LMFD_OSB_09
dev:listen_command(10070)--LMFD_OSB_10
dev:listen_command(10071)--LMFD_OSB_11
dev:listen_command(10072)--LMFD_OSB_12
dev:listen_command(10073)--LMFD_OSB_13
dev:listen_command(10074)--LMFD_OSB_14
dev:listen_command(10075)--LMFD_OSB_15
dev:listen_command(10076)--LMFD_OSB_16
dev:listen_command(10077)--LMFD_OSB_17
dev:listen_command(10078)--LMFD_OSB_18
dev:listen_command(10079)--LMFD_OSB_19
dev:listen_command(10080)--LMFD_OSB_20

dev:listen_command(10091) --RMFD_OSB_01
dev:listen_command(10092) --RMFD_OSB_02
dev:listen_command(10093) --RMFD_OSB_03
dev:listen_command(10094) --RMFD_OSB_04
dev:listen_command(10095) --RMFD_OSB_05
dev:listen_command(10096) --RMFD_OSB_06
dev:listen_command(10097) --RMFD_OSB_07
dev:listen_command(10098) --RMFD_OSB_08
dev:listen_command(10099) --RMFD_OSB_09
dev:listen_command(10100) --RMFD_OSB_10
dev:listen_command(10101) --RMFD_OSB_11
dev:listen_command(10102) --RMFD_OSB_12
dev:listen_command(10103) --RMFD_OSB_13
dev:listen_command(10104) --RMFD_OSB_14
dev:listen_command(10105) --RMFD_OSB_15
dev:listen_command(10106) --RMFD_OSB_16
dev:listen_command(10107) --RMFD_OSB_17
dev:listen_command(10108) --RMFD_OSB_18
dev:listen_command(10109) --RMFD_OSB_19
dev:listen_command(10110) --RMFD_OSB_20

dev:listen_command(10111)--CMFD_OSB_01
dev:listen_command(10112)--CMFD_OSB_02
dev:listen_command(10113)--CMFD_OSB_03
dev:listen_command(10114)--CMFD_OSB_04
dev:listen_command(10115)--CMFD_OSB_05
dev:listen_command(10116)--CMFD_OSB_06
dev:listen_command(10117)--CMFD_OSB_07
dev:listen_command(10118)--CMFD_OSB_08
dev:listen_command(10119)--CMFD_OSB_09
dev:listen_command(10120)--CMFD_OSB_10
dev:listen_command(10121)--CMFD_OSB_11
dev:listen_command(10122)--CMFD_OSB_12
dev:listen_command(10123)--CMFD_OSB_13
dev:listen_command(10124)--CMFD_OSB_14
dev:listen_command(10125)--CMFD_OSB_15
dev:listen_command(10126)--CMFD_OSB_16
dev:listen_command(10127)--CMFD_OSB_17
dev:listen_command(10128)--CMFD_OSB_18
dev:listen_command(10129)--CMFD_OSB_19
dev:listen_command(10130)--CMFD_OSB_20

local PlaneModeNAV 			= Keys.PlaneModeNAV	--1						
local PlaneModeBVR 			= Keys.PlaneModeBVR	--2						
local PlaneModeVS 			= Keys.PlaneModeVS --3								
local PlaneModeBore 		= Keys.PlaneModeBore --4
local PlaneModeFI0 			= Keys.PlaneModeFI0 --6
local NextSteer			 	= Keys.PlaneChangeTarget--steer point up
local PrevSteer 			= 1315--steer point prev
local ChangeRWRMode         = 286
local PlaneRadarOnOff       = 86
local lmfd_current_page = 1 -- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI
local rmfd_current_page = 3 -- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI
local cmfd_current_page = 5 -- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI

local l_hyd_value           = 0--eng page
local r_hyd_value           = 0--eng page
local ground_oride_state    = 1 --open 0 --closed
local bay_select			= 2 -- 1-left 2-center 3-right 4-all
local forgot_override       = 0
local left_select_mode      = 0
local right_select_mode     = 0 

-- local fcs_mode  = 0
-- local fcs_auto  = 0
-- local fcs_state = 0

-- local fuel_flow_r               = sensor_data.getEngineRightFuelConsumption() * 2.20462
-- local fuel_flow_l               = sensor_data.getEngineLeftFuelConsumption() * 2.20462
------------------------------------------------------------------FUNCTION-POST-INIT---------------------------------------------------------------------------------------------------
function post_initialize()
   -- print_message_to_user("MFD SYSTEM POST INIT")
    local bay_option_state = get_aircraft_property("BAY_DOOR_OPTION")--ME Option Box
    local birth_place = LockOn_Options.init_conditions.birth_place

    if birth_place == "GROUND_COLD" then
        parameters.BAY_OPTION:set(bay_option_state) -- Unchecked = 0 Checked = 1
        parameters.L_HYD_VALUE:set(0)--engine page
        parameters.R_HYD_VALUE:set(0)--engine page
        --lmfd_current_page = 1
		--dev:performClickableAction(right_UFD_swap, 1, false)
    elseif birth_place == "GROUND_HOT" or birth_place == "AIR_HOT" then
        parameters.L_HYD_VALUE:set(3950)--engine page
        parameters.R_HYD_VALUE:set(3950)--engine page
        ground_oride_state = 0
        set_aircraft_draw_argument_value(600,0)
		set_aircraft_draw_argument_value(601,0)
		set_aircraft_draw_argument_value(602,0)
		--UFD_KNOB:set(0.5)
		--dispatch_action(nil,Battery)
        --lmfd_current_page = 1
		--print_message_to_user("HOT START")
    end
    --Option Checkbox
    if bay_option_state == 1 then
        ground_oride_state = 0
        --print_message_to_user("OPTIONSET")
	end
end
------------------------------------------------------------------FUNCTION-SETCOMMAND---------------------------------------------------------------------------------------------------
function SetCommand(command,value)
    -- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI
--Dogfight Mode 
    if command == 10005 and parameters.MAIN_POWER:get() == 1 then
        lmfd_current_page = 7
        rmfd_current_page = 7
        cmfd_current_page = 5
        --print_message_to_user("DOGFIGHT MFD OVERRIDE")
    end
--RWR SPO MODE
    if command == RMFD.R_OSB_15 and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 7 then --RWR PAGE ON
        dispatch_action(nil,ChangeRWRMode)
        --print_message_to_user("CHANGE RWR/SPO MODE")
    end
-----------------------------------------------------------------------------------------------------LEFT MFD PAGE LOGIC---------------------------------------------------------------------------------------------------
    if (command == LMFD.L_OSB_3 or command == 10063) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 6-- SET CHECKLIST PAGE
    elseif (command == LMFD.L_OSB_6 or command == 10066) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 8-- SET HSI PAGE
    elseif (command == LMFD.L_OSB_8 or command == 10068) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 2-- SET FCS PAGE 
    elseif (command == LMFD.L_OSB_10 or command == 10070) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 3-- SET FUEL PAGE
    elseif (command == LMFD.L_OSB_13 or command == 10073) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 7--SET SMS PAGE
    elseif (command == LMFD.L_OSB_16 or command == 10076) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 5-- SET BAY PAGE           
    elseif (command == LMFD.L_OSB_18 or command == 10078) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 1-- SET ENGINE PAGE
    elseif (command == LMFD.L_OSB_20 or command == 10080) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 0 then
        lmfd_current_page = 4-- SET ADI PAGE
    elseif (command == LMFD.L_OSB_1 or command == 10061) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 1 then --ENGINE PAGE ON
        lmfd_current_page = 0-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_2 or command == 10062) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 1 then --ENGINE PAGE ON go to sms
        lmfd_current_page = 7-- SET SMS PAGE
    elseif (command == LMFD.L_OSB_3 or command == 10063) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 1 then --ENGINE PAGE ON go to bay
        lmfd_current_page = 5-- SET BAY PAGE
    elseif (command == LMFD.L_OSB_4 or command == 10064) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 1 then --ENGINE PAGE ON go to fcs
        lmfd_current_page = 2-- SET FCS PAGE
    elseif (command == LMFD.L_OSB_5 or command == 10065) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 1 then --ENGINE PAGE ON go to fuel
        lmfd_current_page = 3-- SET FUEL PAGE
    elseif (command == LMFD.L_OSB_1 or command == 10061) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 2 then --FCS PAGE ON sent menu
        lmfd_current_page = 0-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_2 or command == 10062) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 2 then --FCS PAGE ON go to SMS
        lmfd_current_page = 7-- SET SMS PAGE  
    elseif (command == LMFD.L_OSB_4 or command == 10064) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 2 then --FCS PAGE ON go to ENG
        lmfd_current_page = 1-- SET ENG PAGE  
    elseif (command == LMFD.L_OSB_5 or command == 10065) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 2 then --FCS PAGE ON go to FUEL
        lmfd_current_page = 3-- SET FUEL PAGE       
    elseif (command == LMFD.L_OSB_1 or command == 10061) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 3 then --FUEL PAGE ON set menu
        lmfd_current_page = 0-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_2 or command == 10062) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 3 then --FUEL PAGE ON set sms
        lmfd_current_page = 7-- SET SMS PAGE
    elseif (command == LMFD.L_OSB_3 or command == 10063) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 3 then --FUEL PAGE ON set eng
        lmfd_current_page = 1-- SET ENG PAGE
    elseif (command == LMFD.L_OSB_4 or command == 10064) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 3 then --FUEL PAGE ON set bay
        lmfd_current_page = 5-- SET BAY PAGE
    elseif (command == LMFD.L_OSB_5 or command == 10065) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 3 then --FUEL PAGE ON set fcs
        lmfd_current_page = 2-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_1 or command == 10061) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 4 then --ADI PAGE ON set menu
        lmfd_current_page = 0-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_5 or command == 10065) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 4 then --ADI PAGE ON set HSI
        lmfd_current_page = 8-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_1 or command == 10061) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 5 then --BAY PAGE ON go to menu
        lmfd_current_page = 0-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_2 or command == 10062) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 5 then --BAY PAGE ON go to sms
        lmfd_current_page = 7-- SET SMS PAGE
    elseif (command == LMFD.L_OSB_3 or command == 10063) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 5 then --BAY PAGE ON go to eng
        lmfd_current_page = 1-- SET ENG PAGE
    elseif (command == LMFD.L_OSB_4 or command == 10064) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 5 then --BAY PAGE ON go to fuel
        lmfd_current_page = 3-- SET FUEL PAGE   
    elseif (command == LMFD.L_OSB_5 or command == 10065) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 5 then --BAY PAGE ON go to fcs
        lmfd_current_page = 2-- SET FCS PAGE         
    elseif (command == LMFD.L_OSB_1 or command == 10061) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 6 then --CHECKLIST PAGE ON go to menu
        lmfd_current_page = 0-- SET MENU PAGE 
    elseif (command == LMFD.L_OSB_2 or command == 10062) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 6 then --CHECKLIST PAGE ON go to eng
        lmfd_current_page = 1-- SET ENG PAGE 
    elseif (command == LMFD.L_OSB_3 or command == 10063) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 6 then --CHECKLIST PAGE ON go to bay
        lmfd_current_page = 5-- SET BAY PAGE
    elseif (command == LMFD.L_OSB_4 or command == 10064) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 6 then --CHECKLIST PAGE ON go to FCS
        lmfd_current_page = 2-- SET FCS PAGE 
    elseif (command == LMFD.L_OSB_5 or command == 10065) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 6 then --CHECKLIST PAGE ON go to fuel
        lmfd_current_page = 3-- SET FUEL PAGE  
    elseif (command == LMFD.L_OSB_13 or command == 10073) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 7 then --SMS PAGE ON
        lmfd_current_page = 0-- SET MENU PAGE
    elseif (command == LMFD.L_OSB_1 or command == 10061) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 8 then --HSI PAGE ON set menu
        lmfd_current_page = 0-- SET MENU PAGE   
    elseif (command == LMFD.L_OSB_5 or command == 10065) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 8 then --HSI PAGE ON set ADI
        lmfd_current_page = 4-- SET MENU PAGE   
    end
--END LEFT MFD
-----------------------------------------------------------------------------------------------------RIGHT MFD PAGE LOGIC---------------------------------------------------------------------------------------------------

    if (command == RMFD.R_OSB_3 or command == 10093) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 6-- SET CHECKLIST PAGE
    elseif (command == RMFD.R_OSB_6 or command == 10096) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 8-- SET HSI PAGE
    elseif (command == RMFD.R_OSB_8 or command == 10098) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 2-- SET FCS PAGE
    elseif (command == RMFD.R_OSB_10 or command == 10100) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 3-- SET FUEL PAGE
    elseif (command == RMFD.R_OSB_13 or command == 10103) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 7--SET SMS PAGE
    elseif (command == RMFD.R_OSB_16 or command == 10106) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 5-- SET BAY PAGE             
    elseif (command == RMFD.R_OSB_18 or command == 10108) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 1-- SET ENGINE PAGE
    elseif (command == RMFD.R_OSB_20 or command == 10110) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 0 then
        rmfd_current_page = 4-- SET ADI PAGE
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 1 then --ENGINE PAGE ON go to menu
        rmfd_current_page = 0-- SET MENU PAGE
    elseif (command == RMFD.R_OSB_2 or command == 10092) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 1 then --ENGINE PAGE ON go to sms
        rmfd_current_page = 7-- SET SMS PAGE
    elseif (command == RMFD.R_OSB_3 or command == 10093) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 1 then --ENGINE PAGE ON go to bay
        rmfd_current_page = 5-- SET BAY PAGE
    elseif (command == RMFD.R_OSB_4 or command == 10094) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 1 then --ENGINE PAGE ON go to fcs
        rmfd_current_page = 2-- SET FCS PAGE
    elseif (command == RMFD.R_OSB_5 or command == 10095) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 1 then --ENGINE PAGE ON go to fuel
        rmfd_current_page = 3-- SET FUEL PAGE
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 2 then --FCS PAGE ON go to menu
        rmfd_current_page = 0-- SET MENU PAGE    
    elseif (command == RMFD.R_OSB_2 or command == 10092) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 2 then --FCS PAGE ON go to SMS
        rmfd_current_page = 7-- SET SMS PAGE  
    elseif (command == RMFD.R_OSB_4 or command == 10094) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 2 then --FCS PAGE ON go to ENG
        rmfd_current_page = 1-- SET ENG PAGE  
    elseif (command == RMFD.R_OSB_5 or command == 10095) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 2 then --FCS PAGE ON go to FUEL
        rmfd_current_page = 3-- SET FUEL PAGE     
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 3 then --FUEL PAGE ON
        rmfd_current_page = 0-- SET MENU PAGE
    elseif (command == RMFD.R_OSB_2 or command == 10092) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 3 then --FUEL PAGE ON set sms
        rmfd_current_page = 7-- SET SMS PAGE
    elseif (command == RMFD.R_OSB_3 or command == 10093) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 3 then --FUEL PAGE ON set eng
        rmfd_current_page = 1-- SET ENG PAGE
    elseif (command == RMFD.R_OSB_4 or command == 10094) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 3 then --FUEL PAGE ON set bay
        rmfd_current_page = 5-- SET BAY PAGE
    elseif (command == RMFD.R_OSB_5 or command == 10095) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 3 then --FUEL PAGE ON set fcs
        rmfd_current_page = 2-- SET MENU PAGE
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 4 then --ADI PAGE ON
        rmfd_current_page = 0-- SET MENU PAGE
    elseif (command == RMFD.R_OSB_5 or command == 10095) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 4 then --ADI PAGE ON go to HSI
        rmfd_current_page = 8-- SET MENU PAGE
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 5 then --BAY PAGE ON go to menu
        rmfd_current_page = 0-- SET MENU PAGE
    elseif (command == RMFD.R_OSB_2 or command == 10092) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 5 then --BAY PAGE ON go to sms
        rmfd_current_page = 7-- SET SMS PAGE
    elseif (command == RMFD.R_OSB_3 or command == 10093) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 5 then --BAY PAGE ON go to eng
        rmfd_current_page = 1-- SET ENG PAGE
    elseif (command == RMFD.R_OSB_4 or command == 10094) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 5 then --BAY PAGE ON go to fuel
        rmfd_current_page = 3-- SET FUEL PAGE    
    elseif (command == RMFD.R_OSB_5 or command == 10095) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 5 then --BAY PAGE ON go to fCS
        rmfd_current_page = 2-- SET FCS PAGE          
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 6 then --CHECKLIST PAGE ON
        rmfd_current_page = 0-- SET MENU PAGE 
    elseif (command == RMFD.R_OSB_2 or command == 10092) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 6 then --CHECKLIST PAGE ON go to eng
        rmfd_current_page = 1-- SET ENG PAGE 
    elseif (command == RMFD.R_OSB_3 or command == 10093) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 6 then --CHECKLIST PAGE ON go to bay
        rmfd_current_page = 5-- SET BAY PAGE
    elseif (command == RMFD.R_OSB_4 or command == 10094) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 6 then --CHECKLIST PAGE ON go to FCS
        rmfd_current_page = 2-- SET FCS PAGE 
    elseif (command == RMFD.R_OSB_5 or command == 10095) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 6 then --CHECKLIST PAGE ON go to fuel
        rmfd_current_page = 3-- SET FUEL PAGE 
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 7 then --RWR PAGE ON
        rmfd_current_page = 0-- SET MENU PAGE  
    elseif (command == RMFD.R_OSB_1 or command == 10091) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 8 then --HSI PAGE ON go to menu
        rmfd_current_page = 0-- SET MENU PAGE  
    elseif (command == RMFD.R_OSB_5 or command == 10095) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 8 then --HSI PAGE ON go to ADI
        rmfd_current_page = 4-- SET ADI PAGE 
    end
    -- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI
--END RIGHT MFD
-----------------------------------------------------------------------------------------------------CENTER MFD PAGE LOGIC---------------------------------------------------------------------------------------------------

    if ((command == CMFD.C_OSB_3 or command == 10113) or command == 10113) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 0 then --menu page
        cmfd_current_page = 6-- SET CHECKLIST PAGE
    elseif (command == CMFD.C_OSB_6 or command == 10116) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 0 then
        cmfd_current_page = 8-- SET HSI PAGE
    elseif (command == CMFD.C_OSB_8 or command == 10118) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 0 then
        cmfd_current_page = 2-- SET FCS PAGE
    elseif (command == CMFD.C_OSB_10 or command == 10120) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 0 then
        cmfd_current_page = 3-- SET FUEL PAGE
    elseif (command == CMFD.C_OSB_16 or command == 10126) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 0 then
        cmfd_current_page = 5-- SET BAY PAGE             
    elseif (command == CMFD.C_OSB_18 or command == 10128) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 0 then
        cmfd_current_page = 1-- SET ENGINE PAGE
    elseif (command == CMFD.C_OSB_20 or command == 10130) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 0 then --menu page end
        cmfd_current_page = 4-- SET ADI PAGE
    elseif (command == CMFD.C_OSB_1 or command == 10111) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 1 then --ENGINE PAGE ON go to menu
        cmfd_current_page = 0-- SET MENU PAGE
    elseif (command == CMFD.C_OSB_2 or command == 10112) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 1 then --ENGINE PAGE ON go to bay
        cmfd_current_page = 5-- SET BAY PAGE
    elseif (command == CMFD.C_OSB_3 or command == 10113) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 1 then --ENGINE PAGE ON go to fcs
        cmfd_current_page = 2-- SET FCS PAGE
    elseif (command == CMFD.C_OSB_4 or command == 10114) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 1 then --ENGINE PAGE ON go to fuel
        cmfd_current_page = 3-- SET FUEL PAGE
    elseif (command == CMFD.C_OSB_5 or command == 10115) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 1 then --ENGINE PAGE ON go to ADI
        cmfd_current_page = 4-- SET ADI PAGE
    elseif (command == CMFD.C_OSB_1 or command == 10111) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 2 then --FCS PAGE ON go to menu
        cmfd_current_page = 0-- SET MENU PAGE
    elseif (command == CMFD.C_OSB_2 or command == 10112) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 2 then --FCS PAGE ON go to bay
        cmfd_current_page = 5-- SET BAY PAGE        
    elseif (command == CMFD.C_OSB_4 or command == 10114) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 2 then --FCS PAGE ON go to ENG
        cmfd_current_page = 1-- SET ENG PAGE  
    elseif (command == CMFD.C_OSB_5 or command == 10115) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 2 then --FCS PAGE ON go to FUEL
        cmfd_current_page = 3-- SET FUEL PAGE     
    elseif (command == CMFD.C_OSB_1 or command == 10111) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 3 then --FUEL PAGE ON
        cmfd_current_page = 0-- SET MENU PAGE
    elseif (command == CMFD.C_OSB_2 or command == 10112) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 3 then --FUEL PAGE ON set eng
        cmfd_current_page = 1-- SET ENG PAGE
    elseif (command == CMFD.C_OSB_3 or command == 10113) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 3 then --FUEL PAGE ON set bay
        cmfd_current_page = 5-- SET BAY PAGE
    elseif (command == CMFD.C_OSB_4 or command == 10114) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 3 then --FUEL PAGE ON set fcs
        cmfd_current_page = 2-- SET FCS PAGE
    elseif (command == CMFD.C_OSB_5 or command == 10115) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 3 then --FUEL PAGE ON set HSI
        cmfd_current_page = 8-- SET HSI PAGE
    elseif (command == CMFD.C_OSB_1 or command == 10111) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 4 then --ADI PAGE ON
        cmfd_current_page = 0-- SET MENU PAGE
    elseif (command == CMFD.C_OSB_5 or command == 10115) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 4 then --ADI PAGE ON set HSI
        cmfd_current_page = 8-- SET HSI PAGE
    elseif (command == CMFD.C_OSB_1 or command == 10111) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 5 then --BAY PAGE ON go to menu
        cmfd_current_page = 0-- SET MENU PAGE
    elseif (command == CMFD.C_OSB_2 or command == 10112) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 5 then --BAY PAGE ON go to eng
        cmfd_current_page = 1-- SET ENG PAGE
    elseif (command == CMFD.C_OSB_3 or command == 10113) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 5 then --BAY PAGE ON go to FCS
        cmfd_current_page = 2-- SET FCS PAGE  
    elseif (command == CMFD.C_OSB_4 or command == 10114) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 5 then --BAY PAGE ON go to fuel
        cmfd_current_page = 3-- SET FUEL PAGE      
    elseif (command == CMFD.C_OSB_5 or command == 10115) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 5 then --BAY PAGE ON go to HSI
        cmfd_current_page = 8-- SET HSI PAGE       
    elseif (command == CMFD.C_OSB_1 or command == 10111) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 6 then --CHECKLIST PAGE ON
        cmfd_current_page = 0-- SET MENU PAGE 
    elseif (command == CMFD.C_OSB_2 or command == 10112) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 6 then --CHECKLIST PAGE ON go to eng
        cmfd_current_page = 1-- SET ENG PAGE 
    elseif (command == CMFD.C_OSB_3 or command == 10113) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 6 then --CHECKLIST PAGE ON go to bay
        cmfd_current_page = 5-- SET BAY PAGE
    elseif (command == CMFD.C_OSB_4 or command == 10114) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 6 then --CHECKLIST PAGE ON go to FCS
        cmfd_current_page = 2-- SET FCS PAGE 
    elseif (command == CMFD.C_OSB_5 or command == 10115) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 6 then --CHECKLIST PAGE ON go to fuel
        cmfd_current_page = 3-- SET FUEL PAGE 
    elseif (command == CMFD.C_OSB_1 or command == 10111) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 8 then --HSI PAGE ON
        cmfd_current_page = 0-- SET MENU PAGE  
    elseif (command == CMFD.C_OSB_5 or command == 10115) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 8 then --HSI PAGE ON go to ADI
        cmfd_current_page = 4-- SET ADI PAGE  
    end
-- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI
--END RIGHT MFD
-----------------------------------------------------------------------------------------------FCS-LOGIC------------------------------------------------------ 
    
    -- if (command == LMFD.L_OSB_12 or command == 10072) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 2 then --AOA MODE
    --     dispatch_action(nil, 10035)
    -- elseif (command == LMFD.L_OSB_13 or command == 10073) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 2 then -- AUTO/OFF MODE
    --     dispatch_action(nil, 10034)
    -- elseif (command == LMFD.L_OSB_14 or command == 10074) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 2 then --G or ACL MODE
    --     dispatch_action(nil, 10036)
    -- elseif (command == RMFD.R_OSB_12 or command == 10102) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 2 then --AOA MODE
    --     dispatch_action(nil, 10035)
    -- elseif (command == RMFD.R_OSB_13 or command == 10103) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 2 then -- AUTO/OFF MODE
    --     dispatch_action(nil, 10034)
    -- elseif (command == RMFD.R_OSB_14 or command == 10104) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 2 then --G or ACL MODE
    --     dispatch_action(nil, 10036)
    -- elseif (command == CMFD.C_OSB_12 or command == 10122) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 2 then --AOA MODE
    --     dispatch_action(nil, 10035)
    -- elseif (command == CMFD.C_OSB_13 or command == 10123) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 2 then -- AUTO/OFF MODE
    --     dispatch_action(nil, 10034)
    -- elseif (command == CMFD.C_OSB_14 or command == 10124) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 2 then --G or ACL MODE
    --     dispatch_action(nil, 10036)
    -- end
    
    --fcs_mode 0 = AUTO - 1 = AOA ORIDE - 2 = G ORIDE - 3 = OFF
-----------------------------------------------------------------------------------------------HSI-LOGIC------------------------------------------------------    
    -- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI
    --HSI PAGE NAV-ILS-NEXT-PREV
    if (command == LMFD.L_OSB_15 or command == 10075) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 8 then
        dispatch_action(nil,PlaneModeNAV)--FC3 Keybind press 1
    elseif (command == LMFD.L_OSB_19 or command == 10079) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 8 then
        dispatch_action(nil,PrevSteer)--FC3 Keybind press L Shift ~
    elseif (command == LMFD.L_OSB_20 or command == 10080) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 8 then
        dispatch_action(nil,NextSteer)--FC3 Keybind press L CTRL ~
    elseif (command == RMFD.R_OSB_15 or command == 10105) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 8 then
        dispatch_action(nil,PlaneModeNAV)--FC3 Keybind press 1
    elseif (command == RMFD.R_OSB_19 or command == 10109) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 8 then
        dispatch_action(nil,PrevSteer)--FC3 Keybind press L Shift ~
    elseif (command == RMFD.R_OSB_20 or command == 10110) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 8 then
        dispatch_action(nil,NextSteer)--FC3 Keybind press L CTRL ~
    elseif (command == CMFD.C_OSB_15 or command == 10125) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 8 then
        dispatch_action(nil,PlaneModeNAV)--FC3 Keybind press 1
    elseif (command == CMFD.C_OSB_19 or command == 10129) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 8 then
        dispatch_action(nil,PrevSteer)--FC3 Keybind press L Shift ~
    elseif (command == CMFD.C_OSB_20 or command == 10130) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 8 then
        dispatch_action(nil,NextSteer)--FC3 Keybind press L CTRL ~
    end
-----------------------------------------------------------------------------------------------BAY-LOGIC------------------------------------------------------ 
    --BAY OVERRIDE
    if (command == LMFD.L_OSB_17 or command == 10077) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 5 and ground_oride_state == 0 and sensor_data.getWOW_NoseLandingGear() == 1 then
        ground_oride_state = 1
        --print_message_to_user("OVERRIDE OPEN")
    elseif (command == LMFD.L_OSB_17 or command == 10077) and parameters.MAIN_POWER:get() == 1 and lmfd_current_page == 5 and ground_oride_state == 1 and sensor_data.getWOW_NoseLandingGear() == 1 then
        ground_oride_state = 0
        --print_message_to_user("OVERRIDE CLOSE")
    elseif (command == RMFD.R_OSB_17 or command == 10107) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 5 and ground_oride_state == 0 and sensor_data.getWOW_NoseLandingGear() == 1 then
        ground_oride_state = 1
        --print_message_to_user("OVERRIDE OPEN")
    elseif (command == RMFD.R_OSB_17 or command == 10107) and parameters.MAIN_POWER:get() == 1 and rmfd_current_page == 5 and ground_oride_state == 1 and sensor_data.getWOW_NoseLandingGear() == 1 then
        ground_oride_state = 0
        --print_message_to_user("OVERRIDE CLOSE")    
    elseif (command == CMFD.C_OSB_17 or command == 10127) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 5 and ground_oride_state == 0 and sensor_data.getWOW_NoseLandingGear() == 1 then
        ground_oride_state = 1
        --print_message_to_user("OVERRIDE OPEN")
    elseif (command == CMFD.C_OSB_17 or command == 10127) and parameters.MAIN_POWER:get() == 1 and cmfd_current_page == 5 and ground_oride_state == 1 and sensor_data.getWOW_NoseLandingGear() == 1 then
        ground_oride_state = 0
        --print_message_to_user("OVERRIDE CLOSE")    
    end
    --Bay Select : BAY STATION 1-left 2-center 3-right 4-all --MFD PAGES   0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI
        if command == 10004 and bay_select < 4 then
            bay_select = (bay_select + 1)
        elseif command == 10004 and bay_select == 4 then
            bay_select = 1
        end
    --Left Bay Multi Modes
        if command == 10000 and bay_select ~= 1 then --Left Bay select
            bay_select = 1
            left_select_mode = 1
            right_select_mode = 0
            dispatch_action(nil,PlaneModeFI0)--FC3 Keybind press 6
            dispatch_action(nil,PlaneRadarOnOff)
        elseif command == 10000 and bay_select == 1 and left_select_mode == 1 then --Left Bay select
            bay_select = 1
            left_select_mode = 2 --bore
            dispatch_action(nil,PlaneModeBore)--FC3 Keybind press 4
            --dispatch_action(nil,PlaneRadarOnOff)--FC3 Keybind press I
        elseif command == 10000 and bay_select == 1 and left_select_mode == 2 then --Left Bay select
            bay_select = 1
            left_select_mode = 3 --VS
            dispatch_action(nil,PlaneModeVS)--FC3 Keybind press 3
            --dispatch_action(nil,PlaneRadarOnOff)--FC3 Keybind press I
        elseif command == 10000 and bay_select == 1 and left_select_mode == 3 then --Left Bay select
            bay_select = 1
            left_select_mode = 1 --Flood
            dispatch_action(nil,PlaneModeFI0)--FC3 Keybind press 6
            dispatch_action(nil,PlaneRadarOnOff)--FC3 Keybind press I
    --Right Bay Multi Modes       
        elseif command == 10001 and bay_select ~= 3 then
            bay_select = 3
            left_select_mode = 0
            right_select_mode = 1
            dispatch_action(nil,PlaneModeFI0)--FC3 Keybind press 6  
            dispatch_action(nil,PlaneRadarOnOff)
        elseif command == 10001 and bay_select == 3 and right_select_mode == 1 then
            bay_select = 3
            right_select_mode = 2
            dispatch_action(nil,PlaneModeBore)--FC3 Keybind press 4
            --dispatch_action(nil,PlaneRadarOnOff)
        elseif command == 10001 and bay_select == 3 and right_select_mode == 2 then
            bay_select = 3
            right_select_mode = 3
            dispatch_action(nil,PlaneModeVS)--FC3 Keybind press 3
            --dispatch_action(nil,PlaneRadarOnOff)
        elseif command == 10001 and bay_select == 3 and right_select_mode == 3 then
            bay_select = 3
            right_select_mode = 1
            dispatch_action(nil,PlaneModeFI0)--FC3 Keybind press 6  
            dispatch_action(nil,PlaneRadarOnOff)
    --Center Bay        
        elseif command == 10002 and bay_select ~= 2 then
            bay_select = 2
            dispatch_action(nil,PlaneModeBVR)--FC3 Keybind press 2
            --dispatch_action(nil,PlaneRadarOnOff)  
        elseif command == 10003 and bay_select ~= 4 then
            bay_select = 4
            dispatch_action(nil,PlaneModeBVR)--FC3 Keybind press 2
            --dispatch_action(nil,PlaneRadarOnOff)  
        end
        if (command == LMFD.L_OSB_7 or command == 10067) and parameters.LMFD_PAGE:get() == 5 and bay_select < 4 then
			bay_select = (bay_select + 1)
			--print_message_to_user("BAY SELECT UP")
		elseif (command == LMFD.L_OSB_7 or command == 10067) and parameters.LMFD_PAGE:get() == 5 and bay_select == 4 then
            bay_select = 1 --right bay
                --print_message_to_user("BAY SELECT RESET")	
        elseif (command == LMFD.L_OSB_8 or command == 10068) and parameters.LMFD_PAGE:get() == 5 and bay_select > 1 then
            bay_select = (bay_select - 1)
            --print_message_to_user("BAY SELECT DOWN") 
        elseif (command == LMFD.L_OSB_8 or command == 10068) and parameters.LMFD_PAGE:get() == 5 and bay_select == 1 then
            bay_select = 4 --right bay
            --print_message_to_user("BAY SELECT 8 RESET")
        elseif (command == RMFD.R_OSB_7 or command == 10097) and parameters.RMFD_PAGE:get() == 5 and bay_select < 4 then--right
            bay_select = (bay_select + 1)
            --print_message_to_user("BAY SELECT UP")
        elseif (command == RMFD.R_OSB_7 or command == 10097) and parameters.RMFD_PAGE:get() == 5 and bay_select == 4 then
            bay_select = 1 --right bay
                --print_message_to_user("BAY SELECT RESET")	
        elseif (command == RMFD.R_OSB_8 or command == 10098) and parameters.RMFD_PAGE:get() == 5 and bay_select > 1 then
            bay_select = (bay_select - 1)
            --print_message_to_user("BAY SELECT DOWN") 
        elseif (command == RMFD.R_OSB_8 or command == 10098) and parameters.RMFD_PAGE:get() == 5 and bay_select == 1 then
            bay_select = 4 --right bay
                --print_message_to_user("BAY SELECT 8 RESET")
        elseif (command == CMFD.C_OSB_7 or command == 10117) and parameters.CMFD_PAGE:get() == 5 and bay_select < 4 then--CENTER
            bay_select = (bay_select + 1)
            --print_message_to_user("BAY SELECT UP")
        elseif (command == CMFD.C_OSB_7 or command == 10117) and parameters.CMFD_PAGE:get() == 5 and bay_select == 4 then
            bay_select = 1 --right bay
            --print_message_to_user("BAY SELECT RESET")	
        elseif (command == CMFD.C_OSB_8 or command == 10118) and parameters.CMFD_PAGE:get() == 5 and bay_select > 1 then
            bay_select = (bay_select - 1)
            --print_message_to_user("BAY SELECT DOWN") 
        elseif (command == CMFD.C_OSB_8 or command == 10118) and parameters.CMFD_PAGE:get() == 5 and bay_select == 1 then
            bay_select = 4 --right bay
            --print_message_to_user("BAY SELECT 8 RESET")                  
		end
    --Bay Select END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------FUNCTION-UPDATE---------------------------------------------------------------------------------------------------
function update()
----- NOTES -----
-- 730 Stage 1 AB EGT
-- 850 Max EGT
-- 208 HYD ARG

----- PRINT -----

    --local heading = (360 - sensor_data.getHeading() * 180/math.pi)
    
    -- local map = get_terrain_related_data("name")
    -- local base = _G

    -- local Terrain           = require('terrain')

    -- print_message_to_user(ils_vert)

    -- local self_loc_x , own_alt, self_loc_y = sensor_data.getSelfCoordinates()
    -- self_m_x 		= self_loc_x
    -- self_m_z 		= self_loc_y
    -- self_m_y 		= own_alt
    -- local tmp_lat,tmp_long = Terrain.convertMetersToLatLon(self_m_x,self_m_z)
    -- local ll = {36.103, 45.93873, 2000}
    --print_message_to_user("latitude: "..tmp_lat.." longitude: "..tmp_long)
    -- local lat, long, alt = coord.LOtoLL(ll)
    -- print_message_to_user("lat: "..lat.." long: "..long)
    --print_message_to_user(parameters.BAY_STATION:get())
    
    -- parameters.FCS_MODE:set(fcs_mode)
    -- parameters.FCS_AUTO:set(fcs_auto)
    -- parameters.FCS_STATE:set(fcs_state)
------------------------------------------------------------------------------------------------------------------------------------
-- if parameters.APU_RPM_STATE:get() >= 2 and parameters.MAIN_POWER:get() == 0 then
--     --------------------------------
--    -- parameters.LMFD_ENG_PAGE:set(1)      
--    -- parameters.RMFD_BLANK_PAGE:set(1)     
--     --parameters.CMFD_BLANK_PAGE:set(1)
--     ---------------------------------
--     parameters.RMFD_MENU_PAGE:set(0)
--     parameters.RMFD_MASK:set(1) 
--     parameters.RMFD_ENG_PAGE:set(0)
--     parameters.RMFD_ADI_PAGE:set(0)
--     parameters.RMFD_BAY_PAGE:set(0)
--     parameters.RMFD_CHECKLIST_PAGE:set(0)
--     parameters.RMFD_FCS_PAGE:set(0)
--     parameters.RMFD_SMS_PAGE:set(0)
--     parameters.RMFD_HSI_PAGE:set(0)
--     parameters.RMFD_FUEL_PAGE:set(0)
--     --------------------------------
--     --------------------------------
--     --------------------------------
-- elseif parameters.APU_RPM_STATE:get() >= 2 and parameters.MAIN_POWER:get() == 1 then
--     --parameters.LMFD_ENG_PAGE:set(0)      
--     --parameters.RMFD_BLANK_PAGE:set(0)     
--     --parameters.CMFD_BLANK_PAGE:set(0)
-- elseif parameters.MAIN_POWER:get() == 0 then
--     --parameters.LMFD_ENG_PAGE:set(0)     
--     --parameters.RMFD_BLANK_PAGE:set(0)     
--     --parameters.CMFD_BLANK_PAGE:set(0)
-- end
------------------------------------------------------------------ENGINE PAGE UPDATE---------------------------------------------------------------------------------------------------
    local hyd_light      = get_cockpit_draw_argument_value(208)
    local cabin_pressure = get_cockpit_draw_argument_value(114)

	local nozzle_pos_l = sensor_data.getEngineLeftRPM()
	local left_nozzle = 50 + (nozzle_pos_l - 67) * (50 / 33)
		if left_nozzle > 100 then
		left_nozzle = 100
		elseif left_nozzle < 50 then
		left_nozzle = 50
	end
	parameters.L_NOZZLE_POS:set(left_nozzle)
	
	local nozzle_pos_r = sensor_data.getEngineRightRPM()
	local right_nozzle = 50 + (nozzle_pos_r - 67) * (50 / 33)
		if right_nozzle > 100 then
		right_nozzle = 100
		elseif right_nozzle < 50 then
		right_nozzle = 50
	end
	parameters.R_NOZZLE_POS:set(right_nozzle)

    parameters.GROUND_ORIDE:set(ground_oride_state)
    parameters.BAY_STATION:set(bay_select)
    parameters.CABINPRESS:set(cabin_pressure)
    parameters.L_HYD_VALUE:set(l_hyd_value)
    parameters.R_HYD_VALUE:set(r_hyd_value)

    parameters.OIL_L:set(sensor_data.getEngineLeftRPM()*2.7)
    parameters.OIL_R:set(sensor_data.getEngineRightRPM()*2.7)

    parameters.L_HYD_COLOR:set(0)
    parameters.R_HYD_COLOR:set(0)
    parameters.R_FF_VALUE:set(sensor_data.getEngineRightFuelConsumption()*2.20462*3600)
    parameters.L_FF_VALUE:set(sensor_data.getEngineLeftFuelConsumption()*2.20462*3600)
    parameters.LMFD_PAGE:set(lmfd_current_page)
    parameters.RMFD_PAGE:set(rmfd_current_page)
    parameters.CMFD_PAGE:set(cmfd_current_page)
------------------------------------------------------------------FCS PAGE UPDATE---------------------------------------------------------------------------------------------------
    local right_flap                = get_aircraft_draw_argument_value(9)
    local left_flap                 = get_aircraft_draw_argument_value(10)
    local right_aileron             = get_aircraft_draw_argument_value(11)
    local left_aileron              = get_aircraft_draw_argument_value(12)
    local right_elevator            = get_aircraft_draw_argument_value(15)
    local left_elevator             = get_aircraft_draw_argument_value(16)
    local right_rudder              = get_aircraft_draw_argument_value(17)
    local left_rudder               = get_aircraft_draw_argument_value(18)
    local speed_brake               = get_aircraft_draw_argument_value(182)
    local lef                       = get_aircraft_draw_argument_value(603)

    parameters.FCS_RA:set(right_aileron)
    parameters.FCS_LA:set(left_aileron)
    parameters.FCS_RE:set(right_elevator)
    parameters.FCS_LE:set(left_elevator)
    parameters.FCS_RR:set(right_rudder)
    parameters.FCS_LR:set(left_rudder)
    parameters.FCS_RF:set(right_flap)
    parameters.FCS_LF:set(left_flap)
    parameters.FCS_SB:set(speed_brake)
    parameters.FCS_LEF:set(lef)
------------------------------------------------------------------FUEL PAGE UPDATE---------------------------------------------------------------------------------------------------
------------------------------------------------------------------ADI PAGE UPDATE---------------------------------------------------------------------------------------------------
------------------------------------------------------------------HSI PAGE UPDATE----------------------------------------------------------------------------------------------------
    

    
       local ils_vert                  = get_cockpit_draw_argument_value(28)--up + down -
       local ils_horizon               = get_cockpit_draw_argument_value(27)--left - right +
       local hsi_compass               = get_cockpit_draw_argument_value(32)
       local hsi_course_pointer        = get_cockpit_draw_argument_value(35)
       local hsi_deviation             = get_cockpit_draw_argument_value(36)
       local hsi_wp_pointer            = get_cockpit_draw_argument_value(140)
       local ils_flag                  = get_cockpit_draw_argument_value(141)
       local mile_4                    = get_cockpit_draw_argument_value(267)
       local mile_3                    = get_cockpit_draw_argument_value(268)
       local mile_2                    = get_cockpit_draw_argument_value(269)
       local mile_1                    = get_cockpit_draw_argument_value(270)
       local course_1                  = get_cockpit_draw_argument_value(275)
       local course_2                  = get_cockpit_draw_argument_value(276)
       local course_3                  = get_cockpit_draw_argument_value(277)
       local to_from                   = get_cockpit_draw_argument_value(278)
       local ils_nav                   = get_cockpit_draw_argument_value(501)
    --print_message_to_user(ils_horizon)

    parameters.ILS_VERT:set(ils_vert)  --up + down -
    parameters.ILS_HORIZON:set(ils_horizon)--left - right +
    parameters.HSI_COMPASS:set(hsi_compass)
    parameters.HSI_CRS_POINTER:set(hsi_course_pointer)
    parameters.HSI_DEVIATION:set(hsi_deviation)  
    parameters.HSI_WP_POINTER:set(hsi_wp_pointer)
    parameters.ILS_FLAG:set(ils_flag) 
    parameters.ILS_NAV:set(ils_nav)       
    parameters.MILE_1:set(mile_1)         
    parameters.MILE_2:set(mile_2)         
    parameters.MILE_3:set(mile_3)         
    parameters.MILE_4:set(mile_4)        
    parameters.COURSE_1:set(course_1)       
    parameters.COURSE_2:set(course_2)       
    parameters.COURSE_3:set(course_3)       
    parameters.TO_FROM:set(to_from)
    
    if parameters.ILS_NAV:get() >= 0.1 then
        parameters.ILSN_VIS:set(1)
        parameters.NAV_VIS:set(0)
    elseif parameters.ILS_NAV:get() <= 0.09 then
        parameters.ILSN_VIS:set(0)
        parameters.NAV_VIS:set(1)
    end
        
------------------------------------------------------------------ENGINE PAGE LOGIC---------------------------------------------------------------------------------------------------
    --ENGINE PAGE EGT R COLOR CHANGE
    if sensor_data.getEngineRightTemperatureBeforeTurbine() <= 729 then
        parameters.R_EGT_COLOR:set(0)--get green
    elseif sensor_data.getEngineRightTemperatureBeforeTurbine() >= 730 and sensor_data.getEngineRightTemperatureBeforeTurbine() <= 849 then
        parameters.R_EGT_COLOR:set(0.5)--set yellow
    elseif sensor_data.getEngineRightTemperatureBeforeTurbine() >= 850 then
        parameters.R_EGT_COLOR:set(1) --set red
    end
    --ENGINE PAGE EGT L COLOR CHANGE
    if sensor_data.getEngineLeftTemperatureBeforeTurbine() <= 729 then
        parameters.L_EGT_COLOR:set(0)--get green
    elseif sensor_data.getEngineLeftTemperatureBeforeTurbine() >= 730 and sensor_data.getEngineLeftTemperatureBeforeTurbine() <= 849 then
        parameters.L_EGT_COLOR:set(0.5)--set yellow
    elseif sensor_data.getEngineLeftTemperatureBeforeTurbine() >= 850 then
        parameters.L_EGT_COLOR:set(1) --set red
    end
    --ENGINE PAGE RPM COLOR CHANGE R
    if sensor_data.getEngineRightRPM() <= 100 then
        parameters.R_RPM_COLOR:set(0.5)-- set yellow
    elseif sensor_data.getEngineRightRPM() >= 101 then
        parameters.R_RPM_COLOR:set(1)-- set orange
    end
    --ENGINE PAGE RPM COLOR CHANGE L
    if sensor_data.getEngineLeftRPM() <= 100 then
        parameters.L_RPM_COLOR:set(0.5)-- set yellow
    elseif sensor_data.getEngineLeftRPM() >= 101 then
        parameters.L_RPM_COLOR:set(1)-- set orange
    end
    --ENGINE PAGE OIL COLOR CHANGE R
    if sensor_data.getEngineRightRPM() <= 66 then
        parameters.R_OIL_COLOR:set(1)
    elseif sensor_data.getEngineRightRPM() >= 67 then
        parameters.R_OIL_COLOR:set(0)
    end
    --ENGINE PAGE OIL COLOR CHANGE L
    if sensor_data.getEngineLeftRPM() <= 66 then
        parameters.L_OIL_COLOR:set(1)
    elseif sensor_data.getEngineLeftRPM() >= 67 then
        parameters.L_OIL_COLOR:set(0)
    end 
    --HYD ENGINE RIGHT
    if sensor_data.getEngineRightRPM() >= 45 and r_hyd_value <= 3945 then
        r_hyd_value = r_hyd_value + 5
    elseif (sensor_data.getEngineRightRPM() <= 44 or hyd_light == 1) and r_hyd_value >= 0.1 then
        r_hyd_value = r_hyd_value - 5
    end
    --HYD ENGINE LEFT
    if sensor_data.getEngineLeftRPM() >= 45 and hyd_light ~= 1 and l_hyd_value <= 3945 then
        l_hyd_value = l_hyd_value + 5
    elseif (sensor_data.getEngineLeftRPM() <= 44 or hyd_light == 1) and l_hyd_value >= 0.1 then
        l_hyd_value = l_hyd_value - 5
    end
    --HYD COLOR CHANGE RIGHT
    if r_hyd_value >= 1001 then
        parameters.R_HYD_COLOR:set(0)
    elseif r_hyd_value <= 1000 then
        parameters.R_HYD_COLOR:set(1)
    end
    --HYD COLOR CHANGE LEFT
    if l_hyd_value >= 1001 then
        parameters.L_HYD_COLOR:set(0)
    elseif l_hyd_value <= 1000 then
        parameters.L_HYD_COLOR:set(1)
    end
------------------------------------------------------------------FCS PAGE LOGIC---------------------------------------------------------------------------------------------------------

    if parameters.FUEL:get() >= 13456 then
        parameters.TANK_OPACITY:set(1)
    else
        parameters.TANK_OPACITY:set(0)
    end
------------------------------------------------------------------FUEL PAGE LOGIC--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------ADI PAGE LOGIC---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------HSI PAGE LOGIC---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------BAY PAGE LOGIC---------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------PAGE-UPDATE-----------------------------------------------------------------------------------------
--LEFT MFD
    -- 0=MENU, 1=ENG, 2=FCS, 3=FUEL, 4=ADI, 5=BAY, 6=CHKLIST, 7=SMS, 8=HSI    
    if lmfd_current_page == 0 and parameters.MAIN_POWER:get() == 1 then --MENU PAGE
        parameters.LMFD_MENU_PAGE:set(1)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page == 1 and parameters.MAIN_POWER:get() == 1 then --ENGINE PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0) 
        parameters.LMFD_ENG_PAGE:set(1)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page == 2 and parameters.MAIN_POWER:get() == 1 then --FCS PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(1)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page == 3 and parameters.MAIN_POWER:get() == 1 then --FUEL PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(1)
    elseif lmfd_current_page == 4 and parameters.MAIN_POWER:get() == 1 then --ADI PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(1)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page == 5 and parameters.MAIN_POWER:get() == 1 then --BAY PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(1)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page == 6 and parameters.MAIN_POWER:get() == 1 then --CHECKLIST PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(1)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page == 7 and parameters.MAIN_POWER:get() == 1 then --SMS PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(1)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(1)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page == 8 and parameters.MAIN_POWER:get() == 1 then --HSI PAGE
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(0)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(1)
        parameters.LMFD_FUEL_PAGE:set(0)
    elseif lmfd_current_page >= 0 and parameters.MAIN_POWER:get() == 0 then --MAIN POWER OFF SET ENG PAGE FOR APU
        parameters.LMFD_MENU_PAGE:set(0)
        parameters.LMFD_MASK:set(0)
        parameters.LMFD_ENG_PAGE:set(1)
        parameters.LMFD_ADI_PAGE:set(0)
        parameters.LMFD_BAY_PAGE:set(0)
        parameters.LMFD_CHECKLIST_PAGE:set(0)
        parameters.LMFD_FCS_PAGE:set(0)
        parameters.LMFD_SMS_PAGE:set(0)
        parameters.LMFD_HSI_PAGE:set(0)
        parameters.LMFD_FUEL_PAGE:set(0)
    end
--END LEFT MFD
--RIGHT MFD
    if rmfd_current_page == 0 and parameters.MAIN_POWER:get() == 1 then --MENU PAGE
        parameters.RMFD_MENU_PAGE:set(1)
        parameters.RMFD_MASK:set(0)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif rmfd_current_page == 1 and parameters.MAIN_POWER:get() == 1 then --ENGINE PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(0) 
        parameters.RMFD_ENG_PAGE:set(1)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif rmfd_current_page == 2 and parameters.MAIN_POWER:get() == 1 then --FCS PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(0)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(1)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif rmfd_current_page == 3 and parameters.MAIN_POWER:get() == 1 then --FUEL PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(0)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(1)
    elseif rmfd_current_page == 4 and parameters.MAIN_POWER:get() == 1 then --ADI PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(0)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(1)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif rmfd_current_page == 5 and parameters.MAIN_POWER:get() == 1 then --BAY PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(0)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(1)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif rmfd_current_page == 6 and parameters.MAIN_POWER:get() == 1 then --CHECKLIST PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(0)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(1)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif rmfd_current_page == 7 and parameters.MAIN_POWER:get() == 1 then --RWR PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(1)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(1)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif rmfd_current_page == 8 and parameters.MAIN_POWER:get() == 1 then --HSI PAGE
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(0)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(1)
        parameters.RMFD_FUEL_PAGE:set(0)
    elseif parameters.APU_RPM_STATE:get() >= 2 and parameters.MAIN_POWER:get() == 0 then --and parameters.DAY_NIGHT:get() == 1
        parameters.RMFD_MENU_PAGE:set(0)
        parameters.RMFD_MASK:set(1)
        parameters.RMFD_ENG_PAGE:set(0)
        parameters.RMFD_ADI_PAGE:set(0)
        parameters.RMFD_BAY_PAGE:set(0)
        parameters.RMFD_CHECKLIST_PAGE:set(0)
        parameters.RMFD_FCS_PAGE:set(0)
        parameters.RMFD_RWR_PAGE:set(0)
        parameters.RMFD_HSI_PAGE:set(0)
        parameters.RMFD_FUEL_PAGE:set(0)    
    end
--END RIGHT MFD
--CENTER MFD
    if cmfd_current_page == 0 and parameters.MAIN_POWER:get() == 1 then --MENU PAGE
        parameters.CMFD_MENU_PAGE:set(1)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(0)
    elseif cmfd_current_page == 1 and parameters.MAIN_POWER:get() == 1 then --ENGINE PAGE
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(1)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(0)
    elseif cmfd_current_page == 2 and parameters.MAIN_POWER:get() == 1 then --FCS PAGE
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(1)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(0)
    elseif cmfd_current_page == 3 and parameters.MAIN_POWER:get() == 1 then --FUEL PAGE
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(1)
    elseif cmfd_current_page == 4 and parameters.MAIN_POWER:get() == 1 then --ADI PAGE
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(1)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(0)
    elseif cmfd_current_page == 5 and parameters.MAIN_POWER:get() == 1 then --BAY PAGE
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(1)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(0)
    elseif cmfd_current_page == 6 and parameters.MAIN_POWER:get() == 1 then --CHECKLIST PAGE
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(1)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(0)
    elseif cmfd_current_page == 8 and parameters.MAIN_POWER:get() == 1 then --HSI PAGE
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(1)
        parameters.CMFD_FUEL_PAGE:set(0)
    elseif cmfd_current_page >= 0 and parameters.APU_RPM_STATE:get() >= 2 and parameters.MAIN_POWER:get() == 0 then -- and parameters.DAY_NIGHT:get() == 1
        parameters.CMFD_MENU_PAGE:set(0)
        parameters.CMFD_ENG_PAGE:set(0)
        parameters.CMFD_ADI_PAGE:set(0)
        parameters.CMFD_BAY_PAGE:set(0)
        parameters.CMFD_CHECKLIST_PAGE:set(0)
        parameters.CMFD_FCS_PAGE:set(0)
        parameters.CMFD_HSI_PAGE:set(0)
        parameters.CMFD_FUEL_PAGE:set(0)        
    end
--END CENTER MFD
end
need_to_be_closed = false
--Ref
    -- parameters.TAS	        :set(sensor_data.getTrueAirSpeed() * 1.944)
	-- parameters.IAS	        :set(sensor_data.getIndicatedAirSpeed() * 1.944)
	-- parameters.GFORCE       :set(sensor_data.getVerticalAcceleration())
	-- parameters.ADI_PITCH    :set(sensor_data.getPitch() )
	-- parameters.ADI_ROLL     :set(sensor_data.getRoll() )
	-- parameters.YAW          :set(sensor_data.getRateOfYaw() )
	-- parameters.ROLLRATE     :set(sensor_data.getRateOfRoll()/math.pi*180)-- Testing
	-- parameters.NAV          :set(360 - sensor_data.getHeading()/math.pi*180) -- Working, don't change
	-- parameters.RADALT       :set(sensor_data.getRadarAltitude() ) -- Working, don't change
	-- parameters.BARO         :set(sensor_data.getBarometricAltitude() * 3.28084 ) -- Working, don't change	
	-- parameters.RPM_L        :set(sensor_data.getEngineLeftRPM())-- Needs to be tested (might not need to multiply by 2750 cause that was from fixed prop? maybe)
	-- parameters.RPM_R        :set(sensor_data.getEngineRightRPM())
	-- parameters.FUELL        :set(sensor_data.getTotalFuelWeight() * 0.01 ) -- Working, don't change: 0.36622 
	-- parameters.FUEL         :set(sensor_data.getTotalFuelWeight() * 2.20462 ) -- Working, don't change: 0.36622
	-- parameters.FUELT        :set(sensor_data.getTotalFuelWeight() * 2.20462 - 13454 ) -- Working, don't change: 0.36622 
	-- parameters.EGT_L        :set(sensor_data.getEngineLeftTemperatureBeforeTurbine())
    -- parameters.EGT_R        :set(sensor_data.getEngineRightTemperatureBeforeTurbine())
    --getAngleOfAttack
    --getAngleOfSlide
    --getBarometricAltitude
    --getCanopyPos
    --getCanopyState
    --getEngineLeftFuelConsumption
    --getEngineLeftRPM
    --getEngineLeftTemperatureBeforeTurbine
    --getEngineRightFuelConsumption
    --getEngineRightRPM
    --getEngineRightTemperatureBeforeTurbine
    --getFlapsPos
    --getFlapsRetracted
    --getHeading
    --getHelicopterCollective
    --getHelicopterCorrection
    --getHorizontalAcceleration
    --getIndicatedAirSpeed
    --getLandingGearHandlePos
    --getLateralAcceleration
    --getLeftMainLandingGearDown
    --getLeftMainLandingGearUp
    --getMachNumber
    --getMagneticHeading
    --getNoseLandingGearDown
    --getNoseLandingGearUp
    --getPitch
    --getRadarAltitude
    --getRateOfPitch
    --getRateOfRoll
    --getRateOfYaw
    --getRightMainLandingGearDown
    --getRightMainLandingGearUp
    --getRoll
    --getRudderPosition
    --getSelfAirspeed
    --getSelfCoordinates
    --getSelfVelocity
    --getSpeedBrakePos
    --getStickPitchPosition
    --getStickRollPosition
    --getThrottleLeftPosition
    --getThrottleRightPosition
    --getTotalFuelWeight
    --getTrueAirSpeed
    --getVerticalAcceleration
    --getVerticalVelocity
    --getWOW_LeftMainLandingGear
    --getWOW_NoseLandingGear
    --getWOW_RightMainLandingGear
