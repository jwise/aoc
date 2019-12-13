moons = {}

while true do
	local line = io.read("*line")
	if not line then break end

	x,y,z = line:match("<x=([^,]+), y=([^,]+), z=([^>]+)")
	assert(x)
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	
	table.insert(moons, { p = {x, y, z}, v = {0,0,0}, vpat = {{}, {}, {}}, vpatlen = {1,1,1} })
end

STEPS = tonumber(arg[1])

function nrg(mun)
	local pe = 0
	local ke = 0
	for i=1,3 do
		pe = pe + math.abs(mun.p[i])
		ke = ke + math.abs(mun.v[i])
	end
	return pe * ke
end

seen = {}

for st=1,STEPS do
	for a,mun in ipairs(moons) do
		for b,mun2 in ipairs(moons) do
			if a < b then
			for i=1,3 do
				    if mun.p[i] > mun2.p[i] then mun.v[i] = mun.v[i] - 1 mun2.v[i] = mun2.v[i] + 1 --s = s .. ">"
				elseif mun.p[i] < mun2.p[i] then mun.v[i] = mun.v[i] + 1 mun2.v[i] = mun2.v[i] - 1 --s = s .. "<"
				else  -- s = s .. " "
				end
			end
			end
		end
	end
	
	for _,mun in pairs(moons) do
		for i=1,3 do
			mun.p[i] = mun.p[i] + mun.v[i]
			
			-- look for pattern length in v
			mun.vpat[i][st] = mun.v[i]
			if mun.vpat[i][(st - 1) % mun.vpatlen[i] + 1] ~= mun.v[i] then
				mun.vpatlen[i] = st
			end
		end
	end

	print(st,
	      moons[1].p[1], moons[1].p[2], moons[1].p[3],
--	      moons[1].vpatlen[1], moons[1].vpatlen[2], moons[1].vpatlen[3],
--	      moons[1].v[1], moons[1].v[2], moons[1].v[3],
	      moons[2].p[1], moons[2].p[2], moons[2].p[3],
--	      moons[2].v[1], moons[2].v[2], moons[2].v[3],
	      moons[3].p[1], moons[3].p[2], moons[3].p[3],
--	      moons[3].v[1], moons[3].v[2], moons[3].v[3],
	      moons[4].p[1], moons[4].p[2], moons[4].p[3]
--	      moons[4].v[1], moons[4].v[2], moons[4].v[3]
)
end


n = 0
for _,mun in ipairs(moons) do
	n = n + nrg(mun)
end

print(n)

print(moons[1].vpatlen[1], moons[1].vpatlen[2], moons[1].vpatlen[3],
      moons[2].vpatlen[1], moons[2].vpatlen[2], moons[2].vpatlen[3],
      moons[3].vpatlen[1], moons[3].vpatlen[2], moons[3].vpatlen[3])