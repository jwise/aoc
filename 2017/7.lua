#!/usr/bin/env lua

programs = {}
while true do
	l = io.read("*line")
	if not l then break end
	
	pt = {}
	if l:match("%->") then
		pt.name, pt.w, sprgs = l:match("(%S+) %((%d+)%) %-> (.+)")
		pt.prgs = {}
		for i in sprgs:gmatch("%a+") do
			table.insert(pt.prgs, i)
		end
	else
		pt.name, pt.w = l:match("(%S+) %((%d+)%)")
		pt.prgs = {}
	end
	
	pt.from = 0
	pt.w = tonumber(pt.w)
	
	programs[pt.name] = pt
end

for n,prg in pairs(programs) do
	for _,prgname in pairs(prg.prgs) do
		programs[prgname].from = programs[prgname].from + 1
	end
end

for n,prg in pairs(programs) do
	if prg.from == 0 and #prg.prgs ~= 0 then
		root = n
		print(n)
	end
end

-- now compute weights starting at the root
function cpweight(n, depth, tree)
	local fixed = false
	programs[n].cw = programs[n].w
	for _,chld in pairs(programs[n].prgs) do
		fixedone = cpweight(chld, depth + 1, tree.." -> "..chld)
		fixed = fixed or fixedone
		programs[n].cw = programs[n].cw + programs[chld].cw
	end
	
	-- is it consistent?
	-- note that the one that needs to be fixed is the deepest ... and so the first that we come across.
	expw = nil
	programs[n].balanced = true
	bads = 0
	for _,chld in ipairs(programs[n].prgs) do
		chldw = programs[chld].cw
		if not expw then expw = chldw bads = 0
		else
			if expw ~= chldw then
				bads = bads + 1
				if bads == 2 then
					print (n.." unbalanced due to hoser in slot 1")
					expw = chldw
				end
				programs[n].balanced = false
				print (n.." unbalanced due to "..chld.." with w "..chldw.." exp "..expw.." eq "..tostring(expw == chldw))
			end
		end
	end
	
	programs[n].depth = depth
	
	if not programs[n].balanced and not fixed then
		print(n.." has cw "..programs[n].cw.." and "..#programs[n].prgs.." children, depth "..depth.." ("..tree..")".. (programs[n].balanced and "" or ", and is unbalanced"))
		for _,chld in pairs(programs[n].prgs) do
			chldw = programs[chld].cw
			if chldw ~= expw then
				print("  and I blame "..chld..", which should weigh "..expw..", but weighs "..chldw)
				print("  individual weight "..programs[chld].w..", fixed to be ---> "..programs[chld].w + expw - chldw)
			end
		end
		fixed = true
	end
	
	return fixed
end

cpweight(root, 0, root)
