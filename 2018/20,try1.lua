l = io.read("*line")

pstart = { len = 0}
ptree = pstart
pstk = {}

depth = 0
maxdepth = 0

for c in l:gmatch(".") do
	function mkone(x,y)
		ptree.x = x
		ptree.y = y
		ptree.move = true
		ptree.next = { len = ptree.len + 1 }
		ptree = ptree.next
	end
	
	function mkchoice()
		ptree = { len = pstk[#pstk].len }
		table.insert(pstk[#pstk].choices, ptree)
	end
	
	if c == "^" then
	elseif c == "$" then
	elseif c == "W" then mkone(-1, 0)
	elseif c == "E" then mkone(1, 0)
	elseif c == "N" then mkone(0, -1)
	elseif c == "S" then mkone(0, 1)
	elseif c == "(" then
		depth = depth + 1
		if depth > maxdepth then
			maxdepth = depth
		end
		ptree.choices = {}
		ptree.next = { len = ptree.len }
		table.insert(pstk, ptree)
		
		mkchoice()
	elseif c == "|" then
		ptree.empty = true
		ptree.next = pstk[#pstk].next
		mkchoice()
	elseif c == ")" then
		depth = depth - 1
		ptree.empty = true
		ptree.next = pstk[#pstk].next
		ptree = table.remove(pstk, #pstk).next
	else abort()
	end
end
ptree.done = true

-- now walk the tree and build the world
map = {}
nrooms = 0
ndoors = 0
maxd = 0
function walk(tree, x, y, d)
	if not tree.visited then tree.visited = {} end
	if not tree.visited[y] then tree.visited[y] = {} end
	if tree.visited[y][x] then return end
	tree.visited[y][x] = true
	if tree.empty then
		return walk(tree.next, x, y, d)
	elseif tree.choices then
		if d > maxd then
			maxd = d
		end
		for _,t2 in ipairs(tree.choices) do
			walk(t2, x, y, d+1)
		end
	elseif tree.move then
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
		local r = getr(y, x)
		if not r.doors[tree.y][tree.x] then r.doors[tree.y][tree.x] = true ndoors = ndoors + 1 end
		local r2 = getr(y+tree.y, x+tree.x)
		if not r2.doors[-tree.y][-tree.x] then r2.doors[-tree.y][-tree.x] = true ndoors = ndoors + 1 end
		return walk(tree.next, x+tree.x, y+tree.y, d)
	elseif tree.done then
		return
	else
		abort()
	end
end

print("parsed -> "..maxdepth)
walk(pstart, 0, 0, 0)
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
