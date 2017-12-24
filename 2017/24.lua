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
	
	if not parts[part.pa] then parts[part.pa] = {} end
	table.insert(parts[part.pa], part)
	if not parts[part.pb] then parts[part.pb] = {} end
	table.insert(parts[part.pb], part)
	
	part[part.pa] = part.pb
	part[part.pb] = part.pa
end

function maxstr(pins)
	local max = 0
	
	for _,part in pairs(parts[pins]) do
--		print(part.pa, part.pb, pins)
		if not part.used then
			part.used = true
			local str = part[pins] + pins
			str = str + maxstr(part[pins])
			if str > max then max = str end
			part.used = false
		end
	end
	return max
end

print(maxstr(0))

function maxlong(pins)
	local maxl, maxs = 0, 0
	
	for _,part in pairs(parts[pins]) do
		if not part.used then
			part.used = true
			local str = part[pins] + pins
			local nlong, nstr = maxlong(part[pins])
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
