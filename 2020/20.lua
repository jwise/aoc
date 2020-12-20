tiles = {}

local reftn = nil
while true do
	local line = io.read("*line")
	if not line then break end
	
	local tn = line:match("Tile (%d+):")
	tn = tonumber(tn)
	local rows = {}
	while true do
		local line = io.read("*line")
		if line == "" or line == nil then break end
		
		local row = {}
		for c in line:gmatch(".") do
			table.insert(row, c == "#")
		end
		table.insert(rows, row)
	end
	tiles[tn] = rows
	tiles[tn].props = {}
	reftn = tn
	-- props.{n,s,e,w} = nil means not checked, false means no match
end

local NROWS = #tiles[reftn]
local NCOLS = #(tiles[reftn][1])
assert(NROWS == NCOLS)

function iseq(col1,col2,flip)
	-- returns false if unflipped, true if flipped, nil if neither.  be careful!
	if flip == false or flip == nil then
		local isnorm = true
		for i=1,#col1 do
			if col2[i] ~= col1[i] then isnorm = false break end
		end
		if isnorm == true then
			return false
		end
	end
	if flip == true or flip == nil then
		local isflip = true
		for i=1,#col1 do
			if col2[i] ~= col1[NCOLS-i+1] then isflip = false break end
		end
		if isflip == true then
			return true
		end
	end
	return nil
end

function cmpflip(flip1,flip2)
	if flip1 == nil or flip2 == nil then return nil end
	return flip1 ^ flip2
end

function mkrow(tile, rown, flip)
	local col = {}
	for i=1,NCOLS do
		table.insert(col, tile[rown][flip and (NCOLS-i+1) or i])
	end
	return col
end

function mkcol(tile, coln, flip)
	local col = {}
	for i=1,NROWS do
		table.insert(col, tile[flip and (NCOLS-i+1) or i][coln])
	end
	return col
end

function colside(tile,side)
	    if side == "n" then return mkrow(tile, 1)
	elseif side == "s" then return mkrow(tile, NROWS)
	elseif side == "e" then return mkcol(tile, NCOLS)
	elseif side == "w" then return mkcol(tile, 1)
	else print(side) abort()
	end
end

dual = {
	n = "s",
	s = "n",
	e = "w",
	w = "e"
}

rotl = {
	n = "w",
	w = "s",
	s = "e",
	e = "n"
}

rotr = {
	n = "e",
	e = "s",
	s = "w",
	w = "n"
}

isns = { n = true, s = true }

function doflip(tile1, tile, fromedge, toedge, flip)
	assert(not tile.props.n and not tile.props.s and not tile.props.e and not tile.props.w)

	if fromedge == dual[toedge] then
		-- print("",0,flip)
	elseif fromedge == toedge then -- i.e., north side is glued to north side of something else -- rotate 180 degrees
		-- print("",180,flip)
		local rows = {}
		for y=1,#tile do
			table.insert(rows, mkrow(tile, NROWS - y + 1, true))
		end
		for y=1,#rows do
			tile[y] = rows[y]
		end
	elseif fromedge == rotl[toedge] then -- i.e., north side is glued to east side of something else -- rotate 90 degrees right
		-- print("","R",flip)
		-- ... so the east side needs to be on the south side
		-- ... so the west side is on the north side
		-- ... so the west side goes at the top
		local rows = {}
		for x=1,#tile do
			table.insert(rows, mkcol(tile, x, true)) 
		end
		for x=1,#tile do
			tile[x] = rows[x]
		end
		--flip = not flip
	elseif fromedge == rotr[toedge] then -- i.e., north side is glued to west side of something else -- rotate 90 degrees left
		-- print("","L",flip)
		-- ... so the east side goes at the top
		local rows = {}
		for x=1,#tile do
			table.insert(rows, mkcol(tile, NROWS - x + 1))
		end
		for x=1,#tile do
			tile[x] = rows[x]
		end
		--flip = not flip
	end
	
	-- Now tile is aligned correctly with tile1 s.t.  tile1's fromedge
	-- is lined up with tile2's dual[fromedge], but it may or may not be
	-- correctly flipped.
	flip = iseq(colside(tile1, fromedge), colside(tile, dual[fromedge]))
	assert(flip ~= nil)
	
	if flip then
		local rows = {}
		if isns[fromedge] then
			for y=1,#tile do
				table.insert(rows, mkrow(tile, y, true))
			end
		else
			for y=1,#tile do
				table.insert(rows, tile[NROWS - y + 1])
			end
		end
		for y=1,#rows do
			tile[y] = rows[y]
		end
	end
	tile.locked = true
