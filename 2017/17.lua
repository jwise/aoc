#!/usr/bin/env lua

COUNT=2017
STEP=337

--COUNT=3
--STEP=3

buf = {0}

bpos = 0

function pr()
	s = "POS "..bpos..", "
	for k,v in ipairs(buf) do
		s = s .. v .. ","
	end
	print(s)
end

for i=1,COUNT do
--	print(bpos, bpos+STEP, (bpos+STEP)%#buf, #buf)
	bpos = (bpos + STEP) % #buf
	table.insert(buf, bpos+2, i)
	bpos = bpos + 1
--	pr()
end

pr()

for k,v in ipairs(buf) do
	if v == 2017 then print(buf[k+1]) end
end

paz = nil
bsz = 1
for i=1,50000000 do
	if 
	bpos = (bpos + STEP) % bsz
	if bpos == 0 then paz = i end
	bsz = bsz + 1
	bpos = bpos + 1
end

print(paz)
