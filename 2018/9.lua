PLAYERS = tonumber(arg[1])
MAXMARBL = tonumber(arg[2])

curplayer = 0
marblp = 1
marbles = {0}
players = {}
for i=1,PLAYERS do
	players[i] = 0
end

function clockwise(n)
	return ((marblp + n - 1) % #marbles) + 1
end

function ctrclockwise(n)
	return ((marblp - n + #marbles - 1) % #marbles) + 1
end

for i=1,MAXMARBL do
	if i % 10000 == 0 then print(i) end
	if i % 23 == 0 then
		marblp = ctrclockwise(7)
		players[curplayer] = players[curplayer] + i + table.remove(marbles, marblp)
		if marblp > #marbles then
			marblp = 1
		end
	else
		marblp = clockwise(2)
		table.insert(marbles, marblp, i)
	end
	curplayer = (curplayer % PLAYERS) + 1
end

max = 0
for k,v in ipairs(players) do
	if v > max then max = v end
end
print(max)
