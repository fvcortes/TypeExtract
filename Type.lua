-------------------------------------------------------------------
-- File: Type.lua                                               -
-- Type operations                         -
-------------------------------------------------------------------
require "Util"
FunctionTypes = {}
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
    local result = {}
    for k,v in pairs(tb) do
        result[k] = f(v)
    end
    return result
end

local function fold_table(tb,f)
    local result = tb[1]
    for i = 2, #tb do
        result = f(result, tb[i])
    end
    return result
end

local function get_table_tag(tb)
    local tablesize = #tb
    if (tablesize > 0) then
        return "array"
    else                        
        local i,v = next(tb)
        if (i == nil) then
            return "empty"
        else
            return "record"
        end
    end
end

local function get_tag(value)
    local tag = type(value)
    if (tag == "number") then
        return math.type(value)
    else
        if (tag == "table") then
            return get_table_tag(value)
        else
            return tag
        end
    end
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
    return {tag = number_type[n1.tag][n2.tag]}
end

local function add_array_type(a1,a2)
    return {tag = "array", arrayType = Add(a1.arrayType,a2.arrayType)}
end

local function add_record_type(r1,r2)
    local lk = list_keys(r1.recordType,r2.recordType)
    local recordType = {}
    for k,_ in pairs(lk) do
        if (r1.recordType[k] and r2.recordType[k]) then
            --print("label in both records")
            --dumptable(r1)
            --dumptable(r2)
            recordType[k] = Add(r1.recordType[k],r2.recordType[k])
        else
            if (r1.recordType[k] and (r2.recordType[k] == nil)) then
                recordType[k] = r1.recordType[k]
            else
                recordType[k] = r2.recordType[k]
            end
        end
    end
    return {tag = "record", recordType = recordType}
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

function Add(t1, t2)
    --print("Adding types...")
    --print(t1.tag, t2.tag)
    --dumptable(t1)
    --dumptable(t2)
    if(is_compatible(t1, t2)) then
        local tag = t1.tag
        if(is_primitive(t1)) then
            return add_compatible_primitive_types(t1,t2)
        else
            if(tag == "array") then
                --print("adding array types...")
                return add_array_type(t1, t2)
            else
                if (tag == "record") then
                    --print("adding record types...")            
                    return add_record_type(t1,t2)
                else
                    if(tag == "function") then
                        return add_function_type(t1,t2)
                    end
                end
            end
        end
    else
        return {tag = "unknown"}
    end
end

local function get_array_type(array)
    return fold_table(map_table(array, Type), Add)
end

local function get_record_type(record)
    local result = {}
    for k,v in pairs(record) do
        result[k] = Type(v)
    end
    return result
end

local function get_function_type(func)
    return {[func] = true}
end

function Type(value)
    local tag = get_tag(value)
    local result = {tag = tag}
    if (tag == "array") then 
        local at = get_array_type(value)
        --dumptable(at)
        result.arrayType = get_array_type(value)
    else
        if(tag == "record") then
            result.recordType = get_record_type(value)
        else
            if (tag == "function") then
                result.functionType = get_function_type(value)
                table.insert(FunctionTypes, result.functionType)
            end
        end
    end
    return result
end