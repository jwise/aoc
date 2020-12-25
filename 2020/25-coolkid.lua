local pk1 = tonumber(io.read("*line"))
local pk2 = tonumber(io.read("*line"))

function getloopsz(pk1, pk2)
	local lsz = 0
	local val = 1
	local subjn = 7
	while val ~= pk1 and val ~= pk2 do
		lsz = lsz + 1
		val = val * subjn
		val = val % 20201227
	end
	if val == pk1 then return 1,lsz
	else return 2,lsz
	end
end

k,lsz = getloopsz(pk1,pk2)
print(k, lsz)

local val = 1
local subjn = k == 1 and pk2 or pk1
for i=1,lsz do
	val = val * subjn
	val = val % 20201227
end
print(val)