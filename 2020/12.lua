dirs = { { x = 1, y = 0 }, { x = 0, y = 1 }, { x = -1, y = 0 }, { x = 0, y = -1 }}
cdir = 1

cx = 0
cy = 0

while true do
	line = io.read("*line")
	if not line then break end
	
	cmd,par = line:match("(.)(%d+)")
	par = tonumber(par)
	
	if cmd == "N" then cy = cy - par
	elseif cmd == "S" then cy = cy + par
	elseif cmd == "E" then cx = cx + par
	elseif cmd == "W" then cx = cx - par
	elseif cmd == "F" then
		cx = cx + dirs[cdir].x * par
		cy = cy + dirs[cdir].y * par
	elseif cmd == "L" then
		local amt = par / 90
		cdir = (cdir - 1 + 8 - amt) % 4 + 1
	elseif cmd == "R" then
		local amt = par / 90
		cdir = (cdir - 1 + 8 + amt) % 4 + 1
	else
		abort()
	end
end

print(math.abs(cx)+math.abs(cy))
