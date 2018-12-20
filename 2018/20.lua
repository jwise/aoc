l = io.read("*line")

map = {}

pstk = {}
table.insert(pstk, { pos = {} })

nrooms = 0
ndoors = 0

function setk(x, y)
	return (x + 10000) * 20000 + y + 10000
end

function putset(set, x, y)
	set[setk(x,y)] = { x = x, y = y }
end

function getset(set, x, y)
	return set[setk(x,y)]
end
putset(pstk[1].pos, 0, 0)

function getr(y, x)
	if not map[y] then map[y] = {} end
	if not map[y][x] then
		map[y][x] = { doors = {} }
		local r = map[y][x]
		r.x = x
		r.y = y
		r.doors[-1] = {}
		r.doors[0] = {}
		r.doors[1] = {}
		nrooms = nrooms + 1
	end
	return map[y][x]
end

function mkdoor(x, y, dx, dy)
	local r0 = getr(y, x)
	if not r0.doors[dy][dx] then r0.doors[dy][dx] = true ndoors = ndoors + 1 end
	local r1 = getr(y+dy, x+dx)
	if not r1.doors[-dy][-dx] then r1.doors[-dy][-dx] = true ndoors = ndoors + 1 end
end

for c in l:gmatch(".") do
	function move(x,y)	
		local newset = {}
		for _,v in pairs(pstk[#pstk].pos) do
			putset(newset, v.x + x, v.y + y)
			mkdoor(v.x, v.y, x, y)
		end
		pstk[#pstk].pos = newset
	end
	
	function cpset(newset, set)
		for k,v in pairs(set) do
			putset(newset, v.x, v.y)
		end
		return newset
	end
	
	if c == "^" then
	elseif c == "$" then
	elseif c == "W" then move(-1, 0)
	elseif c == "E" then move(1, 0)
	elseif c == "N" then move(0, -1)
	elseif c == "S" then move(0, 1)
	elseif c == "(" then
		table.insert(pstk, { pos = cpset({}, pstk[#pstk].pos), accum = {} })
	elseif c == "|" then
		cpset(pstk[#pstk].accum, pstk[#pstk].pos)
		pstk[#pstk].pos = cpset({}, pstk[#pstk-1].pos)
	elseif c == ")" then
		cpset(pstk[#pstk].accum, pstk[#pstk].pos)
		pstk[#pstk-1].pos = pstk[#pstk].accum
		table.remove(pstk, #pstk)
	else abort()
	end
end

print(nrooms, ndoors)

function dist()
	local q = {}
	
	table.insert(q, {x = 0, y = 0, dist = 0})
	-- visit all the rooms once
	while #q ~= 0 do
		local xy = table.remove(q)
		local r = map[xy.y][xy.x]
		if not r.dist or xy.dist < r.dist then
			r.dist = xy.dist
			function try(y,x)
				if r.doors[y][x] and map[xy.y+y] and map[xy.y+y][xy.x+x] then
					table.insert(q, { x = xy.x + x, y = xy.y + y, dist = xy.dist + 1 })
				end
			end
			try(-1,0)
			try(1,0)
			try(0,1)
			try(0,-1)
		end
	end

	local furthest = map[0][0]
	local further1k = 0
	table.insert(q, {x = 0, y = 0})
	-- now find the furthest
	while #q ~= 0 do
		local xy = table.remove(q)
		local r = map[xy.y][xy.x]
		if not r.visited then
			if r.dist > furthest.dist then furthest = r end
			if r.dist >= 1000 then further1k = further1k + 1 end
			r.visited = true
			function try(y,x)
				if r.doors[y][x] and map[xy.y+y] and map[xy.y+y][xy.x+x] then
					table.insert(q, { x = xy.x + x, y = xy.y + y })
				end
			end
			try(-1,0)
			try(1,0)
			try(0,1)
			try(0,-1)
		end
	end
	
	return furthest.dist, further1k
end

print(dist())
