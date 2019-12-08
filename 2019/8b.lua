line = io.read("*line")

msg = {}
sz = 25*6
pos = 0
x = 0
y = 0
ls = {}
for c in line:gmatch("......................................................................................................................................................") do
	table.insert(ls, c)
end

for l=#ls,1,-1 do
	print(l)
for c in ls[l]:gmatch(".") do
	if not msg[y] then msg[y] = {} end
	if c == "0" then msg[y][x] = " " end
	if c == "1" then msg[y][x] = "#" end
	
	x = x + 1
	if x == 25 then x = 0 y = y + 1 end
	if y == 6 then y = 0 end
end
end

print(x,y)

for y=0,5 do
	s = ""
	for x=0,24 do
		s = s .. msg[y][x]
	end
	print(s)
end
