local interface Element
    info:number
    next:Element? 
end 

local function insert (e:Element?,v:number):Element   
    return { info = v, next = e } 
end
