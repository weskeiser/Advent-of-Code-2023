#!/usr/bin/env lua
local time = os.clock()

local numStrings = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }

local function newEdge(idx, val, edge)
	if idx then
		if not edge or (idx < edge[1]) then
			return { idx, val }
		end
	end

	return edge
end

local sum = 0

for line in io.lines(arg[1]) do
	local first, last

	local lineReversed = line:reverse()

	local firstDigit = line:find("%d")
	local lastDigit = lineReversed:find("%d")

	if firstDigit then
		first = newEdge(firstDigit, line:match("%d"), first)
	end

	if lastDigit then
		last = newEdge(lastDigit, lineReversed:match("%d"), last)
	end

	for val, numString in ipairs(numStrings) do
		first = newEdge(line:find(numString), val, first)
		last = newEdge(lineReversed:find(numString:reverse()), val, last)
	end

	sum = sum + table.concat({ first[2], last[2] })
end

print(sum)
print("\n\n\nT: ", os.clock() - time)
