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


local dev = GetSelf()
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 0.02
make_default_activity(update_time_step)

local sensor_data		= get_base_data()

	local parameters =
		{

			APU_POWER			= get_param_handle("APU_POWER"),
			BATTERY_POWER		= get_param_handle("BATTERY_POWER"),
			MAIN_POWER			= get_param_handle("MAIN_POWER"),
			BAY_OPTION			= get_param_handle("BAY_OPTION"),
			ARM_STATUS			= get_param_handle("ARM_STATUS"), -- ARM TEXT
			GROUND_ORIDE        = get_param_handle("GROUND_ORIDE"),
			ORIDE_X				= get_param_handle("ORIDE_X"),
			ORIDE_TEXT			= get_param_handle("ORIDE_TEXT"),
			BAY_L_ARG			= get_param_handle("BAY_L_ARG"),
			BAY_R_ARG			= get_param_handle("BAY_R_ARG"),
			BAY_C_ARG			= get_param_handle("BAY_C_ARG"),
			ECM_ARG				= get_param_handle("ECM_ARG"),
			LMFD_PAGE           = get_param_handle("LMFD_PAGE"),
			BAY_STATION         = get_param_handle("BAY_STATION"),
			AIR_ORIDE			= get_param_handle("AIR_ORIDE"),
			MASTER_ARM			= get_param_handle("MASTER_ARM"),
			DOGFIGHT			= get_param_handle("DOGFIGHT"),
			HUD_MODE			= get_param_handle("HUD_MODE"),
			GROUND_POWER		= get_param_handle("GROUND_POWER"),
			WoW				    = get_param_handle("WoW"),
			DETENT				= get_param_handle("DETENT"),
			PICKLE				= get_param_handle("PICKLE"),

		}

--wep	
-- local PickleON 						= Keys.PlanePickleOn
-- local PickleOFF 						= Keys.PlanePickleOff
local PickleON 							= 350
local PickleOFF 						= 351
local PlaneFire							= 84--gun trigger on
local PlaneFireOff						= 85--gun trigger off
local PlaneChangeWeapon 				= Keys.PlaneChangeWeapon --D keybind
local PlaneModeCannon					= 113-- C Keybind
--modes
local PlaneModeNAV 						= Keys.PlaneModeNAV	--1						
local PlaneModeBVR 						= Keys.PlaneModeBVR	--2						
local PlaneModeVS 						= Keys.PlaneModeVS --3								
local PlaneModeBore 					= Keys.PlaneModeBore --4
local PlaneModeFI0 						= Keys.PlaneModeFI0 --6
--rwr
-- local PlaneThreatWarnSoundVolumeDown 	= 409
-- local PlaneThreatWarnSoundVolumeUp 		= 410
--jettison
local PlaneJettisonWeapons 				= Keys.PlaneJettisonWeapons
local PlaneJettisonFuelTanks 			= Keys.PlaneJettisonFuelTanks

local ActiveJamming						= Keys.ActiveJamming

--local NextSteer			 				= Keys.PlaneChangeTarget --steer point up
--local PrevSteer 						= 1315 --steer point prev
--local PlaneWheelBrakeON 				= 74
--local PlaneWheelBrakeOff 				= Keys.PlaneWheelBrakeOff
--local PlaneAirRefuel 					= Keys.PlaneAirRefuel
--local PlaneFuelOn 						= Keys.PlaneFuelOn --fuel dump
--local AutoAttHold 					= 62
--local AutoAltHold 					= 389
--local AutoCancel 						= 408

-- local TEST			= 438
-- dev:listen_command(TEST)
dev:listen_command(PickleON)
dev:listen_command(PickleOFF)
dev:listen_command(PlaneFire)
dev:listen_command(PlaneFireOff)
dev:listen_command(PlaneChangeWeapon)
dev:listen_command(PlaneModeNAV)
dev:listen_command(PlaneModeBVR)
dev:listen_command(PlaneModeVS)
dev:listen_command(PlaneModeBore)
dev:listen_command(PlaneModeFI0)
dev:listen_command(PlaneModeCannon)
dev:listen_command(PlaneJettisonWeapons)
dev:listen_command(PlaneJettisonFuelTanks)
dev:listen_command(ActiveJamming)
-- dev:listen_command(PlaneThreatWarnSoundVolumeDown)
-- dev:listen_command(PlaneThreatWarnSoundVolumeUp)
-- dev:listen_command(L_OSB_7)
-- dev:listen_command(10000)--Left Bay Select
-- dev:listen_command(10001)--Right Bay Select
-- dev:listen_command(10002)--Center Bay Select
-- dev:listen_command(10003)--All Bay Select
-- dev:listen_command(10004)--Step Select
dev:listen_command(10006)--Weapon Bay Air Override
dev:listen_command(10024)--Weapon Bay Air Override
dev:listen_command(10007)--Master Arm
dev:listen_command(10008)--Master Arm Toggle
dev:listen_command(10021)--First Detent
dev:listen_command(10022)--Second Detent
dev:listen_command(10026)--PICKLE

