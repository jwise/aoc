#!/usr/bin/env lua

cfgs = {}

table.insert(cfgs, {})

l = io.read("*line")
for i in l:gmatch("%d+") do table.insert(cfgs[1], tonumber(i) ) end

while true do
	cfg = cfgs[#cfgs]
	
--	print(#cfgs)
	
	-- duplicate the cfg, and find the max
	ncfg = {}
	kmax, vmax = 1, 0
	for k,v in ipairs(cfg) do
--		print("\t"..v)
		table.insert(ncfg, v)
		if v > vmax then kmax, vmax = k, v end
	end
	
	-- now walk and litter
	ncfg[kmax] = 0
	for i=kmax+1,kmax+vmax do
		-- fucking ugh.
		n = ((i - 1) % #ncfg) + 1
		ncfg[n] = ncfg[n] + 1
	end
	
	-- finally, look for dups
	dup = false
	for k,v in ipairs(cfgs) do
		isdup = true
		for k0, v0 in ipairs(v) do
			if ncfg[k0] ~= v0 then isdup = false end
		end
		if isdup then
			dup = k
			print("dup of "..k)
		end
	end
	if dup then break end
	table.insert(cfgs, ncfg)
end

print(#cfgs)
print(#cfgs - dup + 1)