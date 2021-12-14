str = io.read("*line")
io.read("*line")
substs = {}

while true do
	line = io.read("*line")
	if not line or line == "" then break end
	c1,c2,ins = line:match("(.)(.) .. (.)")
	substs[c1] = substs[c1] or {}
	substs[c1][c2] = ins
end

function step(str)
	local nstr = ""
	for i=1,#str do
		local c1 = str:sub(i,i)
		local c2 = str:sub(i+1,i+1)
		nstr = nstr .. c1
		if substs[c1] and substs[c1][c2] then
			nstr = nstr .. substs[c1][c2]
		end
	end
	return nstr
end

function mclc(str)
	local counts = {}
	for i=1,#str do
		local c = str:sub(i,i)
		counts[c] = counts[c] or 0
		counts[c] = counts[c] + 1
	end
	local icounts = {}
	for _,count in pairs(counts) do
		table.insert(icounts, count)
	end
	table.sort(icounts)
	return icounts[#icounts] - icounts[1]
end

for i=1,10 do
	print(#str, str)
	str = step(str)
end
print(#str, mclc(str))
