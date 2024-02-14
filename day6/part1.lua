#!/usr/bin/env lua
local clock = os.clock()

local f = assert(io.open(arg[1], "r"))

local races = {}
local num_col = 1
for time in f:read("l"):gmatch("%d+") do
    races[num_col] = { time }
    num_col = num_col + 1
end

num_col = 1
for current_rec in f:read("l"):gmatch("%d+") do
    table.insert(races[num_col], tonumber(current_rec))
    num_col = num_col + 1
end

f:close()

local product = 1

for _, v in pairs(races) do
    local time, current_rec = table.unpack(v)
    local low, fractional = math.modf(time / 2)
    local high = low + math.ceil(fractional)

    local i, j, distance = low, high, low * high
    while i > 0 do
        distance = i * j

        if distance < current_rec then
            local rec_margin = (low - i) * 2

            if fractional == 0 then
                rec_margin = rec_margin - 1
            end

            product = product * rec_margin

            break
        end

        i = i - 1
        j = j + 1
    end
end

print(product)

print("\n\n\nT: ", os.clock() - clock)
