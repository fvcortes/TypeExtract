-------------------------------------------------------------------
-- File: Types.lua                                            -
-- Defines default types for test comparison                      -
-------------------------------------------------------------------
Types = { INTEGER = {tag = "integer"},
FLOAT = {tag = "float"},
NUMBER = {tag = "number"},
BOOLEAN = {tag = "boolean"},
STRING = {tag = "string"},
NIL = {tag = "nil"},
EMPTY = {tag = "empty"},
ANY = {tag = "any"}}

Types.INTEGER_ARRAY = {tag = "array", arrayType = Types.INTEGER}
Types.FLOAT_ARRAY = {tag = "array", arrayType = Types.FLOAT}
Types.NUMBER_ARRAY = {tag = "array", arrayType = Types.NUMBER}
Types.BOOLEAN_ARRAY = {tag = "array", arrayType = Types.BOOLEAN}
Types.STRING_ARRAY = {tag = "array", arrayType = Types.STRING}
Types.EMPTY_ARRAY = {tag = "array", arrayType = Types.EMPTY}
Types.ANY_ARRAY = {tag = "array", arrayType = Types.ANY}

Types.INTEGER_RECORD = {tag = "record", recordType = {x = Types.INTEGER}}
Types.FLOAT_RECORD = {tag = "record", recordType = {x = Types.FLOAT}}
Types.NUMBER_RECORD = {tag = "record", recordType = {x = Types.NUMBER}}
Types.BOOLEAN_RECORD = {tag = "record", recordType = {x = Types.BOOLEAN}}
Types.STRING_RECORD = {tag = "record", recordType = {x = Types.STRING}}
Types.EMPTY_RECORD = {tag = "record", recordType = {x = Types.EMPTY}}
Types.ANY_RECORD = {tag = "record", recordType = {x = Types.ANY}}

Types.INTEGER_RECORD_ARRAY = {tag = "array", arrayType = Types.INTEGER_RECORD}
Types.FLOAT_RECORD_ARRAY = {tag = "array", arrayType = Types.FLOAT_RECORD}
Types.NUMBER_RECORD_ARRAY = {tag = "array", arrayType = Types.NUMBER_RECORD}
Types.BOOLEAN_RECORD_ARRAY = {tag = "array", arrayType = Types.BOOLEAN_RECORD}
Types.STRING_RECORD_ARRAY = {tag = "array", arrayType = Types.STRING_RECORD}
Types.EMPTY_RECORD_ARRAY = {tag = "array", arrayType = Types.EMPTY_RECORD}
Types.ANY_RECORD_ARRAY = {tag = "array", arrayType = Types.ANY_RECORD}


Types.INTEGER_ARRAY_RECORD = {tag = "record", recordType = {x = Types.INTEGER_ARRAY}}
Types.FLOAT_ARRAY_RECORD = {tag = "record", recordType = {x = Types.FLOAT_ARRAY}}
Types.NUMBER_ARRAY_RECORD = {tag = "record", recordType = {x = Types.NUMBER_ARRAY}}
Types.BOOLEAN_ARRAY_RECORD = {tag = "record", recordType = {x = Types.BOOLEAN_ARRAY}}
Types.STRING_ARRAY_RECORD = {tag = "record", recordType = {x = Types.STRING_ARRAY}}
Types.EMPTY_ARRAY_RECORD = {tag = "record", recordType = {x = Types.EMPTY_ARRAY}}
Types.ANY_ARRAY_RECORD = {tag = "record", recordType = {x = Types.ANY_ARRAY}}


Types.INTEGER_ARRAY_ARRAY = {tag = "array", arrayType = Types.INTEGER_ARRAY}
Types.FLOAT_ARRAY_ARRAY = {tag = "array", arrayType = Types.FLOAT_ARRAY}
Types.NUMBER_ARRAY_ARRAY = {tag = "array", arrayType = Types.NUMBER_ARRAY}
Types.BOOLEAN_ARRAY_ARRAY = {tag = "array", arrayType = Types.BOOLEAN_ARRAY}
Types.STRING_ARRAY_ARRAY = {tag = "array", arrayType = Types.STRING_ARRAY}
Types.EMPTY_ARRAY_ARRAY = {tag = "array", arrayType = Types.EMPTY_ARRAY}
Types.ANY_ARRAY_ARRAY = {tag = "array", arrayType = Types.ANY_ARRAY}

Types.INTEGER_RECORD_RECORD = {tag = "record", recordType = {x = Types.INTEGER_RECORD}}
Types.FLOAT_RECORD_RECORD = {tag = "record", recordType = {x = Types.FLOAT_RECORD}}
Types.NUMBER_RECORD_RECORD = {tag = "record", recordType = {x = Types.NUMBER_RECORD}}
Types.BOOLEAN_RECORD_RECORD = {tag = "record", recordType = {x = Types.BOOLEAN_RECORD}}
Types.STRING_RECORD_RECORD = {tag = "record", recordType = {x = Types.STRING_RECORD}}
Types.EMPTY_RECORD_RECORD = {tag = "record", recordType = {x = Types.EMPTY_RECORD}}
Types.ANY_RECORD_RECORD = {tag = "record", recordType = {x = Types.ANY_RECORD}}



