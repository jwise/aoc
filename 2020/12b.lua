wpx = 10
wpy = -1
cx  = 0
cy  = 0

while true do
	line = io.read("*line")
	if not line then break end
	
	cmd,par = line:match("(.)(%d+)")
	par = tonumber(par)
	
	    if cmd == "N" then wpy = wpy - par
	elseif cmd == "S" then wpy = wpy + par
	elseif cmd == "E" then wpx = wpx + par
	elseif cmd == "W" then wpx = wpx - par
	elseif cmd == "F" then
		cx = cx + wpx * par
		cy = cy + wpy * par
	elseif cmd == "L" then
		for _=1,(par/90) do
			wpx,wpy = wpy, wpx * -1
		end
	elseif cmd == "R" then
		for _=1,(par/90) do
			wpx,wpy = wpy * -1, wpx
		end
	else
		abort()
	end
end

print(math.abs(cx)+math.abs(cy))