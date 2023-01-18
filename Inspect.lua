-------------------------------------------------------------------
-- File: Hook.lua                                                 -
-- Inspect local types; export function information               -
-------------------------------------------------------------------
require "Type"
Functions = {}
Stack = {}

local function push(info)
    print(">Inspect:push")

    table.insert(Stack, info)
end

local function pop()
    print(">Inspect:pop")
    return table.remove(Stack)
end

local function get_parameter_types(f)
    local upvalues = Infos[f]
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
                    local n, v = debug.getlocal(4,i)
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
        for i=1,Infos[f].nparams do             -- iterate over parameters
            local _, v = debug.getlocal(4,i)
            --print("Adding parameters type...")
            parameters[i].type = Add(parameters[i].type, Type(v))
            --print("New parameter type ->")
            --dumptable(parameters[i].type)
        end
    end
end

local function update_parameter_type(type)
    print(">Inspect:update_parameter_type")
    local ft = debug.getinfo(4,"ft")
    push(ft)
    if (Functions[ft.func] == nil) then
        Functions[ft.func] = {tag = "function", parameterType = type}
    else
        Functions[ft.func].parameterType = Add(Functions[ft.func].parameterType, type)
    end
end

local function update_result_type(type)
    print(">Inspect:update_result_type")
    local ft = pop()
    Functions[ft.func].returnType = Add(Functions[ft.func].returnType, type)
    while ft.istailcall do
        ft = pop()
        Functions[ft.func].returnType = Add(Functions[ft.func].returnType, type)
    end
end

local function get_transfered_values(event)
    print(">Inspect:get_transfered_values")
    local v = {}
    local r = debug.getinfo(4, "r")
    print(">Inspect:get_transfered_values - event: " .. event)
    print(">Inspect:get_transfered_values - ftransfer: " .. r.ftransfer .. " - ntransfer: " .. r.ntransfer)
    for i=r.ftransfer,(r.ftransfer + r.ntransfer) - 1 do
        local name, value = debug.getlocal(4,i)
        if(event == "call") then
            print(">Inspect:get_transfered_values - -> [" .. name .. "]" )
            table.insert(v, {[name] = value})
        else
            table.insert(v, {[i] = value})
        end
    end
    print(">Inspect:get_transfered_values - dumping transfered_values:" )
    dumptable(v)
    print(">Inspect:get_transfered_values - dumping v[1]:" )
    dumptable(v[1])

    return v
end

function Inspect(event)
    print(">Inspect:Inspect")
    -- IDEA: pack parameter/return values in a table and call Type on it
    local transfered_type = Type(get_transfered_values(event))
    if(event == "call") then
        update_parameter_type(transfered_type)
    else    -- return event
        update_result_type(transfered_type)
    end
end