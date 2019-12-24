local DIM=5

grid = {}
local y = 0
while true do
	local line = io.read("*line")
	if not line then break end
	
	local x = 0
	local r = {}
	for c in line:gmatch(".") do
		r[x] = c == "#"
		x = x + 1
	end
	grid[y] = r
	y = y + 1
end

function gbiod(grid)
	local v = 0
	for y=0,DIM-1 do
		for x=0,DIM-1 do
			if grid[y][x] then
				v = v | (1 << (y * 5 + x))
			end
		end
	end
	return v
end

function step(g)
	local ng = {}
	for y=0,DIM-1 do
		ng[y] = {}
		for x=0,DIM-1 do
			local nbrs = 0
			for yd=-1,1 do
				for xd=-1,1 do
					if (yd ~= 0 or xd ~= 0) and (xd == 0 or yd == 0) and g[y+yd] and g[y+yd][x+xd] then
						nbrs = nbrs + 1
					end
				end
			end
			if g[y][x] then
				ng[y][x] = nbrs == 1
			else
				ng[y][x] = nbrs == 1 or nbrs == 2
			end
		end
	end
	return ng
end

local seen = {}
seen[gbiod(grid)] = true

while true do
	for y=0,DIM-1 do
		local s = ""
		for x=0,DIM-1 do
			s = s .. (grid[y][x] and "#" or ".")
		end
--		print(s)
	end
--	print(gbiod(grid))
--	print("")

	grid = step(grid)
	local gb = gbiod(grid)
	
	if seen[gb] then print(gb) break end
	seen[gb] = true
end
