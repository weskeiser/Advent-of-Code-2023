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

-- local hands_by_type = {
--     five = {},
--     four = {},
--     house = {},
--     three = {},
--     two_pair = {},
--     pair = {},
--     high = {}
-- }


local hands = {}
local hands_positions = {}
for hand, bet in f:read("a"):gmatch("(%S+)%s(%d+)") do
    local working_hand = working_hand:gsub("%a", to_hex_tbl)


    local cards = { {}, {}, {}, {}, {} }

    while #working_hand > 0 do
        local end_card = working_hand:sub(-1)
        local rest, count = working_hand:gsub(end_card, "")

        table.insert(cards[count], end_card)

        working_hand = rest
    end



    local hex_list = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local five, four, three, pair, pair2, high_cards = cards[5][1], cards[4][1], cards[3][1], cards[2][1], cards[2][2],
        cards[1]

    if five then
        hex_list[1] = five
        goto skip_all
    end

    if four then
        hex_list[2] = four
        hex_list[7] = high_cards[1]
        goto skip_all
    end

    if three then
        hex_list[4] = three

        if pair then
            hex_list[3] = 1
            hex_list[6] = pair
            goto skip_all
        end
    end

    if pair then
        if pair2 then
            local pair_val, pair2_val = tonumber(pair, 16), tonumber(pair2, 16)
            local high_pair, low_pair

            if math.max(pair_val, pair2_val) == pair_val then
                high_pair = pair
                low_pair = pair2
                -- pair, pair2 = pair2, pair
            else
                low_pair = pair
                high_pair = pair2
            end

            -- hex_list[5], hex_list[6], hex_list[7] = pair2, pair, high_cards[1]
            hex_list[5], hex_list[6], hex_list[7] = high_pair, low_pair, high_cards[1]
            goto skip_all
        end

        hex_list[5], hex_list[6] = 0, pair
    end

    table.sort(high_cards, function(a, b)
        return tonumber(a, 16) < tonumber(b, 16)
    end)

    for k, v in ipairs(high_cards) do
        hex_list[12 - k] = v
    end

    ::skip_all::

    local hand_val = tonumber(table.concat(hex_list), 16)
    local tied_hand_position = hands_positions[hand_val]

    if not tied_hand_position then
        table.insert(hands, { hand_val, bet })
        hands_positions[hand_val] = #hands
    else
        local tied_hand = hands[tied_hand_position]
        tied_hand[2] = tied_hand[2] + bet
    end
end


table.sort(hands, function(a, b)
    return a[1] < b[1]
end)

local total = 0

for k, hand in ipairs(hands) do
    total = total + (k * hand[2])
end
print(total)

-- print(tonumber("100000", 16))
-- print(tonumber("020000", 16))

-- for k, v in ipairs(hands) do
--     hex_list[6 + k] = v
-- end






print("\n\n\nT: ", os.clock() - clock)
