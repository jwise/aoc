adapters = {}
while true do
	line = io.read("*line")
	if not line then break end
	
	table.insert(adapters, tonumber(line))
end

table.sort(adapters)

jdiff = { 0, 0, 1 }
jlast = 0

for k,v in ipairs(adapters) do
	jdiff[v - jlast] = jdiff[v - jlast] + 1
	jlast = v
end

print(jdiff[1], jdiff[3], jdiff[1] * jdiff[3])