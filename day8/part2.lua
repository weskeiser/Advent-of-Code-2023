#!/usr/bin/env lua
local clock = os.clock()

local lines = io.lines(arg[1], "l")

local turns, lr_tbl = {}, { L = "left", R = "right" }

for turn in lines():gmatch("%a") do
    table.insert(turns, lr_tbl[turn])
end

lines() -- skip empty line

local nodes, starter_nodes = {}, {}
for line in lines do
    local loc, loc_suffix, left, right = line:match("^(%w%w(%w)) = %((%w+), (%w+)")
    local node = { loc = loc, left = left, right = right }

    nodes[loc] = node

    if loc_suffix == "A" then
        table.insert(starter_nodes, loc)
    elseif loc_suffix == "Z" then
        node.Z = true
    end
end

for _, node in pairs(nodes) do
    node.left, node.right = nodes[node.left], nodes[node.right]
end
for k, loc in ipairs(starter_nodes) do
    starter_nodes[k] = nodes[loc]
end

-- local co_turn = coroutine.create(function(next_turn)
--     local matches = 0
--     repeat
--         print(next_turn)
--         for k, node in ipairs(starter_nodes) do
--             -- print(node.loc, next_turn)
--             if node.loc:sub(3) == "Z" then
--                 matches = matches + 1
--             end
--             starter_nodes[k] = node[next_turn]
--         end
--
--         coroutine.yield(matches)
--     until matches == 6
-- end)



local targets_found = {}
local sets_of_turns = 0
local tally = 0

local total_turns, total_starter_nodes = #turns, #starter_nodes



local tee = 149863 * total_turns
print(149863 / 21409)
print(tee + 1)
-- print(tee)
-- while tally < 149864 do
while t < 149864 do
    for turn_nr, turn in ipairs(turns) do
        t = t + 1
        for i, node in ipairs(starter_nodes) do
            local curr_node = node[turn]
            -- if t == 149863 + 1 then
            --     print(i, t, node.loc)
            -- end

            if curr_node.Z then
                print(t, turn_nr, curr_node.loc)
                if not targets_found[i] then
                    -- targets_found[i] = sets_of_turns + (total_turns / turn_nr)
                    tally = tally + 1
                    targets_found[i] = (sets_of_turns + (total_turns / turn_nr)) * total_turns
                end
            end

            starter_nodes[i] = curr_node
        end
    end

    sets_of_turns = sets_of_turns + 1
end

local sorted_step_sets = { table.unpack(targets_found) }
table.sort(sorted_step_sets)
local largest = table.remove(sorted_step_sets)


-- If A and B are the same number, that number is the GCD
-- Otherwise, set the larger number to be the remainder of the larger number divided by the smaller number
-- Goto 1

local points = { 12, 28 }
local factors = {}
local factor = 1

for i, curr in ipairs(sorted_step_sets) do
    local smaller, larger = curr, largest

    local divisions = 0
    while true do
        local rem = larger % smaller

        divisions = divisions + 1

        print(i, "larger: ", larger, "smaller: ", smaller, "remainder: ", rem)
        if rem == 0 then
            factor = math.max(factor, divisions + 1)
            table.insert(factors, divisions)
            break
        end

        larger, smaller = smaller, rem
    end
    -- print()
end

print(table.unpack(factors))
print(factor)

-- local large_step = largest * total_turns
local large_step = largest
print(factor, total_turns, large_step)
local match = factor * large_step
print("match", match)

for i, curr in ipairs(sorted_step_sets) do
    -- print(curr * total_turns * factor)
    -- print(curr, match % (curr * total_turns))
    print(curr, match % (curr))
end

-- print(t)
-- print(common_denominator, total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)
-- print(common_denominator * total_turns)


print("\n\n\nT: ", os.clock() - clock)
