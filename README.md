# TypeExtract
The purpose of this program is extracting types
from functions in a Lua program.

Content:

  Type.lua     - Responsible for extract and infer types
                 of a Lua value.

  Function.lua - Responsible for gathering information
                 about local values in a function call
                 and return.

  Hook.lua     - Implementation of the hook used to extract
                 types from function call and return.

  Report.lua   - Responsible for generating a report with
                 function information.

  Compare.lua  - Used for testing which compares two types
                 and return if they are the same.

  Test.lua     - Makes a series of compares based on programs
                 which we know the output.

  Run.lua      - Responsible for loading a Lua file and set
                 the hook.

  Main.lua     - Receives a Lua program as parameter and run
                 the file.

Usage:

  lua Main.lua <program>

  This will generate a "report.out" file with information about
  functions called during the program execution.

Example:

  Let say we have the following program which has a single function.

   function foo(a)
     return a
   end

  if we call foo(1) in the same file and pass it to our program,
  it will generate the following output:

   [foo.lua]:1 (foo)1
   (integer) => (integer)

  Which means the function declared in line 1 was called once and
  receives an integer and returns an integer

  if we call it twice as foo(1);foo(.1), the output will be as
  the following:

   [foo.lua]:1 (foo)2
   (number) => (number)
   Parameters:
   1.
       float 50.00% (1)
       integer 50.00% (1)
   Results:
   1.
       float 50.00% (1)
       integer 50.00% (1)

  It means that function foo was called twice but not with the
  same value types and the output indicates the proportion of
  each type. Each parameter and result is reported in the order
  which it was passed/transfered.

  Going on with our example, if we continue to call foo but this
  time with no parameters, the following output will be generated:

   [foo.lua]:1 (foo)3
   (opt number) => (opt number)
   Parameters:
   1.
       nil 33.33% (1)
       integer 33.33% (1)
       float 33.33% (1)
   Results
   1.
       nil 33.33% (1)
       integer 33.33% (1)
       float 33.33% (1)

  The new 'opt' tag means that this value is optional, since the
  function was called with a nil value.

  As the complexity of a program grows, it can be hard to generate
  a friendly report with intuitive types. For example, if we have
  a recursive struct types being transfered as values in a function,
  our program is not able to detect it's recursiveness and probably
  will show us a long and repetitive type structure.


