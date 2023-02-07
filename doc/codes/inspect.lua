function Inspect(event,infos)
    local transfered_types = get_transfered_types(infos)
    if(event == "call" or event == "tail call") then
        table.insert(Stack, infos)
        update_parameter_type(transfered_types,infos.func)
    else
        local p = table.remove(Stack)
        update_result_type(transfered_types, p.func, p.istailcall)
    end
end