#!/usr/bin/env lua
local time = os.clock()


-- maze
local maze

local pgph = 1




for line in io.lines(arg[1]) do
    if not maze then
        local seeds = {}

        for num in line:gmatch("%d+") do
            table.insert(seeds, num)
        end

        maze = {}

        maze[pgph] = seeds
        goto continue
    end

    if line:match("%a") then
        pgph = pgph + 1

        print(pgph)
        maze[pgph] = {}
        -- print(21, line, pgph)
        goto continue
    end

    local is_entry, _, destination, source, len = line:find("(%d+)%s(%d+)%s(%d+)")
    print(28, is_entry)

    if not is_entry then
        goto continue
    end
    print(pgph)

    -- print(destination, source, len)

    -- maze
    local n = #maze[pgph]
    n = n + 1

    maze[pgph][n] = {
        destination = destination,
        source = source,
        len = len
    }

    -- Sort
    local i = n
    while i > 1 do
        local j = math.floor(#maze[pgph] / 2)

        if maze[pgph][j].destination > maze[pgph][i].destination then
            maze[pgph][i], maze[pgph][j] = maze[pgph][j], maze[pgph][i]

            i = j
        else
            i = 0
        end
    end

    -- 1	1
    -- 2	15
    -- 3	2
    -- 4	3
    -- 5	5
    -- 6	4
    -- 7	45

    -- 1	15
    -- 2	3
    -- 3	1
    -- 4	45
    -- 5	5
    -- 6	4
    -- 7	2


    ::continue::
end

-- local unvisited =
--
-- local root_node = {}

for key, value in pairs(maze) do
    -- print(key, value)
    for k, v in pairs(value) do
        print(k, v.source)
    end
end


local function heuristic_fn(a, b)
    return a.destination < b.destination
end

local function a_star(array, start, goal, maze)
    local maze = maze
    local closed = {}
end


-- We need a variable to be the list root:
--
--     list = nil
--
-- To insert an element at the beginning of the list, with a value v, we do
--
--     list = {next = list, value = v}
--
-- To traverse the list, we write:
--
--     local l = list
--     while l do
--       print(l.value)
--       l = l.next
--     end




--  seed -> soil

--  soil -> fertilizer

--  fertilizer -> water

--  water -> light

--  light -> temperature

--  temperature -> humidity

--  humidity -> location

print("\n\n\nT: ", os.clock() - time)
