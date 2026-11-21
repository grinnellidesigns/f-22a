-- Input/F-22A profiles: countermeasure keys go to the F-22A's own dispenser, not to the stock commands
local root = arg[1]
local support = dofile((arg[0]:match("^(.*[/\\])") or "") .. "support.lua")
local check = support.check
local mod = root .. "/../../"

local STOCK = {iCommandPlaneDropSnar = 77, iCommandPlaneDropSnarOnce = 176, iCommandPlaneDropSnarOnceOff = 177,
	iCommandPlaneDropFlareOnce = 357, iCommandPlaneDropChaffOnce = 358}
local STOCK_CM = {[77] = true, [176] = true, [357] = true, [358] = true}
local OURS = {[10160] = "Countermeasures Chaff Dispense", [10161] = "Countermeasures Flares Dispense",
	[10162] = "Countermeasures Release", [10163] = "Countermeasures Continuously Dispense"}

-- The commands the dispenser device acts on, read from the device itself
local function device_commands()
	local listened = {}
	local env = setmetatable({}, {__index = _G})
	env.LockOn_Options = {script_path = root .. "/"}
	env.GetSelf = function() return setmetatable({listen_command = function(_, c) listened[c] = true end}, {__index = function() return function() return 0 end end}) end
	env.make_default_activity = function() end
	env.get_param_handle = function() return {get = function() return 0 end, set = function() end} end
	env.dofile = function(path) local f = assert(loadfile(path)); setfenv(f, env); f() end
	local f = assert(loadfile(root .. "/Systems/Countermeasures.lua")); setfenv(f, env); f()
	local cm = {}
	for c in pairs(listened) do if c >= 10000 then cm[c] = true end end
	return cm
end

-- What DCS's base profiles contribute, reduced to what matters here (Config/Input/Aircrafts/base_*_binding.lua)
local function base_profile(keyboard)
	local function combos(key, reformers) return keyboard and {{key = key, reformers = reformers}} or nil end
	return {
		keyCommands = {
			{combos = combos("Q", {"LShift"}), down = 77, name = "Countermeasures Continuously Dispense", category = "Countermeasures", features = {"Countermeasures"}},
			{combos = combos("JOY_BTN_CM"), down = 176, up = 177, name = "Countermeasures Release", category = "Countermeasures", features = {"Countermeasures"}},
			{combos = combos("Delete"), down = 357, name = "Countermeasures Flares Dispense", category = "Countermeasures", features = {"Countermeasures"}},
			{combos = combos("Insert"), down = 358, name = "Countermeasures Chaff Dispense", category = "Countermeasures", features = {"Countermeasures"}},
			{combos = combos("G"), down = 68, name = "Landing Gear Up/Down", category = "Systems"},
			{down = 999, name = "Drag chute", category = "Systems", features = {"dragchute"}},
		},
		axisCommands = {},
	}
end

local function load_profile(kind)
	local env = setmetatable({}, {__index = function(_, k)
		if STOCK[k] then return STOCK[k] end
		if type(k) == "string" and k:find("^iCommand") then return 1000000 + #k end -- any other stock command
		return _G[k]
	end})
	env._ = function(s) return s end
	env.external_profile = function() return base_profile(kind == "keyboard") end
	-- Same as DCS's Scripts/Input/Data.lua
	env.join = function(to, from) for _, v in ipairs(from) do table.insert(to, v) end return to end
	env.ignore_features = function(commands, features)
		local set = {}
		for _, f in ipairs(features) do set[f] = true end
		for i = #commands, 1, -1 do
			for _, f in ipairs(commands[i].features or {}) do if set[f] then table.remove(commands, i); break end end
		end
	end
	local f = assert(loadfile(mod .. "Input/F-22A/" .. kind .. "/default.lua")); setfenv(f, env)
	return f()
end

local wanted = device_commands()
local count = 0
for _ in pairs(wanted) do count = count + 1 end
check(count == 4, "dispenser device acts on 4 F-22A countermeasure commands")

for _, kind in ipairs({"keyboard", "joystick"}) do
	local res = load_profile(kind)
	local stock_left, ours, gear, chute = {}, {}, false, false
	for _, c in ipairs(res.keyCommands) do
		if STOCK_CM[c.down] then stock_left[#stock_left + 1] = c.down end
		if OURS[c.down] then ours[c.down] = c end
		if c.down == 68 then gear = true end
		if c.down == 999 then chute = true end
	end
	check(#stock_left == 0, kind .. ": no stock countermeasure command left to reach the F-15C avionics")
	local all = true
	for id, name in pairs(OURS) do
		local c = ours[id]
		if not (c and c.name == name and c.category == "Countermeasures" and wanted[id]) then all = false; print("  missing or unmatched: " .. id) end
	end
	check(all, kind .. ": each countermeasure binding sends a command the dispenser device acts on, under the stock name")
	if kind == "keyboard" then
		local function key(id) local c = ours[id]; return c and c.combos and c.combos[1].key end
		check(key(10160) == "Insert" and key(10161) == "Delete" and key(10162) == "JOY_BTN_CM" and key(10163) == "Q",
			"keyboard: default keys carried over from the stock bindings")
	end
	check(gear and not chute, kind .. ": other stock commands untouched, drag chute still ignored")
end
support.finish()
