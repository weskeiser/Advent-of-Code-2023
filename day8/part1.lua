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
    end
end

for _, node in pairs(nodes) do
    node.left, node.right = nodes[node.left], nodes[node.right]
end

local curr_node, found = nodes.AAA, nil
local turn_sets, turn_set_size = 0, #turns

while not found do
    for turn_nr, turn in ipairs(turns) do
        curr_node = curr_node[turn]

        if curr_node.loc == "ZZZ" then
            found = turn_sets * turn_set_size + turn_nr
            break
        end
    end

    turn_sets = turn_sets + 1
end

print(found)

print("\n\n\nT: ", os.clock() - clock)
