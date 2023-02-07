function Inspect(event,infos)
    local transfered_types = get_transfered_types(infos)
    if(event == "call" or event == "tail call") then
        push(infos)
        update_parameter_type(transfered_types,infos)
    else
        update_result_type(transfered_types)
    end
end