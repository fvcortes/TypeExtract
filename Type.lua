local Type = {}

Type.extract = function(value)
    return {["tag"] = type(value)}
end

Type.add = function(type1, type2) 
    return {["tag"] = type2.tag}
end

return Type