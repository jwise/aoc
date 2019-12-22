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
	local FAC = 32
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

while true do
	local line = io.read("*line")
	if not line then break end
	
	if line:match("deal with increment (.*)") then
		local incr = tonumber(line:match("deal with increment (.*)"))
		add = safemodmul(add, incr, NCARDS)
		mul = safemodmul(mul, incr, NCARDS)
	elseif line:match("cut (.*)") then
		local cutn = tonumber(line:match("cut (.*)"))
		if cutn < 0 then
			cutn = -cutn
			cutn = NCARDS - cutn
		end
		add = add % NCARDS
		mul = mul % NCARDS
		add = add + NCARDS - cutn
	elseif line:match("deal into new stack") then
		add = ((-add) + NCARDS - 1) % NCARDS
		mul = (-mul) % NCARDS
	else
		abort()
	end
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

