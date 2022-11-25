Type = {tag = "", category = ""}

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

local function extract(value)
    return {tag = getTag(value)}
end

function Type:add (value)
    local newTypeTag = getTag(value)
    -- TODO: Union types
    self.tag = newTypeTag
    
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