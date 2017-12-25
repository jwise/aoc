#!/usr/bin/env lua

rules = {}

local l = io.read("*line")
initst = l:match("in state ([^.]+).")
local l = io.read("*line")
steps = l:match("after (%d+) steps")
l = io.read("*line") -- newline

while true do
	local l = io.read("*line")
	if not l then break end
	
	local xst = l:match("In state ([^:]+):")
	local ts = {}
	
	while true do
		local l = io.read("*line")
		if not l or l == "" then break end
		
		local inval = l:match("value is (%d+)")
		
		l = io.read("*line")
		local val = l:match("the value (%d+)")
		
		l = io.read("*line")
		local dir = l:match("to the ([^.]+)")
		
		l = io.read("*line")
		local nst = l:match("with state ([^.]+)")
		
		ts[inval] = {val = val, dir = (dir == "left") and -1 or 1, next = nst}
	end
	
	rules[xst] = ts
end

ram = {}

state = initst
curs = 0
for i=1,steps do
	if (i % 100000) == 0 then print(i) end
	local crules = rules[state]
	local cval = ram[curs] or "0"
	local copc = crules[cval]
	
--	print(i, state, curs, cval)
	
	ram[curs] = copc.val
	curs = curs + copc.dir
	state = copc.next
end

pop = 0
for k,v in pairs(ram) do
	if v == "1" then pop = pop + 1 end
end
print(pop)
