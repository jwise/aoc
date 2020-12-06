seats = {}

grp = {}
nppl = 0
totkeys = 0
while true do
	line = io.read("*line")
	if not line then break end
	
	if line == "" then
		local nkeys = 0
		for k,v in pairs(grp) do
			if v == nppl then
				nkeys = nkeys + 1
			end
		end
		print(nkeys)
		totkeys = totkeys + nkeys
		grp = {}
		nppl = 0
	else
		for c in line:gmatch(".") do
			grp[c] = (grp[c] or 0) + 1
		end
		nppl = nppl + 1
	end
end

print(totkeys)