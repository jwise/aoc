NCUPS = tonumber(arg[1]) or 9
NMOVES = tonumber(arg[2]) or 100

local ln = io.read("*line")
local cups = {head = nil, tail = nil, ns = {}}
function inscup(c)
	local cup = { val = c, prev = nil, next = nil }
	if not cups.head then
		cup.next = cup
		cup.prev = cup
		cups.head = cup
	else
		cup.prev = cups.head.prev
		cup.next = cups.head
		cups.head.prev.next = cup
		cups.head.prev = cup
	end
	cups.ns[c] = cup
	if c == 0 then abort() end
end

function unlinkcup(c)
	c.prev.next = c.next
	c.next.prev = c.prev
	c.prev = nil
	c.next = nil
	return c -- convenience
end

function putafter(c1, c2)
	assert(c2.prev == nil)
	assert(c2.next == nil)
	c1.next.prev = c2
	c2.next = c1.next
	c1.next = c2
	c2.prev = c1
end

local nsz = 0
for c in ln:gmatch(".") do
	inscup(tonumber(c))
	nsz = nsz + 1
end
for i=nsz+1,NCUPS do
	--print("INS", i)
	inscup(i)
end

local ccup = cups.head
function move()
	local pick1, pick2, pick3
	
	local pick1 = unlinkcup(ccup.next) --print(pick1.val, ccup.next.val)
	local pick2 = unlinkcup(ccup.next) --print(pick2.val, ccup.next.val)
	local pick3 = unlinkcup(ccup.next) --print(pick3.val, ccup.next.val)
	
	local dcupn = ccup.val
	repeat
		dcupn = dcupn - 1
		if dcupn == 0 then dcupn = NCUPS end
	until not (dcupn == pick1.val or dcupn == pick2.val or dcupn == pick3.val)
	
	local dcup = cups.ns[dcupn]
	
	putafter(dcup, pick3)
	putafter(dcup, pick2)
	putafter(dcup, pick1)

	ccup = ccup.next
end
for i=1,NMOVES do
	if i % 100000 == 0 then print(i, NMOVES) end
	move()
end
cup1 = cups.ns[1].next
s = ""
for i=2,9 do
	s = s .. cup1.val
	cup1 = cup1.next
end
print(s)

cup1 = cups.ns[1]

p=1
for i=1,2 do
	cup1 = cup1.next
	p = p * cup1.val
end
print(p)
