pts = {}

NITER = tonumber(arg[1]) or 1000000

while true do
	l = io.read("*line")
	if not l then break end
	
	x0,y0,dx,dy = l:match("position=<%s*([%-0123456789]+),%s*([%-0123456789]+)> velocity=<%s*([%-0123456789]+),%s*([%-0123456789]+)>")
	x0 = tonumber(x0)
	y0 = tonumber(y0)
	dx = tonumber(dx)
	dy = tonumber(dy)
	
	pt = {}
	pt.x = x0
	pt.y = y0
	pt.dx = dx
	pt.dy = dy
	
	table.insert(pts, pt)
end

function mkbbox()
	local bb = {x0 = 999999, y0 = 999999, x1 = -999999, y1 = -999999}
	for k,v in ipairs(pts) do
		if v.x < bb.x0 then bb.x0 = v.x end
		if v.x > bb.x1 then bb.x1 = v.x end
		if v.y < bb.y0 then bb.y0 = v.y end
		if v.y > bb.y1 then bb.y1 = v.y end
	end
	bb.sz = bb.x1 - bb.x0 + bb.y1 - bb.y0
	return bb
end

lastsz = 9999999
for i = 1,NITER do
	for k,v in ipairs(pts) do
		v.x = v.x + v.dx
		v.y = v.y + v.dy
	end
	bb = mkbbox()
	print(i, bb.sz)
	if bb.sz > lastsz then
		break
	end
	lastsz = bb.sz
end

bmp = {}
for y=1,bb.y1-bb.y0+1 do
	bmp[y] = {}
	for x=1,bb.x1-bb.x0+1 do
		bmp[y][x] = " "
	end
end

for k,v in ipairs(pts) do
	bmp[v.y-bb.y0+1][v.x-bb.x0+1] = "X"
end

for y=1,bb.y1-bb.y0+1 do
	s = ""
	for x=1,bb.x1-bb.x0+1 do
		s = s .. bmp[y][x]
	end
	print(s)
end
