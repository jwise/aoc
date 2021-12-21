local rolln = 1
local totrolls = 0
function roll()
	local n = rolln
	rolln = rolln + 1
	if rolln > 100 then rolln = 1 end
	totrolls = totrolls + 1
	return n
end

pos = { 6, 10 }
-- 4, 8 }
-- 6, 10 for real

scores = { 0, 0 }
done = false

while not done do
	for p = 1,2 do
		local move = roll() + roll() + roll()
		pos[p] = (pos[p] - 1 + move) % 10 + 1
		scores[p] = scores[p] + pos[p]
		if scores[p] >= 1000 then done = p break end
	end
end

loser = (done == 1) and 2 or 1

print(scores[loser], totrolls, scores[loser] * totrolls)
