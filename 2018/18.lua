sz = tonumber(arg[1]) or 50
iter = tonumber(arg[2]) or 10

map = {}
OPEN = {char=".",
	next = function(o, t, l)
		if t >= 3 then return TREES
		else return OPEN
		end
	end}
TREES = {char = "|",
	next = function(o, t, l)
		if l >= 3 then return LUMBERYARD
		else return TREES
		end
	end}
LUMBERYARD = {char = "#",
	next = function(o, t, l)
		if l >= 1 and t >= 1 then return LUMBERYARD
		else return OPEN
		end
	end}

function put(map,y,x,v) 
	if not map[y] then map[y] = {} end
	map[y][x] = v
end

function get(map,y,x)
	if not map[y] then return OPEN end
	return map[y][x] or OPEN
end

function pr(map)
	for y=1,sz do
		local s = ""
		for x=1,sz do
			s = s .. get(map,y,x).char
		end
		print(s)
	end
end

while true do
	local l = io.read("*line")
	if not l then break end
	
	local line = {}
	for c in l:gmatch(".") do
		if c == "." then table.insert(line, OPEN)
		elseif c == "|" then table.insert(line, TREES)
		elseif c == "#" then table.insert(line, LUMBERYARD)
		end
	end
	table.insert(map, line)
end

function score(map)
	ntrees = 0
	nlumber = 0
	for y=1,sz do
		for x=1,sz do
			if get(map, y, x) == TREES then ntrees = ntrees + 1
			elseif get(map,y,x) == LUMBERYARD then nlumber = nlumber + 1
			end
		end
	end
	return ntrees * nlumber, ntrees, nlumber
end

for i=1,iter do
	print(i-1,score(map))
--	pr(map)
	local nmap = {}
	for y=1,sz do
		for x=1,sz do
			local ns = {}
			ns[OPEN] = 0
			ns[TREES] = 0
			ns[LUMBERYARD] = 0
			
			function incr(c)
				ns[c] = ns[c] + 1
			end
			
			incr(get(map, y-1, x-1))
			incr(get(map, y-1, x  ))
			incr(get(map, y-1, x+1))
			incr(get(map, y  , x-1))
			incr(get(map, y  , x+1))
			incr(get(map, y+1, x-1))
			incr(get(map, y+1, x  ))
			incr(get(map, y+1, x+1))
			
			put(nmap, y, x, get(map, y, x).next(ns[OPEN], ns[TREES], ns[LUMBERYARD]))
		end
	end
	map = nmap
end

print("***")
print(score(map))