end

function fnbr(tn, edge)
	local col = colside(tiles[tn], edge)
	
	local tile = tiles[tn]
	-- find a neighbor tile
	for tn2,tile2 in pairs(tiles) do
		if tn ~= tn2 then
			if tile2.locked then
				if iseq(col, colside(tile2, dual[edge]), false) ~= nil then
					return tn2
				end
			else
				local matchflip = iseq(col, colside(tile2, "n"), nil)
				if matchflip ~= nil then
					-- print("doflip: ".. tn.. edge .. " -> " .. tn2 .. "n", matchflip)
					doflip(tile, tile2, edge, "n", matchflip)
					return tn2
				end
				
				local matchflip = iseq(col, colside(tile2, "s"), nil)
				if matchflip ~= nil then
					-- print("doflip: ".. tn.. edge .. " -> " .. tn2 .. "s", matchflip)
					doflip(tile, tile2, edge, "s", matchflip)
					return tn2
				end
				
				local matchflip = iseq(col, colside(tile2, "e"), nil)
				if matchflip ~= nil then
					-- print("doflip: ".. tn.. edge .. " -> " .. tn2 .. "e", matchflip)
					doflip(tile, tile2, edge, "e", matchflip)
					return tn2
				end
				
				local matchflip = iseq(col, colside(tile2, "w"), nil)
				if matchflip ~= nil then
					-- print("doflip: ".. tn.. edge .. " -> " .. tn2 .. "w", matchflip)
					doflip(tile, tile2, edge, "w", matchflip)
					return tn2
				end
			end
		end
	end
	return nil
end

tileq = { reftn }
tiles[reftn].locked = true
function ins(tn)
	-- print(tn)
	if not tiles[tn].visited then table.insert(tileq, tn) end
end

function sedge(col)
	local s = ""
	for _,v in ipairs(col) do
		s = s .. (v and "#" or ".")
	end
	return s
end

while #tileq > 0 do
	local tn = table.remove(tileq, 1)
	local tile = tiles[tn]
	
	tile.visited = true
	assert(tile.locked)
	if tile.props.n == nil then
		tile.props.n = fnbr(tn, "n")
		if tile.props.n then
			tiles[tile.props.n].props.s = tn
			ins(tile.props.n)
		end
	end
	
	if tile.props.s == nil then
		tile.props.s = fnbr(tn, "s")
		if tile.props.s then
			tiles[tile.props.s].props.n = tn
			ins(tile.props.s)
		end
	end
	
	if tile.props.w == nil then
		-- make a row from the west column
		tile.props.w = fnbr(tn, "w")
		if tile.props.w then
			tiles[tile.props.w].props.e = tn
			ins(tile.props.w)
		end
	end
	
	if tile.props.e == nil then
		-- make a row from the west column
		tile.props.e = fnbr(tn, "e")
		if tile.props.e then
			tiles[tile.props.e].props.w = tn
			ins(tile.props.e)
		end
	end

	for _,dir in pairs(dual) do
		if tile.props[dir] then
			local ldir = sedge(colside(tile, dir))
			local ddir = sedge(colside(tiles[tile.props[dir]], dual[dir]))
			if ldir ~= ddir then
				print(tn, dir, ldir, tile.props[dir], dual[dir], ddir)
				abort()
			end
		end
	end
