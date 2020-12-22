p1 = {}
p2 = {}

io.read("*line") -- "Player 1"
while true do
	local line = io.read("*line")
	if line == "" then break end
	
	table.insert(p1, tonumber(line))
end

io.read("*line") -- "Player 2"
while true do
	local line = io.read("*line")
	if not line then break end
	
	table.insert(p2, tonumber(line))
end

local gameid = 1
function game(p1,p2,d)
	local configs = {}
	local mygameid = gameid
	gameid = gameid + 1
	local round = 1
	
	while #p1 > 0 and #p2 > 0 do
		--print("round ", round, "game",mygameid)
		round = round + 1
		local cconfig = table.concat(p1, ",") .. "*" .. table.concat(p2, ",")
		if configs[cconfig] then
			return 1,p1
		end
		configs[cconfig] = true

		local n1 = table.remove(p1, 1)
		local n2 = table.remove(p2, 1)
		--print(n1,#p1,n2,#p2)
		
		if n1 <= #p1 and n2 <= #p2 then
			local np1 = {}
			local np2 = {}
			for i=1,n1 do table.insert(np1, p1[i]) end
			for i=1,n2 do table.insert(np2, p2[i]) end
			local winner = game(np1, np2, d+1)
			if winner == 1 then
				table.insert(p1, n1)
				table.insert(p1, n2)
			else
				table.insert(p2, n2)
				table.insert(p2, n1)
			end
		elseif n1 == n2 then abort()
		elseif n1 > n2 then
			table.insert(p1, n1)
			table.insert(p1, n2)
		else
			table.insert(p2, n2)
			table.insert(p2, n1)
		end
	end
	
	if gameid % 100 == 0 then print(d, gameid, round, st) end

	if #p1 > 0 then
		return 1,p1
	else
		return 2,p2
	end
end

winnern,winner = game(p1,p2, 0)
print("WINNER", winnern)
local total = 0
for i=1,#winner do
	total = total + winner[i] * (#winner - i + 1)
end
print(total)