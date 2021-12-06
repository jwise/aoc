bs = {}
ls = 0

while true do
	line = io.read("*line")
	if not line then break end
	n = 1
	for b in line:gmatch(".") do
		b = tonumber(b)
		if not bs[n] then bs[n] = {} end
		if not bs[n][b] then bs[n][b] = 0 end
		bs[n][b] = bs[n][b] + 1
		n = n + 1
	end
end

gam = 0
eps = 0
for b=1,#bs do
	gam = gam * 2
	eps = eps * 2
	bs[b][0] = bs[b][0] or 0
	bs[b][1] = bs[b][1] or 0
	if bs[b][0] > bs[b][1] then
		gam = gam + 1
	else
		eps = eps + 1
	end
end

print(gam,eps,gam*eps)