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

ss = {{1,1},{3,1},{5,1},{7,1}}

ntrprod = 1
for _,s in ipairs(ss) do
	ntr = 0
	for y=1,(#map-1),s[2] do
		x = (y * s[1])
		x = x % w
--		print("",y,x)
		if map[y+1][x+1] then
			ntr = ntr+1
		end
	end
	print(ntr)
	ntrprod = ntrprod * ntr
end

	ntr = 0
	for y=2,(#map-1),2 do
		x = y / 2
		x = x % w
--		print(y,x)
		if map[y+1][x+1] then
			ntr = ntr+1
		end
	end
	print(ntr)
	ntrprod = ntrprod * ntr


print(ntrprod)
