ops = {
	[1] = { name = "add", size = 4, wr = {false, false, true}, fn =
		function(st,s1,s2,d)
			st.mem[d] = s1 + s2
			return st.pc + 4
		end,
	},
	[2] = { name = "mul", size = 4, wr = {false, false, true}, fn =
		function(st,s1,s2,d)
			st.mem[d] = s1 * s2
			return st.pc + 4
		end
	},
	[3] = { name = "input", size = 2, wr = {true}, fn =
		function(st, d)
			if #st.ifif == 0 then
				st.blocked = true
				return st.pc
			end
			st.mem[d] = table.remove(st.ifif, 1)
			return st.pc + 2
		end
	},
	[4] = { name = "output", size = 2, fn =
		function(st, s)
			table.insert(st.ofif, s)
			return st.pc + 2
		end
	},
	[5] = { name = "jt", size = 3, fn =
		function(st,s,tgt)
			if s ~= 0 then return tgt
			else return st.pc + 3
			end
		end
	},
	[6] = { name = "jf", size = 3, fn =
		function(st,s,tgt)
			if s == 0 then return tgt
			else return st.pc + 3
			end
		end
	},
	[7] = { name = "cmplt", size = 4, wr = {false, false, true}, fn =
		function(st,a,b,tgt)
			st.mem[tgt] = a < b and 1 or 0
			return st.pc + 4
		end
	},
	[8] = { name = "cmpeq", size = 4, wr = {false, false, true}, fn =
		function(st,a,b,tgt)
			st.mem[tgt] = a == b and 1 or 0
			return st.pc + 4
		end
	},
	[9] = { name = "adjb", size = 2, fn =
		function(st,a)
			st.base = st.base or 0
			st.base = st.base + a
			return st.pc + 2
		end
	},
	[99] = { name = "halt", size = 1, fn =
		function(st) return nil end
	}
}

function step(st)
	local mem = st.mem
	local pc = st.pc
	
	if st.done then return end
	st.blocked = false
	

	local raw_op = mem[pc]
	local opc = raw_op % 100
	local mode = {}
	mode[1] = math.floor(raw_op / 100) % 10
	mode[2] = math.floor(raw_op / 1000) % 10
	mode[3] = math.floor(raw_op / 10000) % 10
	local op = ops[opc]
	if not op then
		print("bad opcode "..mem[pc].."("..opc..") at pc "..pc)
		abort()
	end
		
	local par = {}
	for i=1,op.size-1 do
		if mode[i] == 2 and (op.wr and op.wr[i]) then -- relative mode, write
			par[i] = (mem[pc+i] or 0) + st.base
		elseif mode[i] == 2 then -- relative mode, read
			par[i] = mem[(mem[pc+i] or 0) + st.base] or 0
		elseif mode[i] == 1 or (op.wr and op.wr[i]) then -- absolute mode, or write
			par[i] = mem[pc+i] or 0
		elseif mode[i] == 0 then
			par[i] = mem[mem[pc+i] or 0] or 0
		else
			print("bad address mode for par "..i.." on "..mem[pc].." at pc "..pc)
			abort()
		end
	end
	
	local newpc = op.fn(st, par[1], par[2], par[3])
	if not newpc then
		st.done = true
		st.blocked = true
	end

	st.pc = newpc
end

function runall(sts)
	local one_unblocked = true
	while one_unblocked do
		one_unblocked = false
		
		for n,st in ipairs(sts) do
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

function numdup(arr)
	local oarr = {}
	for k,v in ipairs(arr) do
		table.insert(oarr, v)
	end
	return oarr
end

line = io.read("*line")
arr = parse(line)

local ifif = { }
local ofif = {}
local st = { mem = memdup(arr), ifif = ifif, ofif = ofif, pc = 0, done = false, blocked = false }

while not st.done do
	if st.blocked then
		local line = io.read("*line")
		for c in line:gmatch(".") do
			table.insert(ifif, c:byte())
		end
		table.insert(ifif, 10)
	end
	step(st)
	while #ofif > 0 do
		local c = table.remove(ofif, 1)
		io.write(string.char(c))
	end
end
