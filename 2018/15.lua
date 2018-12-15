GOBLIN = {char="G",alive = 0}
ELF = {char="E", alive = 0}
WALL = {char="#"}
OPEN = false

elfap = tonumber(arg[1]) or 3
fast_approx = arg[2] ~= nil

monsters = {}
grid = {} -- truthy if the square is *blocked*

while true do
	l = io.read("*line")
	if not l then break end
	
	local row = {}
	table.insert(grid, row)
	for c in l:gmatch(".") do
		if c == "#" then table.insert(row, WALL)
		elseif c == "." then table.insert(row, OPEN)
		elseif c == "G" then
			local monster = { x = #row+1, y = #grid, type = GOBLIN, char = GOBLIN.char, ap = 3, hp = 200 }
			GOBLIN.alive = GOBLIN.alive + 1
			table.insert(monsters, monster)
			table.insert(row, monster)
		elseif c == "E" then
			local monster = { x = #row+1, y = #grid, type = ELF, char = ELF.char, ap = elfap, hp = 200 }
			ELF.alive = ELF.alive + 1
			table.insert(monsters, monster)
			table.insert(row, monster)
		end
	end
end

function square_avail(x,y)
	if not grid[y] then return false end
	if grid[y][x] then return false end
	return true
end

function sort_raster(t)
	table.sort(t, function(a, b) return a.y < b.y or (a.y == b.y and a.x < b.x) end)
end

function key(x,y)
	return x * 1024 + y
end

-- returns shortest path distance, and the step that is shortest
function shortest(x0, y0, x1, y1)
	local toflood = {}
	local distmap = {}
	
	table.insert(toflood, {x=x1,y=y1,dist = 0})
	distmap[key(x1,y1)] = 0
	
	while #toflood ~= 0 do
		local cur = table.remove(toflood)
		local dist = distmap[key(cur.x, cur.y)]
		
		function pending(x, y)
			x = x + cur.x
			y = y + cur.y
			if distmap[key(x,y)] and (fast_approx or distmap[key(x,y)] <= (dist + 1)) then return end
			if not square_avail(x, y) and not (x == x0 and y == y0) then return end
			distmap[key(x,y)] = dist + 1
			table.insert(toflood, {x = x, y = y})
		end
		pending(-1, 0)
		pending(1, 0)
		pending(0, -1)
		pending(0, 1)
	end
	
	if not distmap[key(x0, y0)] then return false end
	local dist = distmap[key(x0, y0)]
	local dirs = {}
	function dir(x, y)
		x = x + x0
		y = y + y0
		if distmap[key(x, y)] == (dist - 1) then table.insert(dirs, {x = x, y = y}) end
	end
	dir(-1, 0)
	dir(1, 0)
	dir(0, -1)
	dir(0, 1)
	sort_raster(dirs)
	
	return dist, dirs[1]
--[[
	local closedset = {}
	local openset = {}
	table.insert(openset, {x=x0, y=y0})
	local camefrom = {}
	local gscore = {}
	gscore[key(x0, y0)] = 0
]]
end

function move(m, targets)
	local inrange = {}
	function consider(m2,x,y)
		x = x + m2.x
		y = y + m2.y
		for _,p in ipairs(inrange) do
			if p.x == x and p.y == y then return end
		end
		if square_avail(x, y) then
			table.insert(inrange, {x = x, y = y})
		end
	end
	for _,m2 in ipairs(targets) do
		consider(m2, -1, 0)
		consider(m2, 1, 0)
		consider(m2, 0, -1)
		consider(m2, 0, 1)
	end
	
	if #inrange == 0 then return end
	
	-- for each square, compute the shortest path to that square
	for i,sq in ipairs(inrange) do
		sq.shortest, sq.step = shortest(m.x, m.y, sq.x, sq.y)
		if not sq.shortest then sq.shortest = 99999 end
	end
	table.sort(inrange, function(a,b) return a.shortest < b.shortest or (a.shortest == b.shortest and (a.y < b.y or (a.y == b.y and a.x < b.x))) end)
	
	local step = inrange[1].step
	if not step then
		return
	end
	grid[m.y][m.x] = OPEN
	grid[step.y][step.x] = m
	m.y = step.y
	m.x = step.x
end

function attack(m, targets)
	table.sort(targets,
		function (a,b)
			return a.hp < b.hp or (a.hp == b.hp and (a.y < b.y or (a.y == b.y and a.x < b.x))) end)
	if #targets == 0 then return end
	
	local target = targets[1]
	target.hp = target.hp - m.ap
--	print("attack "..m.char.."("..m.x..","..m.y..") -> "..target.char.."("..target.x..","..target.y..") -> "..target.hp.."hp")
	
	if target.hp <= 0 then
		grid[target.y][target.x] = OPEN
		target.type.alive = target.type.alive - 1
		print("got one")
		target.y = -1
		target.x = -1
		return true
	end
	return false
end

DBG = 1
function round(i)
	sort_raster(monsters)
	
	if i == DBG then
		prgrid()
		for _,m in ipairs(monsters) do
			print("start",m.x,m.y,m.char,m.hp)
		end
	end
	
	local m
	local nalive = 0
	for id,m in ipairs(monsters) do	
		if m.hp > 0 then
			local targets = {}
			local targets_inrange = {}
			nalive = nalive + 1
			function mktargets()
				local m2
				for _,m2 in ipairs(monsters) do
					if m2.hp > 0 and m2.type ~= m.type then
						table.insert(targets, m2)
						local inrange = false
						if m.x == m2.x and m.y == (m2.y-1) then inrange = true end
						if m.x == m2.x and m.y == (m2.y+1) then inrange = true end
						if m.x == (m2.x-1) and m.y == m2.y then inrange = true end
						if m.x == (m2.x+1) and m.y == m2.y then inrange = true end
						if inrange then table.insert(targets_inrange, m2) end
					end
				end
			end
			mktargets()
			if #targets == 0 then
				return false
			end
			
--			print("",m.char,m.x,m.y,"tgt",#targets,#targets_inrange)
			
			if #targets_inrange == 0 then
				move(m, targets)
				targets = {}
				targets_inrange = {}
				mktargets()
--				print("mv",m.char,m.x,m.y)
			end
			attack(m, targets_inrange)
		end
	end
	return true,nalive
end

function prgrid()
	for _,row in ipairs(grid) do
		local s = ""
		for _,c in ipairs(row) do
			if not c then s = s .. "."
			else s = s .. c.char
			end
		end
		print(s)
	end
end

local iter
local startelves = ELF.alive
for iter=0,1000 do
	print(iter,nalive,GOBLIN.alive,ELF.alive)
	more,nalive = round(iter)
	if not more then
		niters = iter
		break
	end
end

prgrid()
local tothp = 0
for _,m in ipairs(monsters) do
	if m.hp > 0 then
		print(m.x, m.y, m.char, m.hp)
		tothp = tothp + m.hp
	end
end

print(niters * tothp, niters, tothp)