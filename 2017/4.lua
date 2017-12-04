#!/usr/bin/env lua

function anacrack(str)
	cs = {}
	
	for i in str:gmatch("%S") do
		if not cs[i] then cs[i] = 0 end
		cs[i] = cs[i] + 1
	end
	
	return cs
end

function eq(a, b)
	na = 0
	nb = 0
	
	for k,v in pairs(a) do
		if b[k] ~= v then return false end
		na = na + 1
	end
	for k,v in pairs(b) do nb = nb + 1 end
	if na ~= nb then return false end
	
	return true
end

inps = {}
while true do
	l = io.read("*line")
	if not l then break end
	
	inp = {}
	for i in l:gmatch("%S+") do table.insert(inp, { val = i, ana = anacrack(i) }) end
	
	table.insert(inps, inp)
end

valids1 = 0
valids2 = 0

for _,inp in ipairs(inps) do
	valid1 = true
	valid2 = true
	for k1,v1 in ipairs(inp) do
		for k2, v2 in ipairs(inp) do
			if k1 ~= k2 and v1.val == v2.val then
				valid1 = false
			end
			if k1 ~= k2 and eq(v1.ana, v2.ana) then
				valid2 = false
			end
		end
	end
	if valid1 then valids1 = valids1 + 1 end
	if valid2 then valids2 = valids2 + 1 end
end

print(valids1)
print(valids2)