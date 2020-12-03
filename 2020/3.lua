map = {}

while true do
	line = io.read("*line")
	if not line then break end
	r = {}
	for c in line:gmatch(".") do
		table.insert(r, c == "#")
	end
	table.insert(map, r)
end

w = #(map[1])
print(map[2][5])

ntr = 0
for y=1,(#map-1) do
	x = (y * 3)
	x = x % w
	print("",y,x)
	if map[y+1][x+1] then
		print(y,x)
		ntr = ntr+1
	end
end

print(ntr)
