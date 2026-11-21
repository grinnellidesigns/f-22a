--[[
    Grinnelli Designs F-22A Raptor
    Copyright (C) 2026, Oleg V. Kozlyuk

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

-- Chaff/flare dispensing by the F-22A itself rather than the F-15C avionics, one of the
-- capabilities moved off them while they are still loaded. Runs as an avSimpleWeaponSystem,
-- the stock device that can drop chaff and flares.

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.05
make_default_activity(update_time_step)

-- Bound in Input/F-22A instead of the stock countermeasure commands, which only the F-15C avionics
-- receive now, so a key press never dispenses twice
local CHAFF   = 10160
local FLARE   = 10161
local SALVO   = 10162
local PROGRAM = 10163

-- avSimpleWeaponSystem fires the gun on PlaneFire unless its script handles the command (seen when
-- the F-22A ran on it alone); pickle is taken too in case stores are released the same way. While
-- the F-15C avionics are loaded they own the gun and stores, so these are taken and ignored here.
local WEAPON_COMMANDS = {Keys.PlaneFire, Keys.PlaneFireOff, Keys.PlanePickleOn, Keys.PlanePickleOff}

local PROGRAM_INTERVAL = 1.0 -- seconds between salvos of the continuous program

-- Experiment aid: whether this device and the F-15C avionics share one cartridge count is unknown
local SHOW_COUNTS = true

-- The chaff/flare cockpit lights (args 254/255) stay with the F-15C avionics while they are loaded

local MAIN_POWER = get_param_handle("MAIN_POWER")

local program_active  = false
local program_elapsed = 0

for _, command in ipairs({CHAFF, FLARE, SALVO, PROGRAM}) do
	dev:listen_command(command)
end
for _, command in ipairs(WEAPON_COMMANDS) do
	dev:listen_command(command)
end

local function has_power()
	return MAIN_POWER:get() == 1
end

local function show_counts()
	if SHOW_COUNTS then
		print_message_to_user(string.format("CM: chaff %d, flares %d", dev:get_chaff_count(), dev:get_flare_count()))
	end
end

-- No dispenser index: naming one cost flares in flight (after a single chaff, the program's flares
-- went to dispenser 0 and none came out). Left out, DCS picks the dispenser itself.
local function drop_chaff()
	if dev:get_chaff_count() > 0 then
		dev:drop_chaff(1)
	end
end

local function drop_flare()
	if dev:get_flare_count() > 0 then
		dev:drop_flare(1)
	end
end

local function drop_salvo()
	drop_chaff()
	drop_flare()
end

function SetCommand(command, value)
	if not has_power() then
		return
	end
	if command == CHAFF then
		drop_chaff(); show_counts()
	elseif command == FLARE then
		drop_flare(); show_counts()
	elseif command == SALVO then
		drop_salvo(); show_counts()
	elseif command == PROGRAM then
		program_active = not program_active
		-- First salvo goes out on the next update rather than one interval later
		program_elapsed = PROGRAM_INTERVAL
	end
end

function update()
	if not program_active then
		return
	end
	if not has_power() or (dev:get_chaff_count() == 0 and dev:get_flare_count() == 0) then
		program_active = false
		return
	end
	program_elapsed = program_elapsed + update_time_step
	if program_elapsed >= PROGRAM_INTERVAL then
		program_elapsed = 0
		drop_salvo(); show_counts()
	end
end
