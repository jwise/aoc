guards = {}
cguard = nil
sleepmin = nil

while true do
	l = io.read("*line")
	if not l then break end

	if l:match("begins shift") then
		g = l:match("Guard #(%d+) begins")
		g = tonumber(g)
		cguard = guards[g] or {}
		guards[g] = cguard
		cguard.tmins = cguard.tmins or 0
		cguard.eachmin = cguard.eachmin or {}
	elseif l:match("falls asleep") then
		min = l:match("%[....-..-.. 00:(%d%d)%]")
		min = tonumber(min)
		assert(sleepmin == nil)
		sleepmin = tonumber(min)
	elseif l:match("wakes up") then
		min = l:match("%[....-..-.. 00:(%d%d)%]")
		min = tonumber(min)
		for i=sleepmin,min do
			cguard.eachmin[i] = (cguard.eachmin[i] or 0) + 1
		end
		cguard.tmins = cguard.tmins + min - sleepmin
		print("awake:",g,cguard.tmins,min,sleepmin)
		sleepmin = nil
	else
		print(l)
		return
	end
end

-- sleepiest guard
maxmins = 0
maxcg = nil
for g,cg in pairs(guards) do
	print(g,cg,cg.tmins)
	if cg.tmins > maxmins then
		maxmins = cg.tmins
		maxg = g
		maxcg = cg
	end
end

-- sleepiest minute
maxminc = 0
maxmin = nil
for min,minc in pairs(maxcg.eachmin) do
	if minc > maxminc then
		maxminc = minc
		maxmin = min
	end
end

print(g, maxmins, maxminc, maxmin)
print(maxg * maxmin)
