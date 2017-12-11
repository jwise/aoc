#!/usr/bin/env lua

x = 0
y = 0

mstep = 0

function steps()
	ax = math.abs(x)
	ay = math.abs(y)
	
	ystep = (ay - ax) / 2
	return ystep + ax
end

function msup()
	if steps() > mstep then mstep = steps() end
end

l = io.read("*line")
for i in l:gmatch("%a+") do
	    if i == "n" then y = y - 2
	elseif i == "nw" then y = y - 1 x = x - 1
	elseif i == "ne" then y = y - 1 x = x + 1
	elseif i == "s" then y = y + 2
	elseif i == "sw" then y = y + 1 x = x - 1
	elseif i == "se" then y = y + 1 x = x + 1
	end
	msup()
end

print(x,y)

print(steps())

print(mstep)
