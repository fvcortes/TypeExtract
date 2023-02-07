-------------------------------------------------------------------
-- File: Test.lua                                                 -
-- Test type creation and union                                   -
-------------------------------------------------------------------
Type = require "Type"
require "Types"

function Setup()
    print("Setup test types...")
    for _,v in pairs(Types) do Type.set_type(v) end
end

local function testNewPrimitiveType()
    assert(Type.new(1) == Types.INTEGER, "Not an integer type")
    assert(Type.new(1.0) == Types.FLOAT, "Not a float type")
    assert((Type.new(1) + Type.new(1.0)) == Types.FLOAT, "Not a number type")
    assert(Type.new(true) == Types.BOOLEAN, "Not a boolean type")
    assert(Type.new("abc") == Types.STRING, "Not a string type")
    assert(Type.new() == Types.NIL, "Not a nil type")
    assert(Type.new({}) == Types.EMPTY, "Not empty type")
end

local function testNewPrimitiveArrayType()
    assert(Type.new({1}) == Types.INTEGER_ARRAY, "Not an array of integer type")
    assert(Type.new({1.0}) == Types.FLOAT_ARRAY, "Not an array of float type")
    assert((Type.new({1}) + Type.new({1.0})) == Types.FLOAT_ARRAY, "Not an array of number type")
    assert(Type.new({true}) == Types.BOOLEAN_ARRAY, "Not an array of boolean type")
    assert(Type.new({"abc"}) == Types.STRING_ARRAY, "Not an array of string type")
    assert(Type.new({{}}) == Types.EMPTY_ARRAY, "Not an empty array type")
    assert(Type.new({1,"a"}) == Types.UNKNOWN_ARRAY, "Not an unknown array type")
end

local function testNewPrimitiveRecordType()
    assert(Type.new({x = 1}) == Types.INTEGER_RECORD, "Not an record of integer type")
    assert(Type.new({x = 1.0}) == Types.FLOAT_RECORD, "Not a record of float type")
    assert((Type.new({x = 1}) + Type.new({x = 1.0})) == Types.FLOAT_RECORD, "Not a record of number type")
    assert(Type.new({x = true}) == Types.BOOLEAN_RECORD, "Not a record of boolean type")
    assert(Type.new({x = "abc"}) == Types.STRING_RECORD, "Not a record of string type")
    assert(Type.new({x = {}}) == Types.EMPTY_RECORD, "Not a record of empty type")
    assert((Type.new({x = "abc"}) + Type.new({x = true})) == Types.UNKNOWN_RECORD, "Not a record of unknown type")

end

local function testNewArrayOfRecordType()
    assert(Type.new({{x = 1}, {x = 2}}) == Types.INTEGER_RECORD_ARRAY, "Not an array of record of integer type")
    assert(Type.new({{x = 1.0}, {x = 2.0}}) == Types.FLOAT_RECORD_ARRAY, "Not an array of record of float type")
    assert(Type.new({{x = 1}, {x = 1.0}}) == Types.FLOAT_RECORD_ARRAY, "Not an array of record of number type")
    assert(Type.new({{x = true}, {x = false}}) == Types.BOOLEAN_RECORD_ARRAY, "Not an array of record of booelan type")
    assert(Type.new({{x = "abc"}, {x = "xyz"}}) == Types.STRING_RECORD_ARRAY, "Not an array of record of string type")
    assert(Type.new({{x = {}}, {x = {}}}) == Types.EMPTY_RECORD_ARRAY, "Not an array of record of empty type")
    assert(Type.new({{x = "abc"}, {x = 1.0}}) == Types.UNKNOWN_RECORD_ARRAY, "Not an array of record of unknown type")
end

local function testNewRecordOfArrayType()
    assert(Type.new({x = {1,2,3}}) == Types.INTEGER_ARRAY_RECORD, "Not a record of array of integer type")
    assert(Type.new({x = {1.0,2.0,3.0}}) == Types.FLOAT_ARRAY_RECORD, "Not a record of array of float type")
    assert((Type.new({x = {1,2,3}}) + Type.new({x = {1.0,2.0,3.0}})) == Types.FLOAT_ARRAY_RECORD, "Not a record of array of float type")
    assert(Type.new({x = {true,false}}) == Types.BOOLEAN_ARRAY_RECORD, "Not a record of array of boolean type")
    assert(Type.new({x = {"abc", "xyz"}}) == Types.STRING_ARRAY_RECORD, "Not a record of array of string type")
    assert(Type.new({x = {{}, {}}}) == Types.EMPTY_ARRAY_RECORD, "Not a record of array of empty type")
    assert(Type.new({x = {1.0, "abc"}}) == Types.UNKNOWN_ARRAY_RECORD, "Not a record of array of unknown type")
