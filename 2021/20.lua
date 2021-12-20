conv = {}
line = io.read("*line")
n = 0
for c in line:gmatch(".") do
	conv[n] = (c == "#") and true or false
	n = n + 1
end
assert(n == 512)
--assert(conv[0] == false)

grid = {}
maxc = 0
while true do
	local line = io.read("*line")
	if not line then break end
	local row = {}
	local x = 0
	for c in line:gmatch(".") do
		row[x] = (c == "#") and true or false
		if x > maxc then maxc = x end
		x = x + 1
	end
	table.insert(grid, row)
end

minr = 1
maxr = #grid
minc = 0

dfl = false

function get(grid,r,c)
	if r < minr then return dfl end
	if r > maxr then return dfl end
	if c < minc then return dfl end
	if c > maxc then return dfl end
	return grid[r][c]
end

function doconv(grid,r,c)
	local convp =
		(get(grid,r-1,c-1) and 256 or 0) +
		(get(grid,r-1,c  ) and 128 or 0) +
		(get(grid,r-1,c+1) and  64 or 0) +
		(get(grid,r  ,c-1) and  32 or 0) +
		(get(grid,r  ,c  ) and  16 or 0) +
		(get(grid,r  ,c+1) and   8 or 0) +
		(get(grid,r+1,c-1) and   4 or 0) +
		(get(grid,r+1,c  ) and   2 or 0) +
		(get(grid,r+1,c+1) and   1 or 0)
	return conv[convp]
end

function step(g)
	local gn = {}
	local count = 0
	for r=minr-2,maxr+2 do
		gn[r] = {}
		for c=minc-2,maxc+2 do
			gn[r][c] = doconv(g,r,c)
			if gn[r][c] then count = count + 1 end
		end
	end
	minc = minc - 2
	maxc = maxc + 2
	minr = minr - 2
	maxr = maxr + 2
	if conv[0] then dfl = not dfl end
	return gn,count
end

g1,c1 = step(grid)
g2,c2 = step(g1)
print(c2)
