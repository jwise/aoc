SERIAL = tonumber(arg[1]) or 8

function power(x, y)
	local rackid = x + 10
	local power = rackid * y
	power = power + SERIAL
	power = power * rackid
	power = power % 1000
	power = math.floor(power / 100)
	power = power - 5
	
	return power
end

max = 0
maxcoord = {}
for sz=1,30 do
	print(sz)
	for x=1,299-sz do
		for y=1,299-sz do
			local tpower = 0
			for xp=0,sz-1 do
				for yp=0,sz-1 do
					tpower = tpower + power(x+xp,y+yp)
				end
			end
			if tpower > max then
				max = tpower
				maxcoord.x = x
				maxcoord.y = y
				maxcoord.sz = sz
			end
		end
	end
	if sz == 3 then print(max,maxcoord.x,maxcoord.y,maxcoord.sz) end
end

print(max,maxcoord.x,maxcoord.y,maxcoord.sz)
