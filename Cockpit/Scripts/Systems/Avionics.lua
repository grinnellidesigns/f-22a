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
local sensor_data = get_base_data()

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local update_rate = 0.006 --0.006
make_default_activity(update_rate)

local parameters =
{
	-- Engine
	APU_POWER			 = get_param_handle("APU_POWER"),
	APU_RPM_STATE		 = get_param_handle("APU_RPM_STATE"),
	BATTERY_POWER		 = get_param_handle("BATTERY_POWER"),
	MAIN_POWER		     = get_param_handle("MAIN_POWER"),
	L_GEN_POWER			 = get_param_handle ("L_GEN_POWER"),
	R_GEN_POWER			 = get_param_handle ("R_GEN_POWER"),

	-- Indicator
	UFD_OPACITY		     = get_param_handle("UFD_OPACITY"),
	MFD_OPACITY		     = get_param_handle("MFD_OPACITY"),
	ICP_OPACITY		     = get_param_handle("ICP_OPACITY"),
	R_ADI_OPACITY     	 = get_param_handle("R_ADI_OPACITY"),
	R_WAR_OPACITY 		 = get_param_handle("R_WAR_OPACITY"),
	L_ADI_OPACITY     	 = get_param_handle("L_ADI_OPACITY"),
	L_WAR_OPACITY 		 = get_param_handle("L_WAR_OPACITY"),
	TAS				     = get_param_handle("TAS"),
	IAS				     = get_param_handle("IAS"),
	GFORCE			     = get_param_handle("GFORCE"),
	AOA			     	 = get_param_handle("AOA"),
	VV			     	 = get_param_handle("VV"),
	ADI_PITCH 		     = get_param_handle("ADIPITCH"),
	ADI_ROLL			 = get_param_handle("ADIROLL"),
	SLIP				 = get_param_handle("SLIP"),
	YAW				     = get_param_handle("YAW"),
	ROLLRATE			 = get_param_handle("ROLLRATE"),
	NAV                  = get_param_handle("NAV"),
	BARO 				 = get_param_handle("BAROALT"),
	RADALT			     = get_param_handle("RADALT"),
	RPM_L                = get_param_handle("RPM_L"),
	RPM_R                = get_param_handle("RPM_R"),
	EGT_L                = get_param_handle("EGT_L"),
	EGT_R                = get_param_handle("EGT_R"),
	FUELL                = get_param_handle("FUELL"),
	FUEL                 = get_param_handle("FUEL"),
	FUELT                = get_param_handle("FUELT"),
	FUELTANK             = get_param_handle("FUELTANK"),
	FLOOD_LIGHT 		 = get_param_handle("FLOOD_LIGHT"),
	PANEL_LIGHT 		 = get_param_handle("PANEL_LIGHT"),	
	CANOPY_LIGHT 		 = get_param_handle("CANOPY_LIGHT"),	
	CHAFF_LIGHT   	     = get_param_handle("CHAFF_LIGHT"),	
	FLARE_LIGHT   	     = get_param_handle("FLARE_LIGHT"),	
	SPD_BRK_LIGHT 	     = get_param_handle("SPD_BRK_LIGHT"),	
	BINGO_LIGHT   	     = get_param_handle("BINGO_LIGHT"),	
	FLAPS_MOVE 		     = get_param_handle("FLAPS_MOVE"),	
	FLAPS_DOWN		     = get_param_handle("FLAPS_DOWN"),	
	AAR_LIGHT 		     = get_param_handle("AAR_LIGHT"),	
	L_FIRE_LIGHT 		 = get_param_handle("L_FIRE_LIGHT"),	
	R_FIRE_LIGHT 		 = get_param_handle("R_FIRE_LIGHT"),	
	L_GEN_OUT 		     = get_param_handle("L_GEN_OUT"),	
	R_GEN_OUT 		     = get_param_handle("R_GEN_OUT"),	
	HYD_LIGHT 		     = get_param_handle("HYD_LIGHT"),	
	CAUTION_LIGHT		 = get_param_handle("CAUTION_LIGHT"),	
	OIL_LIGHT			 = get_param_handle("OIL_LIGHT"),
	APU_READY			 = get_param_handle("APU_READY"),
	APU_SPOOL			 = get_param_handle("APU_SPOOL"),
	L_OIL_COLOR	     	 = get_param_handle("L_OIL_COLOR"),
	R_OIL_COLOR	     	 = get_param_handle("R_OIL_COLOR"),
	L_HYD_COLOR			 = get_param_handle("L_HYD_COLOR"),
	R_HYD_COLOR			 = get_param_handle("R_HYD_COLOR"),

	LMFD_ENG_PAGE        = get_param_handle("LMFD_ENG_PAGE"),
	LMFD_MENU_PAGE       = get_param_handle("LMFD_MENU_PAGE"),
	LMFD_FCS_PAGE        = get_param_handle("LMFD_FCS_PAGE"),
	LMFD_FUEL_PAGE       = get_param_handle("LMFD_FUEL_PAGE"),
	LMFD_ADI_PAGE        = get_param_handle("LMFD_ADI_PAGE"),
	LMFD_BAY_PAGE        = get_param_handle("LMFD_BAY_PAGE"),
	LMFD_CHECKLIST_PAGE  = get_param_handle("LMFD_CHECKLIST_PAGE"),
	LMFD_SMS_PAGE        = get_param_handle("LMFD_SMS_PAGE"),
	LMFD_HSI_PAGE        = get_param_handle("LMFD_HSI_PAGE"),
 	LMFD_PAGE            = get_param_handle("LMFD_PAGE"),
	LMFD_MASK            = get_param_handle("LMFD_MASK"),
	RMFD_MASK            = get_param_handle("RMFD_MASK"),
	PMFD_MASK            = get_param_handle("PMFD_MASK"),
	RMFD_BLANK_PAGE  	 = get_param_handle("RMFD_BLANK_PAGE"),
	CMFD_BLANK_PAGE      = get_param_handle("CMFD_BLANK_PAGE"),
	DAY_NIGHT	         = get_param_handle("DAY_NIGHT"),
	MACH	         	 = get_param_handle("MACH"),
	PITCHRATE	         = get_param_handle("PITCHRATE"),
	YAWRATE	         	 = get_param_handle("YAWRATE"),
}

