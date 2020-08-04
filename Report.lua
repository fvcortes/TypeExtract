--[[ This module is responsible for generating a report with 
     function information
--]]

require "Function"


-- Print a table recursevly (DEBUG purposes)
function printTable(t,pad)
  local p = ""
  for i=1,pad do p=p.." " end 
  for k,v in pairs(t) do print(string.format("%s KEY:%s VALUE:%s", p,k,v))
    if type(v) == "table" then
      printTable(v,pad+1)
    end
  end
end

-- Get an apropriate name for the function
function getName (func)
  local n = Names[func]
  if n.what == "C" then return n.name end
  local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
  if n.what ~= "main" and n.namewhat ~= "" then
    return string.format("%s (%s)", lc, n.name)
  else
    return lc
  end
end

local getType

-- Return a string representing an array type
local function getArrayType(t,func)
  local s = string.format("array of %s", getType(t,func))
  return s  
end

-- Return a string representing a struct type
local function getStructType(t,func)
  local s = "struct {"
  for k,v in pairs(t) do
    s = s..string.format("%s:%s, ", k,getType(v,func))
  end
  return string.sub(s,1,#s-2).."}"
end

-- Return a string representing a table type
local function getTableType(t,func)
  if t.arrayType == nil then
    return string.format("table { %s }", 
			  getStructType(t.structType,func))
  elseif t.structType == nil then
    return string.format("%s",
			  getArrayType(t.arrayType,func))
  else
    return string.format("table { %s; %s }",
			  getArrayType(t.arrayType),
			   getStructType(t.structType,func))
    end
end

-- Return a string representing the type structure of a function
local function getFuncType(funcType,func)
  local s = "("
  for _,v in pairs(funcType.paramType) do
    s = s..string.format("%s, ", getType(v.Type,func))
  end
  if next(funcType.paramType) ~= nil then
    s = string.sub(s,1,#s-2)
  end
  s =s..string.format(") => (")
  for _,v in pairs(funcType.resultType) do
    s = s..string.format("%s, ", getType(v.Type,func))
  end
  if next(funcType.resultType) ~= nil then
    s = string.sub(s,1,#s-2)
  end
  return s..string.format(")") 
end

-- Return a string representing a type
getType = function(t,func)
  if t.tag == "optional" then
    return "opt "..getType(t.optType,func)
  elseif t.tag == "table" then
    return getTableType(t.tableType,func)  
  elseif t.tag == "function" then
    local tfunc, rReference = getFunction(t.functionType,func)
    if tfunc == nil or rReference == true then 
      return "function"
    else
      return "<<"..getFuncType(tfunc,func)..">>"
    end
  else
    return t.tag
  end
end

-- Return if we should ommit type stat
local function ommitTypeStat(Type, funcCount)
  local flag = true
  for _,v in pairs(Type) do
    if v ~= funcCount then
      flag = false
    end
  end
  return flag
end

-- Return if we should ommit result or paramter stat information
local function ommitStat(Type, funcCount)
  local flag = true
  for _,v in pairs(Type) do
    flag = ommitTypeStat(v.typeCount, funcCount)
  end
  return flag
end

-- Get statistics from typeCount
local function getStat(typeCount, funcCount)
  local s = ""
  for k,v in pairs(typeCount) do
    if v ~= funcCount then -- function was called with different types
      s = s..string.format("\t%s %.0f%% (%d)\n", k, (v/funcCount)*100, v)
    end
  end  
  return s
end

-- Generate a report file with information about function types
function report()
  local file = io.open("report.out", "w")
  io.output(file)
  for func, funcType in pairs(Functions) do
    local count = Count[func]
    local names = Names[func]
    io.write("\n--------------------------------------------------\n")
    io.write(getName(func) ," : ", count, "\n\n")
    io.write(getFuncType(funcType, func), "\n")
    if not ommitStat(funcType.paramType, count) then
      io.write("Parameters:\n\n")
    end
    for k,v in pairs(funcType.paramType) do
       if not ommitTypeStat(v.typeCount, count) then
        io.write(string.format("%d. \n", k))
      end     
      io.write(getStat(v.typeCount, count))  
    end
    if not ommitStat(funcType.resultType, count) then
      io.write("Results:\n\n")
    end
    for k,v in pairs(funcType.resultType) do
      if not ommitTypeStat(v.typeCount, count) then
        io.write(string.format("%d. \n", k))
      end
        io.write(getStat(v.typeCount, count))  
    end
    io.write("\n") 
  end
  io.close(file)
  io.output()
end
