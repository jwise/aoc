coordinace = {}
while true do
	l = io.read("*line")
	if not l then break end
	
	x,y = l:match("(%d+), (%d+)")
	x = tonumber(x)
	y = tonumber(y)
	
	table.insert(coordinace, {x = x, y = y})
end

bbox = {x0 = 1000, y0 = 1000, x1 = 0, y1 = 0}
for k,v in ipairs(coordinace) do
	if v.x < bbox.x0 then bbox.x0 = v.x end
	if v.y < bbox.y0 then bbox.y0 = v.y end
	if v.x > bbox.x1 then bbox.x1 = v.x end
	if v.y > bbox.y1 then bbox.y1 = v.y end
end

-- infinite?
for k,v in ipairs(coordinace) do
	if v.x == bbox.x0 or v.x == bbox.x1 or v.y == bbox.y0 or v.y == bbox.y1 then
		v.infinite = true
	end
end

function manhattan(pt,x,y)
	return math.abs(pt.x-x) + math.abs(pt.y-y)
end

-- now set up a grid...
rgnsz = 0
for y=bbox.y0,bbox.y1 do
	row = {}
	for x = bbox.x0,bbox.x1 do
		tdist = 0
		for k,pt in ipairs(coordinace) do
			tdist = tdist + manhattan(pt,x,y)
		end
		if tdist < 10000 then rgnsz = rgnsz + 1 end
	end
end
print(rgnsz)
