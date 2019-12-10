roids = {}

local y = 0
while true do
	local line = io.read("*line")
	if not line then break end
	local x = 0
	for c in line:gmatch(".") do
		if c ~= "." then
			table.insert(roids, { x = x, y = y, visible = {}, blocked = {} })
		end
		x = x + 1
	end
	y = y + 1
end

print(#roids)
for i,r1 in pairs(roids) do
	print(i)
	-- for each roid r1, pick an r2.  then for each r1 -> r2 pair, see if each r1->r2 is blocked by foreach rblock
	for _, r2 in pairs(roids) do
		if r1 == r2 then
		elseif r1.visible[r2] or r1.blocked[r2] or r2.visible[r1] or r2.blocked[r1] then
		else
			-- now we have to actually do the computation
			for _,rblock in pairs(roids) do
				if rblock ~= r1 and rblock ~= r2 then
					local r2xt, r2yt = r2.x     - r1.x, r2.y     - r1.y
					local rbxt, rbyt = rblock.x - r1.x, rblock.y - r1.y
					
					local distrb = rbxt * rbxt + rbyt * rbyt
					local distr2 = r2xt * r2xt + r2yt * r2yt
					local rbdotr2 = rbxt * r2xt + rbyt * r2yt
				
					local collinear = false
					if r2yt == 0 and rbyt == 0 then collinear = true
					elseif r2xt / r2yt * rbyt == rbxt then
						collinear = true
					end
					
					if collinear and rbdotr2 < distr2 and rbdotr2 > 0 then
--						print(r1.x, r1.y, r2.x, r2.y, rblock.x, rblock.y)
						if r1.x == 5 and r1.y == 8 then
							print(r1.x, r1.y, r2.x, r2.y, "blocked by", rblock.x, rblock.y, rbdotr2, distr2)
						end
						if r2.x == 5 and r2.y == 8 then
							print(r1.x, r1.y, r2.x, r2.y, "blocked by", rblock.x, rblock.y, rbdotr2, distr2)
						end
						
						r1.blocked[r2] = true
						r2.blocked[r1] = true
						table.insert(r1.blocked, r2)
						table.insert(r2.blocked, r1)
						break
					end
				end
			end
			if not r1.blocked[r2] then
				r1.visible[r2] = true
				r2.visible[r1] = true
				table.insert(r1.visible, r2)
				table.insert(r2.visible, r1)
			end
		end
	end
end

local best = nil
for _,r in pairs(roids) do
--	print(r.x, r.y, #r.visible)
	if not best then best = r
	elseif #best.visible < #r.visible then best = r
	end
end
print("BEST:",best.x, best.y, #best.visible)

-- calculate an angle for each roid
for _,r in pairs(roids) do
	r.angle = -math.atan2(r.x-best.x, r.y-best.y)
	r.distsq = (r.x-best.x)*(r.x-best.x) + (r.y-best.y)*(r.y-best.y)
	r.alive = true
end

-- then sort the roids
table.sort(roids, function(r1,r2) return r1.angle < r2.angle or (r1.angle == r2.angle and r1.distsq < r2.distsq) end)

-- then proceed and only zap one roid at each angle per 'rotation'
nroids = #roids
blasted = 0
while nroids > 0 do
	local lastangle = nil
	for _,r in ipairs(roids) do
		if r.alive and r.angle ~= lastangle then
			blasted = blasted + 1
			nroids = nroids - 1
			r.alive = false
			lastangle = r.angle
			if blasted == 200 then print(r.x*100+r.y) end
		end
	end
end
