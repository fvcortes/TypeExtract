local b = 1
local function hello(a,b,c)
    return a
end

local function foo(f)
    return f
end
local function hey()
    return 0
end



--hello(1,2,3)
hello(1,'b',{a=1})
--hello(1,'b', "")
--hello('a', {}, nil)
hey()
hey()
foo("a")