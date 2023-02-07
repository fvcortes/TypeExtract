function Hook (event)
    local infos = debug.getinfo(2,"Snfrt")
    local f = infos.func
    if (Ignores[f] == true) then
        return
    else
        if(Counters[f] == nil) then
            if (infos.what ~= "Lua") then
                Ignores[f] = true
                return
            else
                Counters[f] = 1
                Infos[f] = infos
            end
        else
            if(event == "call" or event == "tail call") then
                Counters[f] = Counters[f] + 1
            end
        end
        Inspect(event,infos)
    end
end