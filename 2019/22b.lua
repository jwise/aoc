local NCARDS = tonumber(arg[1]) or 10007
local LOOKINGFOR = tonumber(arg[2]) or 2019

local pos = LOOKINGFOR

ops = {}
function op_incr(incr)
	table.insert(ops, function (p) return (p * incr) end)
--	print("* "..incr)
end
function op_cut(cutn)
	table.insert(ops, function(p)
		return ((p % NCARDS) + NCARDS - cutn)
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
	for _,f in ipairs(ops) do
		pos = f(pos)
	end
	pos = pos % NCARDS
end

print(pos)
