starty = 0
startx = 0

function iskey(c)
	return c:byte() >= ("a"):byte() and c:byte() <= ("z"):byte() 
end
allkeys = {}

map = {}
while true do
	local l = io.read("*line")
	if not l then break end
	
	local r = {}
	local c
	for c in l:gmatch(".") do
		if c == "@" then
			starty = #map + 1
			startx = #r + 1
			c = "."
		elseif iskey(c) then allkeys[c:upper()] = true
		elseif iskey(c:lower()) then
		elseif c == "#" or c == "." then
		else
			abort()
		end
		table.insert(r, c)
	end
	table.insert(map, r)
end

map[starty-1][startx  ] = "#"
map[starty+1][startx  ] = "#"
map[starty  ][startx-1] = "#"
map[starty  ][startx+1] = "#"

function set(a,y,x,v) if not a[y] then a[y] = {} end a[y][x] = v end
function get(a,y,x  ) if not a[y] then a[y] = {} end return a[y][x] end

function memoize(mem,y,x,keys,v)
	local s = y .. "," .. x .. ","
	for k,v in pairs(allkeys) do
		if keys[k] then s = s .. k end
	end
	if mem[s] then return mem[s] end
	if v then mem[s] = v end
end

local availmem = {}
function availkeys(map,yn,xn,passable)
	passable["."] = true
	passable["@"] = true

	local vposs = memoize(availmem,yn,xn,passable)
	if vposs then return vposs end

	local keys = {}
	local visited = {}
	
	-- iteratively search
	function dfs(y,x,dist)
		if get(visited,y,x) and get(visited,y,x) <= dist then return end
		set(visited,y,x,dist)
		if not passable[map[y][x]] and not iskey(map[y][x]) then return end
		if iskey(map[y][x]) and not passable[map[y][x]:upper()] then -- key that we do not already have
			keys[map[y][x]:upper()] = {x = x, y = y, dist = dist}
		else
			dfs(y-1, x  , dist + 1)
			dfs(y+1, x  , dist + 1)
			dfs(y  , x-1, dist + 1)
			dfs(y  , x+1, dist + 1)
		end
	end
	dfs(yn, xn, 0)
	
	memoize(availmem,yn,xn,passable,keys)
	return keys
end

function memoize_rs(mem,rs,keys,v)
	local s = ""
	for _,r in ipairs(rs) do
		s = s .. r.y .. "," .. r.x .. ","
	end
	for k,v in pairs(allkeys) do
		if keys[k] then s = s .. k end
	end
	if mem[s] then return mem[s] end
	if v then mem[s] = v end
end

local shortmem = {}
function shortest(rs,keys,d)
	keys["@"] = true
	keys["."] = true
	
	-- do we have all the keys?
	local hasall = true
	local k, v
	for k,v in pairs(allkeys) do
		if not keys[k] then hasall = false end
	end
	if hasall then return 0,"" end

	local vposs = memoize_rs(shortmem,rs,keys)
	if vposs then return vposs.a,vposs.b end

	local options = {}
	for rn,r in ipairs(rs) do
		local roptions = availkeys(map,r.y,r.x,keys)
		for k,v in pairs(roptions) do
			options[k] = { x = v.x, y = v.y, dist = v.dist, r = rn }
		end
	end
	if d == 0 then print(#options) end
	
	-- try all the options and see which is shortest
	local bestdist = 9999999
	local bestpdist = 9999999
	local bestc = ""
	local key, params
	for key, params in pairs(options) do
		local newkeys = {}
		local k, v
		for k,v in pairs(keys) do
			newkeys[k] = v
		end
		
		newkeys[key] = true
		
		local oldrx = rs[params.r].x
		local oldry = rs[params.r].y
		
		rs[params.r].x = params.x
		rs[params.r].y = params.y
		
		local sh,c = shortest(rs, newkeys, d+1)
		local ndist = params.dist + sh
		
		rs[params.r].x = oldrx
		rs[params.r].y = oldry
		
		if ndist < bestdist or (ndist == bestdist and params.dist < bestpdist) then
			bestdist = ndist
			bestpdist = params.dist
			bestc = key .. c
		end
	end
	
	memoize_rs(shortmem,rs,keys,{a = bestdist, b = bestc})
	return bestdist, bestc
end

local rs = {
	{ x = startx - 1, y = starty - 1 },
	{ x = startx - 1, y = starty + 1 },
	{ x = startx + 1, y = starty - 1 },
	{ x = startx + 1, y = starty + 1 }
}

print(shortest(rs, {}, 0))
