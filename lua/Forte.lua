--
-- Forte system for Fantasy Grounds.
--


-- Forte format
--  A table:
--  	- field 'fdb' = Reference to the fortedb
--  	- field forte = name of the forte
--  	- field feebs = { Feebles }

-- Feeble Format
-- A table
-- 	- feeble = one of { 'Value', 'Reference' }
-- 	- value = <number>
-- 	- reference = Name of another Forte
-- 	- filter = Name of the registerd function


-- Create a Forte DB
function fortedb_create()
	return {
		-- Fantasy grounds doesn't allow metatables - so we use an evil field
		__fortedb = "fortedb",
		__filters = {},
		add = fortedb_forte_add,
		get = fortedb_forte_get,
		filter_add = fortedb_filter_add,
	}
end

function fortedb_forte_get(db, name)
	assert(db.__fortedb == 'fortedb')
	return db[name]
end

function fortedb_forte_value_get(db, name)
	assert(db.__fortedb == "fortedb");

	local forte = db[name]
	if not forte then
		print("Forte " .. name .. " does not exist")
		return nil, "Invalid forte " .. name
	end

	local val = 0
	for _, feeb in ipairs(forte.feebs) do
		assert(feeb.feeb)
		if feeb.feeb == 'Value' then
			val = val + feeb.value
		elseif feeb.feeb == 'Reference' then
			local ref = fortedb_forte_value_get(db, feeb.reference)
			if feeb.filter then
				ref = db.__filters[feeb.filter](ref)
			end
			val = val + ref
		else
			return nil, "Invalid feeble " .. feeb.feeb
		end
	end

	return val
end

function fortedb_filter_add(db, name, fn)
	assert(db.__fortedb == "fortedb")
	assert(type(fn) == "function")
	assert(type(name) == "string")

	db.__filters[name] = fn
	return true
end

-- FIXME: Make this and the fortedb_value_Get the smae funciton and just to do the type chekc ot
-- make it all work
function forte_value_get(forte)
	return fortedb_forte_value_get(forte.fdb, forte.forte)
end

function fortedb_forte_add(db, name)
	assert(db.__fortedb == "fortedb")

	if db[name] then
		print("The forte " .. name .. " exists")
		return nil, "Name Exists"
	end

	db[name] = {
		fdb = db,
		forte = name,
		feebs = {},
		value_add = forte_value_add,
		ref_add = forte_reference_add,
		ref_filter_add = forte_reference_filter_add,
		value = forte_value_get,
		value_get = forte_value_get,
	}
	return db[name]
end

-- Adds a feeble to the list of feebs on the current forte.
function forte_value_add(forte, value, note)
	assert(forte.fdb) -- just check it exists
	assert(forte.feebs)
	assert(type(value) == 'number')

	table.insert(forte.feebs, {
		feeb = 'Value',
		value = value,
		note = note
	})
	return forte
end

function forte_reference_add(forte, ref, note)
	return forte_reference_filter_add(forte, ref, nil, note)
end

function forte_reference_filter_add(forte, ref, filter, note)
	assert(forte.forte)
	assert(forte.feebs)
	assert(type(ref) == 'string')
	assert(not filter or type(filter) == 'string')
	if filter then
		assert(forte.fdb.__filters[filter])
	end

	table.insert(forte.feebs, {
		feeb = 'Reference',
		reference = ref,
		filter = filter,
		note = note
	})
	return forte
end
