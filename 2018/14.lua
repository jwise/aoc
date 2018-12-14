--INPUT = tonumber(arg[1])
NRECIPES = tonumber(arg[1])

OUTPUT = {}

scoreboard = {}

function crack(n)
	local n0 = n
	local t0 = {}
	if n == 0 then table.insert(t0, 0) end
	while n > 0 do
		table.insert(t0, n % 10)
		n = math.floor((n - n % 10 + 0.001) / 10)
	end
	return t0
end

function insert(t,t0)
	while #t0 ~= 0 do
		table.insert(t, table.remove(t0, #t0))
	end
end

insert(OUTPUT, crack(NRECIPES))
insert(scoreboard, crack(37))

elves = { 1, 2 }
iter = 0

gotit = false
seqp = 0

while not gotit or #scoreboard <= (NRECIPES + 10) do
	iter = iter + 1
	if iter % 100000 == 0 then
		print(iter,#scoreboard)
	end
	local tot = scoreboard[elves[1]] + scoreboard[elves[2]]
	insert(scoreboard, crack(tot))
	
	for elf,_ in ipairs(elves) do
		local pos = elves[elf]
		pos = pos + 1 + scoreboard[elves[elf]]
		pos = (pos - 1) % #scoreboard + 1
		elves[elf] = pos
	end
	
	s = #scoreboard
	for ofs=0,1 do
		gotit = true
		for i=1,#OUTPUT do
			if scoreboard[s-#OUTPUT-ofs+i] ~= OUTPUT[i] then gotit = false break end
		end
		if gotit then seqp = #scoreboard - #OUTPUT - ofs end
	end
end

s = ""
for i=NRECIPES+1,NRECIPES+10 do
	s = s .. scoreboard[i]
end
print("*:",s)
print("**:",seqp)