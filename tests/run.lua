-- Runs every tests/test_*.lua against Cockpit/Scripts, then checks every Lua file in the mod parses.
-- Needs the Lua 5.1 DCS runs the scripts with (setfenv, newproxy); DCS ships one. From the repo root:
--   "C:\Program Files\Eagle Dynamics\DCS World\bin\luae.exe" tests\run.lua
-- A single test runs on its own too:
--   "C:\Program Files\Eagle Dynamics\DCS World\bin\luae.exe" tests\test_hud.lua Cockpit\Scripts

local lua       = arg[-1]
local tests_dir = arg[0]:match("^(.*[/\\])") or ".\\"
local root      = tests_dir .. "..\\"

local function windows_path(path) return (path:gsub("/", "\\")) end

-- cmd /c drops the outer pair of quotes when a command starts with one, hence the extra pair
local function shell(command) return '"' .. command .. '"' end

local function lines_of(command)
	local pipe = assert(io.popen(shell(command)))
	local out = {}
	for line in pipe:lines() do out[#out + 1] = line end
	pipe:close()
	return out
end

local failed = 0

for _, name in ipairs(lines_of('dir /b /on "' .. windows_path(tests_dir) .. 'test_*.lua"')) do
	local output = lines_of(string.format('"%s" "%s%s" "%sCockpit\\Scripts" 2>&1',
		lua, windows_path(tests_dir), name, windows_path(root)))
	local passed, checks = output[#output] == "ALL PASSED", 0
	for _, line in ipairs(output) do
		if line:find("^ok:") then checks = checks + 1
		elseif line ~= "ALL PASSED" then print("  " .. line) end
	end
	print(string.format("%-26s %s (%d checks)", name, passed and "passed" or "FAILED", checks))
	if not passed then failed = failed + 1 end
end

local files, broken = 0, 0
for _, path in ipairs(lines_of('dir /b /s "' .. windows_path(root) .. '*.lua"')) do
	if not path:find("\\.git\\", 1, true) then
		files = files + 1
		local ok, err = loadfile(path)
		if not ok then broken = broken + 1; print("  " .. err) end
	end
end
print(string.format("%-26s %s (%d files)", "syntax", broken == 0 and "passed" or "FAILED", files))
if broken > 0 then failed = failed + 1 end

os.exit(failed == 0 and 0 or 1)
