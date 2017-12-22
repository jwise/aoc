#!/usr/bin/env lua

xmap = {}
while true do
	local l = io.read("*line")
	if not l then break end
	
	local xmapr = {}
	for px in l:gmatch(".") do
		table.insert(xmapr, px == "#")
	end
	table.insert(xmap, xmapr)
end

map = {}
function put(y,x,val)
	if not map[y] then map[y] = {} end
	map[y][x] = val
end
function get(y,x)
	if not map[y] then map[y] = {} end
	return map[y][x]
end

for y,row in ipairs(xmap) do
	local yp = y - ((#xmap + 1) / 2)
	for x,val in ipairs(row) do
		local xp = x - ((#row + 1) / 2)
		put(yp, xp, val)
	end
end

dir_U = { y = -1, x = 0 }
dir_L = { y = 0, x = -1 }
dir_D = { y = 1, x = 0 }
dir_R = { y = 0, x = 1 }
dir_U.L, dir_U.R = dir_L, dir_R
dir_L.L, dir_L.R = dir_D, dir_U
dir_D.L, dir_D.R = dir_R, dir_L
dir_R.L, dir_R.R = dir_U, dir_D

dir = dir_U
pos = { y = 0, x = 0 }
causeinf = 0

for bursts = 1,10000 do
	if get(pos.y, pos.x) then
		dir = dir.R
		put(pos.y, pos.x, false)
	else
		dir = dir.L
		put(pos.y, pos.x, true)
		causeinf = causeinf + 1
	end
	
	pos.y = pos.y + dir.y
	pos.x = pos.x + dir.x
end
print(causeinf)