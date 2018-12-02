three = 0
two = 0
while true do
	l = io.read("*line")
	if not l then break end
	c = {}
	for i in l:gmatch(".") do
		c[i] = (c[i] or 0) + 1
	end
	hastwo = false
	hasthree = false
	for k,v in pairs(c) do
		if v == 2 then hastwo = true end
		if v == 3 then hasthree = true end
	end
	if hastwo then two = two + 1 end
	if hasthree then three = three + 1 end
end

print(two, three, two * three)
