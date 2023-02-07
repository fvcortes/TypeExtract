Type.new(1)                 
--> integer
Type.new("abc")             
--> string
Type.new(true)              
--> booelan
Type.new({1,2,3})           
--> {integer}
Type.new({"abc", "xyz"})    
--> {string}
Type.new({x = 10, y = 20})  
--> {x:integer, y:integer}
Type.new({names = {"Rachel", "Derik"}, ordered = false}) 
--> {names:{string}, ordered:boolean}
