itmrs = {}
ivals = {}
tcreat = {}
nfish = 0

DAYS = tonumber(arg[1]) or 80

line = io.read("*line")
for n in line:gmatch("(%d+)") do
	n = tonumber(n)
	tcreat[n+1] = (tcreat[n+1] or 0) + 1
	nfish = nfish + 1
end

for d=1,DAYS do
	tcreat[d] = tcreat[d] or 0
	tcreat[d+7] = (tcreat[d+7] or 0) + tcreat[d]
	tcreat[d+9] = (tcreat[d+9] or 0) + tcreat[d]
	nfish = nfish + tcreat[d]
	print(d,nfish)
end
