#!/usr/bin/env lua5.1
--
-- Test file for 'scripts/forte.lua'
-- 

-- FIXME: This is super hacky; should set in evironment (and fragile too)
package.path = "../?.lua;" .. package.path

require[[Forte]]

local test = {}

local function filterfn(val)
	return val * 10
end

function test.fortefb_create()
	local fdb = fortedb_create()
	assert(fdb)
	assert(fdb.__fortedb == "fortedb")
	return true
end

function test.forte_add()
	local fdb = assert(fortedb_create())
	local forte = assert(fortedb_forte_add(fdb, "Test"))
	local forte2 = assert(fortedb_forte_get(fdb, "Test"))
	assert(forte == forte2)

	return true
end

function test.forte_value_add()
	local fdb = assert(fortedb_create())
	local forte = assert(fortedb_forte_add(fdb, "Test"))
	assert(forte_value_add(forte, 22, "Test A"))
	assert(forte_value_add(forte, 20, "Test B"))
	assert(forte_value_get(forte) == 42)
	return true
end

function test.forte_ref_add()
	local fdb = assert(fortedb_create())
	local forte = assert(fdb:add("Test"))
	assert(forte:value_add(22, "Some Value"))
	-- create the one with the reference
	local rf = assert(fdb:add("Ref"))
	assert(rf:ref_add("Test", "The reference"))
	assert(rf:value_add(20, "A value"))
	assert(rf:value() == 42)
	return true
end

function test.filterfn()
	local fdb = assert(fortedb_create())
	-- add a filter; called filter
	assert(fdb:filter_add("filter", filterfn))

	-- Add a forte, called Test, with a value of 22, reef/with filter to 'Ref'
	local forte = assert(fdb:add("Test"))
	assert(forte:value_add(22, "Some Value"))
	assert(forte:ref_filter_add("Ref", "filter"))

	-- Add Ref with value 11
	local ref = assert(fdb:add("Ref"))
	assert(ref:value_add(11, "11"))

	-- Value is 10*11 + 22
	assert(forte:value() == 132)
	return true
end

local function main()
	print("== Forte Tests")
	for k, v in pairs(test) do
		print("Testing " .. k)
		local rv, err = v()
		if not rv then
			print("    Failed: ", err)
		else
			print("    Passed")
		end
	end
end

main()
