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
		if mode_1 == 1 or op.wr_1 then par_1 = mem[pc+1] else par_1 = mem[mem[pc+1] or 0] end
		if mode_2 == 1 or op.wr_2 then par_2 = mem[pc+2] else par_2 = mem[mem[pc+2] or 0] end
		if mode_3 == 1 or op.wr_3 then par_3 = mem[pc+3] else par_3 = mem[mem[pc+3] or 0] end
		
		local newpc = op.fn(mem, pc, par_1, par_2, par_3)
		if not newpc then st.done = true st.blocked = true end
	
	st.pc = newpc
end

function runall(sts)
	local one_unblocked = true
	while one_unblocked do
		one_unblocked = false
		
		for n,st in ipairs(sts) do
			if not st.blocked then print("step ",n,st.pc) end
			step(st)
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
	
	table.insert(sts, { mem = memdup(arr), ifif = { a, 0 }   , ofif = { b }      , pc = 0, done = false, blocked = false })
	table.insert(sts, { mem = memdup(arr), ifif = sts[1].ofif, ofif = { c }      , pc = 0, done = false, blocked = false })
	table.insert(sts, { mem = memdup(arr), ifif = sts[2].ofif, ofif = { d }      , pc = 0, done = false, blocked = false })
	table.insert(sts, { mem = memdup(arr), ifif = sts[3].ofif, ofif = { e }      , pc = 0, done = false, blocked = false })
	table.insert(sts, { mem = memdup(arr), ifif = sts[4].ofif, ofif = sts[1].ifif, pc = 0, done = false, blocked = false })
	
	runall(sts)
	
	print(#sts[5].ofif, sts[5].ofif[1])
	return sts[5].ofif[1]
end

line = io.read("*line")
arr = parse(line)
local max = 0
for a=5,9 do
	for b=5,9 do if b ~= a then
		for c=5,9 do if c ~= a and c ~= b then
			for d=5,9 do if d ~= a and d ~= b and d ~= c then
				for e=5,9 do if e ~= a and e ~= b and e ~= c and e ~= d then
					local res = trysetting(arr,a,b,c,d,e)
					if res > max then max = res end
				end end
			end end
		end end
	end end
end
print(max)