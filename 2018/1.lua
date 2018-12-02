n = 0
while true do
	line = io.read("*line")
	if not line then break end
	diff = tonumber(line)
	n = n + diff
end
print(n)
