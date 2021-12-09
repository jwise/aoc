map = {}
while true do
	line = io.read("*line")
	if not line then break end
	row = {}
	for c in line:gmatch(".") do
		table.insert(row, tonumber(c))
	end
	table.insert(map, row)
end

sum = 0
for y,r in ipairs(map) do
	for x,pt in ipairs(r) do
		if ((not map[y-1]) or (map[y-1][x] > pt)) and
		   ((not map[y+1]) or (map[y+1][x] > pt)) and
		   ((not map[y][x-1]) or (map[y][x-1] > pt)) and
		   ((not map[y][x+1]) or (map[y][x+1] > pt)) then
			sum = sum + pt + 1
		end
	end
end
print(sum)
