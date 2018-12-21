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

l = io.read("*line")
ipr = l:match("%#ip (%d)")
ipr = tonumber(ipr)

rom = {}
romp = 0
while true do
	l = io.read("*line")
	if not l then break end
	
	insn,a,b,c = l:match("(....) (%d+) (%d+) (%d+)")
	a = tonumber(a)
	b = tonumber(b)
	c = tonumber(c)
	
	rom[romp] = { insn = opcs[insn], a = a, b = b, c = c }
	romp = romp + 1
end

regs = {}
for i=0,6 do regs[i] = 0 end
regs[0] = tonumber(arg[1]) or 0
prev = nil
seen = {}
count = 0

ip = 0
steps = 0
while rom[ip] do
	r = rom[ip]

	regs[ipr] = ip
	regs[r.c] = r.insn.fn(regs, r.a, r.b)
	ip = regs[ipr]
	ip = ip + 1
	steps = steps + 1
	if ip == 28 then
		if count == 0 then print(regs[5]) end
		count = count + 1
		if count % 1000 == 0 then print("..."..count.."...") end
		if seen[regs[5]] then break end
		seen[regs[5]] = true
		prev = regs[5]
	end
end

print(prev)
