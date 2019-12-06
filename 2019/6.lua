objs = {}

while true do
	line = io.read("*line")
	if not line then break end
	
	inner,outer = line:match("([A-Z0-9]+)%)([A-Z0-9]+)")
	print(inner,outer)
	
	if not objs[inner] then
		objs[inner] = {}
	end
	if not objs[outer] then
		objs[outer] = {}
	end
	
	objs[outer].inner = inner
end

octr = 0
for outer,_ in pairs(objs) do
	local loctr = 0
	local inner = objs[outer].inner
	while inner do
		loctr = loctr + 1
		inner = objs[inner].inner
	end
	octr = octr + loctr
	print(outer, objs[outer].inner, loctr)
end

print(octr)