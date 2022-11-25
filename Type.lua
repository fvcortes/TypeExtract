local function getTableTag(table)
    local tablesize = #table
    if (tablesize > 0) then
        return "array"
    else                        
        local i,v = next(table)
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
    if (type1.tag == type2.tag) then
        return true
    end
    return false
end

local function addArrayType(type1,type2)
    return type2
end

local function addRecordType(type1,type2)
    return type2
end

function addType(type1, type2)
    -- TODO: add types
    if(isCompatible(type1, type2)) then
        local tag = type1.tag
        local result = {tag = tag}
        if(tag == "array") then
            result.arrayType = addArrayType(type1.arrayType, type2.arrayType)
        else
            if (tag == "record") then
                result.recordType = addRecordType(type1.recordType,type2.recordType)
            end
        end
        return result
    else
        return {tag = "unknown"}
    end
end

local function getArrayType(array)
    -- TODO:
    -- arrayOfTypes = map(array, getType)
    -- fold(arrayOfTypes, addType)
    print("getArrayType")
    local t = getType(array[1])
    return t
end

local function getRecordType(record)
    -- TODO:
    -- {label = type}
    print("getRecordType")
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
        result.arrayType = getArrayType(value)
    else
        if(tag == "record") then
            result.recordType = getRecordType(value)
        end
    end
    return result
end