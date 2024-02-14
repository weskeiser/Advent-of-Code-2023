#!/usr/bin/env lua
local clock = os.clock()
local f = assert(io.open(arg[1], "r"))

local to_hex_tbl = {
    J = "1",
    T = "a",
    Q = "b",
    K = "c",
    A = "d"
}

local hands = {}
for hand, bet in f:read("a"):gmatch("(%S+)%s(%d+)") do
    hand = hand:gsub("%a", to_hex_tbl)

    local working_hand = hand
    local pre
    local jokers

    while #working_hand > 0 do
        local end_card = working_hand:sub(-1)
        local rest, count = working_hand:gsub(end_card, "")

        if end_card == "1" then
            jokers = count
        elseif count > 1 then
            local n = count * 3
            if not pre then
                pre = n
            else
                if pre % n == 0 then
                    pre = 7
                else
                    pre = 10
                end
            end
        end

        working_hand = rest
    end

    if jokers then
        if not pre then
            pre = 6
            jokers = jokers - 1
        end

        for i = 1, jokers do
            if pre == 7 then
                pre = 10
            else
                pre = pre + 3 - pre % 3
            end
        end

        if pre > 15 then pre = 15 end
    end

    -- if jokers and pre and pre < 15 then
    --     pre = pre + 2 - pre % 3
    -- end

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

print(6, 6 + 3 - 6 % 3)
print(7, 7 + 3 - 7 % 3)
print(9, 9 + 3 - 9 % 3)
print(10, 10 + 3 - 10 % 3)
print(12, 12 + 3 - 12 % 3)
print(15, 15 + 3 - 15 % 3)



print(total)

print("\n\n\nT: ", os.clock() - clock)