local master_arm_switch = device_commands.Button_1 --track mouse clicks
dev:listen_command(master_arm_switch)
local emer_jet = device_commands.Button_2 --track mouse clicks
dev:listen_command(emer_jet)


local weapon_release_state 	= 0 --track if you press weapon release
local master_arm_state		= 0 --track if master arm switch is ON
local mode_state 			= 1 --default NAV mode
--local ground_override		= 0
local ecm_state				= 0 --track E keybind press
local bay_air_state			= 0
local hotas_station			= 2
local dogfight_mode			= 0
local first_state		    = 0
local fire_z_weapons 		= 0
local air_oride				= 0
local detent_pos			= 0
local pickle_pos			= 0
------------------------------------------------------------------FUNCTION-POSTINIT---------------------------------------------------------------------------------------------------

function post_initialize()
	--print_message_to_user("WEAPON SYSTEM POST INIT")
	
	local bay_option_state = get_aircraft_property("BAY_DOOR_OPTION")--ME Option Box
	local birth = LockOn_Options.init_conditions.birth_place
	--print_message_to_user(bay_option_state)
	if birth == "GROUND_COLD" then
		parameters.BAY_OPTION:set(bay_option_state) -- Unchecked = 0 Checked = 1	
	elseif birth == "GROUND_HOT" or birth == "AIR_HOT" then
		parameters.BAY_OPTION:set(1)
		--dispatch_action(nil,Battery)
		--dev:performClickableAction(battery_switch, 1, false)
	end
	--Bay Arg Preset
	if bay_option_state == 0 then
		--parameters.GROUND_ORIDE:set(1)
		set_aircraft_draw_argument_value(600,1)
		set_aircraft_draw_argument_value(601,1)
		set_aircraft_draw_argument_value(602,1)
	elseif bay_option_state == 1 then
		parameters.GROUND_ORIDE:set(0)
		set_aircraft_draw_argument_value(600,0)
		set_aircraft_draw_argument_value(601,0)
		set_aircraft_draw_argument_value(602,0)
	end
end
------------------------------------------------------------------FUNCTION-SETCOMMAND---------------------------------------------------------------------------------------------------
function SetCommand(command,value)
--WEP JET
	if command == emer_jet then
		dispatch_action(nil,178)
	end
--Air Override
	if (command == 10006 or command == 10024) and air_oride == 0 and parameters.MAIN_POWER:get() == 1 then
		air_oride = 1
	elseif (command == 10006 or command == 10024) and air_oride == 1 and parameters.MAIN_POWER:get() == 1 then
		air_oride = 0
	end
-- --Trigger Detent
-- 	if command == 10021 and master_arm_state == 1 and first_state == 0 and parameters.MAIN_POWER:get() == 1 then
-- 		first_state = 1
-- 		--print_message_to_user("FIRST DETENT")
-- 	elseif command == 10021 and master_arm_state == 1 and first_state == 1 and parameters.MAIN_POWER:get() == 1 then
-- 		first_state = 0
-- 		--print_message_to_user("FIRST RELEASE")
-- 	elseif command == 10022 and master_arm_state == 1 and first_state == 1 and fire_z_weapons == 0 and parameters.MAIN_POWER:get() == 1 then
-- 		fire_z_weapons = 1
-- 		--print_message_to_user("FIRE Z WEAPONS!!!!")
-- 	elseif command == 10022 and master_arm_state == 1 and first_state == 1 and fire_z_weapons == 1 and parameters.MAIN_POWER:get() == 1 then
-- 		fire_z_weapons = 0
-- 		dispatch_action(nil,PlaneFireOff)
-- 		--print_message_to_user("STOP FIRE Z WEAPONS!!!!")
-- 	end

--First Trigger Detent
if command == 10021 and first_state == 0 and parameters.MAIN_POWER:get() == 1 then
	first_state = 1
	detent_pos = 0.50
	--print_message_to_user("FIRST DETENT")
