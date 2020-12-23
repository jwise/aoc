local ln = io.read("*line")
local cups = {}
for c in ln:gmatch(".") do
	table.insert(cups, tonumber(c))
end

local ccup = 1
function move()
	local pick1, pick2, pick3

	print(table.concat(cups, ""), ccup, cups[ccup])

	if (ccup + 1) > #cups then
		pick1 = table.remove(cups, 1)
		ccup = ccup - 1
	else
		pick1 = table.remove(cups, ccup+1)
	end
	if (ccup + 1) > #cups then
		pick2 = table.remove(cups, 1)
		ccup = ccup - 1
	else
		pick2 = table.remove(cups, ccup+1)
	end
	if (ccup + 1) > #cups then
		pick3 = table.remove(cups, 1)
		ccup = ccup - 1
	else
		pick3 = table.remove(cups, ccup+1)
	end
	
	print(ccup, cups[ccup])
	local dcupn = cups[ccup] - 1
	local dcup = nil
	while dcup == nil do
		if dcupn == 0 then dcupn = 9 end
		for k,v in ipairs(cups) do
			if v == dcupn then
				dcup = k
				break
			end
		end
		if not dcup then dcupn = dcupn - 1 end
	end
	
	print(pick1, pick2, pick3, dcupn)
	
	local ccupn = cups[ccup]
	table.insert(cups, dcup + 1, pick3)
	table.insert(cups, dcup + 1, pick2)
	table.insert(cups, dcup + 1, pick1)
	for k,v in ipairs(cups) do
		if v == ccupn then
			ccup = k + 1
			break
		end
	end
	if ccup > #cups then ccup = 1 end
end
for i=1,100 do
	move()
end
for k,v in ipairs(cups) do
	if v == 1 then
		cup1 = k
	end
end
s=""
for i=1,8 do
	s = s.. cups[(cup1+i-1) % 9 + 1]
end
print(s)