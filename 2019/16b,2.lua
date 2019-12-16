line = io.read("*line")

seq = {}
for c in line:gmatch(".") do
	table.insert(seq, tonumber(c))
end

local rofs = 0
rofs = rofs * 10 + seq[1]
rofs = rofs * 10 + seq[2]
rofs = rofs * 10 + seq[3]
rofs = rofs * 10 + seq[4]
rofs = rofs * 10 + seq[5]
rofs = rofs * 10 + seq[6]
rofs = rofs * 10 + seq[7]

print("Setting up...")
local xseq = {}
for i=1,tonumber(arg[3]) or 10000 do
	for j=1,#seq do
		table.insert(xseq, seq[j])
	end
end
seq = xseq
print("ok, #seq "..#seq)

for i=1,tonumber(arg[2]) or 100 do
	local csum = 0
	for i = #seq, 1+rofs, -1 do
		csum = csum + seq[i]
		csum = csum % 10
		seq[i] = csum
	end
end

s=""
for i=1+rofs,8+rofs do
	s = s .. seq[i]
end
print(s)

