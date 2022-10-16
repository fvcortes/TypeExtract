local Counters = {}
local Names = {}
local function hook ()
    local names = debug.getinfo(2,"Sn")
    if names.what == "Lua" then
        local f = debug.getinfo(2,"f").func
        local count = Counters[f]
        if count == nil then -- first time 'f' is called
            Counters[f] = 1
            Names[f] = names
            -- print("------------------------")
            -- for k,v in pairs(Names[f]) do
            --     print (k,v)
            -- end
            -- print("------------------------")
        else
            Counters[f] = count + 1
        end
    end
end
return {
    hook = hook,
    counters = Counters,
    names = Names
}
