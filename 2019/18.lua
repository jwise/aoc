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
		elseif iskey(c) or iskey(c:lower()) then allkeys[c:upper()] = true
		elseif c == "#" or c == "." then
		else
			abort()
		end
		table.insert(r, c)
	end
	table.insert(map, r)
end

function set(a,y,x,v) if not a[y] then a[y] = {} end a[y][x] = v end
function get(a,y,x  ) if not a[y] then a[y] = {} end return a[y][x] end

function memoize(mem,y,x,keys,v)
	local s = y .. "," .. x .. ","
	for i = ("A"):byte(),("Z"):byte() do
		local c = string.char(i)
		if keys[c] then s = s .. c end
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
		if get(visited,y,x) then return end
		if not passable[map[y][x]] and not iskey(map[y][x]) then return end
		set(visited,y,x,true)
		if iskey(map[y][x]) and not passable[map[y][x]:upper()] then
			keys[map[y][x]:upper()] = {x = x, y = y, dist = dist}
		else
			dfs(y-1,x,   dist + 1)
			dfs(y+1,x,   dist + 1)
			dfs(y,  x-1, dist + 1)
			dfs(y,  x+1, dist + 1)
		end
	end
	dfs(yn,xn,0)
	
	memoize(availmem,yn,xn,passable,keys)
	
	return keys
end

local shortmem = {}
function shortest(y,x,keys)
	keys["@"] = true
	keys["."] = true
	
	-- do we have all the keys?
	local hasall = true
	local k, v
	for k,v in pairs(allkeys) do
		if not keys[k] then hasall = false end
	end
	if hasall then return 0,"" end

	local vposs = memoize(shortmem,y,x,keys)
	if vposs then return vposs.a,vposs.b end

	local options = availkeys(map,y,x,keys)
	
	-- try all the options and see which is shortest
	local bestdist = 9999999
	local bestpdist = 999999
	local bestc = ""
	local key, params
	for key,params in pairs(options) do
		if not keys[key] then
			local newkeys = {}
			local k, v
			for k,v in pairs(keys) do
				newkeys[k] = v
			end
			
			newkeys[key] = true
			local sh,c = shortest(params.y, params.x, newkeys)
			local ndist = params.dist + sh
			
			if ndist < bestdist or (ndist == bestdist and params.dist < bestpdist) then
				bestdist = ndist
				bestpdist = params.dist
				bestc = params.dist .. "->" .. key .. "->".. c
			end
		end
	end
	
	memoize(shortmem,y,x,keys,{a = bestdist, b = bestc})
	return bestdist, bestc
end
print(shortest(starty, startx, {}))
