t={}

n0,n1,n2,n3 = 99999,9999,9999,9999
nincr = 0
while true do
	line = io.read("*line")
	if not line then break end
	n = tonumber(line)
	if (n+n0+n1) > (n0+n1+n2) then nincr = nincr + 1 end
	n0,n1,n2 = n,n0,n1
end

print(nincr)