elseif command == 10021 and first_state == 1 and parameters.MAIN_POWER:get() == 1 then
	first_state = 0
	detent_pos = 0
	--print_message_to_user("FIRST RELEASE")
end
--Second Trigger Detent
if command == 10022 and fire_z_weapons == 0 and parameters.MAIN_POWER:get() == 1 then
	fire_z_weapons = 1
	detent_pos = 1
	--first_state    = 1
	--print_message_to_user("FIRE Z WEAPONS!!!!")
elseif command == 10022 and fire_z_weapons == 1 and parameters.MAIN_POWER:get() == 1 then
	fire_z_weapons = 0
	detent_pos = 0.50
	--first_state    = 0
	dispatch_action(nil,PlaneFireOff)
	--print_message_to_user("STOP FIRE Z WEAPONS!!!!")
end	
--Mode States
	if command == PlaneModeNAV then
		mode_state = 1
		--print_message_to_user("NAV MODE")
	elseif command == PlaneModeBVR then
		mode_state = 2
		--print_message_to_user("BVR MODE")
	elseif command == PlaneModeVS then
		mode_state = 3
		--print_message_to_user("VS MODE")
	elseif command == PlaneModeBore then
		mode_state = 4
		--print_message_to_user("BORE MODE")
	elseif command == PlaneModeFI0 then
		mode_state = 6
		--print_message_to_user("FLOOD MODE")
	end					
--Master Arm JOYSTICK/KEYBOARD BINDS
	if (command == 10007 or command == 10008 or command == master_arm_switch) and master_arm_state == 0 then
		master_arm_state = 1
		--print_message_to_user("MASTER ARM ON")
	elseif (command == 10007 or command == 10008 or command == master_arm_switch) and master_arm_state == 1 then
		master_arm_state = 0
		--print_message_to_user("MASTER ARM OFF")
	end		
	-- --Bay Doors Open Close
	-- if command == PickleON and weapon_release_state == 0 then
	-- 	weapon_release_state = 1
	-- 	--print_message_to_user("COMMAND DEPRESS")
	-- elseif command == PickleOFF and weapon_release_state == 1 then
	-- 	weapon_release_state = 0
	-- 	--print_message_to_user("COMMAND RELEASE")
	-- end	
	--Bay Doors Open Close
	if command == 10026 and master_arm_state == 0 and pickle_pos < 1 then
		pickle_pos = 1
		--print_message_to_user("button moves in Doesnt fire")
	elseif command == 10026 and master_arm_state == 0 and pickle_pos > 0  then
		pickle_pos = 0
		--print_message_to_user("button moves out Doesnt fire")
	elseif command == 10026 and weapon_release_state == 0 and master_arm_state == 1 then
		weapon_release_state = 1
		pickle_pos = 1
		dispatch_action(nil,PickleON)
		--print_message_to_user("COMMAND DEPRESS")
	elseif command == 10026 and weapon_release_state == 1 then
		weapon_release_state = 0
		pickle_pos = 0
		dispatch_action(nil,PickleOFF)
		--print_message_to_user("COMMAND RELEASE")
	end	
	--ecm_state JAMMER
	if command == ActiveJamming and ecm_state == 0 then
		ecm_state = 1
		--print_message_to_user("JAMMING")
	elseif command == ActiveJamming and ecm_state == 1 then
		ecm_state = 0
		--print_message_to_user("NOT JAMMING")
	end
	--Dogfight Mode
	-- if command == 10005 and dogfight_mode == 0 then
	-- 	dogfight_mode = 1
	-- 	print_message_to_user("DOGFIGHT MODE ON")
	-- elseif command == 10005 and dogfight_mode == 1 then
	-- 	dogfight_mode = 0
	-- 	print_message_to_user("DOGFIGHT MODE OFF")
	-- end	

