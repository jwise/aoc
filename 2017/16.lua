#!/usr/bin/env lua

sz = tonumber(arg[1] or 16)
count = tonumber(arg[2] or 1000000000)
--line = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"}
line = {}
order = {}
for i=1,sz do
	table.insert(line, string.char(96 + i))
	table.insert(order, i)
end


-- table of unapplied character permutations
permtab = {}
for k,v in pairs(line) do permtab[v] = v end

l = io.read("*line")

for cmd in l:gmatch("([^,]+)") do
	if cmd:match("s%d+") then
		n = tonumber(cmd:match("%d+"))
		
		for i=1,n do
			elt = table.remove(order)
			table.insert(order, 1, elt)
		end
	elseif cmd:match("x%d+/%d+") then
		a,b = cmd:match("x(%d+)/(%d+)")
		a = tonumber(a)
		b = tonumber(b)
		
		ae,be = order[a+1], order[b+1]
		order[b+1], order[a+1] = ae, be
	elseif cmd:match("p%a/%a") then
		a,b = cmd:match("p(%a)/(%a)")
		
		for k,v in pairs(permtab) do
			if v == a then permtab[k] = b
			elseif v == b then permtab[k] = a end
		end
	else
		print("anus? "..cmd)
	end
end

function pr(ln)
	s = ""
	for _,v in ipairs(ln) do
		s = s..v
	end
	print(s)
end

function multiply(order, perm, by)
	-- naively multiplies
	local norder = {}
	local nperm = {}

	for i = 1,sz do
		norder[i] = i
		nperm[string.char(96 + i)] = string.char(96 + i)
	end
	
	for _=1,by do
		local nnorder = {}
		for i=1,sz do
			nnorder[i] = order[norder[i]]
		end
		norder = nnorder
		
		local nnperm = {}
		for k,v in pairs(nperm) do
			nnperm[k] = perm[v]
		end
		nperm = nnperm
	end
	
	return norder, nperm
end

function apply(order, perm, line)
	local nline = {}
	for k,v in pairs(order) do nline[k] = perm[line[order[k]]] end
	
	return nline
end

pr(apply(order, permtab, line))

if arg[3] then
	for i=1,count do
		line = apply(order, permtab, line)
		
		if i == 1 then pr(line) end
		if i % 100000 == 0 then print(i) end
	end
else
	MULFACTOR = 10000
	
	morder, mperm = multiply(order, permtab, MULFACTOR)
	
	for i=1,(count/MULFACTOR) do
		line = apply(morder, mperm, line)
		if (i * MULFACTOR) % 10000000 == 0 then print(i * MULFACTOR) end
	end
	
end
pr(line)
