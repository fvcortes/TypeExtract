Type = {tag = "", category = ""}

local function tabletag(table)
    local i,v = next(table)
    if (i == nil) then
        return "empty"
    else
        local indextype = type(i) -- TODO: Check all index types, not only the first
        if (indextype == "string") then
            return "record"
        else
            if (indextype == "number") then
                return "array"
            else
                return "unknown"
            end
        end
    end
end
local function extracttable(value)
    local result = {}
    result.tag = tabletag(value)
    -- TODO: Continue with array type and record type extraction
    return result
end
local function extract(value)
    local result = {}
    local valuetype = type(value)
    if (valuetype ~= "userdata") then          -- not a table
        if (valuetype ~= "function") then        -- not a function
            if(valuetype ~= "table") then    -- not userdata
                if (valuetype ~= "number") then -- not a number
                    result.tag = valuetype
                else
                    result.tag = math.type(value)
                end
            else 
                result = extracttable(value)
            end
        else
            result.tag = "function"
        end
    else
        result.tag = "userdata" 
    end
    return result
end

function Type:add (value)
    local newType = extract(value)
    -- TODO: Union types
    self.tag = newType.tag
    
end

function Type:new (o)
    o = o or {}
    self.__index = self
    local result = extract(o.value)
    o.tag = result.tag
    setmetatable(o,self)
    return o
end

return Type