objs = {}

while true do
	line = io.read("*line")
	if not line then break end
	
	inner,outer = line:match("([A-Z0-9]+)%)([A-Z0-9]+)")
	print(inner,outer)
	
	if not objs[inner] then
		objs[inner] = { children = {} }
	end
	if not objs[outer] then
		objs[outer] = { children = {} }
	end
	
	table.insert(objs[inner].children, outer)
	objs[outer].parent = inner
end

function dist(obj)
	-- walk the children, then the parent, as long as we haven't touched one already
	local min = 99999
	local xobj = objs[obj]
	
	if xobj.touched then return 99999 end
	
	print(obj,xobj)
	xobj.touched = true
	
	for _,objn in pairs(xobj.children) do
		local xobjn = objs[objn]
		if objn == "SAN" then return 1 end
		if not xobjn.touched then
			local ndist = dist(objn) + 1
			if ndist < min then
				min = ndist
				print("new best from ",obj,"via",objn,ndist)
			end
		end
	end
	
	if xobj.parent and not xobj.parent.touched then
		local ndist = dist(xobj.parent) + 1
		if ndist < min then
			min = ndist
		end
	end
	
	return min
end

print(dist("YOU")-2)
