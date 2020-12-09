SZ = 25

ns = {}

while true do
	line = io.read("*line")
	if not line then break end
	
	table.insert(ns, tonumber(line))
end

want = 14144619
psums = {}

local psum = 0
for i=1,#ns do
	psum = psum + ns[i]
	psums[i] = psum
end

for i=2,#ns do
	for j=1,i-2 do
		if (psums[i] - psums[j]) == want then
			local min = 99999999999999
			local max=0
			print("",ns[i],ns[j+1])
			for ir=j+1,i do
				if ns[ir] < min then min = ns[ir] end
				if ns[ir] > max then max = ns[ir] end
			end
			print(min+max)
		end
	end
end
