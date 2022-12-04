require "Hook"

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

get_type_name = function(t)
    if(t.tag == "array") then
        return "{"..get_type_name(t.arrayType).."}"
    else
        if(t.tag == "record") then
            -- TODO: iterate over all elements of recordType
            return get_record_type_name(t.recordType)
        else
            return t.tag
        end
    end
end

local function get_parameter_type_name(params)
    local p = ""
    local firstparameter = params[1];
    --print(type(firstparameter))
    p = p..firstparameter.name..":"..get_type_name(firstparameter.type)
    for i=2,#params do
        p = p..", "..params[i].name..":"..get_type_name(params[i].type)
    end
    return p
end

-- Finds a suitable name for the function
local function get_name (func)
    local n = Names[func]
    local p = Parameters[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        if (p ~= nil) then
            return string.format("%s\t%s(%s)", lc, n.name, get_parameter_type_name(p))
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