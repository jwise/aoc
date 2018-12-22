tx,ty = arg[1]:match("(%d+),(%d+)")
tx = tonumber(tx)
ty = tonumber(ty)
depth = tonumber(arg[2])

elvls = {}
function erosionlvl(x, y)
	if not elvls[y] then elvls[y] = {} end
	if elvls[y][x] then return elvls[y][x] end
	
	local v = nil
	if x == 0 and y == 0 then v = 0
	elseif x == tx and y == ty then v = 0
	elseif y == 0 then v = x * 16807
	elseif x == 0 then v = y * 48271
	else v = erosionlvl(x-1,y) * erosionlvl(x,y-1)
	end
	
	v = (v + depth) % 20183
	elvls[y][x] = v
	return v
end

TORCH = {}
CLIMBING = {}
NEITHER = {}

ROCKY = {r = 0, c = ".", tools = { [CLIMBING] = true, [TORCH] = true }}
WET = {r = 1, c = "=", tools = {[CLIMBING] = true, [NEITHER] = true}}
NARROW = {r = 2, c = "|", tools = {[TORCH] = true, [NEITHER] = true}}
function tipo(x,y)
	local v = erosionlvl(x, y)
	v = v % 3
	if v == 0 then return ROCKY
	elseif v == 1 then return WET
	elseif v == 2 then return NARROW
	end
end

local sum = 0
for y=0,ty do
	for x = 0,tx do
		local r = tipo(x, y)
		
		sum = sum + r.r
	end
end
print(sum)

-- strategy is: flood fill from [y][x][tool] to get to [ty][tx][torch], go up to [-1000:1000][-1000:1000]
local map = {}
local unvis = {}

function gmap(y,x,tool)
	if not map[y] then map[y] = {} end
	if not map[y][x] then map[y][x] = {} end
	if not map[y][x][tool] then map[y][x][tool] = { y = y, x = x, tool = tool, dist = math.huge, vis = false } end
	return map[y][x][tool]
end

function flood()
	local steps = 0
	gmap(0,0,TORCH).dist = 0
	local cur = map[0][0][TORCH]
	while cur.x ~= tx or cur.y ~= ty or cur.tool ~= TORCH do
		steps = steps + 1
		if steps % 10000 == 0 then io.write("... "..cur.dist.."\r") io.flush() end
		
		function try(y,x)
			y = cur.y + y
			x = cur.x + x
			if y < 0 or x < 0 then return end
			if x > tx * 15 or y > ty * 15 then return end
			if not tipo(x, y).tools[cur.tool] then return end
			local m = gmap(y, x, cur.tool)
			local dprop = cur.dist + 1
			if m.vis then assert(m.dist <= dprop) return end
			if dprop < m.dist then m.dist = dprop end
			unvis[m] = true
		end

		try(-1,0)
		try(1,0)
		try(0,1)
		try(0,-1)
		
		function trytool(tool)
			if cur.tool == tool or not tipo(cur.x,cur.y).tools[tool] then return end
			local m = gmap(cur.y, cur.x, tool)
			local dprop = cur.dist + 7
			if m.vis then assert(m.dist <= dprop) return end
			if dprop < m.dist then m.dist = dprop end
			unvis[m] = true
		end
		trytool(TORCH)
		trytool(CLIMBING)
		trytool(NEITHER)
		
		cur.vis = true
		unvis[cur] = nil
		
		-- now find a new cur
		local lowest = nil
		local lowestv = math.huge
		for k,_ in pairs(unvis) do
			if k.dist < lowestv then
				lowest = k
				lowestv = k.dist
			end
		end
		cur = lowest
	end
end

flood()
print("dist: "..map[ty][tx][TORCH].dist)
