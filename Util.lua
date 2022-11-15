local Util = {}
Util.dumptable = function (t)
    print("------------ table ------------")
    for k,v in pairs(t) do print(k,v) end
    print("-------------------------------")
end
Util.dumplocal = function (locals)
    print("----------- locals ------------")
    for _,v in pairs (locals) do
        local ltype = type(v.value)
        local value
        if ltype == "string" then
            value = "\""..v.value.."\""
        else
            value = v.value
        end
        print("Locals:", v.name..":"..type(v.value).." = "..value)
    end
    print("-------------------------------")
end

return Util