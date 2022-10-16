local h = require "Hook"
local function getname (func)
    local n = h.names[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        return string.format("%s (%s)", lc, n.name)
    else
        return lc
    end
end

local f = assert(loadfile(arg[1]))
table.remove(arg,1)         -- adjust arg table to match programs parameters
debug.sethook(h.hook,"c")   -- turn on the hook for calls
f()                         -- run the program
debug.sethook()             -- turn off hook

for func, count in pairs (h.counters) do
    print(getname(func), count)
end