local day_night = 0

-- Clickable data
local MFD_KNOB_mouse   = device_commands.Button_3 -- Track mouse scroll
local UFD_KNOB_mouse   = device_commands.Button_4  -- Track mouse scroll
local day_night_switch = device_commands.Button_8  -- Track mouse clicks
local right_UFD_swap   = device_commands.Button_9  -- Track mouse clicks
local left_UFD_swap    = device_commands.Button_10 -- Track mouse clicks
local eject_handle     = device_commands.Button_11 -- Track mouse clicks

dev:listen_command(UFD_KNOB_mouse)
dev:listen_command(day_night_switch)
dev:listen_command(right_UFD_swap)
dev:listen_command(left_UFD_swap)
dev:listen_command(83)

dev:listen_command(10017)--DAY NIGHT
dev:listen_command(10018)--DAY NIGHT T

dev:listen_command(10027)--swap bind ufd

function post_initialize()
	--print_message_to_user("AVIONICS SYSTEM POST INIT")
	
	local birth_place = LockOn_Options.init_conditions.birth_place

	if birth_place == "GROUND_COLD" then
		--dev:performClickableAction(right_UFD_swap, 1, false)
		dev:performClickableAction(UFD_KNOB_mouse, 1, false)--remove for release?
		dev:performClickableAction(MFD_KNOB_mouse, 1, false)--remove for release?
	elseif birth_place == "GROUND_HOT" or birth_place == "AIR_HOT" then
		--UFD_KNOB:set(0.5)
		--dispatch_action(nil,Battery)
		dev:performClickableAction(UFD_KNOB_mouse, 1, false)
		dev:performClickableAction(MFD_KNOB_mouse, 1, false)
		--dev:performClickableAction(right_UFD_swap, 1, false)
		--print_message_to_user("HOT START")
	end
