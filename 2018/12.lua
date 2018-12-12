l = io.read("*line")
arr = l:match("state: (.*)")
pots = {pos = 0, min = 0}
for c in arr:gmatch(".") do
	pots.max = pots.pos
	pots[pots.pos] = c == "#"
	pots.pos = pots.pos + 1
end
io.read("*line")

sttab = {}
patid = 0
while true do
	l = io.read("*line")
	if not l then break end
	
	pat,val = l:match("(.....) => (.)")
	
	patid = patid + 1
	pattab = {}
	patpos = -2
	for c in pat:gmatch(".") do
		pattab[patpos] = c == "#"
		patpos = patpos + 1
	end
	val = val == "#"
	sttab[pattab] = val
	pattab.id = patid
end

for gen = 1,tonumber(arg[1]) or 20 do
	if gen % 100000 == 0 then
		print(gen)
	end
--	s = ""
--	for i=pots.min-3,pots.max+3 do
--		if pots[i] then
--			s = s .. "#"
--		else
--			s = s .. "."
--		end
--	end
--	print(gen-1, s)

	newpots = {min = 1000, max = 0}
	for i=pots.min-3,pots.max+3 do
		set = false
		for pat,val in pairs(sttab) do
			correct = true
			for j=-2,2 do
				if (pat[j] or false) ~= (pots[i+j] or false) then correct = false end
			end
			if correct and val then set = true end
		end
		newpots[i] = set
		if set then
			if i < newpots.min then newpots.min = i end
			if i > newpots.max then newpots.max = i end
		end
	end
	pots = newpots
end

score = 0
s = ""
for i=pots.min-2,pots.max+2 do
	if pots[i] then
		s = s .. "#"
		score = score + i
	else
		s = s .. "."
	end
end

print(score)
print(s)
