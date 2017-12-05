#!/usr/bin/env lua

mem = {}
while true do
	l = io.read("*line")
	if not l then break end
	
	table.insert(mem, tonumber(l))
end

ip = 1
steps = 0
while mem[ip] do
	local lastip = ip
	ip = ip + mem[ip]
	if mem[lastip] >= 3 then mem[lastip] = mem[lastip] - 1
	else mem[lastip] = mem[lastip] + 1
	end
	steps = steps + 1
end

print(steps)
