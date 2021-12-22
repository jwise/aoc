-- ok I'm not going to do a kd tree, what I'm going to do is crack boxes apart
boxes = {}
-- a box is {x={0,1},y={0,1},z={0,1}}

function intersects(box1,box2)	-- returns the intersection of box1 and box2
	function intax(ax1, ax2)
		return ax1[2] >= ax2[1] and ax2[2] >= ax1[1],
		       { math.max(ax1[1], ax2[1]),
		         math.min(ax2[2], ax1[2]) }
	end
	local xi, xint = intax(box1.x, box2.x)
	local yi, yint = intax(box1.y, box2.y)
	local zi, zint = intax(box1.z, box2.z)
	
	return xi and yi and zi and { x = xint, y = yint, z = zint }
end

function subtr(box1, intbox, blist) -- returns a list of boxes into blist, assuming box1 and box2 intersect
	-- subdivide by x
	local rembox = {}
	if box1.x[1] < intbox.x[1] then
		table.insert(blist, { x = { box1.x[1], intbox.x[1] - 1 }, y = box1.y, z = box1.z })
	end
	rembox.x = { intbox.x[1], intbox.x[2] }
	if box1.x[2] > intbox.x[2] then
		table.insert(blist, { x = { intbox.x[2] + 1, box1.x[2] }, y = box1.y, z = box1.z })
	end
	
	-- subdivide by y
	if box1.y[1] < intbox.y[1] then
		table.insert(blist, { x = rembox.x, y = { box1.y[1], intbox.y[1] - 1 }, z = box1.z })
	end
	rembox.y = { intbox.y[1], intbox.y[2] }
	if box1.y[2] > intbox.y[2] then
		table.insert(blist, { x = rembox.x, y = { intbox.y[2] + 1, box1.y[2] }, z = box1.z })
	end

	-- subdivide by y
	if box1.z[1] < intbox.z[1] then
		table.insert(blist, { x = rembox.x, y = rembox.y, z = { box1.z[1], intbox.z[1] - 1 } })
	end
	-- lol, rembox == intbox now!!  I guess it wsa the whole time.
	rembox.z = { intbox.z[1], intbox.z[2] }
	if box1.z[2] > intbox.z[2] then
		table.insert(blist, { x = rembox.x, y = rembox.y, z = { intbox.z[2] + 1, box1.z[2] } })
	end
end

g = {}
--MIN=-50
--MAX=50
MIN,MAX=-math.huge,math.huge

function pb(box)
	return string.format("x=%d..%d,y=%d..%d,z=%d..%d", box.x[1], box.x[2], box.y[1], box.y[2], box.z[1], box.z[2])
end

function clampnum(n)
	return math.min(MAX,math.max(MIN,tonumber(n)))
end

while true do
	line = io.read("*line")
	if not line then break end
	local on,x0,x1,y0,y1,z0,z1 = line:match("(%S+) x=(-?%d+)..(-?%d+),y=(-?%d+)..(-?%d+),z=(-?%d+)..(-?%d+)")
	x0 = clampnum(x0)
	x1 = clampnum(x1)
	y0 = clampnum(y0)
	y1 = clampnum(y1)
	z0 = clampnum(z0)
	z1 = clampnum(z1)
	
	local nboxes = {}
	local nbox = { x = {x0, x1}, y = {y0, y1}, z = {z0, z1} }
	for _,box in ipairs(boxes) do
		local int = intersects(nbox, box)
		if not int then
			table.insert(nboxes, box)
		else
			subtr(box, int, nboxes)
		end
	end
	if on == "on" then
		table.insert(nboxes, nbox)
	end
	boxes = nboxes
end

local count = 0
for _,box in pairs(boxes) do
	count = count + (box.x[2] - box.x[1] + 1) * (box.y[2] - box.y[1] + 1) * (box.z[2] - box.z[1] + 1)
end
print(count)
