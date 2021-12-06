bs = {}
lns = {}

while true do
	line = io.read("*line")
	if not line then break end
	n = 1
	table.insert(lns, line)
end


function filt(lns,pos,wantmost)
	if pos > lns[1]:len() or #lns == 1 then
		print("TOTLEN",#lns)
		return lns[1]
	end
	bs = {}
	nlns = {}
	for _,line in ipairs(lns) do
		n = 1
		for b in line:gmatch(".") do
			b = tonumber(b)
			if not bs[n] then bs[n] = {} end
			if not bs[n][b] then bs[n][b] = 0 end
			bs[n][b] = bs[n][b] + 1
			n = n + 1
		end
	end
	bs[pos] = bs[pos] or {}
	bs[pos][0] = bs[pos][0] or 0
	bs[pos][1] = bs[pos][1] or 0
	most = (bs[pos][0] > bs[pos][1]) and 0 or 1
	want = wantmost and (most == 0 and 0 or 1) or (most == 1 and 0 or 1)
	for _,line in ipairs(lns) do
		if tonumber(line:sub(pos,pos)) == want then
			table.insert(nlns, line)
		end
	end
	print(pos,#lns,#nlns)
	return filt(nlns, pos+1, wantmost)
end

print(filt(lns,1,true))
print(filt(lns,1,false))
