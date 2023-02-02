Type = require "Type"

require "Testtypes"

function Setup()
    for _,v in pairs(Types) do setmetatable(v,Type) end
end


local function testNewPrimitiveType()
    assert(Type.new(1) == Types.INTEGER, "Not an integer type")
    assert(Type.new(1.0) == Types.FLOAT, "Not a float type")
    assert((Type.new(1) + Type.new(1.0)) == Types.NUMBER, "Not a number type")
    assert(Type.new(true) == Types.BOOLEAN, "Not a boolean type")
    assert(Type.new("abc") == Types.STRING, "Not a string type")
    assert(Type.new() == Types.NIL, "Not a nil type")
end

local function testNewPrimitiveArrayType()
    assert(Type.new({1}) == Types.INTEGER_ARRAY, "Not an array of integer type")
    assert(Type.new({1.0}) == Types.FLOAT_ARRAY, "Not an array of float type")
    assert((Type.new({1}) + Type.new({1.0})) == Types.NUMBER_ARRAY, "Not an array of number type")
    assert(Type.new({true}) == Types.BOOLEAN_ARRAY, "Not an array of boolean type")
    assert(Type.new({"abc"}) == Types.STRING_ARRAY, "Not an array of string type")
    assert(Type.new({}) == Types.EMPTY_ARRAY, "Not an empty array type")
end

local function testNewPrimitiveRecordType()
    assert(Type.new({x = 1}) == Types.INTEGER_RECORD, "Not an record of integer type")
    assert(Type.new({x = 1.0}) == Types.FLOAT_RECORD, "Not a record of float type")
    assert((Type.new({x = 1}) + Type.new({x = 1.0})) == Types.NUMBER_RECORD, "Not a record of number type")
    assert(Type.new({x = true}) == Types.BOOLEAN_RECORD, "Not a record of boolean type")
    assert(Type.new({x = "abc"}) == Types.STRING_RECORD, "Not a record of string type")
end

local function testNewArrayOfRecordType()
    assert(Type.new({{x = 1}, {x = 2}}) == Types.INTEGER_RECORD_ARRAY, "Not an array of record of integer type")
    assert(Type.new({{x = 1.0}, {x = 2.0}}) == Types.FLOAT_RECORD_ARRAY, "Not an array of record of float type")
    assert(Type.new({{x = 1}, {x = 1.0}}) == Types.NUMBER_RECORD_ARRAY, "Not an array of record of number type")
    assert(Type.new({{x = true}, {x = false}}) == Types.BOOLEAN_RECORD_ARRAY, "Not an array of record of booelan type")
    assert(Type.new({{x = "abc"}, {x = "xyz"}}) == Types.STRING_RECORD_ARRAY, "Not an array of record of string type")
end

local function testNewRecordOfArrayType()
    assert(Type.new({x = {1,2,3}}) == Types.INTEGER_ARRAY_RECORD, "Not a record of array of integer type")
    assert(Type.new({x = {1.0,2.0,3.0}}) == Types.FLOAT_ARRAY_RECORD, "Not a record of array of float type")
    assert((Type.new({x = {1,2,3}}) + Type.new({x = {1.0,2.0,3.0}})) == Types.NUMBER_ARRAY_RECORD, "Not a record of array of float type")
    assert(Type.new({x = {true,false}}) == Types.BOOLEAN_ARRAY_RECORD, "Not a record of array of boolean type")
    assert(Type.new({x = {"abc", "xyz"}}) == Types.STRING_ARRAY_RECORD, "Not a record of array of string type")
    assert(Type.new({x = {}}) == Types.EMPTY_ARRAY_RECORD, "Not a record of empty array")
end

local function testNewArrayOfArrayType()
    assert(Type.new({{1,2,3}}) == Types.INTEGER_ARRAY_ARRAY, "Not an array of array of integer type")
    assert(Type.new({{1.0,2.0,3.0}}) == Types.FLOAT_ARRAY_ARRAY, "Not an array of array of float type")
    assert((Type.new({{1,2,3}}) + Type.new({{1.0,2.0,3.0}})) == Types.NUMBER_ARRAY_ARRAY, "Not an array of array of number type")
    assert(Type.new({{true,false}}) == Types.BOOLEAN_ARRAY_ARRAY, "Not an array of array of boolean type")
    assert(Type.new({{"abc", "xyz"}}) == Types.STRING_ARRAY_ARRAY, "Not an array of array of string type")
    assert(Type.new({{}}) == Types.EMPTY_ARRAY_ARRAY, "Not an array of empty array")
