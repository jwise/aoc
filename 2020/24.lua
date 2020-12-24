map = {} -- white is false

while true do
	local line = io.read("*line")
	if not line then break end
	
	local x = 0
	local y = 0
	
	while line ~= "" do
		    if line:sub(1,1) == "e"  then line = line:sub(2) x = x + 2
		elseif line:sub(1,2) == "se" then line = line:sub(3) x = x + 1 y = y + 1
		elseif line:sub(1,2) == "sw" then line = line:sub(3) x = x - 1 y = y + 1
		elseif line:sub(1,1) == "w"  then line = line:sub(2) x = x - 2
		elseif line:sub(1,2) == "ne" then line = line:sub(3) x = x + 1 y = y - 1
		elseif line:sub(1,2) == "nw" then line = line:sub(3) x = x - 1 y = y - 1
		end
	end
	
	if not map[y] then map[y] = {} end
	map[y][x] = not map[y][x]
end

local flipped = 0
local miny = 0
local maxy = 0
local minx = 0
local maxx = 0
function popcnt()
	local flipped = 0
	for y,r in pairs(map) do
		if y < miny then miny = y end
		if y > maxy then maxy = y end
		for x,c in pairs(r) do
			if x < minx then minx = x end
			if x > maxx then maxx = x end
			if c then flipped = flipped + 1 end
		end
	end
	return flipped
end
print(popcnt())


function get(y,x)
	if not map[y] then return false end
	return map[y][x]
end

function put(nmap,y,x,v)
	if not nmap[y] then nmap[y] = {} end
	nmap[y][x] = v
end

for i=1,100 do
	local nmap = {}
	miny = miny - 1
	maxy = maxy + 1
	minx = minx - 2
	maxx = maxx + 2
	-- minx now -2, -4, ... aligned (i.e., y = 0)
	if minx % 2 == 1 then minx = minx - 1 end
	for y=miny,maxy do
		-- y = 0, x = {-4, -2, 0, 2, 4, ... }
		-- y = 1, x = {-3, -1, 1, 3, ...}
		local ypar = math.abs(y) % 2
		local sx = minx
		if ypar == 1 then sx = minx - 1 end
		for x = sx,maxx,2 do
			local nbrs = 0
			if get(y  , x+2) then nbrs = nbrs + 1 end
			if get(y  , x-2) then nbrs = nbrs + 1 end
			if get(y+1, x+1) then nbrs = nbrs + 1 end
			if get(y+1, x-1) then nbrs = nbrs + 1 end
			if get(y-1, x+1) then nbrs = nbrs + 1 end
			if get(y-1, x-1) then nbrs = nbrs + 1 end
			if get(y,x) then -- black
				if nbrs == 0 or nbrs > 2 then put(nmap,y,x,false) else put(nmap,y,x,true) end
			else
				if nbrs == 2 then put(nmap,y,x,true) else put(nmap,y,x,false) end
			end
		end
	end
	map = nmap
	popcnt() -- update bounds
end
print(popcnt())
