-------------------------------------------------------------------
-- File: Type.lua                                               -
-- Type operations                         -
-------------------------------------------------------------------
require "Util"
local Type = {}

local type_compatibility =
    {
        number = { number = true, integer = true, float = true},
        integer = {number = true, integer = true, float = true},
        float = {number = true, integer = true, float = true},
        string = {string = true},
        boolean = {boolean = true},
        array = {array = true},
        record = {record = true},
        unknown = {},
        empty = {empty = true},
        ["nil"] = {["nil"] = true},
        ["function"] = {["function"] = true}
    }
local primitive =
    { 
        number = true,
        integer = true,
        float = true,
        string = true,
        boolean = true
    }
local number = 
    {
        number = true,
        integer = true,
        float = true
    }
local number_type = 
    {
        number = { number = "number", integer = "number", float = "number" },
        integer = { number = "number", integer = "integer", float = "number" },
        float = { number = "number", integer = "number", float = "float" }
    }

local function list_keys(a,b)
    local list = {}
    for k,_ in pairs(a) do list[k] = true end
    for k,_ in pairs(b) do list[k] = true end
    return list
end

local function map_table(tb,f)
    --print(">Type:map_table")

    local result = {}
    for i = 1,#tb do
        -- print(">Type:map_table - f(tb[i]) = " .. tostring(f(tb[i])))

        result[i] = f(tb[i])
    end
    return result
end

local function fold_table(tb,f)
    --print(">Type:fold_table")

    local result = tb[1]
    --print(">Type:fold_table - tb[1]: " .. tostring(tb[1]))

    for i = 2, #tb do
        -- print(">Type:fold_table - f(result, tb[i]) = " .. tostring(f(result, tb[i])))
        
        result = f(result, tb[i])
    end
    return result
end

local function get_table_tag(tb)
    --print(">Type:get_table_tag")
    local tablesize = #tb
    if (tablesize > 0) then
        --print(">Type:get_table_tag - array")
        return "array"
    else                        
        local i,v = next(tb)
        if (i == nil) then
            --print(">Type:get_table_tag - empty")
            return "empty"
        else
            --print(">Type:get_table_tag - record")
            return "record"
        end
    end
end

local function get_tag(value)
    --print(">Type:get_tag")
    -- print(">Type:get_tag - value: " .. tostring(value))
    local t = type(value)
    if (t == "number") then
        return math.type(value)
    else
        if (t == "table") then
            return get_table_tag(value)
        end
    end
    -- print(">Type:get_tag - tag: " .. t)
    return t
end

local function is_compatible(t1, t2)
    return type_compatibility[t1.tag][t2.tag]
end

local function is_primitive (type)
    return primitive[type.tag]
end

local function is_number(type)
    return number[type.tag]
end

local function add_number_type(n1,n2)
    n1.tag = number_type[n1.tag][n2.tag]
    return n1
    --return {tag = number_type[n1.tag][n2.tag]}
end

local function add_array_type(a1,a2)
    a1.arrayType = a1.arrayType + a2.arrayType
    return a1
    --return {tag = "array", arrayType = a1.arrayType + a2.arrayType}
end

local function add_record_type(r1,r2)
    local lk = list_keys(r1.recordType,r2.recordType)
    local recordType = {}
    for k,_ in pairs(lk) do
        if (r1.recordType[k] and r2.recordType[k]) then
            --print("label in both records")
            --dumptable(r1)
            --dumptable(r2)
            recordType[k] = r1.recordType[k] + r2.recordType[k]
        else
            if (r1.recordType[k] and (r2.recordType[k] == nil)) then
                recordType[k] = r1.recordType[k]
            else
                recordType[k] = r2.recordType[k]
            end
        end
    end
    r1.recordType = recordType
    return r1
    --return {tag = "record", recordType = recordType}
end

local function add_compatible_primitive_types(t1, t2)
    -- types are compatible and primitives
    if (is_number(t1) and is_number(t2)) then
        return add_number_type(t1,t2)
    end
    return (t1 or t2)
end

