INTEGER = {tag = "integer"}
Type.new(1) == INTEGER  --> true

EMPTY = {tag = "empty"}
Type.new({}) == EMPTY   --> true

ANY = {tag = "any"}
Type.new("abc") == ANY  --> false


BOOLEAN = {tag = "boolean"}
BOOLEAN_ARRAY = {tag = "array", arrayType = BOOLEAN}
Type.new({true,false}) == BOOLEAN_ARRAY --> true

FLOAT = {tag = "float"}
FLOAT_RECORD = {tag = "record", recordType = {x = FLOAT}}
Type.new({x = 3.14}) == FLOAT_RECORD    --> true