Type = {tag = "", category = ""}

local function extract(value)
    return type(value), "primitive type"
end

function Type:add (value)
    self.tag = extract(value)
end

function Type:new (o)
    o = o or {}
    self.__index = self
    o.tag, o.category = extract(o.value)
    setmetatable(o,self)
    return o
end

return Type