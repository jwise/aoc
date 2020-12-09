SZ = 25

ns = {}

while true do
	line = io.read("*line")
	if not line then break end
	
	table.insert(ns, tonumber(line))
end

for i=SZ+1,#ns do
	-- search for a pair for which ns[n0] + ns[n1] = i
	local foundone = false
	print(i)
	for n0=i-25,i-1 do
		for n1=i-25,i-1 do
			if (ns[n0] + ns[n1] == ns[i]) and n0 ~= n1 then
				foundone = true
				break
			end
		end
		if foundone then break end
	end
	if not foundone then print(ns[i]) end
end
