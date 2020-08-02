-- Module responsible for extracting types from lua values

--[[
  tag : integer 
	| float
	| boolean
	| string
	| function
	| file
	| nil
	| optional 
	| unknown
--]]

--[[ Inspecting functions are a little tricky since 
     we only now a function type after it has been called 
     and inspected during a hook.
--]]

-- Return de union of types inside array
local function unionPairs(a)
  local temp = table.clone(a)
  local i = temp[1]
  table.remove(temp,1)
  for _,v in pairs(temp) do
    i = union(i,v)
  end
  return i
end

--[[
    Inspect a table returning it's composition 
    between array and struct types
--]]
local function inspectTable(t)
--[[
    a table can be indexed by any lua value,
    so to be considered an array we look only
    to it's consecutive integer indexes begining at 1.

    tables can also be indexed by only integers or
    only fields
--]]
  local iArray = { }
  local iStruct = { }
  local tTemp = table.clone(t)
  for k,v in ipairs(t) do
    table.insert(iArray, inspect(v))
    tTemp[k] = nil
  end
  -- Table indexes not traversed by ipairs
  for k,v in pairs(tTemp) do
    iStruct[k] = inspect(v)
  end
  if not next(iStruct) then
    return { arrayType = unionPairs(iArray) }
  elseif not next(iArray) then
    return { structType = iStruct }
  else
    return { structType = iStruct, 
	   arrayType = unionPairs(iArray) }
  end
end
local function unionTable(a,b)
  if a.arrayType == nil and
      b.arrayType == nil then -- union tables not an array
    return { structType = 
	     unionField(a.structType, b.structType) }
  elseif a.structType == nil and
          b.structType == nil then -- union tables only an array
    return { arrayType = 
	      union(a.arrayType, b.arrayType) }
  -- union tables has both array or struct types
  elseif a.arrayType == nil then -- a has only struct type
    if b.structType == nil then
      return { structType = unionField(a.structType,{}),
	       arrayType = union({tag = "nil"},b.arrayType) }
    else
      return { structType = unionField(a.structType, b.structType),
	       arrayType = union({tag = "nil"}, b.arrayType) }
    end
  elseif b.arrayType == nil then -- b has only struct type
    if a.structType == nil then
      return { structType = unionField({}, b.structType),
	       arrayType = union(a.arrayType, {tag = "nil"}) }
    else
      return { structType = unionField(a.structType, b.structType),
	       arrayType = union(a.arrayType, {tag = "nil"}) }
    end
  elseif a.structType == nil then
    return { structType = unionField({}, b.structType),
	     arrayType = union(a.arrayType, b.arrayType) }
  elseif b.structType == nil then
    return { structType = unionField(a.structType, {}),
	     arrayType = union(a.arrayType, b.arrayType) }
  else
    return { structType = unionField(a.structType, b.structType),
	     arrayType = union(a.arrayType, b.arrayType) }
  end
end

