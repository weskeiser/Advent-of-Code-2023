#!/usr/bin/env lua
local time = os.clock()

local scratchie_queue = {}

local loot = 0

for line in io.lines(arg[1]) do
    local card_nr, winning, drawn = line:match("(%d+):(.*)|(.*)")
    local scratchies = scratchie_queue[tonumber(card_nr)] or 1

    loot = loot + scratchies

    local winners = {}
    for draw in drawn:gmatch("%d+") do
        local _, found = string.gsub(winning, table.concat({ "%s", draw, "%s" }), " ")

        if found == 0 then
            goto skip
        end

        for i in pairs(winners) do
            if winners[i] == draw then
                goto skip
            end
        end


        table.insert(winners, draw)

        local next_card = tonumber(card_nr + #winners)
        scratchie_queue[next_card] = (scratchie_queue[next_card] or 1) + scratchies

        ::skip::
    end
end

print(loot)

print("\n\n\nT: ", os.clock() - time)
