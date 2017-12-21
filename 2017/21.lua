#!/usr/bin/env luajit

if bit then
	BOR = bit.bor
	BLSH = bit.lshift
else
	BOR = load("return function(a,b) return a | b end")()
	BLSH = load("return function(a,b) return a << b end")()
end

rules2 = {}
rules3 = {}

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

function inspat(rin, rout)
	local insz = #rin
	
	function ins(fnx, fny)
		local patn = 0
		
		for py=1,insz do
			for px=1,insz do
				pyp = fny(px,py)
				pxp = fnx(px,py)
				
				patn = BOR(patn, rin[pyp][pxp] and BLSH(1, (py-1)*insz+px-1) or 0)
			end
		end
		
		(insz == 2 and rules2 or rules3)[patn] = rout
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

-- check for table completeness
for i=0,0xF do if not rules2[i] then print("WARNING: tables not complete: counterexample rules2["..i.."]") end end
for i=0,0x1FF do if not rules3[i] then print("WARNING: tables not complete: counterexample rules3["..i.."]") end end



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
			local patn = 0
			for py=1,insz do
				for px=1,insz do
					patn = BOR(patn, st[y+py-1][x+px-1] and BLSH(1, (py-1)*insz+px-1) or 0)
				end
			end
			local pv = (insz == 2 and rules2 or rules3)[patn]
			if not pv then print("no match",x,y) end
			for py = 1,outsz do
				for px=1,outsz do
					nst[outy+py-1][outx+px-1] = pv[py][px]
				end
			end
			
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

