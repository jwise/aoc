ops = {
	[1] = { name = "add", size = 4, fn =
		function(mem,pc)
			local s1, s2, d = mem[pc+1], mem[pc+2], mem[pc+3]
			mem[d] = mem[s1] + mem[s2]
			return pc + 4
		end,
	},
	[2] = { name = "mul", size = 4, fn =
		function(mem,pc)
			local s1, s2, d = mem[pc+1], mem[pc+2], mem[pc+3]
			mem[d] = mem[s1] * mem[s2]
			return pc + 4
		end
	},
	[99] = { name = "halt", size = 1, fn =
		function(mem,pc) return nil end
	}
}

function printop(mem, pc)
	local op = ops[mem[pc]]
	if not op then
		print("bad opcode "..mem[pc].." at pc "..pc)
		return 1
	end
	
	local s = "@"..pc..": ".. op.name .. "["..mem[pc].."] "
	for i=1,op.size-1 do
		s = s .. mem[pc+i] .. ", "
	end
	print(s)
	return op.size
end

function eval(mem)
	local pc = 0
	while true do
		local op = ops[mem[pc]]
		if not op then
			print("bad opcode "..mem[pc].." at pc "..pc)
			return
		end
		local newpc = op.fn(mem, pc)
		if not newpc then return end
		pc = newpc
	end
end

function parse(inp)
	local mem = {}
	local pos = 0
	for n in line:gmatch("%d+") do
		mem[pos] = tonumber(n)
		pos = pos + 1
	end
	return mem
end

function memdup(arr)
	local oarr = {}
	for k,v in pairs(arr) do
		oarr[k] = v
	end
	return oarr
end

function disas(mem)
	local pc = 0
	while mem[pc] do
		pc = pc + printop(mem, pc)
	end
end

line = io.read("*line")

arr = parse(line)
disas(arr)

mem = memdup(arr)
mem[1] = 12
mem[2] = 2
eval(mem)
print(mem[0])

for a1 = 0, 99 do
	for a2 = 0, 99 do
		mem = memdup(arr)
		mem[1] = a1
		mem[2] = a2
		eval(mem)
		if mem[0] == 19690720 then
			print(a1 * 100 + a2)
			break
		end
	end
end
