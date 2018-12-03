tbl = {}
cls = {}

while true do
	l = io.read("*line")
	if not l then break end

	cl = {}

	n,x0,y0,xs,ys = l:match("#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")
	n = tonumber(n)
	cl.x0 = tonumber(x0)
	cl.y0 = tonumber(y0)
	cl.xs = tonumber(xs)
	cl.ys = tonumber(ys)
	x0 = cl.x0
	y0 = cl.y0
	xs = cl.xs
	ys = cl.ys
	cls[n] = cl
	
	for y = y0,(y0+ys-1) do
		tbl[y] = tbl[y] or {}
		for x = x0,x0+xs-1 do
			tbl[y][x] = (tbl[y][x] or {})
			table.insert(tbl[y][x], n)
		end
	end
end

ndup = 0
for n,cl in pairs(cls) do
	x0 = cl.x0
	y0 = cl.y0
	xs = cl.xs
	ys = cl.ys
	
	bad = false
	for y = y0,(y0+ys-1) do
		for x = x0,x0+xs-1 do
			if not tbl[y] then print(y,x) end
			if #(tbl[y][x]) > 1 then bad = true end
		end
	end
	
	if not bad then print(n) end
end
