function sum ( xs : { float }): float
    local s : float = 0 .0
    for i = 1 , # xs do
        s = s + xs [ i ]
    end
    return s
end