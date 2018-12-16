if bit then
	BOR = bit.bor
	BXOR = bit.bxor
	BAND = bit.band
	BLSH = bit.lshift
	BRSH = bit.rshift
else
	BOR = load("return function(a,b) return a | b end")()
	BXOR = load("return function(a,b) return a ^ b end")()
	BAND = load("return function(a,b) return a & b end")()
	BLSH = load("return function(a,b) return a << b end")()
	BRSH = load("return function(a,b) return a >> b end")()
end

opcs = {
	addr = { fn = function(regs, a, b) return regs[a] + regs[b] end },
	addi = { fn = function(regs, a, b) return regs[a] + b end },
	mulr = { fn = function(regs, a, b) return regs[a] * regs[b] end },
	muli = { fn = function(regs, a, b) return regs[a] * b end },
	banr = { fn = function(regs, a, b) return BAND(regs[a],regs[b]) end },
	bani = { fn = function(regs, a, b) return BAND(regs[a], b) end },
	borr = { fn = function(regs, a, b) return BOR(regs[a],regs[b]) end },
	bori = { fn = function(regs, a, b) return BOR(regs[a], b) end },
	setr = { fn = function(regs, a, b) return regs[a] end },
	seti = { fn = function(regs, a, b) return a end },
	gtir = { fn = function(regs, a, b) return (a > regs[b]) and 1 or 0 end },
	gtri = { fn = function(regs, a, b) return (regs[a] > b) and 1 or 0 end },
	gtrr = { fn = function(regs, a, b) return (regs[a] > regs[b]) and 1 or 0 end },
	eqir = { fn = function(regs, a, b) return (a == regs[b]) and 1 or 0 end },
	eqri = { fn = function(regs, a, b) return (regs[a] == b) and 1 or 0 end },
	eqrr = { fn = function(regs, a, b) return (regs[a] == regs[b]) and 1 or 0 end },
}

for opc,tab in pairs(opcs) do
	tab.couldbe = { }
	tab.name = opc
	for i=0,15 do
		tab.couldbe[i] = true
	end
end

local threeormore = 0
while true do
	l = io.read("*line")
	if l == "" then
		io.read("*line")
		break
	end
	
	inp = {}
	a0,b0,c0,d0 = l:match("Before: %[(%d+), (%d+), (%d+), (%d+)%]")
	inp[0] = tonumber(a0)
	inp[1] = tonumber(b0)
	inp[2] = tonumber(c0)
	inp[3] = tonumber(d0)
	
	l = io.read("*line")
	opc,a,b,c = l:match("(%d+) (%d+) (%d+) (%d+)")
	opc = tonumber(opc)
	i0 = tonumber(a)
	i1 = tonumber(b)
	o = tonumber(c)
	
	l = io.read("*line")
	oup = {}
	a1,b1,c1,d1 = l:match("After:  %[(%d+), (%d+), (%d+), (%d+)%]")
	oup[0] = tonumber(a1)
	oup[1] = tonumber(b1)
	oup[2] = tonumber(c1)
	oup[3] = tonumber(d1)
	
	l = io.read("*line")
	
	local couldbe = 0
	for opcnam,tab in pairs(opcs) do
		if oup[o] == tab.fn(inp, i0, i1) then
			couldbe = couldbe + 1
		else
			tab.couldbe[opc] = false
		end
	end
	if couldbe >= 3 then threeormore = threeormore + 1 end
end

print(threeormore)

opclist = {}
for opc,tab in pairs(opcs) do
	table.insert(opclist, tab)
end

asntab = {}
function try(n)
	if n == 17 then return true end
	local op = opclist[n]
	
	for couldbe,really in pairs(op.couldbe) do
		if really and not asntab[couldbe] then
			-- try assigning couldbe
			asntab[couldbe] = op
			if try(n+1) then return true end
			asntab[couldbe] = nil
		end
	end
	return false
end

print(try(1))

for k,v in pairs(asntab) do
	print(v.name, k)
end

regs = {}
regs[0] = 0
regs[1] = 0
regs[2] = 0
regs[3] = 0

while true do
	l = io.read("*line")
	if not l then break end
	
	opc,a,b,c = l:match("(%d+) (%d+) (%d+) (%d+)")
	opc = tonumber(opc)
	i0 = tonumber(a)
	i1 = tonumber(b)
	o = tonumber(c)
	
	regs[o] = asntab[opc].fn(regs, i0, i1)
end

print(regs[0])
