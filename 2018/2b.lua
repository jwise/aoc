ar = {}
while true do
	l = io.read("*line")
	if not l then break end
	c = {}
	for i in l:gmatch(".") do
		table.insert(c, i)
	end
	ar[l] = c
	
	for l1,c1 in pairs(ar) do
		dist = 0
		for k,v in ipairs(c) do
			if c1[k] ~= v then dist = dist + 1 end
		end
		if dist == 1 then print(l1) print(l) end
	end
end
