#!/usr/bin/env lua

local mask, lines = {}, {}

local time = os.clock()
for line in io.lines(arg[1]) do
    local l = line:gsub("(.?)([^%d^%.%s^\n^^])(.?)", function(pre, _, post)
        if pre ~= "" then
            pre = " "
        end
        if post ~= "\n" then
            post = " "
        end

        return pre .. " " .. post
    end)

    table.insert(mask, string.sub(l, 1, #line))
    table.insert(lines, line)
end

local part_nums_mask = {}

for key, line in pairs(lines) do
    local next_mask, prev_mask

    if key + 1 <= #lines then
        next_mask = mask[key + 1]
    end
    if key > 1 then
        prev_mask = mask[key - 1]
    end

    local part_nums = {}

    local idx = 1
    while idx <= #line do
        local i, j, pre, num, post = line:find("(%D?)(%d*)(%D?)", idx)
        local start, ending = i + #pre, j - #post

        if #num < 1 then
            goto continue
        end

        if table.concat({ pre, post }):find("[^%d^%.]") then
            goto con
        elseif prev_mask and string.sub(prev_mask, start, ending):find("%s") then
            goto con
        elseif next_mask and string.sub(next_mask, start, ending):find("%s") then
            goto con
        end

        ::con::

        for l = 0, #num - 1 do
            part_nums[start + l] = num
        end

        ::continue::

        if ending + 1 < #line then
            idx = ending + 1
        else
            idx = math.huge
        end
    end

    part_nums_mask[key] = part_nums
end

local gear_ratio_total = 0

for key, line in pairs(lines) do
    local idx = 1
    while idx <= #line do
        local i, j, pre, star, post = line:find("(.?)(%*)(.?)", idx)

        if not star then
            break
        end

        local gear_parts = {}

        if tonumber(pre) then
            table.insert(gear_parts, line:sub(1, i):match("%d+$"))
        end

        local ending = j - #post

        if tonumber(post) then
            table.insert(gear_parts, string.match(line, "%d+", ending))
        end

        local start = i + #pre

        if #gear_parts < 2 and key > 1 then
            local tops = part_nums_mask[key - 1]
            local above, topleft, topright = tops[start], tops[start - 1], tops[start + 1]

            if above then
                table.insert(gear_parts, above)
            else
                if topleft then
                    table.insert(gear_parts, topleft)
                end
                if topright then
                    table.insert(gear_parts, topright)
                end
            end
        end

        if #gear_parts < 2 then
            local bottoms = part_nums_mask[key + 1]
            local below, bottomleft, bottomright = bottoms[start], bottoms[start - 1], bottoms[start + 1]

            if below then
                table.insert(gear_parts, below)
            else
                if bottomleft then
                    table.insert(gear_parts, bottomleft)
                end

                if bottomright then
                    table.insert(gear_parts, bottomright)
                end
            end
        end

        if #gear_parts == 2 then
            gear_ratio_total = gear_ratio_total + (gear_parts[1] * gear_parts[2])
        end

        if ending + 1 >= #line then
            break
        end

        idx = j
    end
end

print("\nGear total: ", gear_ratio_total)

print("\nT: " .. os.clock() - time)
