ngood = 0

while true do
	line = io.read("*line")
	if not line then break end
	n1,n2,c,pw = line:match("(%d+)-(%d+) (.): (.+)")
	n1 = tonumber(n1)
	n2 = tonumber(n2)
	
	
	nc = 1
	m = 0
	for cc in pw:gmatch(".") do
		if (nc == n1 or nc == n2) and cc == c then m = m + 1 end
		nc = nc + 1
	end
	if m == 1 then
		print(n1,n2,c,pw)
		ngood = ngood + 1
	end
end

print(ngood)
