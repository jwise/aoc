fuel = 0
basefuel = 0
needed = {}
while true do
	line = io.read("*line")
	if not line then break end
	n = tonumber(line)
	table.insert(needed, n)
	basefuel = basefuel + math.floor(n / 3) - 2
end

while #needed > 0 do
	n = table.remove(needed, 1)
	thisfuel = math.floor(n / 3) - 2
	if thisfuel > 0 then
		fuel = fuel + thisfuel	
		table.insert(needed, thisfuel)
	end
end
print(basefuel)
print(fuel)
