map = {}
vis = {}
tdist = {}

while true do
	line = io.read("*line")
	if not line or line == "" then break end
	mrow = {}
	vrow = {}
	trow = {}
	for c in line:gmatch(".") do
		table.insert(mrow, {wt = tonumber(c)})
--		table.insert(vrow, false)
		table.insert(trow, math.huge)
	end
	table.insert(map, mrow)
	table.insert(vis, vrow)
	table.insert(tdist, trow)
end

maxx = #(map[1])
maxy = #map
unvis = {}
nunvis = 0

function wt(x,y)
	local tx = (x - 1) // (maxx - 1)
	local ty = (y - 1) // (maxy - 1)
	local rl = map[(y - 1) % (maxy - 1) + 1][(x - 1) % (maxx - 1) + 1]
	local xwt = (rl + tx + ty - 1) % 9 + 1
end

function visit(x,y)
	function try(x0,y0)
		if vis[y0][x0] then return end
		local ndist = tdist[y][x] + map[y0][x0].wt
		if ndist < tdist[y0][x0] then tdist[y0][x0] = ndist end
		if not unvis[map[y0][x0]] then
			unvis[map[y0][x0]] = true
			nunvis = nunvis + 1
		end
		map[y0][x0].y = y0
		map[y0][x0].x = x0
	end
	if y > 1    then try(x,y-1) end
	if y < maxy then try(x,y+1) end
	if x > 1    then try(x-1,y) end
	if x < maxx then try(x+1, y) end
	vis[y][x] = true
end

tdist[1][1] = 0
unvis[map[1][1]] = true
map[1][1].y = 1
map[1][1].x = 1
nunvis = nunvis + 1

while nunvis > 0 do
	local unvist = {}
	for k,v in pairs(unvis) do
		if v then table.insert(unvist, k) end
	end
	table.sort(unvist, function (a, b) return tdist[a.y][a.x] < tdist[b.y][b.x] end)
	local cur = unvist[1]
	visit(cur.x, cur.y)
	unvis[cur] = nil
	nunvis = nunvis - 1
end
print(tdist[maxy][maxx])
