
local function foo()
    return 1
end


local function hello(a,b)
    return foo()
end

local function fooError(a,b)
    return a
end


local function fooError2(a)
    return a
end

local function fooError3(a,b)
    return a
end



local function hey()
    return 0
end



--hello(1,2,3)
--hello({1,2,3,4,3},1,1)
--hello({1,2,3,4,3},1,1)


--hello({a = {1,2,3}, b = true, c = {x = {1,2,3.0}}},true,1)
--hello(1.0)

hello({1}, nil)
--hello(1.0)
--hello("", 2.0, 3)
--hello(1,2,3)
--hello(1,'b', "")
--hello('a', {}, 2)
--hey()
--hey()
--fooError(nil,1)
--fooError(1,nil) -- tenta tipar um array de parametros em que uma das chaves eh nil ao inves do nome do parametro
--fooError2({{},{}})
--fooError2({{},1})
--fooError3({nil,1})


--foo({x = 1, record = {a=1,b=2}}, {y = 2})

--foo(math.sin)
--foo(math.cos)

--foo()
--foo()