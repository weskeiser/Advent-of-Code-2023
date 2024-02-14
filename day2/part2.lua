#!/usr/bin/env lua

local sum = 0

for line in io.lines(arg[1], "*L") do
    local min = {}

    for part in line:gsub(".-:", "", 1):gmatch("(.-)[;\n]") do
        for num, color in part:gmatch("(%d+)%s(%w+)") do
            if not min[color] or (min[color] < tonumber(num)) then
                min[color] = tonumber(num)
            end
        end
    end

    sum = sum + (min.red * min.green * min.blue)
end

print(sum)
