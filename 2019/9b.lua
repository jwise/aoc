ifif = {}
ofif = {}

curst = nil -- oh my god hack

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
--			print(#curst.ifif)
			mem[d] = table.remove(curst.ifif, 1)
--			print("INPUT ",mem[d])
			return pc + 2
		end
	},
	[4] = { name = "output", size = 2, fn =
		function(mem, pc, s)
			table.insert(curst.ofif, s)
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
	[9] = { name = "adjb", size = 2, fn =
		function(mem,pc,a)
			curst.base = curst.base or 0
			curst.base = curst.base + a
			return pc + 2
		end
	},
	[99] = { name = "halt", size = 1, fn =
		function(mem,pc) return nil end
	}
}

function step(st)
	local mem = st.mem
	local pc = st.pc
	
	-- hack
	curst = st -- so input and output can mutate
	
	if st.done then return end
	st.blocked = false

		local raw_op = mem[pc]
		local opc = raw_op % 100
		local mode_1 = math.floor(raw_op / 100) % 10
		local mode_2 = math.floor(raw_op / 1000) % 10
		local mode_3 = math.floor(raw_op / 10000) % 10
		local op = ops[opc]
		if not op then
			print("bad opcode "..mem[pc].."("..opc..") at pc "..pc)
			abort()
		end
		
		-- hack
		if opc == 3 and #st.ifif == 0 then st.blocked = true return end -- blocked
		
		local par_1, par_2, par_3
		if mode_1 == 1 or op.wr_1 then par_1 = (mem[pc+1] or 0) + (mode_1 == 2 and st.base or 0) elseif mode_1 == 2 then par_1 = mem[mem[pc+1] + st.base] or 0 else par_1 = mem[mem[pc+1] or 0] or 0 end
		if mode_2 == 1 or op.wr_2 then par_2 = (mem[pc+2] or 0) + (mode_2 == 2 and st.base or 0) elseif mode_2 == 2 then par_2 = mem[mem[pc+2] + st.base] or 0 else par_2 = mem[mem[pc+2] or 0] or 0 end
		if mode_3 == 1 or op.wr_3 then par_3 = (mem[pc+3] or 0) + (mode_3 == 2 and st.base or 0) elseif mode_3 == 2 then par_3 = mem[mem[pc+3] + st.base] or 0 else par_3 = mem[mem[pc+3] or 0] or 0 end
		
		local newpc = op.fn(mem, pc, par_1, par_2, par_3)
		if not newpc then st.done = true st.blocked = true end
	
	st.pc = newpc
end

function runall(sts)
	local one_unblocked = true
	while one_unblocked do
		one_unblocked = false
		
		for n,st in ipairs(sts) do
--			if not st.blocked then print("step ",n,st.pc) end
			step(st)
--			print(st.blocked)
			if not st.blocked then one_unblocked = true end
		end
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

function trysetting(arr,a,b,c,d,e)
	local sts = {}
	
	table.insert(sts, { mem = memdup(arr), ifif = { 2 } , ofif = { }      , pc = 0, done = false, blocked = false })
	
	runall(sts)
	
	for k,v in ipairs(sts[1].ofif) do print(v) end
end

line = io.read("*line")
arr = parse(line)
print(trysetting(arr, 0, 0, 0, 0, 0))
