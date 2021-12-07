subs = {}

line = io.read("*line")
for n in line:gmatch("(%d+)") do
	table.insert(subs, tonumber(n))
end

bestfuel = 999999

for i=1,#subs do
	ipos = subs[i]
	fuel = 0
	for n,npos in ipairs(subs) do
		fuel = fuel + math.abs(npos - ipos)
	end
	if fuel < bestfuel then bestfuel = fuel end
end
print(bestfuel)
