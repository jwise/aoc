function isalpha(c)
	return c and c:byte(1) >= 65 and c:byte(1) <= 90
end

function ismap(c)
	return c and (c == "#" or c == ".")
end

map = {}
while true do
	local line = io.read("*line")
	if not line then break end
	local r = {}
	for c in line:gmatch(".") do
		table.insert(r, c)
	end
	table.insert(map, r)
end

portals = {}

for y,r in ipairs(map) do
	for x,c in ipairs(r) do
		if (c == "Z") then print(y,x) end
		if isalpha(c) then
			if isalpha(map[y][x]) and map[y-1] and isalpha(map[y-1][x]) and map[y+1] and ismap(map[y+1][x]) then
				local portal = map[y-1][x] .. map[y][x]
				portals[portal] = portals[portal] or {}
				table.insert(portals[portal], { y = y+1, x = x })
			end
			if isalpha(map[y][x]) and map[y-1] and isalpha(map[y-1][x]) and map[y-2] and ismap(map[y-2][x]) then
				local portal = map[y-1][x] .. map[y][x]
				portals[portal] = portals[portal] or {}
				table.insert(portals[portal], { y = y-2, x = x })
			end
			if isalpha(map[y][x]) and isalpha(map[y][x-1]) and ismap(map[y][x+1]) then
				local portal = map[y][x-1] .. map[y][x]
				portals[portal] = portals[portal] or {}
				table.insert(portals[portal], { y = y, x = x+1 })
			end
			if isalpha(map[y][x]) and isalpha(map[y][x-1]) and ismap(map[y][x-2]) then
				local portal = map[y][x-1] .. map[y][x]
				portals[portal] = portals[portal] or {}
				table.insert(portals[portal], { y = y, x = x-2 })
			end
		end
	end
end

for k,v in pairs(portals) do
	if #v == 2 then
		local p0,p1 = v[1],v[2]
		map[p0.y][p0.x] = { x = p1.x, y = p1.y, p = k }
		map[p1.y][p1.x] = { x = p0.x, y = p0.y, p = k }
	end
end

function set(a,y,x,v) if not a[y] then a[y] = {} end a[y][x] = v end
function get(a,y,x  ) if not a[y] then a[y] = {} end return a[y][x] end

visited = {}

function dfs(y,x,dist)
	if not map[y] then return end
	print(y,x,dist,map[y][x])
	if map[y][x] ~= "." and type(map[y][x]) ~= "table" then return end
	if get(visited,y,x) and get(visited,y,x) <= dist then return end
	set(visited,y,x,dist)
	
	if type(map[y][x]) == "table" then
		print("PORTAL "..map[y][x].p,dist,x,y,map[y][x].x,map[y][x].y)
		dfs(map[y][x].y, map[y][x].x, dist+1)
	end
	dfs(y+1, x  , dist+1)
	dfs(y-1, x  , dist+1)
	dfs(y  , x+1, dist+1)
	dfs(y  , x-1, dist+1)
end
dfs(portals["AA"][1].y,portals["AA"][1].x,0)
print(get(visited, portals["ZZ"][1].y, portals["ZZ"][1].x))