end
------------------------------------------------------------------FUNCTION-UPDATE---------------------------------------------------------------------------------------------------
function update()
	-- print_message_to_user(parameters.WoW:get()) --0 no weight 1 weight on wheel
	-- print_message_to_user(canon_rotate)

	local bay_door_pos   = get_aircraft_draw_argument_value(600)
	local left_door_pos  = get_aircraft_draw_argument_value(601)
	local right_door_pos = get_aircraft_draw_argument_value(602)
	local canon_door_pos = get_aircraft_draw_argument_value(614)
	local canon_rotate   = get_aircraft_draw_argument_value(615)

	local left_door_pos_gpu  = get_aircraft_draw_argument_value(601)
	--LEFT BAY Ground Power
	if parameters.GROUND_POWER:get() == 1 and left_door_pos_gpu <= 1 and parameters.GROUND_ORIDE:get() == 0 and parameters.WoW:get() == 1 then
		left_door_pos_gpu = left_door_pos_gpu + 0.005
		set_aircraft_draw_argument_value(601, left_door_pos_gpu)
	elseif parameters.GROUND_POWER:get() == 0 and left_door_pos_gpu >= 0 and parameters.GROUND_ORIDE:get() == 0 and parameters.WoW:get() == 1 then
		left_door_pos_gpu = left_door_pos_gpu - 0.005
		set_aircraft_draw_argument_value(601, left_door_pos_gpu)
	end
