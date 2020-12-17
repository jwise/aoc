grid = {}

function put(grid,z,y,x,v)
	if not grid[z] then grid[z] = {} end
	if not grid[z][y] then grid[z][y] = {} end
	grid[z][y][x] = v
end

function get(grid,z,y,x)
	if not grid[z] then return false end
	if not grid[z][y] then return false end
	return grid[z][y][x]
end

function nbrs(grid,z,y,x)
	local n = 0
	for dz=-1,1 do
		for dy=-1,1 do
			for dx=-1,1 do
				if dz ~= 0 or dy ~= 0 or dx ~= 0 then
					if get(grid,z+dz,y+dy,x+dx) then
						n = n + 1
					end
				end
			end
		end
	end
	return n
end

initgrid0 = {}
while true do
	local line = io.read("*line")
	if not line then break end
	local lline = {}
	for c in line:gmatch(".") do
		if c == "#" then table.insert(lline, true)
		else table.insert(lline, false)
		end
	end
	table.insert(initgrid0, lline)
end

initgrid = { [0] = initgrid0, minz = 0, maxz = 0, miny = 1, maxy = #initgrid0, minx = 1, maxx = #initgrid0[1] }

print(get(initgrid,0,2,3))
print(nbrs(initgrid,0,2,3))

function iter(grid)
	local newgrid = {}
	local cells = 0
	for z=grid.minz-1,grid.maxz+1 do
		for y=grid.miny-1,grid.maxy+1 do
			for x=grid.minx-1,grid.maxx+1 do
				local active = get(grid,z,y,x)
				local nnbrs = nbrs(grid,z,y,x)
				if not active then
					active = nnbrs == 3
				elseif active then
					active = nnbrs == 2 or nnbrs == 3
				end
				if active then cells = cells + 1 end
				put(newgrid,z,y,x,active)
			end
		end
	end
	newgrid.minz = grid.minz - 1
	newgrid.maxz = grid.maxz + 1
	newgrid.minx = grid.minx - 1
	newgrid.maxx = grid.maxx + 1
	newgrid.miny = grid.miny - 1
	newgrid.maxy = grid.maxy + 1
	return newgrid, cells
end

grid = initgrid
for i=1,6 do
	for z =grid.minz,grid.maxz do
--		print(z)
		for y=grid.miny,grid.maxy do
			s = ""
			for x=grid.minx,grid.maxx do
				s = s .. (get(grid,z,y,x) and "#" or ".")
			end
--			print(s)
		end
	end
	grid,cells = iter(grid)
	print(i,cells)
end
