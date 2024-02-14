#!/usr/bin/env lua

local capacity = {
    r = 13,
    g = 14,
    b = 15,
}

local sum = 0

for line in io.lines(arg[1], "*L") do
    local possible_game

    for part in line:gmatch("(.-)[;:\n]") do
        if not possible_game then
            possible_game = part:sub(6)
            goto skip
        end

        for num, color in part:gmatch("(%d+)%s(%w)") do
            for c, cap in pairs(capacity) do
                if tonumber(num) >= cap and c == color then
                    possible_game = 0
                end
            end
        end

        ::skip::
    end

    sum = sum + possible_game
end

print(sum)
