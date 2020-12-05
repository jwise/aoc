seats = {}

sidmax = 0
while true do
	line = io.read("*line")
	if not line then break end
	
	local sid = 0
	local rmin,rmax,cmin,cmax = 0,127,0,7
	for c in line:gmatch(".") do
		sid = sid * 2
		if c == "B" or c == "R" then
			sid = sid + 1
		end
	end
	if sid > sidmax then
		sidmax = sid
	end
	seats[sid] = true
end

for i=0,(127*8+7) do
	if seats[i-1] and not seats[i] and seats[i+1] then print(i) end
end
