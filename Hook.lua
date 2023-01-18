-------------------------------------------------------------------
-- File: Hook.lua                                                 -
-- Inspect local types; export function information               -
-------------------------------------------------------------------
require "Type"
require "Inspect"
Counters = {}
Names = {}
Ignores = {}
--TODO: Treat varargs from getlocal

function Hook (event)
    print(">Hook:Hook")
    local f = debug.getinfo(2,"f").func
    if (Ignores[f] == true) then
        print(">Hook:Hook - func:" .. tostring(f) .. " ignored")
        return
    else
        if(Counters[f] == nil) then
            local names = debug.getinfo(2,"Sn")
            if (names.what ~= "Lua") then
                print(">Hook:Hook - func:" .. tostring(f) .. " ignored")
                Ignores[f] = true
                return
            else
                print(">Hook:Hook - name:" .. names.name)
                print(">Hook:Hook - Counters = 1")
                Counters[f] = 1
                Names[f] = names
            end
        else
            if(event == "call") then
                Counters[f] = Counters[f] + 1
                print(">Hook:Hook - Counters: " .. Counters[f])
            end
        end
        Inspect(event)
    end
    ----------------------------------------------------------
    -- if(Ignores[f] ~= true) then
    --     --local infos = debug.getinfo(2,"ur")
    --     local functionType = Inspect(event)
    --     if (event == "call") then
    --         if(Counters[f] == nil) then  -- Function never inspected
    --             local names = debug.getinfo(2,"Sn")
    --             if names.what == "Lua" then
    --                 push(finfos)
    --                 Counters[f] = 1
    --                 Names[f] = names
    --             else
    --                 return
    --             end
    --         else    -- Function already inspected and its a call event
    --             push(finfos)
    --             update_counter(f)
    --         end
    --     else    -- return event
    --         finfos = pop()
    --         while finfos.istailcall do
    --             finfos = pop()
    --             Update(finfos.func, functionType)
    --         end
    --         -- REMINDER
    --         --[[
    --             while p.istailcall do
    --                 p = pop()
    --                 updateResult(p.func, info.ftransfer, info.ntransfer)
    --             end
    --         ]]
    --     end
    -- end
    -- TODO: Transfer value obtention logic from debug.getlocal to Inspect module
    -- WARNING: Counters table is messed up now, Inspect module knows how to increment call count (due to event == "call")
    --          but Report module requires Hook and not Inspect
    --          event is only useful to assign the correct table (returnType or parameterType), but
    --          it's very debatable wether event is necessary on Inspect or not because ntransfer and ftransfer
    --          facilitates a lot to iterate over 

    
    --     local infos
    --     if(Counters[f] == nil) then  -- Function never inspected
    --         infos = debug.getinfo(2,"Snurt")
    --         if infos.what == "Lua" then
    --             push(infos)
    --         end
    --     else    -- Function already inspected
    --         infos = pop()
    --     end
    --     Inspect(f,event,infos.ntransfer,infos.ftransfer)
    -- end

    -- if(Ignores[f] ~= true) then
    --     --print("name",debug.getinfo(2,"Sn").name,"event", event)
    --     if (event == "call") then -- call event
    --         if(Counters[f] == nil) then -- first time function is called
    --             local names = debug.getinfo(2,"Sn")
    --             if names.what == "Lua" then
    --                 Infos[f] = debug.getinfo(2,"urt")
    --                 Counters[f] = 1
    --                 Names[f] = names
    --                 get_parameter_types(f)
    --             end
    --         else    -- function already called 
    --             update_counter(f)
    --             add_parameter_type(f)   -- try to add new types to old ones
    --         end
    --     else    -- return event
    --         if(Returns[f] == nil) then  -- first time returned
    --             ReturnInfos[f] = debug.getinfo(2,"urt")
    --             get_return_types(f)
    --         else    -- function already returned before
    --             add_return_types(f)
    --         end
    --     end
    -- end
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
