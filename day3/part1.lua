#!/usr/bin/env lua

local mask = {}
local lines = {}

local time = os.clock()
for line in io.lines(arg[1]) do
    table.insert(lines, line)

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
end

local sum = 0

for key, line in pairs(lines) do
    local next_mask, prev_mask

    if key + 1 <= #lines then
        next_mask = mask[key + 1]
    end
    if key > 1 then
        prev_mask = mask[key - 1]
    end

    local idx = 1
    while idx <= #line do
        local i, j, pre, num, post = line:find("(%D?)(%d*)(%D?)", idx)
        local start, ending = i + #pre, j - #post

        if #num <= 0 then
            goto continue
        end

        if table.concat({ pre, post }):find("[^%d^%.]") then
            sum = sum + num
        elseif prev_mask and string.sub(prev_mask, start, ending):find("%s") then
            sum = sum + num
        elseif next_mask and string.sub(next_mask, start, ending):find("%s") then
            sum = sum + num
        end


        ::continue::

        if ending + 1 >= #line then
            break
        end

        idx = ending + 1
    end
end

print(sum)
print(os.clock() - time)
