grid = {}
maxx = 0
maxy = 0

while true do
	line = io.read("*line")
	if not line or line == "" then break end
	x,y = line:match("(%d+),(%d+)")
	x = tonumber(x)
	y = tonumber(y)
	if x > maxx then maxx = x end
	if y > maxy then maxy = y end
	grid[y] = grid[y] or {}
	grid[y][x] = true
end

while true do
	line = io.read("*line")
	if not line then break end
	ax,coord = line:match("fold along (.)=(%d+)")
	coord = tonumber(coord)
	
	-- only have to implement x for now
	if ax == 'y' then LOL() end
	for x=coord+1,maxx do
		for y=0,maxy do
			if grid[y] and grid[y][x] then
				grid[y][x] = false
				grid[y][coord - (x-coord)] = true
			end
		end
	end
	
	break -- just one!!
end

dots = 0
for y=0,maxy do
	for x=0,maxx do
		if grid[y] and grid[y][x] then dots = dots + 1 end
	end
end
print(dots)