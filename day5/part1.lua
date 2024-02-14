#!/usr/bin/env lua
local time = os.clock()


Entry = {}

function Entry:new(destination_start, source_start, range)
    local entry = {}

    entry.destination_start = tonumber(destination_start)
    entry.source_start = tonumber(source_start)
    entry.range = tonumber(range)

    entry.min_distance = entry.destination_start
    return entry
end

Map = {}

function Map:new(from, to, entries)
    local map = {}

    map.from = from
    map.to = to
    map.entries = entries
    return map
end

local function q_sort(list, cmp)
    cmp = cmp or function(curr, pivot)
        return curr < pivot
    end

    local function qs(left, right)
        if left >= right then
            return
        end

        local i, j = left, left


        while j < right do
            if cmp(list[j], list[right]) then
                if i <= j then
                    list[i], list[j] = list[j], list[i]
                    i = i + 1
                end
            end

            j = j + 1
        end

        list[right], list[i] = list[i], list[right]

        qs(left, i - 1)
        qs(i + 1, right)
    end

    qs(1, #list)
end

-----

local lines = io.lines(arg[1], "l")
local seeds = {}
for seed in lines():gmatch("%d+") do
    table.insert(seeds, tonumber(seed))
end


local line = lines()
local maps = {}
while line do
    line = lines()
    if not line then break end

    local from, to = select(3, line:find("(%w+)%-to%-(%w+)"))

    local entries = {}
    line = lines()

    while line:len() ~= 0 do
        local dest_start, source_start, range = select(3, line:find("(%d-)%s(%d-)%s(%d-)$"))

        local entry = Entry:new(dest_start, source_start, range)

        table.insert(entries, entry)

        line = lines()
    end

    q_sort(entries, function(a, b)
        return a.source_start < b.source_start
    end)

    local map = Map:new(from, to, entries)

    table.insert(maps, map)
end





local function from_to_overlap(src_start, b)
    local src_min = b.source_start
    local src_max = b.source_start + b.range

    if src_start >= src_min and src_start <= src_max then
        return true
    end

    return false
end



local function seed_first(src_start, i, visited)
    visited = visited or {}
    local curr_map = maps[i]

    if not curr_map then
        return { val = src_start }
    end

    local best_seed
    local has_map = false

    for route_nr, route in ipairs(curr_map.entries) do
        if visited[route_nr] then
            goto continue
        end


        local next_src_start

        if from_to_overlap(src_start, route) then
            next_src_start = route.destination_start + (src_start - route.source_start)
            has_map = true

            local found = seed_first(next_src_start, i + 1, visited)

            if found then
                visited[route_nr] = true

                if (not best_seed) or (found.val < best_seed.val) then
                    best_seed = { route_nr = route_nr, val = found.val }
                end
            end
        end

        ::continue::
    end

    if not has_map then
        local found = seed_first(src_start, i + 1, visited)

        if found then
            if (not best_seed) or (found.val < best_seed.val) then
                best_seed = { route_nr = nil, val = found.val }
            end
        end
    end


    return best_seed
end

local best
for _, seed in ipairs(seeds) do
    local res = seed_first(seed, 1)

    if res then
        if not best or res.val < best then
            best = res.val
        end
        print(res.val)
    end
end

print()
print(best)


print("\n\n\nT: ", os.clock() - time)
