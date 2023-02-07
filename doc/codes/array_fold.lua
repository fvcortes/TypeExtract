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

local function get_array_type(array)
    return fold_table(map_table(array, Type.new), Type.__add)
end