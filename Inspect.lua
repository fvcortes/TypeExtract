-------------------------------------------------------------------
-- File: Hook.lua                                                 -
-- Inspect local types; export function information               -
-------------------------------------------------------------------
require "Type"
Functions = {}

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
        for i=1,Infos[f].nparams do             -- iterate over parameters
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

function Update(func, functionType)
end
function Inspect(event, func, infos)
    if(event == "call") then
        if(Functions[func] == nil) then -- first call
            get_parameter_types(func)
        else    -- already called
            add_parameter_type(func)   -- try to add new types to old ones

        end
    else    -- return event
        if(Functions[func].returnType == nil) then  -- First time returning
            get_return_types(func)
        else
            add_return_types(func)
        end
    end
    
end