p1 = {}
p2 = {}

io.read("*line") -- "Player 1"
while true do
	local line = io.read("*line")
	if line == "" then break end
	
	table.insert(p1, tonumber(line))
end

io.read("*line") -- "Player 2"
while true do
	local line = io.read("*line")
	print(line)
	if not line then break end
	
	table.insert(p2, tonumber(line))
end

while #p1 > 0 and #p2 > 0 do
	print(#p1, #p2)
	local n1 = table.remove(p1, 1)
	local n2 = table.remove(p2, 1)
	
	if n1 > n2 then
		table.insert(p1, n1)
		table.insert(p1, n2)
	else
		table.insert(p2, n2)
		table.insert(p2, n1)
	end
end

local winner = #p1 > 0 and p1 or p2
local total = 0
for i=1,#winner do
	print(winner[i])
	total = total + winner[i] * (#winner - i + 1)
end
print(total)