line = io.read("*line")

arr = {}
pos = 0
for n in line:gmatch("%d+") do
	arr[pos] = tonumber(n)
	pos = pos + 1
end

arr[1] = 12
arr[2] = 2

adr = 0
while true do
	op = arr[adr]
	s1 = arr[adr+1]
	s2 = arr[adr+2]
	d = arr[adr+3]
	if arr[adr] == 1 then
		arr[d] = arr[s1] + arr[s2]
	elseif arr[adr] == 2 then
		arr[d] = arr[s1] * arr[s2]
	else
		break
	end
	adr = adr + 4
end

print(arr[0])
