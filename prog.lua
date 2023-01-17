local b = 1
local function hello(a,b,c)
    return a,b
end

local function foo(a)
    return a
end

local function hey()
    return 0
end



--hello(1,2,3)
--hello({1,2,3,4,3},1,1)
--hello({1,2,3,4,3},1,1)

--hello({a = {1,2,3}, b = true, c = {x = {1,2,3.0}}},1,1)
--hello(1.0)
--hello(1, 2)
--hello(1.0)
--hello("", 2.0, 3)
--hello(1,2,3)
--hello(1,'b', "")
hello('a', {}, 2)
--hey()
--hey()

foo(math.sin)
foo(math.cos)

