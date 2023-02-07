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
            r = r..","..tostring(t[i])
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
    local n = Infos[func]
    local f = Functions[func]
    --print("> Report:get_name - Dumping Functions["..tostring(func).."]")
    --local k,v = next(f.parameterType)
    --print(v.tag)
    --print("is parameterTypes empty??", "next(f.parameterType)", next(f.parameterType))
    --print("f.parameterType[1]",f.parameterType[1])
    --print("parameterTypes")
    --dumptable(f.parameterType)
    
    --print("returnType")
    --dumptable(f.returnType)
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    local ln = string.format("%s", true and n.name or "()")
    if n.what ~= "main" then
        --print("> Reporting function with names...")
        --dumptable(n)
        --print("> Report:get_name - n.what ~= \"main\" and n.namewhat ~= \"\"")
        --print("> Report:get_name - f.parameterType: ["..tostring(f.parameterType).. "]")
        --print("> Report:get_name - f.returnType: ["..tostring(f.returnType).. "]")
        if (f.parameterType ~= nil) then
            function_type_name[func] = get_function_type_name(f.parameterType, f.returnType)
            return string.format("%s\t%s\t%s", lc, ln, function_type_name[func])
        end
        return string.format("%s\t%s", lc, ln)
    else
        return lc
    end
end

function Report()
    --print("> Report:Report - dumping Counters...")
    --dumptable(Counters)
    --print("> Report:Report - dumping Function...")
    --dumptable(Functions)
    --print("> Report:Report - dumping Names...")
    --dumptable(Names)
    --for k,v in pairs(Names) do dumptable(v) end
    for func, count in pairs (Counters) do
        print(get_name(func), count)
    end
end