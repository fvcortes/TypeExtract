-- julia.lua
-- Julia sets via interval cell-mapping

local R=2
local exterior,root
local cx,cy
local gray=0.5

------------------------------------------------------------------------------
local O

local function output(a1,a2,a3,a4,a5,a6,a7)
	O:write(
	(a1 or "")," ",
	(a2 or "")," ",
	(a3 or "")," ",
	(a4 or "")," ",
	(a5 or "")," ",
	(a6 or "")," ",
	(a7 or ""),"\n")
end

------------------------------------------------------------------------------
local nP

local function prune(q)
	if q[1]~=nil then
		local c1=prune(q[1])
		local c2=prune(q[2])
		local c3=prune(q[3])
		local c4=prune(q[4])
		if c1==c2 and c1==c3 and c1==c4 and c1~=gray and c1~=nil then
			q.color=c1
			q[1]=nil q[2]=nil q[3]=nil q[4]=nil
			nP=nP+1
		end
	end
	return q.color
end

local function Prune()
	nP=0
	prune(root)
	return nP
end

------------------------------------------------------------------------------
local V,nV={}
local E,nE={}
local Z,nZ={}

local function newcell(c)
	return {color=c}
end

local function addvertex(v)
	nV=nV+1
	V[nV]=v
	v.index=nil
end

local function addedge(a,b)
	nE=nE+1
	E[nE]=Z[b.color] or b
end

local function addsink(i)
	if Z[i]==nil then
		nZ=nZ+1
		Z[nZ]=newcell(i)
		assert(i==nZ)
	end
end

local function refine(i)
	if i==0 then return end
	for v=1,nV do
		local q=V[v]
		if q.color==gray then
			q.color=nil
			q[1]=newcell(gray)
			q[2]=newcell(gray)
			q[3]=newcell(gray)
			q[4]=newcell(gray)
		end
	end
end

------------------------------------------------------------------------------
local R2=R^2

local function outside(xmin,xmax,ymin,ymax)
	local x,y
	if 0<xmin then x=xmin elseif 0<xmax then x=0 else x=xmax end
	if 0<ymin then y=ymin elseif 0<ymax then y=0 else y=ymax end
	return x^2+y^2>R2
end

local function inside(xmin,xmax,ymin,ymax)
	return	xmin^2+ymin^2<=R2 and xmin^2+ymax^2<=R2 and
		xmax^2+ymin^2<=R2 and xmax^2+ymax^2<=R2
end

local function clip(q,xmin,xmax,ymin,ymax,o,oxmin,oxmax,oymin,oymax)
	local ixmin,ixmax,iymin,iymax
	if xmin>oxmin  then ixmin=xmin else ixmin=oxmin end
	if xmax<oxmax  then ixmax=xmax else ixmax=oxmax end
	if ixmin>ixmax then return end
	if ymin>oymin  then iymin=ymin else iymin=oymin end
	if ymax<oymax  then iymax=ymax else iymax=oymax end
	if iymin>iymax then return end
	if q[1]==nil then
		addedge(o,q)
	else
		local xmid=(xmin+xmax)/2.0
		local ymid=(ymin+ymax)/2.0
		clip(q[1],xmin,xmid,ymid,ymax,o,oxmin,oxmax,oymin,oymax)
		clip(q[2],xmid,xmax,ymid,ymax,o,oxmin,oxmax,oymin,oymax)
		clip(q[3],xmin,xmid,ymin,ymid,o,oxmin,oxmax,oymin,oymax)
		clip(q[4],xmid,xmax,ymin,ymid,o,oxmin,oxmax,oymin,oymax)
	end
end

local function imul(xmin,xmax,ymin,ymax)
	local mm=xmin*ymin
	local mM=xmin*ymax
	local Mm=xmax*ymin
	local MM=xmax*ymax
	local m,M=mm,mm
	if m>mM then m=mM elseif M<mM then M=mM end
	if m>Mm then m=Mm elseif M<Mm then M=Mm end
	if m>MM then m=MM elseif M<MM then M=MM end
	return m,M
