subs = {}

line = io.read("*line")
for n in line:gmatch("(%d+)") do
	table.insert(subs, tonumber(n))
end

bestfuel = 9999999999

for i=1,#subs do
	ipos = subs[i]
	fuel = 0
	for n,npos in ipairs(subs) do
		dist = math.abs(npos - ipos)
		for i=1,dist do
			fuel = fuel + i
		end
	end
	if fuel < bestfuel then bestfuel = fuel end
end
print(bestfuel)
