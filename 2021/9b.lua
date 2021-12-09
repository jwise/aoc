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

basins = {}
inbasin = {}
function flood(basin,y,x)
	if inbasin[y] and inbasin[y][x] then return end
	inbasin[y] = inbasin[y] or {}
	inbasin[y][x] = true

	basins[basin] = basins[basin] + 1
	local val = map[y][x]
	if map[y-1] and map[y-1][x] > val and map[y-1][x] ~= 9 then flood(basin,y-1,x) end
	if map[y+1] and map[y+1][x] > val and map[y+1][x] ~= 9 then flood(basin,y+1,x) end
	if map[y][x-1] and map[y][x-1] > val and map[y][x-1] ~= 9  then flood(basin,y,x-1) end
	if map[y][x+1] and map[y][x+1] > val and map[y][x+1] ~= 9 then flood(basin,y,x+1) end
end

for y,r in ipairs(map) do
	for x,pt in ipairs(r) do
		if ((not map[y-1]) or (map[y-1][x] > pt)) and
		   ((not map[y+1]) or (map[y+1][x] > pt)) and
		   ((not map[y][x-1]) or (map[y][x-1] > pt)) and
		   ((not map[y][x+1]) or (map[y][x+1] > pt)) then
		   	table.insert(basins, 0)
		   	flood(#basins,y,x)
		end
	end
end
table.sort(basins)
print(basins[#basins] * basins[#basins-1] * basins[#basins-2])
