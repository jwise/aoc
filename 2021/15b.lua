map = {}
dups=5

-- THIS ONE IS THE DIJKSTRA'S ONE IF YOU'RE LOOKING TO GREP NEXT YEAR, DUDE

while true do
	line = io.read("*line")
	if not line or line == "" then break end
	mrow = {}
	for c in line:gmatch(".") do
		table.insert(mrow, {wt = tonumber(c), td = math.huge, vis = false})
	end
	table.insert(map, mrow)
end

maxx = #(map[1])
maxy = #map
unvist = {}

for y=1,maxy*5 do
	if not map[y] then map[y] = {} end
	for x=1,maxy*5 do
		if not map[y][x] then
			local tx = math.floor((x - 1) / (maxx))
			local ty = math.floor((y - 1) / (maxy))
			local rl = map[(y - 1) % (maxy) + 1][(x - 1) % (maxx) + 1].wt
			local xwt = (rl + tx + ty - 1) % 9 + 1
			map[y][x] = {wt = xwt, td = math.huge, vis = false}
		end
		map[y][x].y = y
		map[y][x].x = x
	end
end

function visit(x,y)
	function try(x0,y0)
		if map[y0][x0].vis then return end
		local ndist = map[y][x].td + map[y0][x0].wt
		if ndist < map[y0][x0].td then map[y0][x0].td = ndist end
		if not map[y0][x0].unvist then
			for i=1,#unvist+1 do
				if not unvist[i] or unvist[i].td > map[y0][x0].td then table.insert(unvist, i, map[y0][x0]) break end
			end
			map[y0][x0].unvist = true
		end
	end
	if y > 1        then try(x,y-1) end
	if y < maxy * 5 then try(x,y+1) end
	if x > 1        then try(x-1,y) end
	if x < maxx * 5 then try(x+1, y) end
	map[y][x].vis = true
end

map[1][1].td = 0
table.insert(unvist, map[1][1])

tgtx,tgty = maxx*dups,maxy*dups
cmaxy = 0

local nvis = 0
local lastclk = 0
while #unvist > 0 do
--	table.sort(unvist, function (a, b) return a.td < b.td end)
	local cur = unvist[1]
	table.remove(unvist, 1)
	visit(cur.x, cur.y)
	nvis = nvis + 1
	if cur.x == tgtx and cur.y == tgty then break end
	if (nvis % 10000) == 0 then print(cur.x, cur.y, #unvist, nvis, os.clock() - lastclk) lastclk = os.clock() end
end
print("100%",#unvist,nvis)
print(map[tgty][tgtx].td)
