-------------------------------------------------------------------
-- File: Main.lua                                                 -
-- Loads input file, run program and show report                  -
-------------------------------------------------------------------
require "Report"
require "Run"

local file = arg[1] or "prog.lua"
assert(file, "input file expected")
local _f = assert(loadfile(file), "could not load file")
table.remove(arg,1)         -- adjust arg table to match programs parameters
Run(_f)
Report()