-------------------------------------------------------------------
-- File: Report.lua                                               -
-- Generates a readable report                         -
-------------------------------------------------------------------
require "Hook"
local function_type_name = {}
local get_type_name

local function get_record_type_name(rt, function_print)
    print(">Report:get_record_type_name")

    local entries = ""
    local firstLabel, firstEntry = next(rt)
    if(function_print) then
        entries = entries..get_type_name(firstEntry)
    else
        entries = entries..firstLabel..":".. get_type_name(firstEntry)
    end
    rt[firstLabel] = nil
    for k,v in pairs(rt) do
        if (function_print) then
            entries = entries.." -> ".. get_type_name(v)
        else
            entries = entries..", "..k..":".. get_type_name(v)
        end
        
    end
    rt[firstLabel] = firstEntry
    if (function_print) then
        return string.format("%s", entries)
    end
    return string.format("{%s}", entries)
end

local function get_function_type_name(ft)
    print(">Report:get_function_type_name")

    local entries = ""
    local firstKey, _ = next(ft)
    entries = entries..tostring(firstKey)
    ft[firstKey] = nil
    for k,_ in pairs(ft) do
        entries = entries.."; "..tostring(k)
    end
    ft[firstKey] = true
    return string.format("{%s}", entries)
end

get_type_name = function(t, function_print)
    print(">Report:get_type_name")

    if(t.tag == "array") then
        if(function_print) then
            return get_type_name(t.arrayType, function_print)
        end
        return "{"..get_type_name(t.arrayType).."}"
    else
        if(t.tag == "record") then
            return get_record_type_name(t.recordType, function_print)
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
    print(">Report:get_function_type_name")

    if (params ~= nil) then
        return string.format("(%s)->(%s)", get_type_name(params, true), get_type_name(returns, true))
    end
end
-- Finds a suitable name for the function
local function get_name (func)
    print(">Report:get_name")
    local n = Names[func]
    local f = Functions[func]
    -- print(">Report:get_name - dumping Functions")
    -- dumptable(Functions)
    -- print(">Report:get_name - dumping Functions[" .. tostring(func) .. "]")
    -- dumptable(f)
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
    print(">Report:Report")
    for func, count in pairs (Counters) do
        --print(">Report:Report - func: " .. tostring(func))
        print(get_name(func), count)
    end
end