tbl = {}

while true do
	l = io.read("*line")
	if not l then break end

	n,x0,y0,xs,ys = l:match("#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")
	n = tonumber(n)
	x0 = tonumber(x0)
	y0 = tonumber(y0)
	xs = tonumber(xs)
	ys = tonumber(ys)
	
	for y = y0,(y0+ys-1) do
		tbl[y] = tbl[y] or {}
		for x = x0,x0+xs-1 do
			tbl[y][x] = (tbl[y][x] or {})
			table.insert(tbl[y][x], n)
		end
	end
end

ndup = 0
for y,row in pairs(tbl) do
	for x,val in pairs(row) do
		if #val > 1 then
			ndup = ndup + 1
		end
	end
end

print(ndup)