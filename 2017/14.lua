#!/usr/bin/env lua5.3


function knothash(str)
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
for i in str:gmatch(".") do
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
	table.insert(dens, xorv)
end

return dens

end


local xpop = 0
local key = io.read("*line")
local arr = {}
function popcnt(hash,into)
	local pop = 0
	for k0,v in ipairs(hash) do
		for i=0,7 do
			if v & (1 << i) ~= 0 then
				pop = pop + 1
				into[(k0-1)*8 + 7-i] = true
			end
		end
	end
	return pop
end

for k=0,127 do
	local hashk = key .. "-" .. k
	arr[k] = {}
	local popc = popcnt(knothash(hashk), arr[k])
	print(hashk,popc)
	xpop = xpop+popc
end
print(xpop)

function floodfill(y,x)
	if not arr[y][x] then return false end
	arr[y][x] = nil
	if arr[y  ][x+1] then floodfill(y, x+1) end
	if arr[y  ][x-1] then floodfill(y, x-1) end
	if arr[y+1] and arr[y+1][x  ] then floodfill(y+1, x) end
	if arr[y-1] and arr[y-1][x  ] then floodfill(y-1, x) end
	return true
end

regions = 0
for yy=0,127 do
	for xx=0,127 do
		if floodfill(yy,xx) then regions = regions + 1 end
	end
end
print(regions)