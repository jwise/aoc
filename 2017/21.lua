#!/usr/bin/env lua5

rules = {}

function mkpat(s)
	local pat = {}
	
	for rs in s:gmatch("([^/]+)") do
		row = {}
		for c in rs:gmatch(".") do
			table.insert(row, c == "#")
		end
		table.insert(pat, row)
	end
	
	return pat
end

function inspat(rin, rout)
	local insz = #rin
	
	function ins(fnx, fny)
		local npat = {}
		local good = true
		
		for py=1,insz do
			local nr = {}
			for px=1,insz do
				table.insert(nr, false)
			end
			table.insert(npat, nr)
		end
		
		for py=1,insz do
			for px=1,insz do
				pyp = fny(px,py)
				pxp = fnx(px,py)
				
				npat[py][px] = rin[pyp][pxp]
			end
		end
		
		table.insert(rules, {key = npat, val = rout})
		return good
	end
			
	function insrots(fnx, fny)
		ins(function(x,y) return fnx(x,y) end, function(x,y) return fny(x,y) end) -- no rotation
		ins(function(x,y) return insz-fnx(x,y)+1 end, function(x,y) return insz-fny(x,y)+1 end) -- rotate 180
		ins(function(x,y) return fny(x,y) end, function(x,y) return insz-fnx(x,y)+1 end) -- rotate left 90
	end
			
	insrots(function(x,y) return x end, function(x,y) return y end) 
	insrots(function(x,y) return y end, function(x,y) return x end) -- flip over xy
	insrots(function(x,y) return insz-x+1 end, function(x,y) return y end) -- flip over y
	insrots(function(x,y) return x end, function(x,y) return insz-y+1 end) -- flip over x
end

while true do
	local l = io.read("*line")
	if not l then break end

	local rin,rout = l:match("(%S+) => (%S+)")
	
	inspat(mkpat(rin), mkpat(rout))
end

function popcnt(pat)
	local pop = 0
	for k,v in ipairs(pat) do
		for k2,v2 in ipairs(v) do
			if v2 then pop = pop + 1 end
		end
	end
	return pop
end

function pr(pat)
	for k,v in ipairs(pat) do
		s = ""
		for k2,v2 in ipairs(v) do
			s = s .. (v2 and "#" or ".")
		end
		print(s)
	end
end

st = mkpat(".#./..#/###")

print(popcnt(st))
pr(st)

stm = os.time()

for i=1,18 do
	print("-------- iteration "..i.." --------")
	if (#st % 2) == 0 then
		insz = 2
		outsz = 3
		print("2x2 mode")
	elseif (#st % 3) == 0 then
		insz = 3
		outsz = 4
		print("3x3 mode")
	end
	
	nst = {}
	-- fill the new state up ...
	for y=1,(#st / insz * outsz) do
		local nr = {}
		for x=1,(#st/insz*outsz) do
			table.insert(nr, false)
		end
		table.insert(nst, nr)
	end
	
	local outy = 1
	for y=1,#st,insz do
		local outx = 1
		for x=1,#st,insz do
			-- now check the rules at (x, y), see if we find one
			function check(pat)
				local good = true
				
				for py=1,insz do
					for px=1,insz do
						if pat[py][px] ~= st[y+py-1][x+px-1] then good = false end
					end
				end
				return good
			end
			
			local matched = false
			for pno,pat in ipairs(rules) do
				pk = pat.key
				pv = pat.val
				if #pk == insz and check(pk) then
					matched = true
					for py = 1,outsz do
						for px=1,outsz do
							nst[outy+py-1][outx+px-1] = pv[py][px]
						end
					end
				end
			end
			if not matched then print("no match",x,y) end
			
			outx = outx + outsz
		end
		outy = outy + outsz
	end
	
	st = nst
--	pr(nst)
	print(popcnt(nst))
	print("("..(os.time() - stm).." seconds)")
	stm = os.time()
end

