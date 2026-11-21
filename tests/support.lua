-- Shared helpers for the cockpit script tests. See tests/run.lua for how to run them.

local support = {}
local failures = 0

function support.check(cond, msg)
	if cond then
		print("ok:   " .. msg)
	else
		failures = failures + 1
		print("FAIL: " .. msg)
	end
end

function support.near(a, b, tol)
	return type(a) == "number" and math.abs(a - b) <= (tol or 1e-6)
end

function support.finish()
	print(failures == 0 and "ALL PASSED" or (failures .. " FAILED"))
	os.exit(failures == 0 and 0 or 1)
end

-- Stub of DCS cockpit elements for page tests.
-- DCS elements are not plain tables: reading a property back does not return what was assigned
-- (dcs.log: "attempt to index field 'element_params' (a string value)"), and reading an unset one is
-- truthy. So the stub returns a placeholder string for every read; page scripts must only ever assign.
-- Returns CreateElement, Add, and the list of added elements as plain tables of what was assigned.
function support.dcs_elements()
	local stores, added = {}, {}
	local function CreateElement(kind)
		local store = {kind = kind}
		local proxy = setmetatable({}, {
			__newindex = function(_, k, v) store[k] = v end,
			__index = function(_, k) return "<element property " .. tostring(k) .. ">" end,
		})
		stores[proxy] = store
		return proxy
	end
	local function Add(element)
		added[#added + 1] = assert(stores[element], "Add of something CreateElement did not make")
	end
	return CreateElement, Add, added
end

return support
