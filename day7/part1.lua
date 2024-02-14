#!/usr/bin/env lua
local clock = os.clock()
-- function Set.new (t)   -- 2nd version
--   local set = {}
--   setmetatable(set, Set.mt)
--   for _, l in ipairs(t) do set[l] = true end
--   return set
-- end

-- print(tonumber("11", 2), "hoooo")
-- print(string.len(string.pack("B", 11)))

-- print(string.unpack("s", string.pack("I4", 11)))
-- local t = string.pack("I", 15)
-- local p = string.pack("L", 12)
-- print(string.pack("I4", 15):len())

local mt = {
    __add = function(left, right)
        if type(right) == "number" then
            return left.int + right
        end
        return left + right.int
    end,
    __le = function(left, right)
        if type(right) == "string" then
            return left.bin <= right
        end
        if type(right) == "number" then
            return left.int <= right
        end
        return left <= right.int
    end,
    __ge = function(left, right)
        if type(left) == "string" then
            return left >= right.bin
        end
        if type(left) == "number" then
            return left >= right.int
        end
        return left.int >= right
    end,
    __lt = function(left, right)
        if type(right) == "string" then
            return left.bin < right
        end
        if type(right) == "number" then
            return left.int < right
        end

        return left < right.bin
    end,
    __gt = function(left, right)
        if type(left) == "string" then
            return left > right.bin
        end
        if type(left) == "number" then
            return left > right.int
        end
        return left.int > right
    end,
}




Num = {}

function Num:new(number)
    N = {}

    if type(number) == "string" then
        if not tonumber(number) then
            if number:find("^T$") then
                number = 10
            elseif number:find("^J$") then
                number = 11
            elseif number:find("^Q$") then
                number = 12
            elseif number:find("^K$") then
                number = 13
            elseif number:find("^A$") then
                number = 14
            else
                return nil
            end
        end
    end

    number = tonumber(number)

    N.int = number
    N.bin = string.pack("I4", number)
    N.hex = string.format("%x", number)

    function N:clone()
        return Num:new(number)
    end

    setmetatable(N, mt)
    return N
end

local function num_gen()
    local nums = {}
    for i = 1, 14 do
        nums[i] = Num:new(i)
    end


    return nums
end

local nums = num_gen()



function nums:find(num)
    for i = 1, 14 do
        if self[i].int == tonumber(num) then
            return self[i]
        end
    end
end

-- local labels = { nil, 2, 3, 4, 5, 6, 7, 8, 9, "T", "J", "Q", "K", "A" }
-- local bins = { nil, "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010", "1011", "1100", "1101",
--     "1110" }
-- local string_labels = {
--     T = 10,
--     J = 11,
--     Q = 12,
--     K = 13,
--     A = 14,
-- }
-- setmetatable(labels, {
--     __index = function(_, key)
--         if tonumber(key) then
--             return tonumber(key)
--         end
--         if type(key) == "string" then
--             return string_labels[key]
--         end
--     end,
-- })
-- local type_order = { "high", "pair", "pairs", "three", "house", "four", "five" }
-- local types = {
--     high = 1,  -- 5
--     pair = 2,  -- 4
--     pairs = 3, -- 3
--     three = 4, -- 3
--     house = 5, -- 2
--     four = 6,  -- 2
--     five = 7   -- 1
-- }

-- setmetatable(types, {
--     __index = function(tbl, key)
--         if type(key) == "number" then
--             return type_order[key]
--         end
--         return tbl[key]
--     end,
-- })
--
local f = assert(io.open(arg[1], "r"))

local hands_high = {}
local hands_low = {}
local hands_poor = {}

local hand_mt = {
    __lt = function(left, right)
        return left.type < right.type
    end,
    __gt = function(left, right)
        return left.type > right.type
    end,
}

Hand = {}

function Hand:new(bet)
    local hand = {}
    hand.type = 1
    hand.bet = bet
    setmetatable(hand, hand_mt)
    return hand
end

