--[[ This module is responsible for loading a lua file and set the hook
--]]
require "Report"
require "Hook"

function run(file)
  local _f = assert(loadfile(file), "could not load file")
  -- adjust arg table to run file
  table.remove(arg,1)
  local IN = os.clock()
  debug.sethook(hook,"cr")
  _f()
  debug.sethook()
  local OUT = os.clock()
  report()
  print("Execution time: ", string.format("%7.2f", OUT-IN))
end
