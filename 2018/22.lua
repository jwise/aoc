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
WET = {r = 1, c= "=", tools = {[CLIMBING] = true, [NEITHER] = true}}
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

function ensure(y,x,tool)
	if not map[y] then map[y] = {} end
	if not map[y][x] then map[y][x] = {} end
	if not map[y][x][tool] then map[y][x][tool] = math.huge end
end

local MAXSCORE = ty + tx + ((ty + tx) / 4) * 7

function flood()
	local toflood = {}
	table.insert(toflood, {x = 0, y = 0, tool = TORCH, time = 0})
	local steps = 0
	ensure(ty, tx, TORCH)
	while #toflood ~= 0 do
		local cur = table.remove(toflood)
		ensure(cur.y, cur.x, cur.tool)
		steps = steps + 1
		if steps % 100000 == 0 then print(cur.y, cur.x, cur.time, #toflood) end
		if map[cur.y][cur.x][cur.tool] > cur.time
		and cur.time < MAXSCORE
		and cur.time < map[ty][tx][TORCH] then
			map[cur.y][cur.x][cur.tool] = cur.time
			
			function try(y,x)
				y = cur.y + y
				x = cur.x + x
				if y > (ty + 20) or y < 0 then return end
				if x > (tx + 20) or x < 0 then return end
				if not tipo(y, x).tools[cur.tool] then return end
				table.insert(toflood, {x = x, y = y, tool = cur.tool, time = cur.time + 1})
			end
			try(-1,0)
			try(1,0)
			try(0,1)
			try(0,-1)
			
			function trytool(tool)
				if cur.tool == tool or not tipo(cur.y,cur.x).tools[tool] then return end
				table.insert(toflood, {x = cur.x, y = cur.y, tool = tool, time = cur.time + 7})
			end
			trytool(TORCH)
			trytool(CLIMBING)
			trytool(NEITHER)
		end
	end
end

flood()
print(map[ty][tx][TORCH])