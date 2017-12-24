#!/usr/bin/env lua

parts = {}
while true do
	l = io.read("*line")
	if not l then break end
	
	local pa, pb = l:match("(%d+)/(%d+)")
	
	local part = {}
	part.pa = tonumber(pa)
	part.pb = tonumber(pb)
	part.used = false
	
	table.insert(parts, part)
end

function maxstr(pins)
	local max = 0
	
	for _,part in pairs(parts) do
--		print(part.pa, part.pb, pins)
		if not part.used and part.pa == pins then
			part.used = true
			local str = part.pa + part.pb
			str = str + maxstr(part.pb)
			if str > max then max = str end
			part.used = false
		elseif not part.used and part.pb == pins then
			part.used = true
			local str = part.pa + part.pb
			str = str + maxstr(part.pa)
			if str > max then max = str end
			part.used = false
		end
	end
	return max
end

print(maxstr(0))

function maxlong(pins)
	local maxl, maxs = 0, 0
	
	for _,part in pairs(parts) do
		if not part.used and part.pa == pins then
			part.used = true
			local str = part.pa + part.pb
			local nlong, nstr = maxlong(part.pb)
			nlong = nlong + 1
			nstr = str + nstr
			if nlong == maxl then
				if nstr > maxs then maxs = nstr end
			elseif nlong > maxl then
				maxl, maxs = nlong, nstr
			end
			part.used = false
		elseif not part.used and part.pb == pins then
			part.used = true
			local str = part.pa + part.pb
			local nlong, nstr = maxlong(part.pa)
			nlong = nlong + 1
			nstr = str + nstr
			if nlong == maxl then
				if nstr > maxs then maxs = nstr end
			elseif nlong > maxl then
				maxl, maxs = nlong, nstr
			end

			part.used = false
		end
	end
	return maxl, maxs
end

print(maxlong(0))
