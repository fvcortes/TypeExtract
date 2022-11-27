require "Hook"

local getTypeName
local function getRecordTypeName(rt)
    local entries = ""
    local firstLabel, firstEntry = next(rt)
    entries = entries..firstLabel..":"..getTypeName(firstEntry)
    rt[firstLabel] = nil
    for k,v in pairs(rt) do
        entries = entries..", "..k..":"..getTypeName(v)
    end
    return string.format("{%s}", entries)
end
getTypeName = function(t)
    if(t.tag == "array") then
        return "{"..getTypeName(t.arrayType).."}"
    else
        if(t.tag == "record") then
            -- TODO: iterate over all elements of recordType
            return getRecordTypeName(t.recordType)
        else
            return t.tag
        end
    end
end
-- Finds a suitable name for the function
local function getname (func)
    local n = Names[func]
    local p = Parameters[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        if (p ~= nil) then
            local params = ""
            local firstparameter = p[1];
            --print(type(firstparameter))
            params = params..firstparameter.name..":"..getTypeName(firstparameter.type)
            for i=2,#p do
                params = params..", "..p[i].name..":"..getTypeName(p[i].type)
            end
            return string.format("%s\t%s(%s)", lc, n.name, params)
        end
        return string.format("%s\t%s()", lc, n.name)
    else
        return lc
    end
end

function run(file)
    --local f = assert(loadfile(arg[1]))
    local _f = assert(loadfile(file), "could not load file")
    table.remove(arg,1)         -- adjust arg table to match programs parameters
    debug.sethook(hook,"c")   -- turn on the hook for calls
    _f()                        -- run the program
    debug.sethook()             -- turn off hook

    for func, count in pairs (Counters) do
        print(getname(func), count)
    end    
end