end


print"..."
--print(sedge(colside(tiles[2473], "w")))
--print(sedge(colside(tiles[1427], "e")))

local prod = 1
for tn,tile in pairs(tiles) do
	local ncorners = 0
	if tile.props.n then ncorners = ncorners + 1 end
	if tile.props.s then ncorners = ncorners + 1 end
	if tile.props.e then ncorners = ncorners + 1 end
	if tile.props.w then ncorners = ncorners + 1 end
	--print(tn,tile.locked,tile.props.n,tile.props.s,tile.props.e,tile.props.w,ncorners)
	if ncorners == 2 then prod = prod * tn end
end
print(prod)

-- Let's go looking for sea monsters.
-- Find the NW (TL) corner based on the refernece tile.
local tn = reftn
while tiles[tn].props.w do
	tn = tiles[tn].props.w
end
while tiles[tn].props.n do
	tn = tiles[tn].props.n
end

assert(not tiles[tn].props.n)
assert(not tiles[tn].props.w)

pictar = {}
npels = 0
while tn do
	local lines = {}
	for i=2,NROWS-1 do
		local line = {}
		table.insert(lines, line)
		table.insert(pictar, line)
	end
	local xtn = tn
	while xtn do
		for y=2,NROWS-1 do
			for x=2,NCOLS-1 do
				table.insert(lines[y-1], tiles[xtn][y][x])
				if tiles[xtn][y][x] then npels = npels + 1 end
			end
		end
		xtn = tiles[xtn].props.e
	end
	tn = tiles[tn].props.s
end

-- print(#pictar, #pictar[1])

-- Here's a sea monster.
seamonster = 
"                  O \n"..
"O    OO    OO    OOO\n"..
" O  O  O  O  O  O   \n"

scoords = {}
y = 0
x = 0
for line in seamonster:gmatch("[^\n]+") do
	x = 0
	for c in line:gmatch(".") do
		if c == "O" then
			table.insert(scoords, { x = x, y = y })
		end
		x = x + 1
	end
	y = y + 1
end
smszx, smszy = x, y

-- Find a sea monster, given an scoords, and produce the coordinates of the
-- sea monsters.
function findsm(pictar, scoords)
	local monsts = {}
	for y=1,#pictar do
		for x=1,#pictar[1] do
			local foundsm = true
			for _,sc in ipairs(scoords) do
				if not pictar[y+sc.y] or not pictar[y+sc.y][x+sc.x] then
					foundsm = false
					break
				end
			end
			if foundsm then
				table.insert(monsts, {x = x, y = y})
			end
		end
	end
	return monsts
end

function transpose(pictar)
	local pictar2 = {}
	for y=1,#pictar do
		local row = {}
		for x=1,#pictar do
			table.insert(row, pictar[x][y])
		end
		table.insert(pictar2, row)
	end
	return pictar2
end

function flipx(pictar)
	local pictar2 = {}
	for y=1,#pictar do
		local row = {}
		for x=1,#pictar do
			table.insert(row, pictar[y][#pictar-x+1])
		end
		table.insert(pictar2, row)
	end
	return pictar2
end

function flipy(pictar)
	local pictar2 = {}
	for y=1,#pictar do
		local row = {}
		for x=1,#pictar do
			table.insert(row, pictar[#pictar-y+1][x])
		end
		table.insert(pictar2, row)
	end
	return pictar2
end

function convolve(pictar, n)
	if n & 1 ~= 0 then pictar = transpose(pictar) end
	if n & 2 ~= 0 then pictar = flipx(pictar) end
	if n & 4 ~= 0 then pictar = flipy(pictar) end
	return pictar
end

for i=0,7 do
	local npictar = convolve(pictar, i)
	local sms = findsm(npictar, scoords)
	if #sms ~= 0 then
		print(npels - #sms * #scoords)
	end
end
