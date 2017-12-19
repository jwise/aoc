#!/usr/bin/env lua

diag = {}
while true do
	row = {}
	l = io.read("*line")
	if not l then break end
	
	for i in l:gmatch(".") do
		table.insert(row, i)
	end
	
	table.insert(diag, row)
end

-- find the start
y = 1
x = nil
for k,v in ipairs(diag[1]) do
	if v ~= " " then
		x = k
	end
end

print(x,y)

function pos(y,x)
	if not diag[y] then return " " end
	return diag[y][x] or " "
end

dir = { x = 0, y = 1 }
str = ""
steps = 0
while diag[y][x] ~= " " do
	if diag[y][x] == "+" then
		-- find a new direction that's not the same as the current one
		function try(dy, dx)
			if pos(y+dy,x+dx) ~= " " and dir.y ~= -dy and dir.x ~= -dx then
				dir.x = dx
				dir.y = dy
				print("change",x, y, dir.x, dir.y)
				return true
			end
		end
		found = try(0, 1) or try(0, -1) or try(1, 0) or try(-1, 0)
		if not found then print("anus?") end
	elseif pos(y,x) == "|" or pos(y,x) == "-" then
	else
		str = str .. pos(y,x)
	end
	x = x + dir.x
	y = y + dir.y
	steps = steps + 1
end

print(str,steps)
