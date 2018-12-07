ELVES = 5
BASETM = 61

steps = {}

while true do
	l = io.read("*line")
	if not l then break end
	
	dep,tgt = l:match("Step (.) must be finished before step (.)")
	if not steps[tgt] then
		steps[tgt] = { deps = {}, ndeps = 0 }
	end
	if not steps[dep] then
		steps[dep] = { deps = {}, ndeps = 0 }
	end
	
	steps[tgt].deps[dep] = true
	steps[tgt].ndeps = steps[tgt].ndeps + 1
end

elves = {}
for i=1,ELVES do
	table.insert(elves, {availtm = 0})
end

seq = ""
curtm = 0
while true do
	progress = false
	
	-- is an elf available?  if not, fast forward to when one will be
	for k,v in ipairs(elves) do
	--	if v.cur then progress = true end
		if v.availtm <= curtm then
			v.cur = nil
		end
	end
	
	-- unblock everyone...
	for k,v in pairs(steps) do
		if not v.done and (v.donetm or 10000000) <= curtm then
			seq = seq .. k
			for k2,v2 in pairs(steps) do
				if v2.deps[k] then
	--				progress = true
					v2.deps[k] = false
					v2.ndeps = v2.ndeps - 1
				end
			end
			v.done = true
	--		progress = true
		end
	end
	
	repeat
		microprogress = false
		for id=0x41,0x5a do
			chr = string.char(id)
			donetm = id - 0x41 + BASETM + curtm
			if steps[chr] and steps[chr].ndeps == 0 and not steps[chr].done and not steps[chr].inuse then
				haself = nil
				for k,v in ipairs(elves) do
					if not v.cur then haself = v break end
				end
				if not haself then break end
				steps[chr].donetm = donetm
				haself.availtm = donetm
				haself.cur = chr
				steps[chr].inuse = true
	--			progress = true
				microprogress = true
				break
			end
		end
	until not microprogress
	
	print(curtm,elves[1].cur,elves[1].availtm,elves[2].cur,elves[2].availtm)
	curtm = curtm + 1
	for k,v in ipairs(elves) do
		if v.cur then progress = true end
	end

	if not progress then break end
end
print(curtm-1)