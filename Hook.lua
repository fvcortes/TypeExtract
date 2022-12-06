-------------------------------------------------------------------
-- File: Hook.lua                                                 -
-- Inspect local types; export function information               -
-------------------------------------------------------------------
require "Type"
Counters = {}
Names = {}
Parameters = {}
Returns = {}
CallInfos = {}
ReturnInfos = {}
Ignores = {}
local FIRST_RETURN = true
local FIRST_CALL = true
--TODO: Treat varargs from getlocal


local function update_counter(f)
    Counters[f] = Counters[f] + 1
end

local function get_parameter_types(f)
    local upvalues = CallInfos[f]
    print("get_parameter_types(f,upvalues)")
    if (upvalues.isvararg == false) then        -- function parameter is not vararg
        if (upvalues.nparams > 0) then 
            local parameters = {}
            --print("Getting types for the first time...")
            --print("nparams",upvalues.nparams)
            for i=1,upvalues.nparams do         -- iterate over parameters
                local n, v = debug.getlocal(3,i)
                --dumptable(t)
                table.insert(parameters, {name = n, type = Type(v)})
            end
            Parameters[f] = parameters
        end
    end
end

local function get_return_types(f)
    print("get_return_types(f)")
    local upvalues = ReturnInfos[f]
    --dumptable(upvalues)
    --dumptable(Names[f])
    if(upvalues.istailcall ~= true) then            -- functions is not a tail call
        if (upvalues.isvararg == false) then        -- function parameter is not vararg
            if (upvalues.nparams > 0) then
                local returns = {}
                --print("Getting types for the first time...")
                --print("nparams",upvalues.nparams)
                for i=upvalues.ftransfer,(upvalues.ftransfer + upvalues.ntransfer) - 1 do         -- iterate over parameters
                    local n, v = debug.getlocal(3,i)
                    table.insert(returns, {name = n, type = Type(v)})
                end
                Returns[f] = returns
            end
        end
    end
end

local function add_parameter_type(f)
    print("add_parameter_type(f)")
    local parameters = Parameters[f]
    if (parameters ~= nil) then     -- function already called with parameters before
        for i=1,CallInfos[f].nparams do             -- iterate over parameters
            local _, v = debug.getlocal(3,i)
            --print("Adding parameters type...")
            parameters[i].type = Add(parameters[i].type, Type(v))
            --print("New parameter type ->")
            --dumptable(parameters[i].type)
        end
    end
end

local function add_return_types(f)
end

function Hook (event)
    local f = debug.getinfo(2,"f").func
    if(Ignores[f] ~= true) then
        --print("name",debug.getinfo(2,"Sn").name,"event", event)
        if (event == "call") then
            if(FIRST_CALL) then
                Ignores[f] = true
                FIRST_CALL = false
            else
                if(Counters[f] ~= nil) then -- function already called
                    update_counter(f)
                    add_parameter_type(f)    -- try to add new types to old ones
                else
                    local names = debug.getinfo(2,"Sn")
                    if names.what == "Lua" then
                        CallInfos[f] = debug.getinfo(2,"urt")
                        Counters[f] = 1
                        Names[f] = names
                        get_parameter_types(f)
                    end
                end
            end
        else
            if (FIRST_RETURN) then
                Ignores[f] = true
                FIRST_RETURN = false
            else 
                if(Returns[f] ~= nil) then -- function already returned before
                    add_return_types(f)
                else
                    ReturnInfos[f] = debug.getinfo(2,"urt")
                    get_return_types(f)
                end
            end
        end
    end
end

---------------------------- NOTES --------------------------------
-- if the function isvararg, the value of nparams from getlocal  is always 0
-- the value of nparams is always the number of parameters defined in the functions declaration,
-- and not from the functions invocation
-- e.g.
--      local function foo(a,b,c)
--          ...
--      end
--      foo(1,2,3)  --> nparams = 3
--      foo(1)      --> nparams = 3
--      local function boo(...)
--          ...
--      end
--      boo(1,2,3)  --> nparams = 0
--      boo(1)      --> nparams = 0
-- In a call hook, we want to analyse function parameters.
-- If nparams is 0 then only update functions call
-- If nparams is greater than 0, we iterate over nparams obtaining parameter names and values through getlocal
-- First hook and last hook evocations should be avoided cause its sethook return and set_hook call at the end

-------------------------------------------------------------------
-- 'f': pushes onto the stack the function that is running at the given level;
-- 'l': fills in the field currentline;
-- 'n': fills in the fields name and namewhat;
-- 'r': fills in the fields ftransfer and ntransfer;
-- 'S': fills in the fields source, short_src, linedefined, lastlinedefined, and what;
-- 't': fills in the field istailcall;
-- 'u': fills in the fields nups, nparams, and isvararg;
-- 'L': pushes onto the stack a table whose indices are the lines on the function with some associated code, that is, the lines where you can put a break point. (Lines with no code include empty lines and comments.) If this option is given together with option 'f', its table is pushed after the function. This is the only option that can raise a memory error.

-- The fields of lua_Debug have the following meaning:

-- source: the source of the chunk that created the function. If source starts with a '@', it means that the function was defined in a file where the file name follows the '@'. If source starts with a '=', the remainder of its contents describes the source in a user-dependent manner. Otherwise, the function was defined in a string where source is that string.
-- srclen: The length of the string source.
-- short_src: a "printable" version of source, to be used in error messages.
-- linedefined: the line number where the definition of the function starts.
-- lastlinedefined: the line number where the definition of the function ends.
-- what: the string "Lua" if the function is a Lua function, "C" if it is a C function, "main" if it is the main part of a chunk.
-- currentline: the current line where the given function is executing. When no line information is available, currentline is set to -1.
-- name: a reasonable name for the given function. Because functions in Lua are first-class values, they do not have a fixed name: some functions can be the value of multiple global variables, while others can be stored only in a table field. The lua_getinfo function checks how the function was called to find a suitable name. If it cannot find a name, then name is set to NULL.
-- namewhat: explains the name field. The value of namewhat can be "global", "local", "method", "field", "upvalue", or "" (the empty string), according to how the function was called. (Lua uses the empty string when no other option seems to apply.)
-- istailcall: true if this function invocation was called by a tail call. In this case, the caller of this level is not in the stack.
-- nups: the number of upvalues of the function.
-- nparams: the number of parameters of the function (always 0 for C functions).
-- isvararg: true if the function is a vararg function (always true for C functions).
-- ftransfer: the index in the stack of the first value being "transferred", that is, parameters in a call or return values in a return. (The other values are in consecutive indices.) Using this index, you can access and modify these values through lua_getlocal and lua_setlocal. This field is only meaningful during a call hook, denoting the first parameter, or a return hook, denoting the first value being returned. (For call hooks, this value is always 1.)
-- ntransfer: The number of values being transferred (see previous item). (For calls of Lua functions, this value is always equal to nparams.)
