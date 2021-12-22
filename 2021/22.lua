g = {}
MIN=-50
MAX=50

while true do
	line = io.read("*line")
	if not line then break end
	local c,x0,x1,y0,y1,z0,z1 = line:match("(%S+) x=(-?%d+)..(-?%d+),y=(-?%d+)..(-?%d+),z=(-?%d+)..(-?%d+)")
	x0 = tonumber(x0)
	x1 = tonumber(x1)
	y0 = tonumber(y0)
	y1 = tonumber(y1)
	z0 = tonumber(z0)
	z1 = tonumber(z1)
	for z=math.max(MIN,z0),math.min(MAX,z1) do
		for y=math.max(MIN,y0),math.min(MAX,y1) do
			for x=math.max(MIN,x0),math.min(MAX,x1) do
				g[z] = g[z] or {}
				g[z][y] = g[z][y] or {}
				g[z][y][x] = c == "on"
			end
		end
	end
end

local count = 0
for _,zr in pairs(g) do
	for _,yr in pairs(zr) do
		for  _,xr in pairs(yr) do
			if xr then count = count + 1 end
		end
	end
end
print(count)
