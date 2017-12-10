#!/usr/bin/env lua

LEN=256

elts = {}
for i=0,(LEN-1) do elts[i] = i end

pos = 0
skips = 0

l = io.read("*line")
for i in l:gmatch("%d+") do
	num = tonumber(i)
	
	startp = pos
	endp = startp + num - 1
	
	orig = {}
	for pp=startp,endp do
		table.insert(orig, elts[pp % LEN])
	end
	origp = num
	for pp=startp,endp do
		elts[pp % LEN] = orig[origp]
		origp = origp - 1
	end
	
	pos = pos + num + skips
	
	skips = skips + 1
	
--	print("num ",num,"skips",skips,"pos",pos)
--	print("list")
--	for i=0,(LEN-1) do
--		print("",elts[i])
--	end
end

print(elts[0] * elts[1])