-- This module is responsible for comparing Types

local compareField

local function listKeys(a,b)
  local list = {}
  for k,_ in pairs(a) do list[k] = true end
  for k,_ in pairs(b) do list[k] = true end
  return list
end

-- Compare two parameter types
local function compareLocal(a,b)
  for k,_ in pairs(listKeys(a,b)) do
    if not a[k] or not b[k] then
      return false, "missing fields in local type"
    end
    local value, reason = compare(a[k].Type, b[k].Type)
    if not value then
      return value, "local "..reason
    else
      return value
    end
  end
  return true
end

-- Compare two function types
function compareFunction(a,b)
  local value, reason = compareLocal(a.paramType, b.paramType)
  if value then
    local v, r = compareLocal(a.resultType, b.resultType)
    if not v then
      return v, "function "..r
    else
      return v 
    end
  else
    return value, reason  
  end
end

-- Compare two table types
--[[
    Two table types are equal if 
    their arrayType and structType are equal
--]]
local function compareTable(a,b)
  local value, reason
  if (a.arrayType == nil and b.arrayType ~= nil) or
      (a.arrayType ~= nil and b.arrayType == nil) then
    return false, "table with different array type"
  end
  if (a.structType == nil and b.structType ~= nil) or
      (a.structType ~= nil and b.structType == nil) then
    return false, "table with different field type"
  end
  if a.arrayType ~= nil and b.arrayType ~= nil then
    value, reason = compare(a.arrayType, b.arrayType)
    if value then
      if a.structType ~= nil and b.structType ~= nil then
        return compareField(a.structType, b.structType)
      else
        return value
      end
    else
      return value, reason
    end
  elseif b.structType ~= nil and b.structType ~= nil then
    return compare(a.structType, b.structType)
  end
end

-- Compare two Types
function compare(a,b)
  if a.tag ~= b.tag then
    return false, "different types"
  else
    local tag = a.tag
    if tag == "optional" then
      return compare(a.optType, b.optType)
    elseif tag == "table" then
      return compareTable(a.tableType,b.tableType)
    elseif tag == "function" then
      return compareFunction(a.functionType, b.functionType)
    else
      return true
    end
  end
end

-- Compare two table fields
compareField = function(a,b)
  for k,_ in pairs(listKeys(a,b)) do
    if not a[k] or not b[k] then
      return false, "missing fields"
    end
    local value, reason = compare(a[k], b[k])
    if not value then 
      return value, "field "..reason
    else
      return value
    end
  end
  return true
end


