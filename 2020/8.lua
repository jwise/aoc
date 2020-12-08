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

while not executed[pc] do
	executed[pc] = true
	print(pc,prog[pc].opc,prog[pc].ofs)
	if prog[pc].opc == "nop" then
		pc = pc + 1
	elseif prog[pc].opc == "acc" then
		acc = acc + prog[pc].ofs
		pc = pc + 1
	elseif prog[pc].opc == "jmp" then
		pc = pc + prog[pc].ofs
	end
end
print(acc)