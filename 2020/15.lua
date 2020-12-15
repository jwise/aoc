nturns = tonumber(arg[1]) or 2020

nums = {}
local line = io.read("*line")
t = 1
local lastnum = nil
local nextn = 0
for n in line:gmatch("%d+") do
	n = tonumber(n)
	print("***",t,n)
	nums[n] = t
	lastnum = n
	t = t + 1
end

for t=t,nturns do
	local thisn
	if prevturn then
		thisn = t - 1 - prevturn
	else
		thisn = 0
	end
	lastnum = thisn
	prevturn = nums[thisn]
	nums[thisn] = t
end

print(lastnum)