end

local function isqr(xmin,xmax)
	local u=xmin*xmin
	local v=xmax*xmax
	if xmin<=0.0 and 0.0<=xmax then
		if u<v then return 0.0,v else return 0.0,u end
	else
		if u<v then return u,v else return v,u end
	end
end

local function f(xmin,xmax,ymin,ymax)
	local x2min,x2max=isqr(xmin,xmax)
	local y2min,y2max=isqr(ymin,ymax)
	local xymin,xymax=imul(xmin,xmax,ymin,ymax)
	return x2min-y2max+cx,x2max-y2min+cx,2.0*xymin+cy,2.0*xymax+cy
end

local function map(q,xmin,xmax,ymin,ymax)
	xmin,xmax,ymin,ymax=f(xmin,xmax,ymin,ymax)
	if outside(xmin,xmax,ymin,ymax) then
		addedge(q,exterior)
	else
		if not inside(xmin,xmax,ymin,ymax) then
			addedge(q,exterior)
		end
		clip(root,-R,R,-R,R,q,xmin,xmax,ymin,ymax)
	end
end

local function edges(q,xmin,xmax,ymin,ymax)
	if q[1]==nil then
		if q.color==gray then
			addvertex(q)
			q[2]=nE+1
			map(q,xmin,xmax,ymin,ymax)
			q[3]=nE
		end
	else
		local xmid=(xmin+xmax)/2.0
		local ymid=(ymin+ymax)/2.0
		edges(q[1],xmin,xmid,ymid,ymax)
		edges(q[2],xmid,xmax,ymid,ymax)
		edges(q[3],xmin,xmid,ymin,ymid)
		edges(q[4],xmid,xmax,ymin,ymid)
	end
end

local function graph()
	nV=0
	nE=0
	for i=1,nZ do
		local z=Z[i]
		addvertex(z)
		z[2]=nE+1
		addedge(z,z)
		z[3]=nE
	end
	edges(root,-R,R,-R,R)
	return nV,nE,string.format("%.2f",nE/nV)
end

------------------------------------------------------------------------------
local min=math.min
local index
local S,nS={}
local nC
local sink

local function issink(b,e)
	for i=b,e do
		local v=S[i]
		for i=v[2],v[3] do
			local w=E[i]
			assert(w.scc)
			if w.scc~=v.scc then
				return false
			end
		end
	end
	return true
end

local function issingle(b,e)
	local c=nil
	for i=b,e do
		local v=S[i]
		for i=v[2],v[3] do
			local w=E[i]
			assert(w.color)
			if c==nil then
				c=w.color
			elseif w.color~=c then
				return nil
			end
		end
	end
	return c
end

local function recolor(b,e)
	local c
	if issink(b,e) then
		sink=sink+1
		addsink(sink)
		c=sink
	else
		c=issingle(b,e) or gray
	end
	for i=b,e do
		local v=S[i]
		v.color=c
	end
	--if e-b+1>1 then print("SCC",e-b+1,c) else print("SCC1",S[b][3]-S[b][2]+1,c) end
end

local function strongconnect(v)
	index=index + 1
	v.index=index
	v.lowlink=index
	v.scc=nil
	nS=nS+1
	S[nS]=v
	for i=v[2],v[3] do
		local w=E[i]
		if w.index==nil then
			strongconnect(w)
			v.lowlink=min(v.lowlink, w.lowlink)
		elseif w.scc==nil then
			v.lowlink=min(v.lowlink, w.lowlink)
		end
	end
	if v.lowlink==v.index then
		nC=nC+1
		local e=nS
		repeat
			local w=S[nS]
			nS=nS-1
			w.scc=nC
		until w==v
		local b=nS+1
		recolor(b,e)
	end
end

local function scc()
	sink=0
	index=0
	nS=0
	nC=0
	for v=1,nV do
		local q=V[v]
		if q.index==nil then
			strongconnect(q)
		end
	end
	return nC,#S,nZ,math.floor(100*#S/nV)
