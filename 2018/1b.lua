n = 0
seen = {}
seen[0] = true
while true do
	line = io.read("*line")
	if not line then break end
	diff = tonumber(line)
	n = n + diff
	if seen[n] then print(n) return end
	seen[n] = true
end
print "a"
