-------------------------------------------------------------------
-- File: Hook.lua                                                 -
-- Inspect local types; export function information               -
-------------------------------------------------------------------
local Type = require "Type"
Functions = {}
Stack = {}

local function push(info)
    --print(">Inspect:push")
    table.insert(Stack, info)
end

local function pop()
    --print(">Inspect:pop")
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

local function update_parameter_type(types)
    print(">Inspect:update_parameter_type")
    local ft = debug.getinfo(4,"ft")
    print(">Inspect:update_parameter_type - istailcall: ", ft.istailcall)
    push(ft)
    if (Functions[ft.func] == nil) then     -- first call
        Functions[ft.func] = {tag = "function", parameterType = types}
    else
        for k,v in pairs(types) do
            Functions[ft.func].parameterType[k] = v + Functions[ft.func].parameterType[k]
        end
--        Functions[ft.func].parameterType = type + Functions[ft.func].parameterType
    end
end

local function update_result_type(types)
    --print(">Inspect:update_result_type")
    local ft = pop()
    if(Functions[ft.func].returnType == nil) then   -- first return
        Functions[ft.func].returnType = types
    else
        for k,v in pairs (types) do
            Functions[ft.func].returnType[k] = v + Functions[ft.func].returnType[k]
        end
    end

    -- for k,v in pairs (types) do
    --     Functions[ft.func].returnType[k] = v + Functions[ft.func].returnType[k]
    -- end
    --Functions[ft.func].returnType = type + Functions[ft.func].returnType
    while ft.istailcall do
        ft = pop()
        if(Functions[ft.func].returnType == nil) then   -- first return
            Functions[ft.func].returnType = types
        else
            for k,v in pairs (types) do
                Functions[ft.func].returnType[k] = v + Functions[ft.func].returnType[k]
            end
        end
        -- for k,v in pairs (types) do
        --     Functions[ft.func].returnType[k] = v + Functions[ft.func].returnType[k]
        -- end
    end
end
local function iter_transfer(r, event)
    local t = {}
    if (r.ntransfer == 0) then
        table.insert(t, Type.new(nil))
        return  t
    end
    for i=r.ftransfer,(r.ftransfer + r.ntransfer) - 1 do
        local _, value = debug.getlocal(4,i)
        -- when transfered value is nil, tranfered array gets messedup
        --print(">Inspect:get_transfered_values - -> [" .. name .. "] = "..tostring(value) )
        table.insert(t, Type.new(value))
    end
    return t
end
local function get_transfered_types(event)
    --print(">Inspect:get_transfered_types")
    local r = debug.getinfo(4, "r")
    print(">Inspect:get_transfered_types - event: " .. event)
    print(">Inspect:get_transfered_types - ftransfer: " .. r.ftransfer .. " - ntransfer: " .. r.ntransfer)
    if(r.ntransfer == 0) then
        return {}
    end
    return iter_transfer(r,event)
end

function Inspect(event)
    --print(">Inspect:Inspect")
    -- pack parameter/return values in a table and call Type on it
    local transfered_types = get_transfered_types(event)
    if(event == "call" or event == "tail call") then
        update_parameter_type(transfered_types)
    else    -- return event
        update_result_type(transfered_types)
    end
end