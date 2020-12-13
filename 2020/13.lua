start = tonumber(io.read("*line"))
buses = {}
for b in io.read("*line"):gmatch("[^,]+") do
	if b ~= "x" then
		table.insert(buses, tonumber(b))
	end
end

local bid,maxtowait = 0,999999999
for _,b in ipairs(buses) do
	local towait = b - (start % b)
	if towait < maxtowait then
		bid = b
		maxtowait = towait
	end
end
print(bid,maxtowait,bid*maxtowait)
