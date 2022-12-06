-------------------------------------------------------------------
-- File: Report.lua                                               -
-- Generates a human readable type report                         -
-------------------------------------------------------------------
require "Hook"
local function_type_names = {}
local get_type_name

local function get_record_type_name(rt)
    local entries = ""
    local firstLabel, firstEntry = next(rt)
    entries = entries..firstLabel..":"..get_type_name(firstEntry)
    rt[firstLabel] = nil
    for k,v in pairs(rt) do
        entries = entries..", "..k..":"..get_type_name(v)
    end
    return string.format("{%s}", entries)
end

local function get_function_type_name(ft)
    local entries = ""
    for k,_ in pairs(ft) do
        entries = entries.."; "..tostring(k)
    end
    return string.format("{%s}", entries)
end
get_type_name = function(t)
    if(t.tag == "array") then
        return "{"..get_type_name(t.arrayType).."}"
    else
        if(t.tag == "record") then
            return get_record_type_name(t.recordType)
        else
            if(t.tag == "function") then
                return get_function_type_name(t.functionType)
            else
                return t.tag
            end
        end
    end
end

local function get_parameter_type_name(params)
    if(params ~= nil) then
        local p = ""
        local firstparameter = params[1];
        --print(type(firstparameter))
        p = p..get_type_name(firstparameter.type)
        for i=2,#params do
            p = p.."->"..get_type_name(params[i].type)
        end
        return p
    end
end

local function get_return_type_name(returns)
    if(returns ~= nil) then
        local r = ""
        local firstreturn = returns[1];
        r = r..get_type_name(firstreturn.type)
        for i=2,#returns do
            r = r.."->"..get_type_name(returns[i].type)
        end
        return r
    end
end

local function get_function_type_name(params, returns)
    if (params ~= nil) then
        return string.format("(%s)->(%s)", get_parameter_type_name(params), get_return_type_name(returns))
    end
end
-- Finds a suitable name for the function
local function get_name (func)
    local n = Names[func]
    local p = Parameters[func]
    local r = Returns[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        if (p ~= nil) then
            function_type_names[func] = get_function_type_name(p,r)
            return string.format("%s\t%s\t%s", lc, n.name, function_type_names[func])
        end
        return string.format("%s\t%s()", lc, n.name)
    else
        return lc
    end
end

function Show()
    for func, count in pairs (Counters) do
        print(get_name(func), count)
    end
end