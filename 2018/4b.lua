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
maxminc = 0
maxmin = 0
maxg = 0 
for g,cg in pairs(guards) do
	for min,minc in pairs(cg.eachmin) do
		if minc > maxminc then
			maxminc = minc
			maxmin = min
			maxg = g
		end
	end
end

print(maxg, maxmin, maxminc)
print(maxg * maxmin)
