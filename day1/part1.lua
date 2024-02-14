#!/usr/bin/env lua
local time = os.clock()

local sum = 0

for line in io.lines(arg[1]) do
	sum = sum + table.concat({ line:match("%d"), line:reverse():match("%d") })
end

print(sum)
print("\n\n\nT: ", os.clock() - time)