-- Make a clone of a table value (for inspect purposes)
table.clone = function (orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Make a list of keys from two tables
function listKeys(a,b)
  local list = {}
  for k,_ in pairs(a) do list[k] = true end
  for k,_ in pairs(b) do list[k] = true end
  return list
end

-- Inspect a lua value returning a table containing the value types
function inspect(v)
  local vType = type(v)
 -- print(string.format("inspecting %s, type: %s", v,vType))
  if vType == "number" then
    return { tag = math.type(v)}
  elseif vType == "table" then
    if not next(v) then
      -- table is empty
      return { tag = "emptyTable" }
    else
      return { tag = vType,
	       tableType = inspectTable(v) }
    end
  elseif vType == "function" then
    return { tag = vType, 
	     functionType = { functionList = {[v] = true}} }
  else
    return { tag = vType }
  end	    
end

-- Infer the union of two types
function union(a,b)
  if a.tag == "table" and
      b.tag == "table" then
    return { tag = "table", 
	     tableType = unionTable(a.tableType,b.tableType) } 
  elseif a.tag == "function" and
          b.tag == "function" then
    return { tag = "function", 
             functionType = {functionList = listKeys(a.functionType.functionList,b.functionType.functionList)}}
  elseif a.tag == "optional" and
  	  b.tag == "optional" then
    return { tag = "optional", 
	     optType = union(a.optType, b.optType) }
  elseif a.tag == "emptyTable" and
	  b.tag == "emptyTable" then
    return { tag = "emptyTable" }
  elseif a.tag == b.tag then -- same tag union
    return { tag = a.tag }
  elseif a.tag == "unknown" or
	  b.tag == "unknown"  then
    return { tag = "unknown" }
  elseif a.tag == "emptyTable" or
	  b.tag == "emptyTable" then
    if a.tag == "emptyTable" then
      if b.tag == "table" then
        if b.tableType.structType == nil then
          return { tag = "table",
		   tableType = 
		     { arrayType = union({tag="nil"},b.tableType.arrayType)}}
        else
          if b.tableType.arrayType == nil then
            return { tag = "table",
		     tableType = 
		       { structType = unionField({},b.tableType.structType)}}
          else
            return { tag = "table",
  		     tableType = 
		       { structType = unionField({}, b.tableType.structType),
		         arrayType = union({tag="nil"}, b.tableType.arrayType) }}
          end
        end
      else
        return { tag = "unknown" }
      end
    else
      if a.tag == "table" then
        if a.tableType.structType == nil then
          return { tag = "table",
		   tableType = 
		     { arrayType = union(a.tableType.arrayType,{tag="nil"})}}
        else
          if a.tableType.arrayType == nil then
            return { tag = "table",
		     tableType = 
		       { structType = unionField(a.tableType.structType,{})}}
          else
            return { tag = "table",
  		     tableType = 
		       { structType = unionField(a.tableType.structType,{}),
		         arrayType = union(a.tableType.arrayType,{tag="nil"}) }}
          end
        end
      else
        return { tag = "unknown" }
      end
    end
  elseif a.tag == "optional" or
          b.tag == "optional" then
    if a.tag == "optional" then
      if b.tag == "nil" then
        return { tag = "optional", 
		 optType = a.optType }
      elseif b.tag == "unknown" then
        return {tag = "unknown"}
      else
        local u = union(a.optType,b)
        if u.tag == "unknown" then
          return u
        else
          return { tag = "optional",
		 optType = u }
        end
      end
    else
      if a.tag == "nil" then
        return { tag = "optional",
		 optType = b.optType }
      elseif a.tag == "unknown" then
	return { tag = "unknown" }
      else
        local u = union(a,b.optType)
        if u.tag == "unknown" then
          return u
        else
	  return { tag = "optional",
		 optType = u }
        end
      end
    end
  elseif a.tag == "nil" or
          b.tag == "nil" then
    if a.tag == "nil" then
      if b.tag == "unknown" then
        return { tag = "unknown" }
      else
        return { tag = "optional",
		optType = b }
      end
    else
      if a.tag == "unknown" then
        return { tag = "unknown" }
      else
        return { tag = "optional",
		optType = a }
      end
    end
  elseif ((a.tag == "integer") and (b.tag == "float")) or 
	 ((a.tag == "float") and (b.tag == "integer")) or 
	 ((a.tag == "number") and (b.tag == "integer")) or 
	 ((a.tag == "integer") and (b.tag == "number")) or 
	 ((a.tag == "number") and (b.tag == "float")) or 
	 ((a.tag == "float") and (b.tag == "number")) then 
    return { tag = "number" }
  else
    return { tag = "unknown" }
  end
end

-- Union fields from two tables 
function unionField(a,b)
  local r = { }
  for k,_ in pairs(listKeys(a,b)) do
    if b[k] == nil then -- key only exist in a
      r[k] = union(a[k], { tag = "nil" })
    elseif a[k] == nil then -- key only exist in b
      r[k] = union({ tag = "nil" }, b[k])
    else -- key present in both tables
      r[k] = union(a[k],b[k])
    end
  end
  return r
end

