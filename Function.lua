-- This module is responsible for gathering information about function calls and returns during execution time

require "Type"

Functions = {}
Count = {}
Names = {}
--[[ Note: We cannot use one function to do both parameter
     and result update because in a return hook, parameter
     values could have been messed up during function execution

     Note2: Functions can have different number of parameter and 
     results in each call
  
     Note3: Due to 

     Note4:An alternative faster way of inspecting the 
     program would be to union the local types after 
     it had been inspected. This would consume much 
     more memory since we would have to store each 
     local type for each function call (and return). 

--]]

-- Union two counters of types (used for report purposes)
local function unionTypeCount(a,b)
  local r = {}
  for k,v in pairs(listKeys(a,b)) do
    if b[k] == nil then -- key exist only in a
      r[k] = a[k]
    elseif a[k] == nil then -- key exist only in b
      r[k] = b[k]
    else
      r[k] = a[k] + b[k]
    end
  end
  return r
end

-- Union two local types (field types and type counter)
local function unionLocal(a,b)
  local r = {}
  for k,v in pairs(listKeys(a,b)) do
    r[k] = {}
    if b[k] == nil then -- key only exist in a
      r[k].Type = union(a[k].Type, "nil")
      r[k].typeCount = unionTypeCount(a[k].typeCount, {})
    elseif a[k] == nil then -- key only exist in b
      r[k].Type = union("nil", b[k].Type) 
      r[k].typeCount = unionTypeCount({},b[k].typeCount)
    else
      r[k].Type = union(a[k].Type,b[k].Type)
      r[k].typeCount = unionTypeCount(a[k].typeCount, b[k].typeCount)
    end
  end
  return r 
end

-- Inspect local value types given transfered values indexes
local function inspectLocal(ftransfer, ntransfer)
  local r = {}
  --[[ Since ntransfer is equal nparams and ftransfer is 1
       during a call hook, we can use it for inspect both
       parameter and result types
  --]]
  local j = 1
  for i=ftransfer, (ftransfer + ntransfer) - 1 do
    name, value = debug.getlocal(4,i)
    local v = inspect(value)
    local tc = {}
    if v == "nil" then
      tc["nil"] = 1
    elseif v.tag == nil then
      tc[v] = 1
    else
      tc[v.tag] = 1
    end
    r[j] = {Type = v, typeCount = tc }
    j = j + 1
  end
  return r
end

local function unionFunction(a,b)
  return { paramType = unionLocal(a.paramType, b.paramType),
           resultType = unionLocal(a.resultType, b.resultType) }
end

--[[ Return the union of called functions passed as
     parameter for a function

     If a function has itself passed as a paremeter or as
     a result, getFunction return a flag indicating it has
     a recursive reference. This flag is necessary when 
     writing the report. Without this flag we wouldn't be
     able to detect a recursive reference and report would
     get stuck in a loop
--]]
function getFunction(funcType,func)
  local temp = {}
  local rr = false
  -- Create an array of called functions
  for k,_ in pairs(funcType.functionList) do
    if Functions[k] then
      if k == func then rr = true end
      table.insert(temp,k)
    end
  end
  local i = Functions[temp[1]]
  table.remove(temp,1)
  for _,v in pairs(temp) do
    i = unionFunction(i,Functions[v])
  end
  return i, rr
end

-- Update parameter types in Functions table
function updateParameter(func, ftransfer, ntransfer)
  if not Functions[func] then  -- first call
    Functions[func] = { paramType = inspectLocal(ftransfer,ntransfer) }
  else
    Functions[func].paramType = unionLocal(
				  Functions[func].paramType, 
				  inspectLocal(ftransfer,ntransfer))
  end
end


-- Update result types in Functions table
--[[ During result update, we wan't to keep track of any function type
     that has been passed as parameter (or returned as a result).
--]]
function updateResult(func, ftransfer, ntransfer)
  if not Functions[func].resultType then  -- first return
    Functions[func].resultType = inspectLocal(ftransfer, ntransfer)
  else
    Functions[func].resultType = unionLocal(
				  Functions[func].resultType,
				  inspectLocal(ftransfer, ntransfer))
    
  end
end

-- Increment the number of calls of function f in table Count
function updateCount(f)
  local count = Count[f]
  if not count then
    Count[f] = 1
  else
    Count[f] = count + 1
  end
end


