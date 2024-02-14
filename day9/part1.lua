#!/usr/bin/env lua
local clock = os.clock()

local f = assert(io.open(arg[1], "r"))

Sum = 0
for line in f:lines() do
    local get_next = line:gmatch("%-?%w+")

    local data = {}
    local head

    local curr_val = get_next()
    repeat
        table.insert(data, curr_val)
        head = { next = head, val = curr_val }
        curr_val = get_next()
    until not curr_val




    local prediction = 0

    local history = {}
    local tot = data[#data]
    -- repeat
    while true do
        local has_values = false
        local prev
        local curr = head


        while curr.next do
            curr.val = math.abs(curr.next.val - curr.val)

            table.insert(history, curr.val)

            if curr.val ~= 0 then
                has_values = true
            end

            prev = curr
            curr = curr.next
        end

        -- print(history[1], tot, "ddddddd")
        tot = tot + history[1]


        -- print(history[1], tot, Sum)
        if not has_values then
            print("ooooooooo", tot, history[1])
            Sum = Sum + tot
            print(Sum, tot, history[1], "hhh")

            break
        end

        prev.next = nil


        if not head.next then
            -- print(history[1], history[#history])
            head.next = nil
            head.val = tot
            head = { next = head, val = history[1] }
            tot = 0
            -- history = { history[#history] }
        else
            history = {}
        end
    end

    -- print(data[#data])
    print("pred", prediction, "\n")
    -- Sum = Sum + prediction
end
print(Sum)




print("\n\n\nT: ", os.clock() - clock)
