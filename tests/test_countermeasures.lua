-- Systems/Countermeasures.lua: the F-22A's own chaff/flare dispenser, running while the F-15C avionics are still loaded
local root = arg[1]
local support = dofile((arg[0]:match("^(.*[/\\])") or "") .. "support.lua")
local check = support.check

-- Commands bound in Input/F-22A (see test_input.lua)
local CHAFF, FLARE, SALVO, PROGRAM = 10160, 10161, 10162, 10163
-- Stock commands the F-15C avionics act on
local STOCK_CM = {77, 176, 357, 358}
local GUN_ON, GUN_OFF, PICKLE_ON, PICKLE_OFF = 84, 85, 350, 351

local function new_env(chaff, flare, power)
	local env = setmetatable({}, {__index = _G})
	local drops, listened, messages = {}, {}, {}
	local params = {MAIN_POWER = power}
	-- The device is an avSimpleWeaponSystem: the dispenser calls are on the device itself
	local dev = {
		listen_command  = function(_, c) listened[c] = true end,
		get_chaff_count = function() return chaff end,
		get_flare_count = function() return flare end,
		drop_chaff = function(_, n, d) chaff = chaff - n; drops[#drops + 1] = "C" .. d end,
		drop_flare = function(_, n, d) flare = flare - n; drops[#drops + 1] = "F" .. d end,
	}
	env.LockOn_Options = {script_path = root .. "/"}
	env.GetSelf = function() return dev end
	env.GetDevice = function(id) error("unexpected GetDevice(" .. tostring(id) .. "): the F-15C avionics own the cockpit lights") end
	env.make_default_activity = function() end
	env.get_param_handle = function(name) return {get = function() return params[name] end, set = function(_, v) params[name] = v end} end
	env.print_message_to_user = function(text) messages[#messages + 1] = text end
	env.dofile = function(path) local f = assert(loadfile(path)); setfenv(f, env); f() end
	local f = assert(loadfile(root .. "/Systems/Countermeasures.lua")); setfenv(f, env); f()
	if env.post_initialize then env.post_initialize() end
	return {env = env, drops = drops, listened = listened, messages = messages, params = params}
end

local function join(t) return table.concat(t, ",") end

do local a = new_env(10, 10, 1)
	check(a.listened[CHAFF] and a.listened[FLARE] and a.listened[SALVO] and a.listened[PROGRAM], "listens to the F-22A countermeasure commands")
	local stock = false
	for _, c in ipairs(STOCK_CM) do if a.listened[c] then stock = true end end
	check(not stock, "leaves the stock countermeasure commands alone")
	check(a.listened[GUN_ON] and a.listened[GUN_OFF] and a.listened[PICKLE_ON] and a.listened[PICKLE_OFF],
		"takes gun and pickle commands so avSimpleWeaponSystem does not act on them next to the F-15C avionics")
	for _, c in ipairs({GUN_ON, GUN_OFF, PICKLE_ON, PICKLE_OFF, 77, 176, 357, 358}) do a.env.SetCommand(c, 1) end
	a.env.update()
	check(#a.drops == 0, "and does nothing with them, nor with stock countermeasure commands")
end
do local a = new_env(10, 10, 0)
	a.env.SetCommand(CHAFF, 1); a.env.SetCommand(FLARE, 1); a.env.SetCommand(SALVO, 1)
	check(#a.drops == 0, "nothing dispensed without main power")
end
do local a = new_env(10, 10, 1)
	a.env.SetCommand(CHAFF, 1); a.env.SetCommand(FLARE, 1); a.env.SetCommand(SALVO, 1)
	check(join(a.drops) == "C0,F1,C0,F1", "chaff, flare and salvo alternate dispensers: " .. join(a.drops))
	check(a.messages[#a.messages] == "CM: chaff 8, flares 8", "shows what is left after each drop: " .. tostring(a.messages[#a.messages]))
end
do local a = new_env(0, 5, 1)
	a.env.SetCommand(CHAFF, 1); a.env.SetCommand(SALVO, 1); a.env.update()
	check(join(a.drops) == "F0", "empty chaff skipped, flare still released: " .. join(a.drops))
end
do local a = new_env(10, 10, 1)
	a.env.SetCommand(PROGRAM, 1)
	for _ = 1, 50 do a.env.update() end -- 2.5 s
	check(#a.drops == 6, "continuous program: 3 salvos in 2.5 s, got " .. #a.drops / 2)
	a.env.SetCommand(PROGRAM, 1)
	for _ = 1, 50 do a.env.update() end
	check(#a.drops == 6, "continuous program stops on second toggle")
end
do local a = new_env(10, 10, 1)
	a.env.SetCommand(PROGRAM, 1); a.env.update(); a.params.MAIN_POWER = 0
	for _ = 1, 50 do a.env.update() end
	a.params.MAIN_POWER = 1
	for _ = 1, 50 do a.env.update() end
	check(#a.drops == 2, "power loss cancels the program (no auto-resume)")
end
do local a = new_env(1, 1, 1)
	a.env.SetCommand(PROGRAM, 1)
	for _ = 1, 100 do a.env.update() end
	check(#a.drops == 2, "program stops when both are used up")
end
support.finish()