local function add_function_type(f1,f2)
    return {tag = "function", functionType = list_keys(f1.functionType,f2.functionType)}
end

local function get_array_type(array)
    --print(">Type:get_array_type")
    -- local mapped = map_table(array,Type)
    -- print(">Type:get_array_type -  dumping mapped table")
    -- dumptable(mapped)
    -- print(">Type:get_array_type -  dumping mapped[1]")
    -- dumptable(mapped[1])
    local ret = fold_table(map_table(array, Type.new), Type.__add)
    --print(">Type:get_array_type - ret: ")
    --print(ret)
    return fold_table(map_table(array, Type.new), Type.__add)
end

local function get_record_type(record)
    local result = {}
    for k,v in pairs(record) do
        result[k] = Type.new(v)
    end
    return result
end

local function get_function_type(func)
    return {[func] = true}
end

local function get_record_type_name(rt, function_print)
    --print(">Report:get_record_type_name")

    local entries = ""
    local label, type = next(rt.recordType)
    if(function_print) then
        entries = entries.. tostring(type)
    else
        entries = entries..label..":"..tostring(type)
    end
    rt.recordType[label] = nil
    for k,v in pairs(rt.recordType) do
        entries = entries..", "..k..":"..tostring(v)
    end
    rt.recordType[label] = type
    if (function_print) then
        return string.format("%s", entries)
    end
    return string.format("{%s}", entries)
end

local function get_function_type_name(ft)
    --print(">Report:get_function_type_name")

    local entries = ""
    local firstKey, _ = next(ft.functionType)
    entries = entries..tostring(firstKey)
    ft[firstKey] = nil
    for k,_ in pairs(ft) do
        entries = entries.."; "..tostring(k)
    end
    ft[firstKey] = true
    return string.format("{%s}", entries)
end

function Type:__tostring()
    if(self.tag == "array") then
        return "{".. tostring(self.arrayType) .."}"
    else
        if(self.tag == "record") then
            return get_record_type_name(self)
        else
            if(self.tag == "function") then
                return get_function_type_name(self)
            else
                return self.tag
            end
        end
    end
end

function Type:insert_record(label, record)
    self.recordType[label] = record
end
function Type:__add(t)
    --print(">Type:Type:__add")
    --print(">Type:Add - self: " .. tostring(t1) .. " - t2: " .. tostring(t2))
    -- if(t1 == nil and t2 == nil) then
    --     return {tag = "nil"}
    -- else
    --     if (t1 == nil) then
    --         return t2
    --     else
    --         if (t2 == nil) then
    --             return t1
    --         end
    --     end
    -- end
    if(t == nil) then
        return self
    end

    if(is_compatible(self, t)) then
        local tag = self.tag
        if(is_primitive(t)) then
            return add_compatible_primitive_types(self,t)
        else
            if(tag == "array") then
                --print("adding array types...")
                return add_array_type(self, t)
            else
                if (tag == "record") then
                    --print("adding record types...")            
                    return add_record_type(self,t)
                else
                    if(tag == "function") then
                        return add_function_type(self,t)
                    end
                end
            end
        end
    else
        return {tag = "unknown"}
    end
end

function Type.new_record(record_type)
    local t = {tag = "record", recordType = record_type}
    setmetatable(t,Type)
    return t
end

function Type.new_array(array_of_types)
    local t = {tag = "array", arrayType = fold_table(array_of_types, Type.__add)}
    setmetatable(t,Type)
    return t
end


function Type.new(value)
    --print(">Type:Type.new")

    local tag = get_tag(value)
    --(">Type:Type.new - tag: " .. tag)

    local t = {tag = tag}
    if (tag == "array") then
        --print(">Type:Type -  dumping value")
        --dumptable(value)
        --local at = get_array_type(value)
        --print(">Type:Type -  dumping array type")
        --dumptable(at)
        t.arrayType = get_array_type(value)
    else
        if(tag == "record") then
            t.recordType = get_record_type(value)
        else
            if (tag == "function") then
                t.functionType = get_function_type(value)
            end
        end
    end
    setmetatable(t,Type)
    return t
end

return Type