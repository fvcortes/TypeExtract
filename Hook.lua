--[[ 
    This module contains the implementation of the hook 
    which will be used to extract the types from function calls
--]]

require "Function"

function printInfo(info)
  for k,v in pairs(info) do print(k,v) end
end

local fstack = { }
--[[ Because lua tail-call elimination
     some calls won't have the equivalent "return" event
     on the stack. For this reason, we assign the tail call	
     return type for each consecutive tail call on the stack
     until the call event that generated de tail call
--]]

-- Push function information on fstack
local function push(info)
  return table.insert(fstack, info)
end

-- Pop function information from fstack
local function pop()
  return table.remove(fstack)
end

-- Hook function used to extract local value types from functions
function hook(event)
  local info = debug.getinfo(2,"frtSn")
  local names
  if Names[info.func] == nil then
    names = debug.getinfo(2,"Sn")
    Names[info.func] = names
  end
  --[[ Functions defined in [C] won't have it place in table
       'Functions' even if it was called sometime inside the
        program.
  --]]
  if Names[info.func].what == "Lua" then
    if event == "call" or event == "tail call" then

      -- Update function count
      updateCount(info.func)

      -- push function information
      push(info) 

      -- update function parameter types
      updateParameter(info.func, info.ftransfer, info.ntransfer)

    elseif event == "return" then

      -- Pop function information from stack
      local p = pop()

      -- update poped function result types
      updateResult(p.func, info.ftransfer, info.ntransfer)
      
      -- update consecutive tail calls with current result information
      while p.istailcall do
        p = pop()
        updateResult(p.func, info.ftransfer, info.ntransfer)
      end
    end
  end
end