end

local function testNewArrayOfArrayType()
    assert(Type.new({{1,2,3}}) == Types.INTEGER_ARRAY_ARRAY, "Not an array of array of integer type")
    assert(Type.new({{1.0,2.0,3.0}}) == Types.FLOAT_ARRAY_ARRAY, "Not an array of array of float type")
    assert((Type.new({{1,2,3}}) + Type.new({{1.0,2.0,3.0}})) == Types.FLOAT_ARRAY_ARRAY, "Not an array of array of number type")
    assert(Type.new({{true,false}}) == Types.BOOLEAN_ARRAY_ARRAY, "Not an array of array of boolean type")
    assert(Type.new({{"abc", "xyz"}}) == Types.STRING_ARRAY_ARRAY, "Not an array of array of string type")
    assert(Type.new({{{}, {}}}) == Types.EMPTY_ARRAY_ARRAY, "Not an array of array of empty type")
    assert(Type.new({{true, 1}}) == Types.UNKNOWN_ARRAY_ARRAY, "Not an array of array of unknown type")
end

local function testNewRecordOfRecordType()
    assert(Type.new({x = {x = 1}}) == Types.INTEGER_RECORD_RECORD, "Not a record of record of integer type")
    assert(Type.new({x = {x = 1.0}}) == Types.FLOAT_RECORD_RECORD, "Not a record of record of float type")
    assert((Type.new({x = {x = 1}}) + Type.new({x = {x = 1.0}})) == Types.FLOAT_RECORD_RECORD, "Not a record of record of number type")
    assert(Type.new({x = {x = true}}) == Types.BOOLEAN_RECORD_RECORD, "Not a record of record of booelan type")
    assert(Type.new({x = {x = "abc"}}) == Types.STRING_RECORD_RECORD, "Not a record of record of string type")
    assert(Type.new({x = {x = {}}}) == Types.EMPTY_RECORD_RECORD, "Not a record of record of empty type")
    assert((Type.new({x = {x = true}}) + Type.new({x = {x = "abc"}})) == Types.UNKNOWN_RECORD_RECORD, "Not a record of record of unknown type")
end

