#!/usr/bin/env lua
local clock = os.clock()
local f = assert(io.open(arg[1], "r"))

local to_hex_tbl = {
    T = "a",
    J = "b",
    Q = "c",
    K = "d",
    A = "e"
}

local hands = {}
for hand, bet in f:read("a"):gmatch("(%S+)%s(%d+)") do
    hand = hand:gsub("%a", to_hex_tbl)

    local working_hand = hand
    local pre

    while #working_hand > 0 do
        local end_card = working_hand:sub(-1)
        local rest, count = working_hand:gsub(end_card, "")

        if count > 1 then
            local n = count * 2
            if pre then
                if pre % n == 0 then
                    pre = 5
                else
                    pre = 7
                end
            else
                pre = n
            end
        end

        working_hand = rest
    end

    if pre then
        hand = table.concat({ pre, hand })
    end

    table.insert(hands, { tonumber(hand, 16), bet })
end

table.sort(hands, function(a, b)
    return a[1] < b[1]
end)

local total = 0

for k, hand in ipairs(hands) do
    total = total + (k * hand[2])
end

print(total)

print("\n\n\nT: ", os.clock() - clock)
