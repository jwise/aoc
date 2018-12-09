PLAYERS = tonumber(arg[1])
MAXMARBL = tonumber(arg[2])

curplayer = 0

marb0 = {val = 0}
marb0.ccw = marb0
marb0.cw = marb0
marbl = marb0

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
	if i % 23 == 0 then
		for _ = 1,7 do
			marbl = marbl.ccw
		end
		players[curplayer] = players[curplayer] + i + marbl.val
		marbl.ccw.cw = marbl.cw
		marbl.cw.ccw = marbl.ccw
		marbl = marbl.cw
	else
		nmarb = {val = i, cw = marbl.cw.cw, ccw = marbl.cw }
		marbl.cw.cw.ccw = nmarb
		marbl.cw.cw = nmarb
		marbl = nmarb
	end
	curplayer = (curplayer % PLAYERS) + 1
end

max = 0
for k,v in ipairs(players) do
	if v > max then max = v end
end
print(max)