local function testPrimitiveTypeSum()
    -- string + string
    assert((Types.STRING + Types.STRING) ==  Types.STRING)
    -- string + number
    assert((Types.STRING + Types.NUMBER) ==  Types.UNKNOWN)
    -- string + int
    assert((Types.STRING + Types.INTEGER) ==  Types.UNKNOWN)
    -- string + float
    assert((Types.STRING + Types.FLOAT) ==  Types.UNKNOWN)
    -- string + boolean
    assert((Types.STRING + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- number + string
    assert((Types.NUMBER + Types.STRING) ==  Types.UNKNOWN)
    -- number + number
    assert((Types.NUMBER + Types.NUMBER) ==  Types.NUMBER)
    -- number + integer
    assert((Types.NUMBER + Types.INTEGER) ==  Types.NUMBER)
    -- number + float
    assert((Types.NUMBER + Types.FLOAT) ==  Types.NUMBER)
    -- number + boolean
    assert((Types.NUMBER + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- integer + string
    assert((Types.INTEGER + Types.STRING) ==  Types.UNKNOWN)
    -- integer + number
    assert((Types.INTEGER + Types.NUMBER) ==  Types.NUMBER)
    -- integer + integer
    assert((Types.INTEGER + Types.INTEGER) ==  Types.INTEGER)
    -- integer + float
    assert((Types.INTEGER + Types.FLOAT) ==  Types.FLOAT)
    -- integer + boolean
    assert((Types.INTEGER + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- float + string
    assert((Types.FLOAT + Types.STRING) ==  Types.UNKNOWN)
    -- float + number
    assert((Types.FLOAT + Types.NUMBER) ==  Types.NUMBER)
    -- float + integer
    assert((Types.FLOAT + Types.INTEGER) ==  Types.FLOAT)
    -- float + float
    assert((Types.FLOAT + Types.FLOAT) ==  Types.FLOAT)
    -- float + boolean
    assert((Types.FLOAT + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- boolean + string
    assert((Types.BOOLEAN + Types.STRING) ==  Types.UNKNOWN)
    -- boolean + number
    assert((Types.BOOLEAN + Types.NUMBER) ==  Types.UNKNOWN)
    -- boolean + integer
    assert((Types.BOOLEAN + Types.INTEGER) ==  Types.UNKNOWN)
    -- boolean + float
    assert((Types.BOOLEAN + Types.FLOAT) ==  Types.UNKNOWN)
    -- boolean + boolean
    assert((Types.BOOLEAN + Types.BOOLEAN) ==  Types.BOOLEAN)
end

local function testArrayTypeSum()
    -- string + string
    assert((Types.STRING_ARRAY + Types.STRING_ARRAY) == Types.STRING_ARRAY)
    -- string + number
    assert((Types.STRING_ARRAY + Types.NUMBER_ARRAY) == Types.UNKNOWN_ARRAY)
    -- string + int
    assert((Types.STRING_ARRAY + Types.INTEGER_ARRAY) == Types.UNKNOWN_ARRAY)
    -- string + float
    assert((Types.STRING_ARRAY + Types.FLOAT_ARRAY) == Types.UNKNOWN_ARRAY)
    -- string + boolean
    assert((Types.STRING_ARRAY + Types.BOOLEAN_ARRAY) == Types.UNKNOWN_ARRAY)
    -- number + string
    assert((Types.NUMBER_ARRAY + Types.STRING_ARRAY) == Types.UNKNOWN_ARRAY)
    -- number + number
    assert((Types.NUMBER_ARRAY + Types.NUMBER_ARRAY) == Types.NUMBER_ARRAY)
    -- number + integer
    assert((Types.NUMBER_ARRAY + Types.INTEGER_ARRAY) == Types.NUMBER_ARRAY)
    -- number + float
    assert((Types.NUMBER_ARRAY + Types.FLOAT_ARRAY) == Types.NUMBER_ARRAY)
    -- number + boolean
    assert((Types.NUMBER_ARRAY + Types.BOOLEAN_ARRAY) == Types.UNKNOWN_ARRAY)
    -- integer + string
    assert((Types.INTEGER_ARRAY + Types.STRING_ARRAY) == Types.UNKNOWN_ARRAY)
    -- integer + number
    assert((Types.INTEGER_ARRAY + Types.NUMBER_ARRAY) == Types.NUMBER_ARRAY)
    -- integer + integer
    assert((Types.INTEGER_ARRAY + Types.INTEGER_ARRAY) == Types.INTEGER_ARRAY)
    -- integer + float
    assert((Types.INTEGER_ARRAY + Types.FLOAT_ARRAY) == Types.FLOAT_ARRAY)
    -- integer + boolean
    assert((Types.INTEGER_ARRAY + Types.BOOLEAN_ARRAY) == Types.UNKNOWN_ARRAY)
    -- float + string
    assert((Types.FLOAT_ARRAY + Types.STRING_ARRAY) == Types.UNKNOWN_ARRAY)
    -- float + number
    assert((Types.FLOAT_ARRAY + Types.NUMBER_ARRAY) == Types.NUMBER_ARRAY)
    -- float + integer
    assert((Types.FLOAT_ARRAY + Types.INTEGER_ARRAY) == Types.FLOAT_ARRAY)
    -- float + float
    assert((Types.FLOAT_ARRAY + Types.FLOAT_ARRAY) == Types.FLOAT_ARRAY)
    -- float + boolean
    assert((Types.FLOAT_ARRAY + Types.BOOLEAN_ARRAY) == Types.UNKNOWN_ARRAY)
    -- boolean + string
    assert((Types.BOOLEAN_ARRAY + Types.STRING_ARRAY) == Types.UNKNOWN_ARRAY)
    -- boolean + number
    assert((Types.BOOLEAN_ARRAY + Types.NUMBER_ARRAY) == Types.UNKNOWN_ARRAY)
    -- boolean + integer
    assert((Types.BOOLEAN_ARRAY + Types.INTEGER_ARRAY) == Types.UNKNOWN_ARRAY)
    -- boolean + float
    assert((Types.BOOLEAN_ARRAY + Types.FLOAT_ARRAY) == Types.UNKNOWN_ARRAY)
    -- boolean + boolean
    assert((Types.BOOLEAN_ARRAY + Types.BOOLEAN_ARRAY) == Types.BOOLEAN_ARRAY)
end

local function testRecordTypeSum()
    -- string + string
    assert((Types.STRING_RECORD + Types.STRING_RECORD) == Types.STRING_RECORD)
    -- string + number
    assert((Types.STRING_RECORD + Types.NUMBER_RECORD) == Types.UNKNOWN_RECORD)
    -- string + int
    assert((Types.STRING_RECORD + Types.INTEGER_RECORD) == Types.UNKNOWN_RECORD)
    -- string + float
    assert((Types.STRING_RECORD + Types.FLOAT_RECORD) == Types.UNKNOWN_RECORD)
    -- string + boolean
    assert((Types.STRING_RECORD + Types.BOOLEAN_RECORD) == Types.UNKNOWN_RECORD)
    -- number + string
    assert((Types.NUMBER_RECORD + Types.STRING_RECORD) == Types.UNKNOWN_RECORD)
    -- number + number
    assert((Types.NUMBER_RECORD + Types.NUMBER_RECORD) == Types.NUMBER_RECORD)
    -- number + integer
    assert((Types.NUMBER_RECORD + Types.INTEGER_RECORD) == Types.NUMBER_RECORD)
    -- number + float
    assert((Types.NUMBER_RECORD + Types.FLOAT_RECORD) == Types.NUMBER_RECORD)
    -- number + boolean
    assert((Types.NUMBER_RECORD + Types.BOOLEAN_RECORD) == Types.UNKNOWN_RECORD)
    -- integer + string
    assert((Types.INTEGER_RECORD + Types.STRING_RECORD) == Types.UNKNOWN_RECORD)
    -- integer + number
    assert((Types.INTEGER_RECORD + Types.NUMBER_RECORD) == Types.NUMBER_RECORD)
    -- integer + integer
    assert((Types.INTEGER_RECORD + Types.INTEGER_RECORD) == Types.INTEGER_RECORD)
    -- integer + float
    assert((Types.INTEGER_RECORD + Types.FLOAT_RECORD) == Types.FLOAT_RECORD)
    -- integer + boolean
    assert((Types.INTEGER_RECORD + Types.BOOLEAN_RECORD) == Types.UNKNOWN_RECORD)
    -- float + string
    assert((Types.FLOAT_RECORD + Types.STRING_RECORD) == Types.UNKNOWN_RECORD)
    -- float + number
    assert((Types.FLOAT_RECORD + Types.NUMBER_RECORD) == Types.NUMBER_RECORD)
    -- float + integer
    assert((Types.FLOAT_RECORD + Types.INTEGER_RECORD) == Types.FLOAT_RECORD)
    -- float + float
    assert((Types.FLOAT_RECORD + Types.FLOAT_RECORD) == Types.FLOAT_RECORD)
    -- float + boolean
    assert((Types.FLOAT_RECORD + Types.BOOLEAN_RECORD) == Types.UNKNOWN_RECORD)
    -- boolean + string
    assert((Types.BOOLEAN_RECORD + Types.STRING_RECORD) == Types.UNKNOWN_RECORD)
    -- boolean + number
    assert((Types.BOOLEAN_RECORD + Types.NUMBER_RECORD) == Types.UNKNOWN_RECORD)
    -- boolean + integer
    assert((Types.BOOLEAN_RECORD + Types.INTEGER_RECORD) == Types.UNKNOWN_RECORD)
    -- boolean + float
    assert((Types.BOOLEAN_RECORD + Types.FLOAT_RECORD) == Types.UNKNOWN_RECORD)
    -- boolean + boolean
    assert((Types.BOOLEAN_RECORD + Types.BOOLEAN_RECORD) == Types.BOOLEAN_RECORD)
end


local function testNewType()
    testNewPrimitiveType()
    testNewPrimitiveArrayType()
    testNewPrimitiveRecordType()
    testNewArrayOfRecordType()
    testNewRecordOfArrayType()
    testNewArrayOfArrayType()
    testNewRecordOfRecordType()
    print("Type creation - OK")
end

local function testTypeSum()
    testPrimitiveTypeSum()
    testArrayTypeSum()
    testRecordTypeSum()
    print("Type sum - OK")
end

Setup()
testNewType()
testTypeSum()