function boo()
    return 1
end
function foo()
    return boo()
end
foo()