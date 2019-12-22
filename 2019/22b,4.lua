local NCARDS = tonumber(arg[1]) or 10007
local LOOKINGFOR = tonumber(arg[2]) or 2019

local pos = LOOKINGFOR

ops = {}
function op_incr(incr)
	table.insert(ops, function (p) return (p * incr) end)
	print("* "..incr)
end
function op_cut(cutn)
	table.insert(ops, function(p)
		return ((p % NCARDS) + NCARDS - cutn)
	end)
	print("% ".. NCARDS .. " + "..(NCARDS - cutn))
end
function op_rev()
	table.insert(ops, function(p) return (NCARDS - p - 1) end)
	print("* -1 + "..(NCARDS - 1))
end

local mul = 1
local add = 0

function safemodmul(a,b,n)
	local FAC = 0x10000
	-- a already < n
	local t = {}
	local acc = 0
	while b > 0 do
		table.insert(t, b % FAC)
		b = b // FAC
	end
	while #t > 0 do
		local p = table.remove(t)
		acc = (acc * FAC) % n
		acc = (acc + (a * p)) % n
	end
	return acc
end

function modinverse(b, m)
	g, x, y = gcd(b, m)
	if g ~= 1 then abort() end
	return x % m
end

function gcd(a, b)
	if a == 0 then return b, 0, 1 end
	local g, x1, y1 = gcd(b % a, a)
	return g, y1 - (b // a) * x1, x1
end

ops = {}
function op_incr(incr)
	print("incr: "..incr)
	local mi = modinverse(incr, NCARDS)
	print("mi: "..mi)
	
	table.insert(ops, function (m,a)
		return safemodmul(m, mi, NCARDS), safemodmul(a, mi, NCARDS)
	end)
end
function op_cut(cutn)
	table.insert(ops, function(m,a)
		return m, (a + cutn) % NCARDS
	end)
--	print("% ".. NCARDS .. " + "..(NCARDS - cutn))
end
function op_rev()
	table.insert(ops, function(m,a)
		return (-m) % NCARDS, ((-a) + NCARDS - 1) % NCARDS
	end)
--	print("* -1 + "..(NCARDS - 1))
end

while true do
	local line = io.read("*line")
	if not line then break end
	
	if line:match("deal with increment (.*)") then
		local incr = tonumber(line:match("deal with increment (.*)"))
		op_incr(incr)
	elseif line:match("cut (.*)") then
		local cutn = tonumber(line:match("cut (.*)"))
		if cutn < 0 then
			cutn = -cutn
			cutn = NCARDS - cutn
		end
		op_cut(cutn)
	elseif line:match("deal into new stack") then
		op_rev()
	else
		abort()
	end
end
for i = #ops,1,-1 do
	mul,add = ops[i](mul,add)
end

print("(A * "..mul.." + "..add..") % "..NCARDS)
print((pos * mul + add) % NCARDS)

function apply(m1, a1, m2, a2)
	-- ((P * M1 + A1) % C * M2 + A2) % C
	-- (P * M1 * M2 + A1 * M2 + A2) % C
	-- (P * (M1 * M2) % C + (A1 * M2 + A2) % C) % C
	return safemodmul(m1, m2, NCARDS), (safemodmul(a1, m2, NCARDS) + a2) % NCARDS
end

local macc = 1
local aacc = 0
local REPS = tonumber(arg[3]) or 1
local REDUCE = tonumber(arg[4]) or 100000

local rrem = REPS
while rrem > 0 do
	local reduced = 1
	macc = mul
	aacc = add
	while reduced * 2 < rrem do
		macc, aacc = apply(macc, aacc, macc, aacc)
		reduced = reduced * 2
	end
	print(reduced .. " reduction factor")
	pos = (safemodmul(pos, macc, NCARDS) + aacc) % NCARDS
	rrem = rrem - reduced
end
print(pos)

