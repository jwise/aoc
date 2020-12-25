local pk1 = tonumber(io.read("*line"))
local pk2 = tonumber(io.read("*line"))

function getloopsz(pk)
	local lsz = 0
	local val = 1
	local subjn = 7
	while val ~= pk do
		lsz = lsz + 1
		val = val * subjn
		val = val % 20201227
	end
	return lsz
end

lsz1 = getloopsz(pk1)
lsz2 = getloopsz(pk2)
print(lsz1, lsz2)

local val = 1
local subjn = pk1
for i=1,lsz2 do
	val = val * subjn
	val = val % 20201227
end
print(val)