--parameters.BAY_OPTION:get() == 1
	--parameters.BAY_STATION:set(hotas_station) --had to remove
	--GROUND BAY OVERRIDE
	if sensor_data.getNoseLandingGearDown() == 1 and parameters.GROUND_ORIDE:get() == 1 and parameters.MAIN_POWER:get() == 1 and bay_door_pos <= 1 then --and parameters.BAY_OPTION:get() == 0 then
		bay_door_pos = bay_door_pos + 0.0022
		left_door_pos = left_door_pos + 0.0022
		right_door_pos = right_door_pos + 0.0022
		set_aircraft_draw_argument_value(600,bay_door_pos)
		set_aircraft_draw_argument_value(601,left_door_pos)
		set_aircraft_draw_argument_value(602,right_door_pos)
	elseif sensor_data.getNoseLandingGearDown() == 1 and parameters.GROUND_ORIDE:get() == 0 and parameters.MAIN_POWER:get() == 1 and bay_door_pos >= 0 then --and parameters.BAY_OPTION:get() == 0 then
		bay_door_pos = bay_door_pos - 0.0022
		left_door_pos = left_door_pos - 0.0022
		right_door_pos = right_door_pos - 0.0022
		set_aircraft_draw_argument_value(600,bay_door_pos)
		set_aircraft_draw_argument_value(601,left_door_pos)
		set_aircraft_draw_argument_value(602,right_door_pos)
	end

	
	--ORIDE X
	if sensor_data.getNoseLandingGearDown() == 0 then --not on the ground...
		parameters.ORIDE_X:set(1)
	else
		parameters.ORIDE_X:set(0)
	end
	--ORIDE TEXT
	if sensor_data.getNoseLandingGearDown() == 1 and bay_door_pos >= 0.01 then
		parameters.ORIDE_TEXT:set(1)
	elseif sensor_data.getNoseLandingGearDown() == 1 and bay_door_pos < 0.01 then
		parameters.ORIDE_TEXT:set(0)
	end
	-- ARMED TEXT
	if sensor_data.getNoseLandingGearDown() == 1 and sensor_data.getRightMainLandingGearDown() == 1 and sensor_data.getLeftMainLandingGearDown() == 1 then
		parameters.ARM_STATUS:set(2)
	elseif master_arm_state == 1 and sensor_data.getNoseLandingGearDown() == 0 and sensor_data.getRightMainLandingGearDown() == 0 and sensor_data.getLeftMainLandingGearDown() == 0 then
		parameters.ARM_STATUS:set(1)
	elseif master_arm_state == 0 and sensor_data.getNoseLandingGearDown() == 0 and sensor_data.getRightMainLandingGearDown() == 0 and sensor_data.getLeftMainLandingGearDown() == 0 then
		parameters.ARM_STATUS:set(0)
	end
	--WEAPON BAY FIRE ANIMATIONS BAY STATION 1-left 2-center 3-right 4-all
		--ALL BAY ORIDE
		if air_oride == 1 and parameters.BAY_STATION:get() == 4 and master_arm_state == 1 and bay_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			left_door_pos = left_door_pos + 0.05
			right_door_pos = right_door_pos + 0.05
			bay_door_pos = bay_door_pos + 0.05
			set_aircraft_draw_argument_value(600, bay_door_pos)
			set_aircraft_draw_argument_value(601, left_door_pos)
			set_aircraft_draw_argument_value(602, right_door_pos)
		end
		--ALL BAY
		if weapon_release_state == 1 and air_oride == 0 and parameters.BAY_STATION:get() == 4 and master_arm_state == 1 and right_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			left_door_pos = left_door_pos + 0.05
			right_door_pos = right_door_pos + 0.05
			bay_door_pos = bay_door_pos + 0.05
			set_aircraft_draw_argument_value(600, bay_door_pos)
			set_aircraft_draw_argument_value(601, left_door_pos)
			set_aircraft_draw_argument_value(602, right_door_pos)
		end
		--CENTER BAY AIR ORIDE
		if air_oride == 1 and parameters.BAY_STATION:get() == 2 and master_arm_state == 1 and bay_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			bay_door_pos = bay_door_pos + 0.05
			set_aircraft_draw_argument_value(600, bay_door_pos)
		elseif air_oride == 0 and parameters.MAIN_POWER:get() == 1 and bay_door_pos >= 0 and sensor_data.getNoseLandingGearDown() == 0 then
			bay_door_pos = bay_door_pos
			set_aircraft_draw_argument_value(600, bay_door_pos)
		end
		--CENTER BAY
		if weapon_release_state == 1 and air_oride == 0 and parameters.BAY_STATION:get() == 2 and master_arm_state == 1 and bay_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			bay_door_pos = bay_door_pos + 0.05
			set_aircraft_draw_argument_value(600, bay_door_pos)
		elseif weapon_release_state == 0 and air_oride == 0 and parameters.MAIN_POWER:get() == 1 and bay_door_pos >= 0 and sensor_data.getNoseLandingGearDown() == 0 then
			bay_door_pos = bay_door_pos - 0.05
			set_aircraft_draw_argument_value(600, bay_door_pos)
		end
		--LEFT BAY ORIDE
		if air_oride == 1 and parameters.BAY_STATION:get() == 1 and master_arm_state == 1 and left_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() then
			left_door_pos = left_door_pos + 0.05
			set_aircraft_draw_argument_value(601, left_door_pos)
		elseif air_oride == 0 and parameters.MAIN_POWER:get() == 1 and left_door_pos >= 0 and sensor_data.getNoseLandingGearDown() == 0 and parameters.GROUND_POWER:get() == 0 then
			left_door_pos = left_door_pos
			set_aircraft_draw_argument_value(601, left_door_pos)
		end
		--LEFT BAY
		if weapon_release_state == 1 and air_oride == 0 and parameters.BAY_STATION:get() == 1 and master_arm_state == 1 and left_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			left_door_pos = left_door_pos + 0.05
			set_aircraft_draw_argument_value(601, left_door_pos)
		elseif weapon_release_state == 0 and air_oride == 0 and parameters.MAIN_POWER:get() == 1 and left_door_pos >= 0 and sensor_data.getNoseLandingGearDown() == 0 then
			left_door_pos = left_door_pos - 0.05
			set_aircraft_draw_argument_value(601, left_door_pos)
		end
		--RIGHT BAY ORIDE
		if air_oride == 1 and parameters.BAY_STATION:get() == 3 and master_arm_state == 1 and right_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			right_door_pos = right_door_pos + 0.05
			set_aircraft_draw_argument_value(602, right_door_pos)
		elseif air_oride == 0 and parameters.MAIN_POWER:get() == 1 and right_door_pos >= 0 and sensor_data.getNoseLandingGearDown() == 0 then
			right_door_pos = right_door_pos
			set_aircraft_draw_argument_value(602, right_door_pos)
		end
		--RIGHT BAY
		if weapon_release_state == 1 and air_oride == 0 and parameters.BAY_STATION:get() == 3 and master_arm_state == 1 and right_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			right_door_pos = right_door_pos + 0.05
			set_aircraft_draw_argument_value(602, right_door_pos)
		elseif weapon_release_state == 0 and air_oride == 0 and parameters.MAIN_POWER:get() == 1 and right_door_pos >= 0 and sensor_data.getNoseLandingGearDown() == 0 then
			right_door_pos = right_door_pos - 0.05
			set_aircraft_draw_argument_value(602, right_door_pos)
		end
		--First Detent CAnon Door
		if first_state == 1 and master_arm_state == 1 and canon_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			canon_door_pos = canon_door_pos + 0.0900
			set_aircraft_draw_argument_value(614, canon_door_pos)
		elseif first_state == 0 and master_arm_state == 1 and canon_door_pos >= 0 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			canon_door_pos = canon_door_pos - 0.0900
			set_aircraft_draw_argument_value(614, canon_door_pos)
		end
		if fire_z_weapons == 1 and master_arm_state == 1 and canon_door_pos <= 1 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
			canon_door_pos = canon_door_pos + 1--0.0900
			set_aircraft_draw_argument_value(614, canon_door_pos)
		-- elseif fire_z_weapons == 0 and master_arm_state == 1 and canon_door_pos >= 0 and parameters.MAIN_POWER:get() == 1 and sensor_data.getNoseLandingGearDown() == 0 then
		-- 	canon_door_pos = canon_door_pos - 0.0900
		-- 	set_aircraft_draw_argument_value(614, canon_door_pos)	
		end
		--Canon Timer
		if first_state == 1 and master_arm_state == 1 and parameters.MAIN_POWER:get() == 1 and canon_rotate < 1 then
			canon_rotate = (canon_rotate + update_time_step * 2)
			set_aircraft_draw_argument_value(615, canon_rotate)
		elseif first_state == 1 and master_arm_state == 1 and parameters.MAIN_POWER:get() == 1 and canon_rotate > 1 then
			canon_rotate = 0
			set_aircraft_draw_argument_value(615, canon_rotate)
		elseif fire_z_weapons == 1 and master_arm_state == 1 and parameters.MAIN_POWER:get() == 1 and canon_rotate < 1 then
			canon_rotate = (canon_rotate + update_time_step * 2)
			set_aircraft_draw_argument_value(615, canon_rotate)
		elseif fire_z_weapons == 1 and master_arm_state == 1 and parameters.MAIN_POWER:get() == 1 and canon_rotate > 1 then
			canon_rotate = 0
			set_aircraft_draw_argument_value(615, canon_rotate)
		end
		--CANON FIRE
		if fire_z_weapons == 1 and master_arm_state == 1 then
			dispatch_action(nil,PlaneFire)
		end
		-- --Canon Timer
		-- if first_state == 1 and master_arm_state == 1 and parameters.MAIN_POWER:get() == 1 and canon_rotate < 1 then
		-- 	canon_rotate = (canon_rotate + update_time_step * 2)
		-- 	set_aircraft_draw_argument_value(615, canon_rotate)
		-- elseif first_state == 1 and master_arm_state == 1 and parameters.MAIN_POWER:get() == 1 and canon_rotate > 1 then
		-- 	canon_rotate = 0
		-- 	set_aircraft_draw_argument_value(615, canon_rotate)
		-- end
		
		--Missile
		-- if weapon_release_state == 1 and master_arm_state == 1 and parameters.MAIN_POWER:get() == 1 then
		-- 	dispatch_action(nil,PickleON)
		-- 	print_message_to_user("FIRE Z MISSILE")
		-- else
		-- 	dispatch_action(nil,PickleOFF)
		-- 	print_message_to_user("DONT FIRE Z MISSILE")
		-- end