end
local L_UFD_WAR = 1
local R_UFD_ADI = 1 
local R_UFD_WAR = 0
local L_UFD_ADI = 0
function SetCommand(command,value)
	--Eject handle
	if command == eject_handle then
		dispatch_action(nil,83)
		print_message_to_user("EJECT!!!")
	end
	-- Day/Night switch
	if (command == day_night_switch or command == 10017 or command == 10018) and day_night == 0 then
		day_night = 1
		--print_message_to_user("NIGHT MODE")
	elseif (command == day_night_switch or command == 10017 or command == 10018) and day_night == 1 then 
		day_night = 0
		--print_message_to_user("DAY MODE")
	end
	--RIGHT UFD SWAP
	if (command  == right_UFD_swap or command == left_UFD_swap or command == 10027) and R_UFD_ADI == 1 then
		R_UFD_ADI = 0
		R_UFD_WAR = 1
		--print_message_to_user("UFD SCREEN SWAP - RIGHT")
	elseif (command  == right_UFD_swap or command == left_UFD_swap or command == 10027) and R_UFD_ADI == 0 then
		R_UFD_ADI = 1
		R_UFD_WAR = 0
		--print_message_to_user("UFD SWAP")
	end
end

function update()
	--print_message_to_user(parameters.FLAPS_DOWN:get())

	--Fix for flaps down light
	local flapPosL = get_aircraft_draw_argument_value(10)
	local flapPosR = get_aircraft_draw_argument_value(9)
	if ((flapPosL + flapPosR) > 1.98) then
		parameters.FLAPS_DOWN:set(1)	
	else
		parameters.FLAPS_DOWN:set(0)	
	end

	-- Fuel state
	if parameters.FUELT:get() <= 0 then
		parameters.FUELTANK:set(0)
	else
		parameters.FUELTANK:set(sensor_data.getTotalFuelWeight() * 2.20462 - 13454) -- Working, don't chage: 0.36622 
	end
	
	local MFD_KNOB          = get_cockpit_draw_argument_value(704)
	local UFD_KNOB          = get_cockpit_draw_argument_value(705)
	local CONSOLE_KNOB      = get_cockpit_draw_argument_value(706)
	local FLOOD_KNOB        = get_cockpit_draw_argument_value(707)
	local CANOPY_ARG        = get_cockpit_draw_argument_value(251)
	local CHAFF_ARG         = get_cockpit_draw_argument_value(254)
	local FLARE_ARG         = get_cockpit_draw_argument_value(255)
	local SPD_BRK_ARG       = get_cockpit_draw_argument_value(200)
	local BINGO_ARG         = get_cockpit_draw_argument_value(225)
	local FLAPS_MOVE_ARG    = get_cockpit_draw_argument_value(42)
	local FLAPS_DOWN_ARG    = get_cockpit_draw_argument_value(43)
	local AAR_ARG           = get_cockpit_draw_argument_value(0)
	local L_FIRE_ARG        = get_cockpit_draw_argument_value(126)
	local R_FIRE_ARG        = get_cockpit_draw_argument_value(256)
	local L_GEN_ARG         = get_cockpit_draw_argument_value(207)
	local R_GEN_ARG         = get_cockpit_draw_argument_value(219)
	local HYD_ARG           = get_cockpit_draw_argument_value(208) 
	local CAUTION_ARG       = get_cockpit_draw_argument_value(117)       
	local OIL_ARG           = get_cockpit_draw_argument_value(220)

	--parameters.UFD_OPACITY  :set(UFD_KNOB)
	--parameters.MFD_OPACITY  :set(MFD_KNOB)
	parameters.TAS	        :set(sensor_data.getTrueAirSpeed() * 1.944)
	parameters.IAS	        :set(sensor_data.getIndicatedAirSpeed() * 1.944)
	parameters.GFORCE       :set(sensor_data.getVerticalAcceleration())
	parameters.ADI_PITCH    :set(sensor_data.getPitch() )
	parameters.ADI_ROLL     :set(sensor_data.getRoll() )
	parameters.SLIP			:set(sensor_data.getAngleOfSlide() )
	parameters.YAW          :set(sensor_data.getRateOfYaw() )
	parameters.ROLLRATE     :set(sensor_data.getRateOfRoll()/math.pi*180)-- Testing
	parameters.PITCHRATE    :set(sensor_data.getRateOfPitch()/math.pi*180)-- Testing
	parameters.YAWRATE      :set(sensor_data.getRateOfYaw()/math.pi*180)-- Testing
	parameters.AOA			:set(sensor_data.getAngleOfAttack()/math.pi*180)
	parameters.VV			:set(sensor_data.getVerticalVelocity()* 196.85)
	parameters.MACH			:set(sensor_data.getMachNumber())
	--parameters.NAV          :set(360 - sensor_data.getHeading()/math.pi*180) -- Working, don't change
	hdg_int = math.floor(360 - sensor_data.getHeading()/math.pi*180)
	if (hdg_int > 359) then
   		hdg_int = 0
	end
	parameters.NAV:set(hdg_int)
	--parameters.NAV			:set((359 - sensor_data.getHeading() * 180/math.pi))
	parameters.RADALT       :set(sensor_data.getRadarAltitude() ) -- Working, don't change
	parameters.BARO         :set(sensor_data.getBarometricAltitude() * 3.28084 ) -- Working, don't change	
	parameters.RPM_L        :set(sensor_data.getEngineLeftRPM())-- Needs to be tested (might not need to multiply by 2750 cause that was from fixed prop? maybe)
	parameters.RPM_R        :set(sensor_data.getEngineRightRPM())
	parameters.FUELL        :set(sensor_data.getTotalFuelWeight() * 0.01 ) -- Working, don't change: 0.36622 
	parameters.FUEL         :set(sensor_data.getTotalFuelWeight() * 2.20462 ) -- Working, don't change: 0.36622
	parameters.FUELT        :set(sensor_data.getTotalFuelWeight() * 2.20462 - 18000) -- Working, don't change: 0.36622 **25725 - 17500 = 8225**
	parameters.EGT_L        :set(sensor_data.getEngineLeftTemperatureBeforeTurbine())
	parameters.EGT_R        :set(sensor_data.getEngineRightTemperatureBeforeTurbine())

	parameters.CANOPY_LIGHT :set(CANOPY_ARG)
	parameters.CHAFF_LIGHT  :set(CHAFF_ARG)
	parameters.FLARE_LIGHT  :set(FLARE_ARG)
	parameters.SPD_BRK_LIGHT:set(SPD_BRK_ARG)	
	parameters.BINGO_LIGHT  :set(BINGO_ARG)	
	-- parameters.FLAPS_DOWN   :set(FLAPS_DOWN_ARG)	
	parameters.FLAPS_MOVE   :set(FLAPS_MOVE_ARG)	
	parameters.AAR_LIGHT    :set(AAR_ARG)	
	parameters.L_FIRE_LIGHT :set(L_FIRE_ARG)	
	parameters.R_FIRE_LIGHT :set(R_FIRE_ARG)	
	parameters.L_GEN_OUT    :set(L_GEN_ARG)	
	parameters.R_GEN_OUT    :set(R_GEN_ARG)
	parameters.CAUTION_LIGHT:set(CAUTION_ARG)
	parameters.OIL_LIGHT    :set(OIL_ARG)
	parameters.HYD_LIGHT    :set(HYD_ARG)
	parameters.DAY_NIGHT    :set(day_night)

	if parameters.APU_RPM_STATE:get() >= 2 and parameters.MAIN_POWER:get() == 0 then
		parameters.LMFD_ENG_PAGE:set(1)      
		parameters.RMFD_BLANK_PAGE:set(1)     
		parameters.CMFD_BLANK_PAGE:set(1)
	elseif parameters.APU_RPM_STATE:get() >= 2 and parameters.MAIN_POWER:get() == 1 then
		parameters.LMFD_ENG_PAGE:set(0)      
		parameters.RMFD_BLANK_PAGE:set(0)     
		parameters.CMFD_BLANK_PAGE:set(0)
	elseif parameters.MAIN_POWER:get() == 0 then
		parameters.LMFD_ENG_PAGE:set(0)     
		parameters.RMFD_BLANK_PAGE:set(0)     
		parameters.CMFD_BLANK_PAGE:set(0)
	end

	-- ALL SCREEN OPACITY LOGIC WITH DAY NIGHT MODE | UFD PAGE SWAP LOGIC | L-MFD ENG PAGE ONLY | C-MFD BAY PAGE ONLY | R-MFD CHK LIST ONLY 
	if (parameters.MAIN_POWER:get() == 1 or parameters.APU_RPM_STATE:get() >= 2) and parameters.BATTERY_POWER:get() == 1 and day_night == 0 and R_UFD_ADI == 1 then
		parameters.L_WAR_OPACITY:set(1)--WARNING PANEL LEFT ON
		parameters.R_WAR_OPACITY:set(0)
		parameters.UFD_OPACITY:set(UFD_KNOB)
		parameters.MFD_OPACITY:set(MFD_KNOB)
		parameters.FLOOD_LIGHT:set(FLOOD_KNOB)
		parameters.PANEL_LIGHT:set(CONSOLE_KNOB)     
	elseif (parameters.MAIN_POWER:get() == 1 or parameters.APU_RPM_STATE:get() >= 2) and parameters.BATTERY_POWER:get() == 1 and day_night == 0 and R_UFD_ADI == 0 then
		parameters.L_WAR_OPACITY:set(0)
		parameters.R_WAR_OPACITY:set(1)--WARNING PANEL RIGHT ON
		parameters.UFD_OPACITY:set(UFD_KNOB)
		parameters.MFD_OPACITY:set(MFD_KNOB)
		parameters.FLOOD_LIGHT:set(FLOOD_KNOB)
		parameters.PANEL_LIGHT:set(CONSOLE_KNOB)
	elseif (parameters.MAIN_POWER:get() == 1 or parameters.APU_RPM_STATE:get() >= 2) and parameters.BATTERY_POWER:get() == 1 and day_night == 1 and R_UFD_ADI == 1 then
		parameters.L_WAR_OPACITY:set(1)--WARNING PANEL LEFT ON	
		parameters.R_WAR_OPACITY:set(0)
		parameters.UFD_OPACITY:set(UFD_KNOB - 0.9)
		parameters.MFD_OPACITY:set(MFD_KNOB - 0.9)
		parameters.FLOOD_LIGHT:set(FLOOD_KNOB)
		parameters.PANEL_LIGHT:set(CONSOLE_KNOB)
	elseif (parameters.MAIN_POWER:get() == 1 or parameters.APU_RPM_STATE:get() >= 2) and parameters.BATTERY_POWER:get() == 1 and day_night == 1 and R_UFD_ADI == 0 then
		parameters.L_WAR_OPACITY:set(0)
		parameters.R_WAR_OPACITY:set(1)--WARNING PANEL RIGHT ON
		parameters.UFD_OPACITY:set(UFD_KNOB - 0.9)
		parameters.MFD_OPACITY:set(MFD_KNOB - 0.9)
		parameters.FLOOD_LIGHT:set(FLOOD_KNOB)
		parameters.PANEL_LIGHT:set(CONSOLE_KNOB)	
	elseif parameters.MAIN_POWER:get() == 0 or parameters.APU_RPM_STATE:get() <= 1.9 then
		parameters.L_WAR_OPACITY:set(0)
		parameters.R_WAR_OPACITY:set(0)
		parameters.UFD_OPACITY:set(0)
		parameters.MFD_OPACITY:set(0)
		parameters.FLOOD_LIGHT:set(0)
		parameters.PANEL_LIGHT:set(0)
	end

	-- Day/Night lights
	-- if day_night == 1 then
	-- 	parameters.UFD_OPACITY:set(UFD_KNOB - 0.9)
	-- 	parameters.MFD_OPACITY:set(MFD_KNOB - 0.9)
	-- end	
	-- if parameters.MAIN_POWER:get() == 1 and day_night == 0 then
	-- 	parameters.UFD_OPACITY:set(UFD_KNOB)
	-- 	parameters.MFD_OPACITY:set(MFD_KNOB)
	-- 	parameters.FLOOD_LIGHT:set(FLOOD_KNOB)
	-- 	parameters.PANEL_LIGHT:set(CONSOLE_KNOB)
	-- elseif parameters.MAIN_POWER:get() == 1 and day_night == 1 then
	-- 	parameters.UFD_OPACITY:set(UFD_KNOB - 0.9)
	-- 	parameters.MFD_OPACITY:set(MFD_KNOB - 0.9)
	-- 	parameters.FLOOD_LIGHT:set(FLOOD_KNOB)
	-- 	parameters.PANEL_LIGHT:set(CONSOLE_KNOB)
	-- end

	-- ADI page
	if parameters.MAIN_POWER:get() == 1 and R_UFD_ADI == 1 then
		parameters.R_ADI_OPACITY:set(1)
		parameters.L_ADI_OPACITY:set(0)
	elseif parameters.MAIN_POWER:get() == 1 and R_UFD_ADI == 0 then
		parameters.R_ADI_OPACITY:set(0)
		parameters.L_ADI_OPACITY:set(1)
	elseif  parameters.MAIN_POWER:get() == 0 then
		parameters.R_ADI_OPACITY:set(0)
		parameters.L_ADI_OPACITY:set(0)
		parameters.PMFD_MASK:set(0)
		parameters.LMFD_MASK:set(0)
		parameters.RMFD_MASK:set(0)
	end	

	--APU SPOOL
	if parameters.APU_POWER:get() == 0 and parameters.APU_RPM_STATE:get() > 0.10 and parameters.APU_RPM_STATE:get() < 3.80 then
		parameters.APU_SPOOL:set(1)
		parameters.APU_READY:set(0)
		--print_message_to_user("APU SPOOLING UP")
	elseif parameters.APU_POWER:get() == 1 and parameters.APU_RPM_STATE:get() > 0.10 and parameters.APU_RPM_STATE:get() < 3.80 then
		parameters.APU_SPOOL:set(1)
		parameters.APU_READY:set(0)
		--print_message_to_user("APU SPOOLING DOWN")			
	elseif parameters.APU_POWER:get() == 1 then
		parameters.APU_SPOOL:set(0)	
		parameters.APU_READY:set(1)
		--print_message_to_user("APU READY")
	else 
		parameters.APU_SPOOL:set(0)
		parameters.APU_READY:set(0)
	end
	--GEN OUT LIGHT FORCE
	if parameters.L_GEN_POWER:get() == 0 and parameters.RPM_L:get() >= 40 and sensor_data.getWOW_NoseLandingGear() == 1 then
		parameters.L_GEN_OUT:set(1)
		parameters.CAUTION_LIGHT:set(1)
	end
	--GEN OUT LIGHT FORCE
	if parameters.R_GEN_POWER:get() == 0 and parameters.RPM_R:get() >= 40 and sensor_data.getWOW_NoseLandingGear() == 1 then
		parameters.R_GEN_OUT:set(1)
		parameters.CAUTION_LIGHT:set(1)
	end
	--HYD LIGHT FORCE
	if parameters.L_HYD_COLOR:get() == 1 or parameters.R_HYD_COLOR:get() == 1 then
		parameters.HYD_LIGHT:set(1)
		parameters.CAUTION_LIGHT:set(1)
	end
	--OIL LIGHT FORCE
	if parameters.L_OIL_COLOR:get() == 1 or parameters.R_OIL_COLOR:get() == 1 then
		parameters.OIL_LIGHT:set(1)
		parameters.CAUTION_LIGHT:set(1)
	end
	--CANOPY MASTER CAUTION FORCE
	if parameters.CANOPY_LIGHT:get() == 1 then
		parameters.CAUTION_LIGHT:set(1)
	end
	-- UFD power knob (used for opacity/brightness issues)
	if UFD_KNOB == 0 then
		parameters.R_WAR_OPACITY:set(0)
		parameters.L_WAR_OPACITY:set(0)
		parameters.R_ADI_OPACITY:set(0)
		parameters.L_ADI_OPACITY:set(0)
		parameters.CANOPY_LIGHT:set(0)
		parameters.CHAFF_LIGHT:set(0)
		parameters.FLARE_LIGHT:set(0)
		parameters.SPD_BRK_LIGHT:set(0)	
		parameters.BINGO_LIGHT:set(0)	
		parameters.FLAPS_DOWN:set(0)	
		parameters.FLAPS_MOVE:set(0)	
		parameters.AAR_LIGHT:set(0)	
		parameters.L_FIRE_LIGHT:set(0)	
		parameters.R_FIRE_LIGHT:set(0)	
		parameters.L_GEN_OUT:set(0)	
		parameters.R_GEN_OUT:set(0)
		parameters.CAUTION_LIGHT:set(0)
		parameters.OIL_LIGHT:set(0)
		parameters.HYD_LIGHT:set(0)	
	end
	if MFD_KNOB == 0 then
		parameters.LMFD_MASK:set(0)
		parameters.RMFD_MASK:set(0)
		parameters.PMFD_MASK:set(0)
	end
	if parameters.BATTERY_POWER:get() == 0 then
		parameters.R_ADI_OPACITY:set(0)
		parameters.R_WAR_OPACITY:set(0)
		parameters.L_ADI_OPACITY:set(0)
		parameters.L_WAR_OPACITY:set(0)
		parameters.UFD_OPACITY:set(0)
		parameters.MFD_OPACITY:set(0)
		parameters.FLOOD_LIGHT:set(0)
		parameters.PANEL_LIGHT:set(0)
		parameters.ICP_OPACITY:set(0)
	end
end

need_to_be_closed = false
