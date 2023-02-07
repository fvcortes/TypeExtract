-------------------------------------------------------------------
-- File: Type.lua                                                 -
-- Type operations                                                -
-------------------------------------------------------------------
require "Util"
local Type = {}

local type_compatibility =
    {
        number = { number = true, integer = true, float = true, ["nil"] = true},
        integer = {number = true, integer = true, float = true, ["nil"] = true},
        float = {number = true, integer = true, float = true, ["nil"] = true},
        string = {string = true, ["nil"] = true},
        boolean = {boolean = true, ["nil"] = true},
        array = {array = true, ["nil"] = true},
        record = {record = true, ["nil"] = true},
        unknown = {},
        empty = {empty = true, ["nil"] = true},
        ["nil"] = {["nil"] = true, number = true, integer = true, float = true, string = true, boolean = true, array = true, record = true},
        ["function"] = {["function"] = true}
    }
local primitive =
    {
        number = true,
        integer = true,
        float = true,
        string = true,
        boolean = true,
        empty = true,
        ["nil"] = true
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
        integer = { number = "number", integer = "integer", float = "float" },
        float = { number = "number", integer = "float", float = "float" }
    }

local function list_keys(a,b)
    local list = {}
    for k,_ in pairs(a) do list[k] = true end
    for k,_ in pairs(b) do list[k] = true end
    return list
end

local function map_table(tb,f)
    local result = {}
    for i = 1,#tb do
        result[i] = f(tb[i])
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
    local t = type(value)
    if (t == "number") then
        return math.type(value)
    else
        if (t == "table") then
            return get_table_tag(value)
        end
    end
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
    return {tag = number_type[n1.tag][n2.tag]}
end

local function add_array_type(a1,a2)
    return {tag = "array", arrayType = a1.arrayType + a2.arrayType}
end

local function add_record_type(r1,r2)
    local lk = list_keys(r1.recordType,r2.recordType)
    local recordType = {}
    for k,_ in pairs(lk) do
        if (r1.recordType[k] and r2.recordType[k]) then
            recordType[k] = r1.recordType[k] + r2.recordType[k]
        else
            if (r1.recordType[k] and (r2.recordType[k] == nil)) then
                recordType[k] = r1.recordType[k]
            else
                recordType[k] = r2.recordType[k]
            end
            recordType[k].optional = true
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

local function get_array_type(array)
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
    return Type.new {[func] = true}
end

local function get_record_type_name(rt)
    local entries = ""
    local label, type = next(rt.recordType)
    entries = entries..tostring(label)..":"..tostring(type)
    rt.recordType[label] = nil
    for k,v in pairs(rt.recordType) do
        entries = entries..", "..k..":"..tostring(v)
    end
    rt.recordType[label] = type
    return string.format("{%s}", entries)
end

function Type:__tostring()
    local result
    if(self.tag == "array") then
        result = "{".. tostring(self.arrayType) .."}"
    else
        if(self.tag == "record") then
            result = get_record_type_name(self)
        else
            result = self.tag
        end
    end
    if (self.optional == true) then
        result = result.."?"
    end
    return result
end

function Type:insert_record(label, record)
    self.recordType[label] = record
end

function Type:__eq(t)
    if(t == nil) then
        return false
    end
    if(self.tag ~= t.tag) then
        return false
    end
    if(t.tag == "array") then
        return self.arrayType == t.arrayType
    else
        if (t.tag == "record") then
            for k,_ in pairs(list_keys(self.recordType,t.recordType)) do
                if (self.recordType[k] ~= t.recordType[k]) then
                    return false
                end
            end
            return true
        else
            if(t.tag == "function") then
                return false
            else
                return true
            end
        end
    end
end

function Type:__add(t)
    local result = {}
    if(t == nil) then
        self.optional = true
        return self
    end
    if(is_compatible(self, t)) then
        -- check if t1 or t2 are nil
        if(self.tag == "nil" and t.tag == "nil") then
            return self
        end
        if(self.tag == "nil") then
            t.optional = true
            return t
        end
        if(t.tag == "nil") then
            self.optional = true
            return self
        end
        if(is_primitive(self) and is_primitive(t)) then
            result = add_compatible_primitive_types(self,t)
        else
            local tag = self.tag
            if(tag == "array") then
                result = add_array_type(self, t)
            else
                if (tag == "record") then
                    result = add_record_type(self,t)
                else
                    if(tag == "function") then
                        result = add_function_type(self,t)
                    end
                end
            end
        end
    else
        result = {tag = "unknown"}
    end
    result.optional = (self.optional == true or t.optional == true)
    setmetatable(result,Type)
    return result
end

function Type.set_type(type)
    setmetatable(type,Type)
end

-- function Type.new_record(record_type)
--     local t = {tag = "record", recordType = record_type}
--     setmetatable(t,Type)
--     return t
-- end

-- function Type.new_array(array_of_types)
--     local t = {tag = "array", arrayType = fold_table(array_of_types, Type.__add)}
--     setmetatable(t,Type)
--     return t
-- end


function Type.new(value)
    local tag = get_tag(value)
    local t = {tag = tag}
    if (tag == "array") then
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