end

------------------------------------------------------------------------------
local function savenode(q)
	if q[1]==nil then
		if q.color==0 then O:write("W") end
		if q.color==1 then O:write("B") end
		if q.color==gray then O:write("G") end
	else
		O:write("(")
		savenode(q[1])
		savenode(q[2])
		savenode(q[3])
		savenode(q[4])
		O:write(")")
	end
end

local function savetree(p)
do return end
	p=string.format("%03d.tree",p)
	O=assert(io.open(p,"w"))
	savenode(root)
	O:close()
end

------------------------------------------------------------------------------
local colormap={[gray]=0.5, [1]=1.0, [2]=0.0, [3]=0.8, [4]=0.25}

local function boxcolor(q)
local aa=2
	if q[1]==nil then
		return assert(colormap[q.color or gray])
	else
		if aa==1 then
			return colormap[gray]
		else
			local c1=boxcolor(q[1])
			local c2=boxcolor(q[2])
			local c3=boxcolor(q[3])
			local c4=boxcolor(q[4])
			if aa==2 then
				if c1==c2 and c1==c3 and c1==c4 then
					return c1
				else
					return colormap[gray]
				end
			else
				return (c1+c2+c3+c4)/4
			end
		end
	end
end

local function savebox(q,xmin,ymin,N)
	if q[1]==nil or N==1 then
		output(xmin,ymin,N-0,boxcolor(q))
		return 1
	else
		N=N/2
		local xmid=xmin+N
		local ymid=ymin+N
		return
		savebox(q[1],xmin,ymin,N)+
		savebox(q[2],xmid,ymin,N)+
		savebox(q[3],xmin,ymid,N)+
		savebox(q[4],xmid,ymid,N)
	end
end

local function save(p)
	local N=2^10
	p=string.format("%02d.box",p)
	O=assert(io.open(p,"w"))
	output(N)
	output(0,0,N,0.25)
	local n=savebox(root,0,0,N)
	O:close()
	return n
end

------------------------------------------------------------------------------
local function report(i,s,f,...)
	print(i,s,"start","","",math.floor(collectgarbage"count"/1024).."M")
	local t0=os.clock()
	local t={f(i,...)}
	local t1=os.clock()
	print(i,s,"stop",string.format("%7.2f",t1-t0),"",math.floor(collectgarbage"count"/1024).."M",table.unpack(t))
end

local function step(i)
	report(i,"refine",refine)
	report(i,"graph", graph)
	report(i,"scc",   scc)
	report(i,"prune", Prune)
	report(i,"save",  save)
end

local function steps(l,a,b)
	cx=a	cy=b
	exterior=newcell(1)	nZ=1	Z[nZ]=exterior
	root=newcell(gray)
	for i=0,l do
		print""
		report(i,"step",step)
	end
	print""
	return l,a,b
end

local function julia(l,a,b)
	report(l,"julia",steps,a,b)
end

------------------------------------------------------------------------------

julia(5,-1,0)
--julia(12,0,1)
--julia(8,0,0)
--julia(12,-0.12,0.30)
--julia(12,-0.12,0.74)
--julia(15,-0.12,0.70)
--julia(12,-0.25,0.74)
--julia(13,0.1,0.1)
--julia(12,0.25,0)
--julia(14,0.2499,0)
--julia(12,-0.75,0)

-- http://math.stackexchange.com/a/491910/589
-- period 2
--julia(14, -1 , 0)

-- period 3
--julia(14, -1.75487766624669276 , 0)
--julia(14, -0.122561166876653620 , 0.744861766619744237)

-- period 4
--julia(14, -1.31070264133683288 , 0)
--julia(14, -0.156520166833755062 , 1.03224710892283180)
--julia(12, 0.282271390766913880 , 0.530060617578525299)

-- period 5
--julia(14, -0.504340175446244000 , 0.562765761452981964)
--julia(12, 0.379513588015923745 , 0.334932305597497587)

--julia(12, -1.0, 0.0)
