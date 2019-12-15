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


ifif = {}
ofif = {}

line = io.read("*line")
arr = parse(line)

-- build a vm
ifif = {}
ofif = {}
local st = { mem = memdup(arr), ifif = ifif, ofif = ofif, pc = 0, done = false, blocked = false }
while not st.blocked do
	step(st)
end
curpos = { } -- chain of dirs

-- explore the space
dirs = { { x = 0, y = -1, dual = 2,n="S"}, {x = 0, y = 1, dual = 1,n="N"}, {x = -1, y= 0, dual = 4,n="W"}, {x = 1, y = 0, dual = 3,n="E"}}

function set(a,y,x,v) if not a[y] then a[y] = {} end a[y][x] = v end
function get(a,y,x  ) if not a[y] then a[y] = {} end return a[y][x] end

explored = {}
wall = {}
set(explored,0,0,true)
oxygen = nil

exq = {} -- contains a chain of dirs to get to a space

-- We do a flood fill of the space, starting from (0,0).
table.insert(exq, {1})
table.insert(exq, {2})
table.insert(exq, {3})
table.insert(exq, {4})

function xy_from_ops(ops)
	local pos = { x = 0, y = 0 }
	if ops == nil then abort() end
	for _,d in ipairs(ops) do
		if d == nil then abort() end
		pos.x = pos.x + dirs[d].x
		pos.y = pos.y + dirs[d].y
	end
	return pos
end

function chtostr(ops)
	local s = ""
	for _,d in ipairs(ops) do
		s = s .. dirs[d].n
	end
	return s
end

while #exq > 0 do
	local ex = table.remove(exq, 1) -- space to explore
	
	-- have we already explored it?
	local ex_pos = xy_from_ops(ex)
	if not get(explored,ex_pos.y,ex_pos.x) then
		--print(ex_pos.y, ex_pos.x) --, chtostr(curpos), chtostr(ex))
		-- got here
		set(explored,ex_pos.y,ex_pos.x,true)
	
		-- now navigate to the space, by backing up from curpos and going into expos
		ifif = {}
		ofif = {}
		local st = { mem = memdup(arr), ifif = ifif, ofif = ofif, pc = 0, done = false, blocked = false }

		-- now ifif has backed up ... time to go forwards
		for i=1,#ex do
			table.insert(ifif, ex[i])
		end
		
		-- now, run it
		while not st.blocked do
			step(st)
		end
		if st.done then abort() end
		
		while #ofif > 1 do
			if table.remove(ofif, 1) == 0 then abort() end
		end
		
		local val = table.remove(ofif, 1)
		--print("",val)
		if val == 0 then
			set(wall,ex_pos.y,ex_pos.x,true)
			-- curpos is a little tricky now, we didn't make the last move
			curpos = ex
			table.remove(curpos)
		elseif val == 1 then
			curpos = ex
			local a
			a = memdup(ex) table.insert(a, 1) table.insert(exq, 1, a)
			a = memdup(ex) table.insert(a, 2) table.insert(exq, 1, a)
			a = memdup(ex) table.insert(a, 3) table.insert(exq, 1, a)
			a = memdup(ex) table.insert(a, 4) table.insert(exq, 1, a)
		elseif val == 2 then
			oxygen = ex
			curpos = ex
			print(#oxygen)
		end
	end
end

-- now flood fill with oxygen?
oxygenxy = xy_from_ops(oxygen)
haso2 = {}
set(haso2,oxygenxy.y,oxygenxy.x, 0)
did_work = true
time = 0
while did_work do
	did_work = false
	for y,r in pairs(haso2) do
		for x,v in pairs(r) do
			if v == time then
				if not get(wall,y  ,x+1) and not get(haso2,y  ,x+1) then set(haso2,y  ,x+1,time+1) did_work = true end
				if not get(wall,y  ,x-1) and not get(haso2,y  ,x-1) then set(haso2,y  ,x-1,time+1) did_work = true end
				if not get(wall,y+1,x  ) and not get(haso2,y+1,x  ) then set(haso2,y+1,x  ,time+1) did_work = true end
				if not get(wall,y-1,x  ) and not get(haso2,y-1,x  ) then set(haso2,y-1,x  ,time+1) did_work = true end
			end
		end
	end
	if did_work then time = time + 1 end
end

print(time)