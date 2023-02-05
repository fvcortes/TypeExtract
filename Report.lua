-------------------------------------------------------------------
-- File: Report.lua                                               -
-- Generates a readable report                                    -
-------------------------------------------------------------------
require "Hook"
local function_type_name = {}

local function get_transfered_type_name(t)
    if(t ~= nil) then
        local r = ""
        local firstreturn = t[1];
        r = r..tostring(firstreturn)
        for i=2,#t do
            r = r.."->"..tostring(t[i])
        end
        return r
    end
end

local function get_function_type_name(params, returns)
    if (params ~= nil) then
        return string.format("(%s)->(%s)", get_transfered_type_name(params), get_transfered_type_name(returns))
    end
end

-- Finds a suitable name for the function
local function get_name (func)
    local n = Names[func]
    local f = Functions[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        if (f.parameterType ~= nil) then
            function_type_name[func] = get_function_type_name(f.parameterType, f.returnType)
            return string.format("%s\t%s\t%s", lc, n.name, function_type_name[func])
        end
        return string.format("%s\t%s()", lc, n.name)
    else
        return lc
    end
end

function Report()
    for func, count in pairs (Counters) do
        print(get_name(func), count)
    end
end