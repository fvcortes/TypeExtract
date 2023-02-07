-------------------------------------------------------------------
-- File: Hook.lua                                                 -
-- Inspect local types; export function information               -
-------------------------------------------------------------------
local Type = require "Type"
Functions = {}
Stack = {}

local function push(info)
    table.insert(Stack, info)
end

local function pop()
    return table.remove(Stack)
end

-- local function get_parameter_types(f)
--     local upvalues = Infos[f]
--     print("get_parameter_types(f,upvalues)")
--     if (upvalues.isvararg == false) then        -- function parameter is not vararg
--         if (upvalues.nparams > 0) then
--             local parameters = {}
--             --print("Getting types for the first time...")
--             --print("nparams",upvalues.nparams)
--             for i=1,upvalues.nparams do         -- iterate over parameters
--                 local n, v = debug.getlocal(3,i)
--                 --dumptable(t)
--                 table.insert(parameters, {name = n, type = Type(v)})
--             end
--             Parameters[f] = parameters
--         end
--     end
-- end

-- local function get_return_types(f)
--     print("get_return_types(f)")
--     local upvalues = ReturnInfos[f]
--     --dumptable(upvalues)
--     --dumptable(Names[f])
--     if(upvalues.istailcall ~= true) then            -- functions is not a tail call
--         if (upvalues.isvararg == false) then        -- function parameter is not vararg
--             if (upvalues.nparams > 0) then
--                 local returns = {}
--                 --print("Getting types for the first time...")
--                 --print("nparams",upvalues.nparams)
--                 for i=upvalues.ftransfer,(upvalues.ftransfer + upvalues.ntransfer) - 1 do         -- iterate over parameters
--                     local n, v = debug.getlocal(4,i)
--                     table.insert(returns, {name = n, type = Type(v)})
--                 end
--                 Returns[f] = returns
--             end
--         end
--     end
-- end

-- local function add_parameter_type(f)
--     print("add_parameter_type(f)")
--     local parameters = Parameters[f]
--     if (parameters ~= nil) then     -- function already called with parameters before
--         for i=1,Infos[f].nparams do             -- iterate over parameters
--             local _, v = debug.getlocal(4,i)
--             --print("Adding parameters type...")
--             parameters[i].type = Add(parameters[i].type, Type(v))
--             --print("New parameter type ->")
--             --dumptable(parameters[i].type)
--         end
--     end
-- end

local function add_parameter_types(types, func)
    if (Functions[func] == nil) then     -- first call
        Functions[func] = {tag = "function", parameterType = types}
    else
        for k,v in ipairs(types) do
            Functions[func].parameterType[k] = Functions[func].parameterType[k] + v
        end
    end
end

local function add_return_types(types,func)
    if(Functions[func].returnType == nil) then   -- first return
        Functions[func].returnType = types
    else
        for k,v in ipairs (types) do
            Functions[func].returnType[k] = v + Functions[func].returnType[k]
        end
    end
end

local function update_parameter_type(types,func)
    add_parameter_types(types,func)
end

local function update_return_type(types, func, istailcall)
    add_return_types(types,func)
    while istailcall do
        local p = table.remove(Stack)
        func = p.func
        istailcall = p.istailcall
        add_return_types(types,func)
    end
end

local function get_transfered_types(infos)
    local t = {}
    for i=infos.ftransfer,(infos.ftransfer + infos.ntransfer) - 1 do
        local _, value = debug.getlocal(4,i)
        table.insert(t, Type.new(value))
    end
    return t
end

function Inspect(event,infos)
    local transfered_types = get_transfered_types(infos)
    if(event == "call" or event == "tail call") then
        table.insert(Stack, infos)
        update_parameter_type(transfered_types,infos.func)
    else
        local p = table.remove(Stack)
        update_return_type(transfered_types, p.func, p.istailcall)
    end
end