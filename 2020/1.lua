t={}

while true do
	line = io.read("*line")
	if not line then break end
	n = tonumber(line)
	table.insert(t, n)
end

for k1,v1 in ipairs(t) do
	for k2,v2 in ipairs(t) do
		if v1 + v2 == 2020 then
			print(v1, v2, v1*v2)
		end
	end
end


for k1,v1 in ipairs(t) do
	for k2,v2 in ipairs(t) do
		for k3,v3 in ipairs(t) do
			if v1 + v2 + v3 == 2020 then
				print(v1, v2, v3, v1*v2*v3)
			end
		end
	end
end
