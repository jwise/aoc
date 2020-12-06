seats = {}

grp = {}
totkeys = 0
while true do
	line = io.read("*line")
	if not line then break end
	
	if line == "" then
		local nkeys = 0
		for k,v in pairs(grp) do
			nkeys = nkeys + 1
		end
		print(nkeys)
		totkeys = totkeys + nkeys
		grp = {}
	else
		for c in line:gmatch(".") do
			grp[c] = true
		end
	end
end

print(totkeys)