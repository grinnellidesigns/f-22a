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
local sensor_data = get_base_data()

local update_time_step = 0.01
make_default_activity(update_time_step)

-- Parameters
local parameters = {
    APU_POWER        = get_param_handle("APU_POWER"),
    APU_RPM_STATE    = get_param_handle("APU_RPM_STATE"),
    BATTERY_POWER    = get_param_handle("BATTERY_POWER"),
    MAIN_POWER       = get_param_handle("MAIN_POWER"),
    WoW              = get_param_handle("WoW"),
    AAR              = get_param_handle("AAR"),
    N_GEAR_LIGHT     = get_param_handle("N_GEAR_LIGHT"),
    R_GEAR_LIGHT     = get_param_handle("R_GEAR_LIGHT"),
    L_GEAR_LIGHT     = get_param_handle("L_GEAR_LIGHT"),
    TAXI_SWITCH      = get_param_handle("TAXI_SWITCH"),
    NAV_LIGHT_SWITCH = get_param_handle("NAV_LIGHT_SWITCH"),
    FORM_KNOB        = get_param_handle("FORM_KNOB"),
    AAR_KNOB         = get_param_handle("AAR_KNOB"),
    AAR_READY        = get_param_handle("AAR_READY"),
}

local PlaneAirRefuel = Keys.PlaneAirRefuel
local AAR_SWITCH     = device_commands.Button_1
local AAR_LIGHT      = device_commands.Button_2
local NAV_SWITCH     = device_commands.Button_3
local TAXI_LIGHT     = device_commands.Button_4
local FORM_LIGHT     = device_commands.Button_7

dev:listen_command(PlaneAirRefuel)
dev:listen_command(AAR_SWITCH)
dev:listen_command(AAR_LIGHT)
dev:listen_command(NAV_SWITCH)
dev:listen_command(TAXI_LIGHT)
dev:listen_command(FORM_LIGHT)
dev:listen_command(74)  -- Brakes on
dev:listen_command(75)  -- Brakes off
dev:listen_command(10015)
dev:listen_command(10016)
dev:listen_command(10151)
dev:listen_command(10152)
dev:listen_command(10153)
dev:listen_command(10154)

local aar_state         = 0
local light_state       = 0  
local form_knob         = 0  
local aar_knob          = 0  

------------------------------------------------------------------FUNCTION-POST-INIT---------------------------------------------------------------------------------------------------
function post_initialize()
    aar_state        = 0
    light_state      = 0
    form_knob        = 0.5
    aar_knob         = 0.5
    parameters.AAR:set(aar_state)
    parameters.TAXI_SWITCH:set(light_state)
    parameters.FORM_KNOB:set(form_knob)
    parameters.AAR_KNOB:set(aar_knob)
    parameters.AAR_READY:set(0)
    dev:performClickableAction(AAR_SWITCH, aar_state, false)  
    dev:performClickableAction(AAR_LIGHT, aar_knob, false)  
    dev:performClickableAction(FORM_LIGHT, form_knob, false)  
end

------------------------------------------------------------------FUNCTION-SETCOMMAND---------------------------------------------------------------------------------------------------
function SetCommand(command, value)
    -- AAR Switch
    if (command == AAR_SWITCH or command == 10015 or command == 10016) and aar_state == 0 then
        aar_state = 1
        dispatch_action(nil, PlaneAirRefuel)
        dev:performClickableAction(AAR_SWITCH, aar_state, false)
        parameters.AAR:set(aar_state)
    elseif (command == AAR_SWITCH or command == 10015 or command == 10016) and aar_state == 1 then
        aar_state = 0
        dispatch_action(nil, PlaneAirRefuel)
        dev:performClickableAction(AAR_SWITCH, aar_state, false)
        parameters.AAR:set(aar_state)
    end

    -- AAR Light Knob (continuous axis)
    if command == AAR_LIGHT then
        aar_knob = math.max(0, math.min(1, value))
        dev:performClickableAction(AAR_LIGHT, aar_knob, false)
        parameters.AAR_KNOB:set(aar_knob)
    end

    -- Taxi/Landing Light Switch (keybinds only)
    if (command == 10151 or command == 10152) and light_state == 0 then -- taxi light
        light_state = -1
        dev:performClickableAction(TAXI_LIGHT, -1, false)
        parameters.TAXI_SWITCH:set(light_state)
    elseif (command == 10151 or command == 10152) and light_state == -1 then -- taxi light
        light_state = 0
        dev:performClickableAction(TAXI_LIGHT, 0, false)
        parameters.TAXI_SWITCH:set(light_state)
    elseif (command == 10151 or command == 10152) and light_state == 1 then -- taxi light
        light_state = 0
        dev:performClickableAction(TAXI_LIGHT, 0, false)
        parameters.TAXI_SWITCH:set(light_state)
    elseif (command == 10153 or command == 10154) and light_state == 0 then -- land light
        light_state = 1
        dev:performClickableAction(TAXI_LIGHT, 1, false)
        parameters.TAXI_SWITCH:set(light_state)
    elseif (command == 10153 or command == 10154) and light_state == 1 then -- land light
        light_state = 0
        dev:performClickableAction(TAXI_LIGHT, 0, false)
        parameters.TAXI_SWITCH:set(light_state)
    elseif (command == 10153 or command == 10154) and light_state == -1 then -- land light
        light_state = 0
        dev:performClickableAction(TAXI_LIGHT, 0, false)
        parameters.TAXI_SWITCH:set(light_state)
    end

    -- Formation Light Knob (continuous axis)
    if command == FORM_LIGHT then
        form_knob = math.max(0, math.min(1, value))
        dev:performClickableAction(FORM_LIGHT, form_knob, false)
        parameters.FORM_KNOB:set(form_knob)
    end
end

------------------------------------------------------------------FUNCTION-UPDATE---------------------------------------------------------------------------------------------------
function update()
    parameters.AAR:set(aar_state)
    parameters.TAXI_SWITCH:set(get_cockpit_draw_argument_value(709))
    parameters.NAV_LIGHT_SWITCH:set(get_cockpit_draw_argument_value(715))
    parameters.FORM_KNOB:set(get_cockpit_draw_argument_value(714))
    parameters.AAR_KNOB:set(get_cockpit_draw_argument_value(713))
    parameters.AAR_READY:set(get_aircraft_draw_argument_value(22))
end

need_to_be_closed = false