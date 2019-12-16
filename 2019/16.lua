line = io.read("*line")

seq = {}
for c in line:gmatch(".") do
	table.insert(seq, tonumber(c))
end

function ph(n,len)
	local base = {0,1,0,-1}
	local basep = 1
	local basec = 0
	local phout = {}
	for i= 1,len+1 do
		table.insert(phout, base[basep])
		basec = basec + 1
		if n == basec then
			basep = basep + 1
			basec = 0
			if basep == 5 then basep = 1 end
		end
	end
	
	table.remove(phout, 1)
	return phout
end

function conv(seq,ph)
	local acc = 0
	assert(#seq == #ph)
	for i=1,#seq do
		acc = acc + seq[i] * ph[i]
	end
	acc = math.abs(acc)
	return acc % 10
end

function iter(seq)
	local newseq = {}
	for i=1,#seq do
		table.insert(newseq, conv(seq, ph(i, #seq)))
	end
	return newseq
end

for i=1,100 do
	seq = iter(seq)
end

s=""
for i=1,8 do
	s = s .. seq[i]
end
print(s)
