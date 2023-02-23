
test: check

.PHONY: check
check:
	(cd lua/test && ./forte-test.lua)
