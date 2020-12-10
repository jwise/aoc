adapters = {}
while true do
	line = io.read("*line")
	if not line then break end
	
	table.insert(adapters, tonumber(line))
end

table.sort(adapters)

has_adapter = {}
max = 0
for k,v in ipairs(adapters) do
	has_adapter[v] = true
	if v > max then max = v end
end

nways_mem = {}
function nways(jolts)
	if nways_mem[jolts] then return nways_mem[jolts] end

	local ways = 0
	for i=jolts+1,jolts+3 do
		if i == max + 3 then
			ways = ways + 1
		elseif has_adapter[i] then
			ways = ways + nways(i)
		end
	end
	nways_mem[jolts] = ways
	return ways
end

print(nways(0))