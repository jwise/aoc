seats = {}

sidmax = 0
while true do
	line = io.read("*line")
	if not line then break end
	
	local rmin,rmax,cmin,cmax = 0,127,0,7
	for c in line:gmatch(".") do
		if c == "F" then
			rmax = (rmax - rmin + 1) / 2 - 1 + rmin
		elseif c == "B" then
			rmin = (rmax - rmin + 1) / 2 + rmin
		elseif c == "L" then
			cmax = (cmax - cmin + 1) / 2 - 1 + cmin
		elseif c == "R" then
			cmin = (cmax - cmin + 1) / 2 + cmin
		else
			abort()
		end
	end
	local sid = rmin * 8 + cmin
	if sid > sidmax then
		sidmax = sid
	end
	seats[sid] = true
end

for i=0,(127*8+7) do
	if seats[i-1] and not seats[i] and seats[i+1] then print(i) end
end
