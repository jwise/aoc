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

seq = ""
while true do
	done = false
	for id=0x41,0x5a do
		chr = string.char(id)
		print(steps[chr])
		if steps[chr] and steps[chr].ndeps == 0 and not steps[chr].done then
			seq = seq .. chr
			for k,v in pairs(steps) do
				print(k)
				if v.deps[chr] then
					done = true
					v.deps[chr] = false
					v.ndeps = v.ndeps - 1
				end
			end
			steps[chr].done = true
			if done then break end
		end
	end
	if not done then break end
end
print(seq)