#!/usr/bin/env lua
local time = os.clock()

local points = 0


for line in io.lines(arg[1]) do
    local winning, drawn = line:match(":(.*)|(.*)")
    local winners = {}

    for draw in drawn:gmatch("%d+") do
        local _, found = string.gsub(winning, table.concat({ "%s", draw, "%s" }), " ")

        if found == 0 then
            goto skip
        end

        for i = 1, #winners do
            if winners[i] == draw then
                goto skip
            end
        end

        table.insert(winners, draw)

        ::skip::
    end

    if #winners < 1 then
        goto continue
    end

    points = points + (1 << #winners - 1)

    ::continue::
end

print(points)


print("\n\n\nT: ", os.clock() - time)
