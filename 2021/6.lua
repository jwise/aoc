itmrs = {}
ivals = {}

DAYS = tonumber(arg[1]) or 80

line = io.read("*line")
for n in line:gmatch("(%d+)") do
	table.insert(itmrs, n)
	table.insert(ivals, n)
end

for _=1,DAYS do
	nfish = #itmrs
	for f=1,nfish do -- avoid eating tail
		tmr = itmrs[f]
		if tmr == 0 then
			itmrs[f] = 6
			table.insert(itmrs, 8)
			table.insert(ivals, 7)
		else
			itmrs[f] = itmrs[f] - 1
		end
	end
end

print(#itmrs)
