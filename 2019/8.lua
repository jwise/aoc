line = io.read("*line")

ls = {}
sz = 25*6
pos = 0
n0 = 0
n1 = 0
n2 = 0
for c in line:gmatch(".") do
	if c == "0" then n0 = n0 + 1 end
	if c == "1" then n1 = n1 + 1 end
	if c == "2" then n2 = n2 + 1 end
	pos = pos + 1
	if pos == sz then
		table.insert(ls, { n0 = n0, n1 = n1, n2 = n2 })
		pos = 0
		n0 = 0
		n1 = 0
		n2 = 0
	end
end

print(pos)
print(#ls)

min0 = 99999
prod12 = nil
for _,v in ipairs(ls) do
	if v.n0 < min0 then
		prod12 = v.n1 * v.n2
		min0 = v.n0
	end
end
print(prod12)