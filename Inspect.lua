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

local function update_parameter_type(types,infos)
    if (Functions[infos.func] == nil) then     -- first call
        Functions[infos.func] = {tag = "function", parameterType = types}
    else
        for k,v in ipairs(types) do
            Functions[infos.func].parameterType[k] = Functions[infos.func].parameterType[k] + v
        end
    end
end

local function add_return_types(func,types)
    if(Functions[func].returnType == nil) then   -- first return
        Functions[func].returnType = types
    else
        for k,v in ipairs (types) do
            Functions[func].returnType[k] = v + Functions[func].returnType[k]
        end
    end
end
local function add_parameter_types ()
    
end
local function update_result_type(types, func, istailcall)
    add_return_types(func,types)
    while istailcall do
        local p = pop()
        func = p.func
        istailcall = p.istailcall
        add_return_types(func,types)
    end
end
local function get_transfered_types(infos)
    --print(">Inspect:get_transfered_types")
    --local r = debug.getinfo(4, "r")
    -- print(">Inspect:get_transfered_types - r.ftransfer: " .. r.ftransfer .. " - r.ntransfer: " .. r.ntransfer.." - infos.linedefined:["..infos.linedefined.."]")
    --print(">Inspect:get_transfered_types - infos.ftransfer: " .. infos.ftransfer .. " - infos.ntransfer: " .. infos.ntransfer.." - infos.linedefined:["..infos.linedefined.."]")
    local t = {}
    if (infos.ntransfer == 0) then
        table.insert(t, Type.new(nil))
        return  {}
    end
    for i=infos.ftransfer,(infos.ftransfer + infos.ntransfer) - 1 do
        local _, value = debug.getlocal(4,i)
        -- when transfered value is nil, tranfered array gets messedup
        --print(">Inspect:get_transfered_values - -> [" .. name .. "] = "..tostring(value) )
        table.insert(t, Type.new(value))
    end
    -- print(">Inspect:Inspect - dumping transfered table")
    -- dumptable(t)
    return t
end

function Inspect(event,infos)
    local transfered_types = get_transfered_types(infos)
    if(event == "call" or event == "tail call") then
        push(infos)
        update_parameter_type(transfered_types,infos)
    else
        local p = pop()
        update_result_type(transfered_types, p.func, p.istailcall)
    end
end