end

local function testNewRecordOfRecordType()
    assert(Type.new({x = {x = 1}}) == Types.INTEGER_RECORD_RECORD, "Not a record of record of integer type")
    assert(Type.new({x = {x = 1.0}}) == Types.FLOAT_RECORD_RECORD, "Not a record of record of float type")
    assert((Type.new({x = {x = 1}}) + Type.new({x = {x = 1.0}})) == Types.NUMBER_RECORD_RECORD, "Not a record of record of number type")
    assert(Type.new({x = {x = true}}) == Types.BOOLEAN_RECORD_RECORD, "Not a record of record of booelan type")
    assert(Type.new({x = {x = "abc"}}) == Types.STRING_RECORD_RECORD, "Not a record of record of string type")
end

local function testTypeSum()
    -- STRING + STRING
    assert((Types.STRING + Types.STRING) ==  Types.STRING)
    -- STRING + NUMBER
    assert((Types.STRING + Types.NUMBER) ==  Types.UNKNOWN)
    -- STRING + INT
    assert((Types.STRING + Types.INTEGER) ==  Types.UNKNOWN)
    -- STRING + FLOAT
    assert((Types.STRING + Types.FLOAT) ==  Types.UNKNOWN)
    -- STRING + BOOLEAN
    assert((Types.STRING + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- NUMBER + STRING
    assert((Types.NUMBER + Types.STRING) ==  Types.UNKNOWN)
    -- NUMBER + NUMBER
    assert((Types.NUMBER + Types.NUMBER) ==  Types.NUMBER)
    -- NUMBER + INTEGER
    assert((Types.NUMBER + Types.INTEGER) ==  Types.NUMBER)
    -- NUMBER + FLOAT
    assert((Types.NUMBER + Types.FLOAT) ==  Types.NUMBER)
    -- NUMBER + BOOLEAN
    assert((Types.NUMBER + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- INTEGER + STRING
    assert((Types.INTEGER + Types.STRING) ==  Types.UNKNOWN)
    -- INTEGER + NUMBER
    assert((Types.INTEGER + Types.NUMBER) ==  Types.NUMBER)
    -- INTEGER + INTEGER
    assert((Types.INTEGER + Types.INTEGER) ==  Types.INTEGER)
    -- INTEGER + FLOAT
    assert((Types.INTEGER + Types.FLOAT) ==  Types.NUMBER)
    -- INTEGER + BOOLEAN
    assert((Types.INTEGER + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- FLOAT + STRING
    assert((Types.FLOAT + Types.STRING) ==  Types.UNKNOWN)
    -- FLOAT + NUMBER
    assert((Types.FLOAT + Types.NUMBER) ==  Types.NUMBER)
    -- FLOAT + INTEGER
    assert((Types.FLOAT + Types.INTEGER) ==  Types.NUMBER)
    -- FLOAT + FLOAT
    assert((Types.FLOAT + Types.FLOAT) ==  Types.FLOAT)
    -- FLOAT + BOOLEAN
    assert((Types.FLOAT + Types.BOOLEAN) ==  Types.UNKNOWN)
    -- BOOLEAN + STRING
    assert((Types.BOOLEAN + Types.STRING) ==  Types.UNKNOWN)
    -- BOOLEAN + NUMBER
    assert((Types.BOOLEAN + Types.NUMBER) ==  Types.UNKNOWN)
    -- BOOLEAN + INTEGER
    assert((Types.BOOLEAN + Types.INTEGER) ==  Types.UNKNOWN)
    -- BOOLEAN + FLOAT
    assert((Types.BOOLEAN + Types.FLOAT) ==  Types.UNKNOWN)
    -- BOOLEAN + BOOLEAN
    assert((Types.BOOLEAN + Types.BOOLEAN) ==  Types.BOOLEAN)
end

local function testNewType()

    testNewPrimitiveType()
    testNewPrimitiveArrayType()
    testNewPrimitiveRecordType()
    testNewArrayOfRecordType()
    testNewRecordOfArrayType()
    testNewArrayOfArrayType()
    testNewRecordOfRecordType()
end

Setup()

testNewType()
testTypeSum()