NCUPS = tonumber(arg[1]) or 9
NMOVES = tonumber(arg[2]) or 100

local ln = io.read("*line")
local cups = {}

local nsz = 0
local lastc = nil
local firstc = nil
for c in ln:gmatch(".") do
	c = tonumber(c)
	if not firstc then firstc = c end
	if lastc then cups[lastc] = c end
	lastc = c
	nsz = nsz + 1
end
for c=nsz+1,NCUPS do
	if not firstc then firstc = c end
	if lastc then cups[lastc] = c end
	lastc = c
end
cups[lastc] = firstc

local ccup = firstc
function move()
	local pick1, pick2, pick3
	
	local pick1 = cups[ccup]
	local pick2 = cups[pick1]
	local pick3 = cups[pick2]
	cups[ccup] = cups[pick3]
	
	local dcupn = ccup
	repeat
		dcupn = dcupn - 1
		if dcupn == 0 then dcupn = NCUPS end
	until not (dcupn == pick1 or dcupn == pick2 or dcupn == pick3)
	
	local dcup = dcupn
	
	cups[pick1] = pick2
	cups[pick2] = pick3
	cups[pick3] = cups[dcup]
	cups[dcup] = pick1

	ccup = cups[ccup]
end
for i=1,NMOVES do
	if i % 100000 == 0 then print(i, NMOVES) end
	move()
end
cup1 = cups[1]
s = ""
for i=2,9 do
	s = s .. cup1
	cup1 = cups[cup1]
end
print(s)

cup1 = 1
p=1
for i=1,2 do
	cup1 = cups[cup1]
	p = p * cup1
end
print(p)
