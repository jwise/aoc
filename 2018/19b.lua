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
	addr = { fn = function(regs, a, b) return regs[a] + regs[b] end,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." + r"..b..";") end},
	addi = { fn = function(regs, a, b) return regs[a] + b end,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." + "..b..";") end},
	mulr = { fn = function(regs, a, b) return regs[a] * regs[b] end,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." * r"..b..";") end},
	muli = { fn = function(regs, a, b) return regs[a] * b end,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." * "..b..";") end },
	banr = { fn = function(regs, a, b) return BAND(regs[a],regs[b]) end,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." & r"..b..";") end },
	bani = { fn = function(regs, a, b) return BAND(regs[a], b) end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." & "..b..";") end},
	borr = { fn = function(regs, a, b) return BOR(regs[a],regs[b]) end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." | r"..b..";") end},
	bori = { fn = function(regs, a, b) return BOR(regs[a], b) end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." | "..b..";") end},
	setr = { fn = function(regs, a, b) return regs[a] end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a..";") end},
	seti = { fn = function(regs, a, b) return a end,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = "..a..";") end },
	gtir = { fn = function(regs, a, b) return (a > regs[b]) and 1 or 0 end,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = "..a.." > r"..b..";") end },
	gtri = { fn = function(regs, a, b) return (regs[a] > b) and 1 or 0 end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." > "..b..";") end},
	gtrr = { fn = function(regs, a, b) return (regs[a] > regs[b]) and 1 or 0 end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." > r"..b..";") end},
	eqir = { fn = function(regs, a, b) return (a == regs[b]) and 1 or 0 end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = "..a.." == r"..b..";") end},
	eqri = { fn = function(regs, a, b) return (regs[a] == b) and 1 or 0 end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." == "..b..";") end},
	eqrr = { fn = function(regs, a, b) return (regs[a] == regs[b]) and 1 or 0 end ,
	         pr=function(ip,a,b,c) print("L"..ip..": r"..c.." = r"..a.." == r"..b..";") end},
}

l = io.read("*line")
ipr = l:match("%#ip (%d)")
ipr = tonumber(ipr)

rom = {}
romp = 0
print("IP IS r"..ipr)
print("r0 = 1;")
while true do
	l = io.read("*line")
	if not l then break end
	
	insn,a,b,c = l:match("(....) (%d+) (%d+) (%d+)")
	a = tonumber(a)
	b = tonumber(b)
	c = tonumber(c)
	
	opcs[insn].pr(romp, a,b,c)
	romp = romp + 1
end

