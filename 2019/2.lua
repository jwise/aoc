line = io.read("*line")

iarr = {}
pos = 0
for n in line:gmatch("%d+") do
	iarr[pos] = tonumber(n)
	pos = pos + 1
end

for a1=0,99 do
for a2= 0,99 do

arr = {}
for k,v in pairs(iarr) do
	arr[k] = v
end

arr[1] = a1
arr[2] = a2

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

if arr[0] == 19690720 then
	print(a1,a2)
	break
end

end
end

