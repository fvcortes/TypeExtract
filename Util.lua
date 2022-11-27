
function dumptable (t)
    print("------------ table ------------")
    for k,v in pairs(t) do print(k,v) end
    print("-------------------------------")
end
dumplocal = function (locals)
    print("----------- locals ------------")
    for _,v in pairs (locals) do
        print("Locals:", v.name..":"..v.type.tag.." = "..tostring(v.type.lastvalue))
    end
    print("-------------------------------")
end
