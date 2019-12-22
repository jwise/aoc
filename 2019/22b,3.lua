local NCARDS = tonumber(arg[1]) or 10007
local LOOKINGFOR = tonumber(arg[2]) or 2019

local pos = LOOKINGFOR

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
	table.insert(ops, function (p) return (p * modinverse(incr, NCARDS)) end)
--	print("* "..incr)
end
function op_cut(cutn)
	table.insert(ops, function(p)
		return (p + cutn) % NCARDS
	end)
--	print("% ".. NCARDS .. " + "..(NCARDS - cutn))
end
function op_rev()
	table.insert(ops, function(p) return (NCARDS - p - 1) end)
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

for i=1,tonumber(arg[3]) or 1 do
	for i = #ops,1,-1 do
		pos = ops[i](pos)
	end
	pos = pos % NCARDS
end

print(pos)