-----------------------------------------------------------------------
	parameters.BAY_C_ARG:set(bay_door_pos)
	parameters.BAY_L_ARG:set(left_door_pos)
	parameters.BAY_R_ARG:set(right_door_pos)
	parameters.ECM_ARG:set(ecm_state)
	parameters.MASTER_ARM:set(master_arm_state)
	parameters.DOGFIGHT:set(dogfight_mode)
	parameters.AIR_ORIDE:set(air_oride)
	parameters.HUD_MODE:set(mode_state)
	parameters.DETENT:set(detent_pos)
	parameters.PICKLE:set(pickle_pos)

end

--need_to_be_closed = false

----Ref
--[[
getAngleOfAttack
getAngleOfSlide
getBarometricAltitude
getCanopyPos
getCanopyState
getEngineLeftFuelConsumption
getEngineLeftRPM
getEngineLeftTemperatureBeforeTurbine
getEngineRightFuelConsumption
getEngineRightRPM
getEngineRightTemperatureBeforeTurbine
getFlapsPos
getFlapsRetracted
getHeading
getHelicopterCollective
getHelicopterCorrection
getHorizontalAcceleration
getIndicatedAirSpeed
getLandingGearHandlePos
getLateralAcceleration
getLeftMainLandingGearDown
getLeftMainLandingGearUp
getMachNumber
getMagneticHeading
getNoseLandingGearDown
getNoseLandingGearUp
getPitch
getRadarAltitude
getRateOfPitch
getRateOfRoll
getRateOfYaw
getRightMainLandingGearDown
getRightMainLandingGearUp
getRoll
getRudderPosition
getSpeedBrakePos
getStickPitchPosition
getStickRollPosition
getThrottleLeftPosition
getThrottleRightPosition
getTotalFuelWeight
getTrueAirSpeed
getVerticalAcceleration
getVerticalVelocity
getLeftMainLandingGearDown
getNoseLandingGearDown
getRightMainLandingGearDown
]]
