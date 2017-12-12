#!/usr/bin/env lua

pgs = {}
while true do
	pg = {}
	pg.chs = {}
	
	l = io.read("*line")
	if not l then break end
	
	pg.num,nums = l:match("(%d+) <%-> (.+)")
	pg.num = tonumber(pg.num)
	
	for i in nums:gmatch("%d+") do
		table.insert(pg.chs, tonumber(i))
	end
	
	pgs[pg.num] = pg
end

function search(pgm)
	tosearch = {pgm}
	while #tosearch ~= 0 do
		pgn = table.remove(tosearch)
		if not pgs[pgn].searched then
			pgs[pgn].inset = true
			pgs[pgn].searched = true
			
			for _,v in ipairs(pgs[pgn].chs) do
				table.insert(tosearch, v)
			end
		end
	end
end

search(0)

insets = 0
for k,v in pairs(pgs) do
	if v.inset then insets = insets + 1 end
end

print(insets)

-- now look for new groups
groups = 1
for k,v in pairs(pgs) do
	if not v.inset then groups = groups + 1 search(k) end
end
print(groups)

