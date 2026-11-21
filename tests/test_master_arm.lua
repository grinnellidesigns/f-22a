-- Systems/Weapon_System.lua and Input/F-22A: master arm at spawn, from the cockpit switch and from bindings
local root = arg[1]
local support = dofile((arg[0]:match("^(.*[/\\])") or "") .. "support.lua")
local check = support.check
local mod = root .. "/../../"

local SWITCH = 3001 -- device_commands.Button_1, the cockpit Master Arm switch (clickabledata.lua)
local HOLD   = 10007 -- "Master Arm On (Hold)": value 1 on press, 0 on release
local TOGGLE = 10008 -- "Master Arm Toggle"

local function spawn(birth_place)
	local params, switch = {}, {}
	local depth, max_depth = 0, 0
	local function stub() return 0 end
	local env = setmetatable({}, {__index = function(_, k) local v = _G[k]; if v ~= nil then return v end; return stub end})
	-- DCS moves the clickable to the value and runs SetCommand synchronously from performClickableAction
	local dev = setmetatable({
		listen_command = function() end,
		performClickableAction = function(_, command, value)
			switch[command] = value
			depth = depth + 1; max_depth = math.max(max_depth, depth)
			if depth < 10 then env.SetCommand(command, value) end
			depth = depth - 1
		end,
	}, {__index = function() return stub end})
	env.LockOn_Options = {script_path = root .. "/", init_conditions = {birth_place = birth_place}}
	env.dofile = function(path) local f = assert(loadfile(path)); setfenv(f, env); f() end
	env.GetSelf = function() return dev end
	env.get_base_data = function() return setmetatable({}, {__index = function() return stub end}) end
	env.get_param_handle = function(name) return {get = function() return params[name] or 0 end, set = function(_, v) params[name] = v end} end
	local f = assert(loadfile(root .. "/Systems/Weapon_System.lua")); setfenv(f, env); f()
	env.post_initialize()
	env.update()
	local a = {}
	function a.command(c, v) env.SetCommand(c, v); env.update() end
	function a.click(v) switch[SWITCH] = v; a.command(SWITCH, v) end -- a click moves the switch and sends its new position
	function a.armed() return params.MASTER_ARM == 1 end
	function a.switch() return switch[SWITCH] end
	function a.max_depth() return max_depth end
	return a
end

do local a = spawn("AIR_HOT")
	check(a.armed() and a.switch() == 1, "air start: armed, cockpit switch at ARM")
	a.click(0)
	check(not a.armed(), "click to SAFE safes it")
	a.click(1); a.click(1)
	check(a.armed(), "the switch sets a position: clicking ARM twice stays armed")
	a.command(HOLD, 0)
	check(not a.armed() and a.switch() == 0, "On (Hold) released: SAFE, cockpit switch follows")
	a.command(HOLD, 1)
	check(a.armed() and a.switch() == 1, "On (Hold) pressed: ARM, cockpit switch follows")
	a.command(TOGGLE, 1)
	check(not a.armed() and a.switch() == 0, "Toggle: SAFE, cockpit switch follows")
	a.command(TOGGLE, 1)
	check(a.armed() and a.switch() == 1, "Toggle again: ARM")
	check(a.max_depth() == 1, "moving the switch re-enters SetCommand once, no further (depth " .. a.max_depth() .. ")")
end
do local a = spawn("AIR_HOT") -- a physical switch on On (Hold), left at OFF while spawning armed
	a.command(HOLD, 1); a.command(HOLD, 0)
	check(not a.armed() and a.switch() == 0, "physical switch on On (Hold): in step after its first move")
end
for _, birth in ipairs({"GROUND_COLD", "GROUND_HOT"}) do
	local a = spawn(birth)
	check(not a.armed() and a.switch() == nil, birth .. ": SAFE, switch untouched")
end

-- Bindings, from the profiles as DCS loads them
local function profile(kind)
	local env = setmetatable({}, {__index = function(_, k)
		if type(k) == "string" and k:find("^iCommand") then return 1000000 + #k end
		return _G[k]
	end})
	env._ = function(s) return s end
	env.external_profile = function() return {keyCommands = {}, axisCommands = {}} end
	env.join = function(to, from) for _, v in ipairs(from) do table.insert(to, v) end return to end
	env.ignore_features = function() end
	local f = assert(loadfile(mod .. "Input/F-22A/" .. kind .. "/default.lua")); setfenv(f, env)
	local by_down = {}
	for _, c in ipairs(f().keyCommands) do if c.down then by_down[c.down] = c end end
	return by_down
end
for _, kind in ipairs({"keyboard", "joystick"}) do
	local p = profile(kind)
	local hold, toggle = p[HOLD], p[TOGGLE]
	check(hold and hold.name == "Master Arm On (Hold)" and hold.up == HOLD and hold.value_down == 1 and hold.value_up == 0,
		kind .. ": Master Arm On (Hold) arms on press and safes on release")
	check(toggle and toggle.name == "Master Arm Toggle" and toggle.value_down == nil, kind .. ": Master Arm Toggle unchanged")
end
support.finish()
