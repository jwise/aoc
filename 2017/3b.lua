#!/usr/bin/env lua

dirs = {
  { x = 1, y = 0 },
  { x = 0, y = -1 },
  { x = -1, y = 0 },
  { x = 0, y = 1 }
}

y,x = 0,0
ymax, ymin = 0,0
xmax, xmin = 0,0
dir = 1

ar = {}
ar_rev = {}
function store(x, y, n) ar_rev[x*1024+y] = n end
function get(x, y, n) return ar_rev[x*1024+y] or {value = 0} end

goal = tonumber(arg[1])
foundone = false

for i = 1,goal do
	nbrs = get(x-1, y-1).value + get(x, y-1).value + get(x+1, y-1).value +
	       get(x-1, y  ).value +                     get(x+1, y  ).value +
	       get(x-1, y+1).value + get(x, y+1).value + get(x+1, y+1).value 
	if i == 1 then nbrs = 1 end
	ar[i] = {x = x, y = y, i = i, value = nbrs}
	store(x, y, ar[i])
	if nbrs > goal and not foundone then print(nbrs) foundone = true end
	
	y = y + dirs[dir].y
	x = x + dirs[dir].x
	
	if x > xmax or y > ymax or x < xmin or y < ymin then
		if x > xmax then xmax = x end
		if x < xmin then xmin = x end
		if y > ymax then ymax = y end
		if y < ymin then ymin = y end
		
		dir = dir + 1
		if not dirs[dir] then dir = 1 end
	end
end

print(goal,ar[goal].x, ar[goal].y, math.abs(ar[goal].x) + math.abs(ar[goal].y), ar[goal].value)