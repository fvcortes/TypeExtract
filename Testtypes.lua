
Types = { INTEGER = {tag = "integer"},
FLOAT = {tag = "float"},
NUMBER = {tag = "number"},
BOOLEAN = {tag = "boolean"},
STRING = {tag = "string"},
NIL = {tag = "nil"},
UNKNOWN = {tag = "unknown"}}

Types.INTEGER_ARRAY = {tag = "array", arrayType = Types.INTEGER}
Types.FLOAT_ARRAY = {tag = "array", arrayType = Types.FLOAT}
Types.NUMBER_ARRAY = {tag = "array", arrayType = Types.NUMBER}
Types.BOOLEAN_ARRAY = {tag = "array", arrayType = Types.BOOLEAN}
Types.STRING_ARRAY = {tag = "array", arrayType = Types.STRING}
Types.UNKNOWN_ARRAY = {tag = "array", arrayType = Types.UNKNOWN}
Types.EMPTY_ARRAY = {tag = "empty"}

Types.INTEGER_RECORD = {tag = "record", recordType = {x = Types.INTEGER}}
Types.FLOAT_RECORD = {tag = "record", recordType = {x = Types.FLOAT}}
Types.NUMBER_RECORD = {tag = "record", recordType = {x = Types.NUMBER}}
Types.BOOLEAN_RECORD = {tag = "record", recordType = {x = Types.BOOLEAN}}
Types.STRING_RECORD = {tag = "record", recordType = {x = Types.STRING}}
Types.UNKNOWN_RECORD = {tag = "record", recordType = {x = Types.UNKNOWN}}

Types.INTEGER_RECORD_ARRAY = {tag = "array", arrayType = Types.INTEGER_RECORD}
Types.FLOAT_RECORD_ARRAY = {tag = "array", arrayType = Types.FLOAT_RECORD}
Types.NUMBER_RECORD_ARRAY = {tag = "array", arrayType = Types.NUMBER_RECORD}
Types.BOOLEAN_RECORD_ARRAY = {tag = "array", arrayType = Types.BOOLEAN_RECORD}
Types.STRING_RECORD_ARRAY = {tag = "array", arrayType = Types.STRING_RECORD}
Types.UNKNOWN_RECORD_ARRAY = {tag = "array", arrayType = Types.UNKNOWN_RECORD}

Types.INTEGER_ARRAY_RECORD = {tag = "record", recordType = {x = Types.INTEGER_ARRAY}}
Types.FLOAT_ARRAY_RECORD = {tag = "record", recordType = {x = Types.FLOAT_ARRAY}}
Types.NUMBER_ARRAY_RECORD = {tag = "record", recordType = {x = Types.NUMBER_ARRAY}}
Types.BOOLEAN_ARRAY_RECORD = {tag = "record", recordType = {x = Types.BOOLEAN_ARRAY}}
Types.STRING_ARRAY_RECORD = {tag = "record", recordType = {x = Types.STRING_ARRAY}}
Types.EMPTY_ARRAY_RECORD = {tag = "record", recordType = {x = Types.EMPTY_ARRAY}}
Types.UNKNOWN_ARRAY_RECORD = {tag = "record", recordType = {x = Types.UNKNOWN_ARRAY}}

Types.INTEGER_ARRAY_ARRAY = {tag = "array", arrayType = Types.INTEGER_ARRAY}
Types.FLOAT_ARRAY_ARRAY = {tag = "array", arrayType = Types.FLOAT_ARRAY}
Types.NUMBER_ARRAY_ARRAY = {tag = "array", arrayType = Types.NUMBER_ARRAY}
Types.BOOLEAN_ARRAY_ARRAY = {tag = "array", arrayType = Types.BOOLEAN_ARRAY}
Types.STRING_ARRAY_ARRAY = {tag = "array", arrayType = Types.STRING_ARRAY}
Types.EMPTY_ARRAY_ARRAY = {tag = "array", arrayType = Types.EMPTY_ARRAY}
Types.UNKNOWN_ARRAY_ARRAY = {tag = "array", arrayType = Types.UNKNOWN_ARRAY}

Types.INTEGER_RECORD_RECORD = {tag = "record", recordType = {x = Types.INTEGER_RECORD}}
Types.FLOAT_RECORD_RECORD = {tag = "record", recordType = {x = Types.FLOAT_RECORD}}
Types.NUMBER_RECORD_RECORD = {tag = "record", recordType = {x = Types.NUMBER_RECORD}}
Types.BOOLEAN_RECORD_RECORD = {tag = "record", recordType = {x = Types.BOOLEAN_RECORD}}
Types.STRING_RECORD_RECORD = {tag = "record", recordType = {x = Types.STRING_RECORD}}
Types.UNKNOWN_RECORD = {tag = "record", recordType = {x = Types.UNKNOWN_ARRAY}}

