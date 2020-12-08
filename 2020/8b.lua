prog = {}
pc = 1
acc = 0
executed = {}

while true do
	line = io.read("*line")
	if not line then break end
	
	opc,ofs = line:match("(%S+) ([+-]%d+)")
	ofs = tonumber(ofs)
	
	table.insert(prog, { opc = opc, ofs = ofs })
end

for patch=1,#prog do
	executed = {}
	acc = 0
	pc = 1

	print("trying", patch)
	while prog[pc] and not executed[pc] do
		executed[pc] = true
		print(pc,prog[pc].opc,prog[pc].ofs)
		ispatch = (pc == patch)
		if (prog[pc].opc == "nop" and not ispatch) or (prog[pc].opc == "jmp" and ispatch) then
			pc = pc + 1
		elseif prog[pc].opc == "acc" then
			acc = acc + prog[pc].ofs
			pc = pc + 1
		elseif (prog[pc].opc == "jmp" and not ispatch) or (prog[pc].opc == "nop" and ispatch) then
			pc = pc + prog[pc].ofs
		end
	end
	if not prog[pc] then
		print("GOT IT", pc, acc)
		abort()
	end
end