line = io.read("*line")
xmin,xmax,ymin,ymax = line:match("target area: x=(%d+)..(%d+), y=(-%d+)..(-%d+)")
xmin = tonumber(xmin)
xmax = tonumber(xmax)
ymin = tonumber(ymin)
ymax = tonumber(ymax)

function xsim(dx) -- returns a STEP COUNT if the projectile passes through the x range
	local x = 0
	local steps = 0
	local minsteps,maxsteps = nil,nil
	while x <= xmax do
		if x >= xmin and not minsteps then minsteps = steps end
		maxsteps = steps
		x = x + dx
		if dx == 0 then maxsteps = math.huge break end
		dx = dx - 1
		steps = steps + 1
	end
	return minsteps,(minsteps and maxsteps or nil)
end

function ysim(dy,mins,maxs) -- returns PEAK Y if the projectile passes through the y range at step range
	local y = 0
	local steps = 0
	local peaky = 0
	local didintercept = false
	while steps <= maxs and y >= ymin do
		if steps >= mins and y >= ymin and y <= ymax then didintercept = true end
		if y > peaky then peaky = y end
		y = y + dy
		dy = dy - 1
		steps = steps + 1
	end
	return didintercept and peaky or nil
end

local peaky = 0
local npos = 0
for dx=1,285 do
	print(dx)
	local mins,maxs = xsim(dx)
	if mins then
		print(dx,mins,maxs)
		for dy=-85,85 do
			local yres = ysim(dy,mins,maxs)
			if yres then
				print(dx,dy,mins,maxs)
				if yres > peaky then peaky = yres end
				npos = npos + 1
			end
		end
	end
end
print(peaky,npos)
