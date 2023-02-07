local function get_transfered_types(infos)
    local t = {}
    for i=infos.ftransfer,(infos.ftransfer + infos.ntransfer) - 1 do
        local _, value = debug.getlocal(4,i)
        table.insert(t, Type.new(value))
    end
    return t
end