EMPTY = {}
OCCUP = {}
FLOOR = {}

seats = {}
maxx = 0
maxy = 0

while true do
	line = io.read("*line")
	if not line then break end
	
	row = {}
	for c in line:gmatch(".") do
		table.insert(row, (c == ".") and FLOOR or EMPTY)
	end
	table.insert(seats, row)
end
maxy = #seats
maxx = #seats[1]

function gets(y,x)
	if not seats[y] then return FLOOR end
	if not seats[y][x] then return FLOOR end
	return seats[y][x]
end

function look(y,x,dy,dx)
	y = y + dy
	x = x + dx
	while seats[y] and seats[y][x] and seats[y][x] == FLOOR do
		y = y + dy
		x = x + dx
	end
	return (seats[y] and seats[y][x] and seats[y][x] == OCCUP) and 1 or 0
end

function adj(y,x)
	return look(y,x,-1,-1) +
	       look(y,x,-1, 0) +
	       look(y,x,-1, 1) +
	       look(y,x, 0,-1) +
	       look(y,x, 0, 1) +
	       look(y,x, 1,-1) +
	       look(y,x, 1, 0) +
	       look(y,x, 1, 1)
end

local totoccup = 0
while true do
	local changed = 0
	local snew = {}
	totoccup = 0
	for y,row in ipairs(seats) do
		local rownew = {}
		for x,s in ipairs(row) do
			local news = s
			local nadj = adj(y,x)
			if nadj == 0 and s == EMPTY then news = OCCUP
			elseif nadj >= 5 and s == OCCUP then news = EMPTY
			end
			if news ~= s then changed = changed + 1 end
			if news == OCCUP then totoccup = totoccup + 1 end
			table.insert(rownew, news)
		end
		table.insert(snew, rownew)
	end
	print(".", totoccup)
	seats = snew
	if changed == 0 then break end
end
