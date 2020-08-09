require "Compare"
require "Run"
-- Common Type Variables
TNumber = "number"

TInt = "integer"

TFloat = "float"

TString = "string"

TBool = "boolean"

TUnknown = "unknown"

TNil = "nil"

TEmptyTable = "emptyTable"

TArrayNumber = {tag = "table", tableType = {arrayType = TNumber}}

TArrayInt = {tag = "table", tableType = {arrayType = TInt}}

TArrayFloat = {tag = "table", tableType = {arrayType = TFloat}}

TArrayString = {tag = "table", tableType = {arrayType = TString}}

TArrayBool = {tag = "table", tableType = {arrayType = TBool}}

TArrayUnknown = {tag = "table", tableType = {arrayType = TUnknown}}

TOptInt = {tag = "optional", optType = TInt}

TOptFloat = {tag = "optional", optType = TFloat}

TOptNumber = {tag = "optional", optType = TNumber}

TOptString = {tag = "optional", optType = TString}

TOptBool = {tag = "optional", optType = TBool}

local function clear()
  Functions = {}
end
-- #1
  run("Test/temp.lua")
  local _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = TInt}},resultType = {{Type = TInt}}}, fType))

-- #2
  clear()
  run("Test/temp2.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = TString}}, resultType = {{Type = TString}}}, fType))


-- #3
  clear()
  run("Test/temp3.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = TBool}}, resultType = {{Type = TBool}}}, fType))

-- #4
  clear()
  run("Test/temp4.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = TFloat}}, resultType = {{Type = TFloat}}}, fType))

-- #5
  clear()
  run("Test/temp5.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = TNumber}}, resultType = {{Type = TNumber}}}, fType))

--#6
  clear()
  run("Test/temp6.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = TNil}}, resultType = {{Type = TNil}}}, fType))

-- #7
  clear()
  run("Test/temp7.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {},resultType = {}}, fType))

-- #8
  clear()
  run("Test/temp8.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = {tag = "table", tableType = {arrayType = TInt}}}},
			   resultType = {{Type = {tag = "table", tableType = {arrayType = TInt}}}}}, fType))

-- #9
  clear()
  run("Test/temp9.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = {tag = "table", tableType = {structType = {a = TInt}}}}},
			   resultType = {{Type = {tag = "table", tableType = {structType = {a = TInt}}}}}}, fType))


-- #10
  clear()
  run("Test/temp10.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = {tag = "table", tableType = {arrayType = TInt, structType = {a = TInt}}}}},
			   resultType = {{Type = {tag = "table", tableType = {arrayType = TInt, structType = {a = TInt}}}}}}
			, fType))
-- #11
  clear()
  run("Test/temp11.lua")
  _,fType = next(Functions)
  assert(compareFunction({paramType = {{Type = TOptInt}}, resultType = {{Type = TOptInt}}}, fType))

