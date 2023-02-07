local function update_return_type(types, func, istailcall)
    add_return_types(types,func)
    while istailcall do
        local p = table.remove(Stack)
        func = p.func
        istailcall = p.istailcall
        add_return_types(types,func)
    end
end