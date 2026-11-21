-- Systems/Electrical_System.lua: AAR switch, AAR and formation light knobs, taxi/landing light keybinds
local root = arg[1]
local support = dofile((arg[0]:match("^(.*[/\\])") or "") .. "support.lua")
local check = support.check

-- DCS re-enters SetCommand from performClickableAction: dcs.log showed "ELECTRICAL_SYSTEM::SetCommand:
-- C stack overflow" once per performClickableAction in post_initialize. The stub does the same, and
-- stops at a depth no legitimate chain reaches instead of overflowing.
local MAX_DEPTH = 10
local params, dispatched, moved = {}, {}, {}
local depth, deepest, env = 0, 0, nil
local dev = {
	listen_command = function() end,
	performClickableAction = function(_, command, value)
		moved[#moved + 1] = {command, value}
		if depth >= MAX_DEPTH then return end
		depth = depth + 1
		deepest = math.max(deepest, depth)
		env.SetCommand(command, value)
		depth = depth - 1
	end,
}
env = setmetatable({}, {__index = _G})
env.LockOn_Options = {script_path = root .. "/"}
env.dofile = function(path) local f = assert(loadfile(path)); setfenv(f, env); f() end
env.get_base_data = function() return setmetatable({}, {__index = function() return function() return 0 end end}) end
env.get_param_handle = function(name) return {get = function() return params[name] or 0 end, set = function(_, v) params[name] = v end} end
env.GetSelf = function() return dev end
env.make_default_activity = function() end
env.dispatch_action = function(_, command) dispatched[#dispatched + 1] = command end
env.get_cockpit_draw_argument_value = function() return 0 end
env.get_aircraft_draw_argument_value = function() return 0 end
local f = assert(loadfile(root .. "/Systems/Electrical_System.lua")); setfenv(f, env); f()

local AAR_SWITCH, AAR_LIGHT, FORM_LIGHT = env.device_commands.Button_1, env.device_commands.Button_2, env.device_commands.Button_7
local REFUEL = env.Keys.PlaneAirRefuel
local function refuels() local n = 0; for _, c in ipairs(dispatched) do if c == REFUEL then n = n + 1 end end; return n end
local function last_move(command) for i = #moved, 1, -1 do if moved[i][1] == command then return moved[i][2] end end end
local function settled(what) check(deepest < MAX_DEPTH, what .. " settles (re-entry depth " .. deepest .. ")"); deepest = 0 end

env.post_initialize()
settled("post_initialize")
check(params.AAR == 0 and refuels() == 0, "starts with the AAR port closed, nothing dispatched")
check(params.AAR_KNOB == 0.5 and params.FORM_KNOB == 0.5, "light knobs start at half")

env.SetCommand(10015, 1)
settled("AAR keybind")
check(params.AAR == 1 and refuels() == 1, "AAR keybind opens the port once")
check(last_move(AAR_SWITCH) == 1, "AAR keybind moves the cockpit switch to open")
env.SetCommand(10016, 1)
settled("AAR toggle keybind")
check(params.AAR == 0 and refuels() == 2, "AAR toggle keybind closes it again")
check(last_move(AAR_SWITCH) == 0, "and moves the cockpit switch back")

env.SetCommand(AAR_SWITCH, 1)
settled("clicking the AAR switch")
check(params.AAR == 1 and refuels() == 3, "clicking the switch open opens the port once")
env.SetCommand(AAR_SWITCH, 1)
check(params.AAR == 1 and refuels() == 3, "the switch already open: nothing more dispatched")
env.SetCommand(AAR_SWITCH, -1)
settled("clicking the AAR switch back")
check(params.AAR == 0 and refuels() == 4, "clicking it closed closes the port")

env.SetCommand(AAR_LIGHT, 0.3)
settled("turning the AAR light knob")
check(params.AAR_KNOB == 0.3, "AAR light knob value kept")
env.SetCommand(FORM_LIGHT, 1.4)
settled("turning the formation light knob")
check(params.FORM_KNOB == 1, "formation light knob clamped to 1")

env.SetCommand(10151, 1)
settled("taxi light keybind")
check(last_move(env.device_commands.Button_4) == -1, "taxi light keybind moves the switch to taxi")

support.finish()