local count = 0
for h, bet in f:read("a"):gmatch("(%S+)%s(%d+)") do
    count = count + 1
    local hand = Hand:new(bet)
    hand.h = h

    local rest = h
    local _, _, pair = rest:find("(.).-(%1)")
    local values = {
        fives = nil,
        fours = nil,
        house = nil,
        threes = nil,
        pairs = nil,
        pair = nil,
        highs = {}
    }

    if pair then
        values.pair = Num:new(pair)
        -- rest = rest:gsub("(.)(.-)(%1)", "%2", 1)
        rest = rest:gsub(pair, "", 1)

        hand.type = hand.type + 1
        hand.pair_high = Num:new(pair)

        -- Three
        if rest:find(pair) then
            hand.type = hand.type + 2
            values.pair, values.threes = values.threes, values.pair
            rest = rest:gsub(pair, "", 1)
        end

        -- Four
        if rest:find(pair) then
            hand.type = hand.type + 2
            values.threes, values.fours = values.fours, values.threes
            rest = rest:gsub(pair, "", 1)

            -- values.highs = nums:find(rest)
            -- rest = rest:gsub(pair, "", 1)
        end

        -- Five
        if rest:find(pair) then
            hand.type = hand.type + 1
            values.fours, values.fives = values.fives, values.fours
            rest = ""
        end
    end


    -- Pairs or House
    if 1 < hand.type and hand.type < 5 then
        local _, _, pair2 = rest:find("(.).-(%1)")

        if pair2 then
            hand.type = hand.type + 1
            hand.pair_low = Num:new(pair2)

            rest = rest:gsub(pair2, "", 2)

            if hand.type == 3 and rest ~= pair2 then
                if nums:find(pair2).int > hand.pair_high then
                    hand.pair_high, hand.pair_low = hand.pair_low, hand.pair_high
                end


                table.insert(values.highs, Num:new(rest).bin)
                -- values.highs = Num:new(rest)
                rest = ""

                values.pairs = hand.pair_high
                values.pair = hand.pair_low


                -- hand.high = nums:find(rest)
            else
                values.pairs = hand.pair_low
                values.house = Num:new(2)
                rest = ""
            end
        end
    end

    -- local function geeet(num)
    --     if type(num) == "string" then
    --         if num:find("^T$") then
    --             return 10
    --         elseif num:find("^J$") then
    --             return 11
    --         elseif num:find("^Q$") then
    --             return 12
    --         elseif num:find("^K$") then
    --             return 13
    --         elseif num:find("^A$") then
    --             return 14
    --         else
    --             return tonumber(num)
    --         end
    --     end
    -- end


    for i = 1, #rest do
        local n = Num:new(rest:sub(1, 1))
        table.insert(values.highs, n.bin)
        rest = rest:sub(2)
    end

    table.sort(values.highs)

    -- local r = {}

    -- for i = 1, #values.highs do
    --     table.insert(r, values.highs[i].bin)
    -- end

    local sendoff = {}
    if hand.type > 2 and #values.highs > 0 then
        sendoff = values.highs
        -- print(#sendoff)
    end

    -- print(#r)
    -- for index, value in ipairs(r) do
    --     -- print("i", r[1].int)
    --     -- print(h, rest)
    -- end
    -- table.sort(r)
    -- hand.rest = table.concat(r)
    -- if hand.type == 1 then
    -- end

    local t = { values.fives, values.fours, values.house, values.threes, values.pairs, values.pair, sendoff }
    -- , hand.rest

    -- local c = 1
    local play = {}
    for i, value in pairs(t) do
        if value ~= nil then
            table.insert(play, value.bin)
        else
            table.insert(play, string.pack("I4", 0))
        end
        --     play[i] = string.pack("I", 1)
        -- print(key, value)
        -- print(value.int)
        -- print(value.bin:len())
        -- end
    end
    -- table.sort(play)
    -- table.insert(play, string.pack("I", values.highs))
    hand.play = table.concat(play)
    -- print(hand.play:len())

    -- hand.play = string.pack("I31", table.concat(play))
    -- string.
    -- print(hand.play:len())
    -- if hand.rest then
    --     print(hand.rest)
    -- end

    -- hand.play = table.concat({ values.fives, values.fours, values.house, values.threes, values.pairs, values.pair,
    -- values.highs })

    if hand.type == 2 then
        table.insert(hands_low, hand)
    elseif hand.type == 1 then
        table.insert(hands_poor, hand)
    elseif hand.type == 4 then
        values.highs = hand.rest
        table.insert(hands_high, hand)
    end


    hand.tt = hand.type
    hand.h = h
    hand.count = count


    -- if not hand.rest then
    --     table.insert(hands_high, hand)
    -- elseif hand.type == 2 then
    --     table.insert(hands_low, hand)
    -- elseif hand.type == 1 then
    --     table.insert(hands_poor, hand)
    -- end







    -- print(h, rest, hand.rest, types[hand.type], hand.pair_high, hand.pair_low, hand.high)

    -- local val = table.concat({ values.fives, values.fours, values.house, values.threes, values.pairs, values.pair,
    -- values.highs })
    -- print(val, hand.rest)

    -- print(val:gsub("^0+(.-)0-$", "%1"))

    -- local t = val:gsub(".", function(char)
    --     return tonumber(char, 2)
    -- end)
    -- print(t)
end

-- table.sort(hands_high, function(a, b)
--     -- print(a, b)
--     return a.play < b.play
-- end)
-- table.sort(hands_low, function(a, b)
--     return a.rest < b.rest
-- end)
-- table.sort(hands_poor, function(a, b)
--     return a.rest < b.rest
-- end)

local prod = 0

-- for k, v in ipairs(hands_poor) do
--     prod = prod + (k * v.bet)
-- end
print(prod)

local offset = #hands_poor

-- for k, v in ipairs(hands_low) do
--     prod = prod + ((k + offset) * v.bet)
-- end

print(prod)

offset = offset + #hands_low

for k, v in ipairs(hands_high) do
    prod = prod + ((k + offset) * v.bet)
    print(k, v.h, v.play, v.count, v.bet)
end
print(prod)




-- print(1, one < two)
-- print(2, one > two)
-- print(3, one > 11)
-- print(4, one < 11)
-- print(5, 11 > one)
-- print(6, 11 < one)
-- print(7, two < string.pack("B", 3))
-- print(7, two <= string.pack("B", 1))


-- print()
-- print("1101" < "1100")

print("\n\n\nT: ", os.clock() - clock)
