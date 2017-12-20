#!/usr/bin/env lua5.3

parts = {}
pn = 0
while true do
	local l = io.read("*line")
	if not l then break end
	
	part = {}
	part.p = {}
	part.v = {}
	part.a = {}
	
	local px,py,pz,vx,vy,vz,ax,ay,az =
		l:match("p=<([^,]+),([^,]+),([^>]+)>, v=<([^,]+),([^,]+),([^>]+)>, a=<([^,]+),([^,]+),([^>]+)>")
	
	if not ax then print(l) end
	
	part.p.x = tonumber(px)
	part.p.y = tonumber(py)
	part.p.z = tonumber(pz)
	part.v.x = tonumber(vx)
	part.v.y = tonumber(vy)
	part.v.z = tonumber(vz)
	part.a.x = tonumber(ax)
	part.a.y = tonumber(ay)
	part.a.z = tonumber(az)

	parts[pn] = part
	pn = pn + 1
end

smallan,smalla = nil,nil
for k,v in pairs(parts) do
	t = 1000000
	local a = math.abs(.5 * v.a.x * t * t + v.v.x * t + v.p.x) +
	          math.abs(.5 * v.a.y * t * t + v.v.y * t + v.p.y) +
	          math.abs(.5 * v.a.z * t * t + v.v.z * t + v.p.z)
	
	if not smallan or a < smalla then
		smallan = k
		smalla = a
	end
end

print(smallan,smalla)

-- now evaluate and collide them.  ugh.
nrem = pn
for t = 0,50 do
	for k,v in pairs(parts) do
		v.v.x = v.v.x + v.a.x
		v.v.y = v.v.y + v.a.y
		v.v.z = v.v.z + v.a.z
		
		v.p.x = v.p.x + v.v.x
		v.p.y = v.p.y + v.v.y
		v.p.z = v.p.z + v.v.z
	end
	
	for k1=0,pn-1 do
		v1 = parts[k1]
		if v1 then
			for k2=k1+1,(pn-1) do
				v2 = parts[k2]
				if v2 then
					if v1.p.x == v2.p.x and v1.p.y == v2.p.y and v1.p.z == v2.p.z then
--						print(t, k1, k2)
						if parts[k1] then parts[k1] = nil nrem = nrem - 1 end
						if parts[k2] then parts[k2] = nil nrem = nrem - 1 end
					end
				end
			end
		end
	end
--	print("", t, nrem)
end
print(nrem)
