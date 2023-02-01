Type = require "Type"

INTEGER_TYPE = {tag = "integer"}
FLOAT_TYPE = {tag = "float"}
NUMBER_TYPE = {tag = "number"}
BOOLEAN_TYPE = {tag = "boolean"}
STRING_TYPE = {tag = "string"}
NIL_TYPE = {tag = "nil"}
UNKNOWN_TYPE = {tag = "unknown"}
INTEGER_ARRAY_TYPE = {tag = "array", arrayType = INTEGER_TYPE}
FLOAT_ARRAY_TYPE = {tag = "array", arrayType = FLOAT_TYPE}
NUMBER_ARRAY_TYPE = {tag = "array", arrayType = NUMBER_TYPE}
BOOLEAN_ARRAY_TYPE = {tag = "array", arrayType = BOOLEAN_TYPE}
STRING_ARRAY_TYPE = {tag = "array", arrayType = STRING_TYPE}
EMPTY_ARRAY_TYPE = {tag = "empty"}
INTEGER_RECORD_TYPE = {tag = "record", recordType = {x = INTEGER_TYPE}}
FLOAT_RECORD_TYPE = {tag = "record", recordType = {x = FLOAT_TYPE}}
NUMBER_RECORD_TYPE = {tag = "record", recordType = {x = NUMBER_TYPE}}
BOOLEAN_RECORD_TYPE = {tag = "record", recordType = {x = BOOLEAN_TYPE}}
STRING_RECORD_TYPE = {tag = "record", recordType = {x = STRING_TYPE}}
INTEGER_RECORD_ARRAY_TYPE = {tag = "array", arrayType = INTEGER_RECORD_TYPE}
FLOAT_RECORD_ARRAY_TYPE = {tag = "array", arrayType = FLOAT_RECORD_TYPE}
NUMBER_RECORD_ARRAY_TYPE = {tag = "array", arrayType = NUMBER_RECORD_TYPE}
BOOLEAN_RECORD_ARRAY_TYPE = {tag = "array", arrayType = BOOLEAN_RECORD_TYPE}
STRING_RECORD_ARRAY_TYPE = {tag = "array", arrayType = STRING_RECORD_TYPE}
INTEGER_ARRAY_RECORD_TYPE = {tag = "record", recordType = {x = INTEGER_ARRAY_TYPE}}
FLOAT_ARRAY_RECORD_TYPE = {tag = "record", recordType = {x = FLOAT_ARRAY_TYPE}}
NUMBER_ARRAY_RECORD_TYPE = {tag = "record", recordType = {x = NUMBER_ARRAY_TYPE}}
BOOLEAN_ARRAY_RECORD_TYPE = {tag = "record", recordType = {x = BOOLEAN_ARRAY_TYPE}}
STRING_ARRAY_RECORD_TYPE = {tag = "record", recordType = {x = STRING_ARRAY_TYPE}}
EMPTY_ARRAY_RECORD_TYPE = {tag = "record", recordType = {x = EMPTY_ARRAY_TYPE}}
INTEGER_ARRAY_ARRAY_TYPE = {tag = "array", arrayType = INTEGER_ARRAY_TYPE}
FLOAT_ARRAY_ARRAY_TYPE = {tag = "array", arrayType = FLOAT_ARRAY_TYPE}
NUMBER_ARRAY_ARRAY_TYPE = {tag = "array", arrayType = NUMBER_ARRAY_TYPE}
BOOLEAN_ARRAY_ARRAY_TYPE = {tag = "array", arrayType = BOOLEAN_ARRAY_TYPE}
STRING_ARRAY_ARRAY_TYPE = {tag = "array", arrayType = STRING_ARRAY_TYPE}
EMPTY_ARRAY_ARRAY_TYPE = {tag = "array", arrayType = EMPTY_ARRAY_TYPE}
INTEGER_RECORD_RECORD_TYPE = {tag = "record", recordType = {x = INTEGER_RECORD_TYPE}}
FLOAT_RECORD_RECORD_TYPE = {tag = "record", recordType = {x = FLOAT_RECORD_TYPE}}
NUMBER_RECORD_RECORD_TYPE = {tag = "record", recordType = {x = NUMBER_RECORD_TYPE}}
BOOLEAN_RECORD_RECORD_TYPE = {tag = "record", recordType = {x = BOOLEAN_RECORD_TYPE}}
STRING_RECORD_RECORD_TYPE = {tag = "record", recordType = {x = STRING_RECORD_TYPE}}


local function testPrimitiveTypeCreation()
    assert(Type.new(1) == INTEGER_TYPE, "Not an integer type")
    assert(Type.new(1.0) == FLOAT_TYPE, "Not a float type")
    assert((Type.new(1) + Type.new(1.0)) == NUMBER_TYPE, "Not a number type")
    assert(Type.new(true) == BOOLEAN_TYPE, "Not a boolean type")
    assert(Type.new("abc") == STRING_TYPE, "Not a string type")
    assert(Type.new() == NIL_TYPE, "Not a nil type")
end

