require "Util"
typeCompatibility = 
    {
        number = { number = true, integer = true, float = true},
        integer = {number = true, integer = true, float = true},
        float = {number = true, integer = true, float = true},
        string = {string = true},
        boolean = {boolean = true},
        array = {array = true},
        record = {record = true}
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
local numberType = 
    {
        number = { number = "number", integer = "number", float = "number" },
        integer = { number = "number", integer = "integer", float = "number" },
        float = { number = "number", integer = "number", float = "float" }
    }

function listKeys(a,b)
    local list = {}
    for k,_ in pairs(a) do list[k] = true end
    for k,_ in pairs(b) do list[k] = true end
    return list
end

function mapTable(tb,f)
    local result = {}
    for k,v in pairs(tb) do
        result[k] = f(v)
    end
    return result
end

function foldTable(tb,f)
    local result = tb[1]
    for i = 2, #tb do
        result = f(result, tb[i])
    end
    return result
end

local function getTableTag(tb)
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

local function getTag(value)
    local tag
    local valuetype = type(value)
    if (valuetype ~= "userdata") then           -- not a userdata
        if (valuetype ~= "function") then       -- not a function
            if(valuetype ~= "table") then       -- not table
                if (valuetype ~= "number") then -- not a number
                    tag = valuetype
                else
                    tag = math.type(value)
                end
            else 
                tag = getTableTag(value)
            end
        else
            tag = "function"
        end
    else
        tag = "userdata" 
    end
    return tag
end

local function isCompatible(type1, type2)
    return typeCompatibility[type1.tag][type2.tag]
end

local function isPrimitive (type)
    return primitive[type.tag]
end

local function isNumber(type)
    return number[type.tag]
end

local function addNumberType(n1,n2)
    return {tag = numberType[n1.tag][n2.tag]}
end

local function addArrayType(a1,a2)
    return {tag = "array", arrayType = addType(a1.arrayType,a2.arrayType)}
end

local function addRecordType(r1,r2)
    local lk = listKeys(r1.recordType,r2.recordType)
    local recordType = {}
    for k,_ in pairs(lk) do
        if (r1.recordType[k] and r2.recordType[k]) then
            --print("label in both records")
            --dumptable(r1)
            --dumptable(r2)
            recordType[k] = addType(r1.recordType[k],r2.recordType[k])
        else
            if (r1.recordType[k] and ~(r2.recordType[k])) then
                recordType[k] = r1.recordType[k]
            else
                recordType[k] = r2.recordType[k]
            end
        end
    end
    return {tag = "record", recordType = recordType}
end

local function addPrimitiveType(type1, type2)
    -- types are compatible and primitives
    if (isNumber(type1) and isNumber(type2)) then
        return addNumberType(type1,type2)
    end
    return (type1 or type2)
end

function addType(type1, type2)
    --print("Adding types...")
    --print(type1.tag, type2.tag)
    --dumptable(type1)
    --dumptable(type2)
    if(isCompatible(type1, type2)) then
        local tag = type1.tag
        if(tag == "array") then
            --print("adding array types...")
            return addArrayType(type1, type2)
        else
            if (tag == "record") then
                --print("adding record types...")            
                return addRecordType(type1,type2)
            else
                return addPrimitiveType(type1,type2)
            end
        end
    else
        return {tag = "unknown"}
    end
end

local function getArrayType(array)
    return foldTable(mapTable(array, getType), addType)
end

local function getRecordType(record)
    local result = {}
    for k,v in pairs(record) do
        result[k] = getType(v)
    end
    return result
end

function getType(value)
    local tag = getTag(value)
    local result = {tag = tag}
    if (tag == "array") then 
        local at = getArrayType(value)
        --dumptable(at)
        result.arrayType = getArrayType(value)
    else
        if(tag == "record") then
            result.recordType = getRecordType(value)
        end
    end
    return result
end