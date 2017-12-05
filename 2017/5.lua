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
	mem[lastip] = mem[lastip] + 1
	steps = steps + 1
end

print(steps)