local function testPrimitiveArrayTypeCreation()
    assert(Type.new({1}) == INTEGER_ARRAY_TYPE, "Not an array of integer type")
    assert(Type.new({1.0}) == FLOAT_ARRAY_TYPE, "Not an array of float type")
    assert((Type.new({1}) + Type.new({1.0})) == NUMBER_ARRAY_TYPE, "Not an array of number type")
    assert(Type.new({true}) == BOOLEAN_ARRAY_TYPE, "Not an array of boolean type")
    assert(Type.new({"abc"}) == STRING_ARRAY_TYPE, "Not an array of string type")
    assert(Type.new({}) == EMPTY_ARRAY_TYPE, "Not an empty array type")
end

local function testPrimitiveRecordTypeCreation()
    assert(Type.new({x = 1}) == INTEGER_RECORD_TYPE, "Not an record of integer type")
    assert(Type.new({x = 1.0}) == FLOAT_RECORD_TYPE, "Not a record of float type")
    assert((Type.new({x = 1}) + Type.new({x = 1.0})) == NUMBER_RECORD_TYPE, "Not a record of number type")
    assert(Type.new({x = true}) == BOOLEAN_RECORD_TYPE, "Not a record of boolean type")
    assert(Type.new({x = "abc"}) == STRING_RECORD_TYPE, "Not a record of string type")
end

local function testArrayOfRecordTypeCreation()
    assert(Type.new({{x = 1}, {x = 2}}) == INTEGER_RECORD_ARRAY_TYPE, "Not an array of record of integer type")
    assert(Type.new({{x = 1.0}, {x = 2.0}}) == FLOAT_RECORD_ARRAY_TYPE, "Not an array of record of float type")
    assert(Type.new({{x = 1}, {x = 1.0}}) == NUMBER_RECORD_ARRAY_TYPE, "Not an array of record of number type")
    assert(Type.new({{x = true}, {x = false}}) == BOOLEAN_RECORD_ARRAY_TYPE, "Not an array of record of booelan type")
    assert(Type.new({{x = "abc"}, {x = "xyz"}}) == STRING_RECORD_ARRAY_TYPE, "Not an array of record of string type")
end

local function testRecordOfArrayTypeCreation()
    assert(Type.new({x = {1,2,3}}) == INTEGER_ARRAY_RECORD_TYPE, "Not a record of array of integer type")
    assert(Type.new({x = {1.0,2.0,3.0}}) == FLOAT_ARRAY_RECORD_TYPE, "Not a record of array of float type")
    assert((Type.new({x = {1,2,3}}) + Type.new({x = {1.0,2.0,3.0}})) == NUMBER_ARRAY_RECORD_TYPE, "Not a record of array of float type")
    assert(Type.new({x = {true,false}}) == BOOLEAN_ARRAY_RECORD_TYPE, "Not a record of array of boolean type")
    assert(Type.new({x = {"abc", "xyz"}}) == STRING_ARRAY_RECORD_TYPE, "Not a record of array of string type")
    assert(Type.new({x = {}}) == EMPTY_ARRAY_RECORD_TYPE, "Not a record of empty array")
end

local function testArrayOfArrayTypeCreation()
    assert(Type.new({{1,2,3}}) == INTEGER_ARRAY_ARRAY_TYPE, "Not an array of array of integer type")
    assert(Type.new({{1.0,2.0,3.0}}) == FLOAT_ARRAY_ARRAY_TYPE, "Not an array of array of float type")
    assert((Type.new({{1,2,3}}) + Type.new({{1.0,2.0,3.0}})) == NUMBER_ARRAY_ARRAY_TYPE, "Not an array of array of number type")
    assert(Type.new({{true,false}}) == BOOLEAN_ARRAY_ARRAY_TYPE, "Not an array of array of boolean type")
    assert(Type.new({{"abc", "xyz"}}) == STRING_ARRAY_ARRAY_TYPE, "Not an array of array of string type")
    assert(Type.new({{}}) == EMPTY_ARRAY_ARRAY_TYPE, "Not an array of empty array")
end

local function testRecordOfRecordTypeCreation()
    assert(Type.new({x = {x = 1}}) == INTEGER_RECORD_RECORD_TYPE, "Not a record of record of integer type")
    assert(Type.new({x = {x = 1.0}}) == FLOAT_RECORD_RECORD_TYPE, "Not a record of record of float type")
    assert((Type.new({x = {x = 1}}) + Type.new({x = {x = 1.0}})) == NUMBER_RECORD_RECORD_TYPE, "Not a record of record of number type")
    assert(Type.new({x = {x = true}}) == BOOLEAN_RECORD_RECORD_TYPE, "Not a record of record of booelan type")
    assert(Type.new({x = {x = "abc"}}) == STRING_RECORD_RECORD_TYPE, "Not a record of record of string type")
end

local function testUnknownType()
    assert((Type.new(1) + Type.new("a")) == UNKNOWN_TYPE)
end

testPrimitiveTypeCreation()
testPrimitiveArrayTypeCreation()
testPrimitiveRecordTypeCreation()
testArrayOfRecordTypeCreation()
testRecordOfArrayTypeCreation()
testArrayOfArrayTypeCreation()
testRecordOfRecordTypeCreation()
testUnknownType()