t={}

n0 = 99999
nincr = 0
while true do
	line = io.read("*line")
	if not line then break end
	n = tonumber(line)
	if n > n0 then nincr = nincr + 1 end
	n0 = n
end

print(nincr)