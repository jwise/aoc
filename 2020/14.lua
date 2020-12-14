mem = {}
maskset = 0
maskclr = 0
while true do
	local line = io.read("*line")
	if not line then break end
	
	if line:match("mask = ") then
		bitstr = line:match("mask = (.+)")
		maskset = 0
		maskclr = 0
		for c in bitstr:gmatch(".") do
			maskset = maskset * 2
			maskclr = maskclr * 2
			if c == "0" then maskclr = maskclr + 1
			elseif c == "1" then maskset = maskset + 1
			end
		end
	else
		adr,da = line:match("mem.(%d+). = (%d+)")
		adr = tonumber(adr)
		da = tonumber(da)
		mem[adr] = (da | maskset) & ~maskclr
	end
end

local tot = 0
for adr,da in pairs(mem) do
	print(adr,da)
	tot = tot + da
end
print(tot)
