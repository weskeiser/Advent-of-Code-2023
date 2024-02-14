#!/usr/bin/env lua
local clock = os.clock()

local f = assert(io.open(arg[1], "r"))

local time = f:read("l"):gsub("%D", "")
local current_rec = f:read("l"):gsub("%D", "")
f:close()
current_rec = tonumber(current_rec)

local low, fractional = math.modf(time / 2)
local high = low + math.ceil(fractional)

local i, j, distance = low, high, low * high
while i > 0 do
    distance = i * j

    if current_rec > distance then
        local rec_margin = (low - i) * 2

        if fractional == 0 then
            rec_margin = rec_margin - 1
        end

        print(rec_margin)

        break
    end


    i = i - 1
    j = j + 1
end


print("\n\n\nT: ", os.clock() - clock)
