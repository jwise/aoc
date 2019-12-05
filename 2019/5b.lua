ops = {
	[1] = { name = "add", size = 4, wr_3 = true, fn =
		function(mem,pc,s1,s2,d)
			mem[d] = s1 + s2
			return pc + 4
		end,
	},
	[2] = { name = "mul", size = 4, wr_3 = true, fn =
		function(mem,pc,s1,s2,d)
			mem[d] = s1 * s2
			return pc + 4
		end
	},
	[3] = { name = "input", size = 2, wr_1 = true, fn =
		function(mem, pc, d)
			mem[d] = 5
			return pc + 2
		end
	},
	[4] = { name = "output", size = 2, fn =
		function(mem, pc, s)
			print("OUTPUT "..s)
			return pc + 2
		end
	},
	[5] = { name = "jt", size = 3, fn =
		function(mem,pc,s,tgt)
			if s ~= 0 then return tgt
			else return pc + 3
			end
		end
	},
	[6] = { name = "jf", size = 3, fn =
		function(mem,pc,s,tgt)
			if s == 0 then return tgt
			else return pc + 3
			end
		end
	},
	[7] = { name = "cmplt", size = 4, wr_3 = true, fn =
		function(mem,pc,a,b,tgt)
			mem[tgt] = a < b and 1 or 0
			return pc + 4
		end
	},
	[8] = { name = "cmpeq", size = 4, wr_3 = true, fn =
		function(mem,pc,a,b,tgt)
			mem[tgt] = a == b and 1 or 0
			return pc + 4
		end
	},
	[99] = { name = "halt", size = 1, fn =
		function(mem,pc) return nil end
	}
}

function eval(mem)
	local pc = 0
	while true do
		local raw_op = mem[pc]
		local opc = raw_op % 100
		local mode_1 = math.floor(raw_op / 100) % 10
		local mode_2 = math.floor(raw_op / 1000) % 10
		local mode_3 = math.floor(raw_op / 10000) % 10
		local op = ops[opc]
		if not op then
			print("bad opcode "..mem[pc].."("..opc..") at pc "..pc)
			return
		end
		
		local par_1, par_2, par_3
		if mode_1 == 1 or op.wr_1 then par_1 = mem[pc+1] else par_1 = mem[mem[pc+1] or 0] end
		if mode_2 == 1 or op.wr_2 then par_2 = mem[pc+2] else par_2 = mem[mem[pc+2] or 0] end
		if mode_3 == 1 or op.wr_3 then par_3 = mem[pc+3] else par_3 = mem[mem[pc+3] or 0] end
		
		local newpc = op.fn(mem, pc, par_1, par_2, par_3)
		if not newpc then return end
		pc = newpc
	end
end

function parse(inp)
	local mem = {}
	local pos = 0
	for n in line:gmatch("[^,]+") do
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

line = io.read("*line")

arr = parse(line)
eval(arr)
