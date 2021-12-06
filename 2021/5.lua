lines = {}
map = {}

function incr(x,y)
	map[y] = map[y] or {}
	map[y][x] = map[y][x] or 0
	map[y][x] = map[y][x] + 1
end

while true do
	line = io.read("*line")
	if not line then break end
	x1,y1,x2,y2 = line:match("(%d+),(%d+) .. (%d+),(%d+)")
	x1 = tonumber(x1)
	y1 = tonumber(y1)
	x2 = tonumber(x2)
	y2 = tonumber(y2)
	if (x1 == x2) or (y1 == y2) then
		table.insert(lines, {x1,y1,x2,y2})
		if x1 == x2 then
			x = x1
			if y2 < y1 then y1,y2=y2,y1 end
			for y=y1,y2 do
				incr(x,y)
			end
		elseif y1 == y2 then
			y = y1
			if x2 < x1 then x1,x2=x2,x1 end
			for x=x1,x2 do
				incr(x,y)
			end
		end
	end
end

n=0
for y,row in pairs(map) do
	for x,count in pairs(row) do
		if count > 1 then n = n + 1 end
	end
end

print(n)
