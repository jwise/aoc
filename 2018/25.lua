consts = {}

function manhat(pt1, pt2)
	return math.abs(pt1.x-pt2.x) +
	       math.abs(pt1.y-pt2.y) +
	       math.abs(pt1.z-pt2.z) +
	       math.abs(pt1.w-pt2.w) 
end

function adj(pt1, pt2)
	return manhat(pt1, pt2) <= 3
end

function inconst(pt, c)
	for _,pt2 in ipairs(c) do
		if adj(pt, pt2) then return true end
	end
	return false
end

while true do
	l = io.read("*line")
	if not l then break end
	x,y,z,w = l:match("%s*(-?%d+),(-?%d+),(-?%d+),(-?%d+)")
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	w = tonumber(w)
	
	local pt = { x = x, y = y, z = z, w = w, const = nil }
	
	for _,c in ipairs(consts) do
		if not c.eaten and inconst(pt, c) then
			if pt.const == nil then
				table.insert(c, pt)
				pt.const = c
			else
				-- merge
				c.eaten = true
				for _,pt2 in ipairs(c) do
					table.insert(pt.const, pt2)
				end
			end
		end
	end
	
	if not pt.const then
		local nc = {}
		table.insert(nc, pt)
		table.insert(consts, nc)
	end
end

nconsts = 0
for _,c in ipairs(consts) do
	if not c.eaten then nconsts = nconsts + 1 end
end

print(nconsts)