-- 1
t1 = Type.new(1)
t2 = Type.new(2.0)
t1 + t2     --> float

-- 2
t1 = Type.new({x = 10, y = 20})
t2 = Type.new({x = 10, y = 20, z = 30})
t1 + t2     --> {y:integer, x:integer, z:integer?}

-- 3
t1 = Type.new({1,2,3})
t2 = Type.new({"a","b", "c"})
t1 + t2     --> {any}
