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

local inpqs = {}

line = io.read("*line")
arr = parse(line)

local sts = {}
for i=0,49 do
	-- build a vm
	local ifif = { i }
	local ofif = {}
	inpqs[i] = {}
	local st = { mem = memdup(arr), ifif = ifif, ofif = ofif, inpq = inpqs[i], addr = i, pc = 0, done = false, blocked = false }
	table.insert(sts, st)
end

while true do
	for n,st in ipairs(sts) do
		if #st.inpq > 0 then
			local inp = table.remove(st.inpq, 1)
			table.insert(st.ifif, inp.x)
			table.insert(st.ifif, inp.y)
		end
		if st.blocked and #st.ifif == 0 then
			table.insert(st.ifif, -1)
		end
		
		step(st)
		
		if #st.ofif >= 3 then
			local addr = table.remove(st.ofif, 1)
			local x = table.remove(st.ofif, 1)
			local y = table.remove(st.ofif, 1)
			
			local inp = { addr = addr, x = x, y = y }
			print(st.addr .. " -> " .. addr .. ": X " .. x .. ", Y "..y)
			if addr == 255 then abort() end
			table.insert(inpqs[addr], inp)
		end
	end
end
