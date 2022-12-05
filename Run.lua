-------------------------------------------------------------------
-- File: Run.lua                                                  -
-- Run input file with inspection Hook                           -
-------------------------------------------------------------------
require "Hook"

function Run(f)
    debug.sethook(Hook,"cr")   -- turn on the hook for calls
    f()                        -- run the program
    debug.sethook()             -- turn off hook
end



