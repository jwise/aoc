moons = {}

while true do
	local line = io.read("*line")
	if not line then break end

	x,y,z = line:match("<x=([^,]+), y=([^,]+), z=([^>]+)")
	assert(x)
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	
	table.insert(moons, { x = x, y = y, z = z, dx = 0, dy = 0, dz = 0 })
end

STEPS = tonumber(arg[1])

function nrg(mun)
	local pe = 0
	local ke = 0
	for _,c in pairs({"x", "y", "z"}) do
		pe = pe + math.abs(mun[c])
	end
	for _,c in pairs({"dx", "dy", "dz"}) do
		ke = ke + math.abs(mun[c])
	end
	return pe * ke
end

seen = {}

for i=1,STEPS do
--	s = ""
	for a,mun in ipairs(moons) do
		for b,mun2 in ipairs(moons) do
			if a < b then
			for _,c in pairs({"x", "y", "z"}) do
				dc = "d"..c
				    if mun[c] > mun2[c] then mun[dc] = mun[dc] - 1 mun2[dc] = mun2[dc] + 1 --s = s .. ">"
				elseif mun[c] < mun2[c] then mun[dc] = mun[dc] + 1 mun2[dc] = mun2[dc] - 1 --s = s .. "<"
				else  -- s = s .. " "
				end
			end
			end
		end
	end
--	print(s)
	
	h = 0
	for _,mun in pairs(moons) do
		for _,c in pairs({"x", "y", "z"}) do
			dc = "d"..c
--			h = ((h * 1023) + mun[c] + mun[dc]) % 1048576
			mun[c] = mun[c] + mun[dc]
		end
	end
	
--	local n = 0
--	for _,mun in ipairs(moons) do
--		n = n + nrg(mun)
--	end
	if (i % 10000) == 0 then print(i) end
--	if seen[h] then
--		print(i,n,h)
--		abort()
--	end
--	seen[h] = true
end


n = 0
for _,mun in ipairs(moons) do
	print(mun.x, mun.y, mun.z, mun.dx, mun.dy, mun.dz)
	n = n + nrg(mun)
end

print(n)