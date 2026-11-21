-- Systems/Weapon_System.lua: master arm at spawn
local root = arg[1]
local support = dofile((arg[0]:match("^(.*[/\\])") or "") .. "support.lua")
local check = support.check

local MASTER_ARM_SWITCH = 3001 -- device_commands.Button_1, the cockpit Master Arm switch (clickabledata.lua)
local MASTER_ARM_KEY    = 10008 -- "Master Arm Toggle" binding

local function spawn(birth_place)
	local params, switch = {}, {}
	local function stub() return 0 end
	local env = setmetatable({}, {__index = function(_, k) local v = _G[k]; if v ~= nil then return v end; return stub end})
	-- DCS runs SetCommand synchronously from performClickableAction, and moves the clickable to the value
	local dev = setmetatable({
		listen_command = function() end,
		performClickableAction = function(_, command, value)
			switch[command] = value
			env.SetCommand(command, value)
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
	return {env = env, params = params, switch = switch}
end

do local a = spawn("AIR_HOT")
	check(a.params.MASTER_ARM == 1, "air start: master arm on")
	check(a.switch[MASTER_ARM_SWITCH] == 1, "air start: cockpit Master Arm switch moved to ARM")
	a.env.SetCommand(MASTER_ARM_SWITCH, 0); a.env.update()
	check(a.params.MASTER_ARM == 0, "air start: one click on the switch safes it again")
	a.env.SetCommand(MASTER_ARM_KEY, 1); a.env.update()
	check(a.params.MASTER_ARM == 1, "air start: the toggle binding still works")
end
for _, birth in ipairs({"GROUND_COLD", "GROUND_HOT"}) do
	local a = spawn(birth)
	check(a.params.MASTER_ARM == 0 and a.switch[MASTER_ARM_SWITCH] == nil, birth .. ": master arm stays safe, switch untouched")
end
support.finish()
