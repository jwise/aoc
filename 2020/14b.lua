mem = {}
maskset = 0
maskclr = 0
maskz   = {}

function setall(bitn, adr, da)
	if bitn == 36 then
		--print(adr, da)
		mem[adr] = da
		return
	end
	if maskz[bitn] then
		adr = adr & ~(1 << bitn)
		setall(bitn + 1, adr | (1 << bitn), da)
		setall(bitn + 1, adr              , da)
	else
		setall(bitn + 1, adr              , da)
	end
end

while true do
	local line = io.read("*line")
	if not line then break end
	
	if line:match("mask = ") then
		bitstr = line:match("mask = (.+)")
		maskset = 0
		maskclr = 0
		maskz   = {}
		bitn    = 35
		for c in bitstr:gmatch(".") do
			maskset = maskset * 2
			maskclr = maskclr * 2
			if c == "0" then maskclr = maskclr + 1
			elseif c == "1" then maskset = maskset + 1
			elseif c == "X" then maskz[bitn] = true
			end
			bitn = bitn - 1
		end
	else
		local adr,da = line:match("mem.(%d+). = (%d+)")
		adr = tonumber(adr)
		da = tonumber(da)
		
		adr = adr | maskset
		setall(0, adr, da)
	end
end

local tot = 0
for adr,da in pairs(mem) do
	--print(adr,da)
	tot = tot + da
end
print(tot)
