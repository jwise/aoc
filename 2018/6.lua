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
bbox.x0 = bbox.x0 - 1
bbox.x1 = bbox.x1 + 1
bbox.y0 = bbox.y0 - 1
bbox.y1 = bbox.y1 + 1
grid = {}
for y=bbox.y0,bbox.y1 do
	row = {}
	grid[y] = row
	for x = bbox.x0,bbox.x1 do
		row[x] = {dist=100000, owner = nil}
	end
end
print(bbox.x0,bbox.x1,bbox.y0,bbox.y1)

-- now run them all...
for k,pt in ipairs(coordinace) do
	print(k)
	for y = bbox.y0,bbox.y1 do
		row = grid[y]
		for x = bbox.x0,bbox.x1 do
			dist = manhattan(pt,y,x)
			if row[x].dist == dist then
				row[x].owner = nil -- multiple
			elseif row[x].dist > dist then
				row[x].dist = dist
				row[x].owner = k
			end
		end
	end
end

coordinace[""] = {}

for y=bbox.y0,bbox.y0 do
	row = grid[y]
	for x = bbox.x0,bbox.x1 do
		coordinace[row[x].owner or ""].infinite = true
	end
end
for y=bbox.y1,bbox.y1 do
	row = grid[y]
	for x = bbox.x0,bbox.x1 do
		coordinace[row[x].owner or ""].infinite = true
	end
end
for y=bbox.y0,bbox.y1 do
	row = grid[y]
	for x = bbox.x0,bbox.x0 do
		coordinace[row[x].owner or ""].infinite = true
	end
end
for y=bbox.y1,bbox.y1 do
	row = grid[y]
	for x = bbox.x1,bbox.x1 do
		coordinace[row[x].owner or ""].infinite = true
	end
end


bbox.x0 = bbox.x0 + 1
bbox.x1 = bbox.x1 - 1
bbox.y0 = bbox.y0 + 1
bbox.y1 = bbox.y1 - 1


-- now add them up ...
for y=bbox.y0,bbox.y1 do
	row = grid[y]
	for x = bbox.x0,bbox.x1 do
		owner = row[x].owner
		if owner then
			coordinace[owner].n = (coordinace[owner].n or 0) + 1
		end
	end
end

maxn = 0
for k,p in ipairs(coordinace) do
	p.n = p.n or 0
	print(k,p.n,p.infinite)
	if p.n > maxn and not p.infinite then
		maxn = p.n
	end
end
print(maxn)