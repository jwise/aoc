bots = {}
bestr = 0
best = nil
while true do
	l = io.read("*line")
	if not l then break end
	
	x,y,z,r = l:match("pos=<(-?%d+),(-?%d+),(-?%d+)>, r=(%d+)")
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	r = tonumber(r)
	
	local bot = { x = x, y = y, z = z, r = r }
	if bot.r > bestr then
		bestr = bot.r
		best = bot
	end
	table.insert(bots, bot)
end

function dist(bot1,bot2)
	return math.abs(bot1.x-bot2.x) +
	       math.abs(bot1.y-bot2.y) +
	       math.abs(bot1.z-bot2.z)
end

local n = 0
for _,bot2 in ipairs(bots) do
	if dist(best,bot2) <= best.r then
		n = n + 1
	end
end

print("; ".. n)

print("(define-fun inrange ((x Int) (y Int) (z Int)) Int")
print(" (+")
for _,bot in ipairs(bots) do
	print(string.format("  (if (<= (dist x y z %d %d %d) %d) 1 0)", bot.x, bot.y, bot.z, bot.r))
end
print("  ))")
