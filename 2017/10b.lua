#!/usr/bin/env lua5.3

LEN=256

elts = {}
for i=0,(LEN-1) do elts[i] = i end

pos = 0
skips = 0

function mangle(num)
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
end

seq = {}
l = io.read("*line")
for i in l:gmatch(".") do
	table.insert(seq, i:byte())	
end
table.insert(seq, 17)
table.insert(seq, 31)
table.insert(seq, 73)
table.insert(seq, 47)
table.insert(seq, 23)

for i=0,63 do
	for k,v in ipairs(seq) do
		mangle(v)
	end
end

dens = {}
denss = ""
for i=0,15 do
	xorv = 0
	for j = 0,15 do
		xorv = xorv ~ elts[i * 16 + j]
	end
	denss = denss .. string.format("%02x", xorv)
end

print(denss)
