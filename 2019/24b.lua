local DIM=5

grid = {}
local y = 0
grid[0] = {}
while true do
	local line = io.read("*line")
	if not line then break end
	
	local x = 0
	local r = {}
	for c in line:gmatch(".") do
		r[x] = c == "#"
		x = x + 1
	end
	grid[0][y] = r
	y = y + 1
end
grid.maxl = 0
grid.minl = 0

function step(g)
	local ng = {}
	function _g(l,y,x)
		return g[l] and g[l][y] and g[l][y][x] and 1 or 0
	end
	local minl, maxl, pop = 0,0,0
	
	for l = grid.minl-1,grid.maxl+1 do
		ng[l] = {}
		local lpop = 0
		for y=0,DIM-1 do
			ng[l][y] = {}
			for x=0,DIM-1 do
				local nbrs = 0
				if x == 0 then
					nbrs = nbrs + _g(l-1, 2, 1)
					nbrs = nbrs + _g(l, y, 1)
				elseif x == 4 then
					nbrs = nbrs + _g(l-1, 2, 3)
					nbrs = nbrs + _g(l, y, 3)
				elseif x == 1 and y == 2 then
					nbrs = nbrs + _g(l, y, 0)
					nbrs = nbrs + _g(l+1, 0, 0)
					nbrs = nbrs + _g(l+1, 1, 0)
					nbrs = nbrs + _g(l+1, 2, 0)
					nbrs = nbrs + _g(l+1, 3, 0)
					nbrs = nbrs + _g(l+1, 4, 0)
				elseif x == 3 and y == 2 then
					nbrs = nbrs + _g(l, y, 4)
					nbrs = nbrs + _g(l+1, 0, 4)
					nbrs = nbrs + _g(l+1, 1, 4)
					nbrs = nbrs + _g(l+1, 2, 4)
					nbrs = nbrs + _g(l+1, 3, 4)
					nbrs = nbrs + _g(l+1, 4, 4)
				else -- well, ok, then
					nbrs = nbrs + _g(l, y, x-1)
					nbrs = nbrs + _g(l, y, x+1)
				end

				if y == 0 then
					nbrs = nbrs + _g(l-1, 1, 2)
					nbrs = nbrs + _g(l, 1, x)
				elseif y == 4 then
					nbrs = nbrs + _g(l-1, 3, 2)
					nbrs = nbrs + _g(l, 3, x)
				elseif y == 1 and x == 2 then
					nbrs = nbrs + _g(l, 0, x)
					nbrs = nbrs + _g(l+1, 0, 0)
					nbrs = nbrs + _g(l+1, 0, 1)
					nbrs = nbrs + _g(l+1, 0, 2)
					nbrs = nbrs + _g(l+1, 0, 3)
					nbrs = nbrs + _g(l+1, 0, 4)
				elseif y == 3 and x == 2 then
					nbrs = nbrs + _g(l, 4, x)
					nbrs = nbrs + _g(l+1, 4, 0)
					nbrs = nbrs + _g(l+1, 4, 1)
					nbrs = nbrs + _g(l+1, 4, 2)
					nbrs = nbrs + _g(l+1, 4, 3)
					nbrs = nbrs + _g(l+1, 4, 4)
				else -- well, ok, then
					nbrs = nbrs + _g(l, y-1, x)
					nbrs = nbrs + _g(l, y+1, x)
				end
				
				if l == -1 and y == 2 and x == 3 then
				--	print(nbrs, _g(l,y,x))
				end

				if _g(l,y,x) == 1 then
					ng[l][y][x] = nbrs == 1
				else
					ng[l][y][x] = nbrs == 1 or nbrs == 2
				end
				
				if y ~= 2 or x ~= 2 then
					lpop = lpop + (ng[l][y][x] and 1 or 0)
				end
			end
		end
		if lpop > 0 then
			if l < minl then minl = l end
			if l > maxl then maxl = l end
		end
		pop = pop + lpop
	end
	ng.minl = minl
	ng.maxl = maxl
	ng.pop = pop
	return ng
end

for i=1,(tonumber(arg[1]) or 10) do
	grid = step(grid)
	
	if arg[2] then
	for l=grid.minl,grid.maxl do
		print("Layer "..l)
		for y=0,DIM-1 do
			local s = ""
			for x=0,DIM-1 do
				s = s .. (grid[l][y][x] and "#" or ".")
			end
			print(s)
		end
	end
	end
end
print(grid.pop)
