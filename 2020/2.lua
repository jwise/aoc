ngood = 0

while true do
	line = io.read("*line")
	if not line then break end
	n1,n2,c,pw = line:match("(%d+)-(%d+) (.): (.+)")
	n1 = tonumber(n1)
	n2 = tonumber(n2)
	
	nc = 0
	for cc in pw:gmatch(".") do
		if cc == c then nc = nc + 1 end
	end
	
	if nc >= n1 and nc <= n2 then
		print(n1,n2,c,pw)
		ngood = ngood + 1
	end
end

print(ngood)
