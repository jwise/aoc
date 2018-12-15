DEBUG = false

if bit then
	BOR = bit.bor
	BXOR = bit.bxor
	BAND = bit.band
	BLSH = bit.lshift
	BRSH = bit.rshift
else
	BOR = load("return function(a,b) return a | b end")()
	BXOR = load("return function(a,b) return a ^ b end")()
	BAND = load("return function(a,b) return a & b end")()
	BLSH = load("return function(a,b) return a << b end")()
	BRSH = load("return function(a,b) return a >> b end")()
end

-- Read everything in.

l = io.read("*line")
arr = l:match("state: (.*)")
pots = {pos = 0, min = 0}
for c in arr:gmatch(".") do
	pots.max = pots.pos
	pots[pots.pos] = c == "#"
	pots.pos = pots.pos + 1
end
io.read("*line")

-- Bitfield representation.

sttab = {}
patid = 0
while true do
	l = io.read("*line")
	if not l then break end
	
	pat,val = l:match("(.....) => (.)")
	
	patid = patid + 1
	pattab = {}
	patv = 0
	patpos = 4
	for c in pat:gmatch(".") do
		patv = patv + BLSH((c == "#" and 1 or 0), patpos)
		patpos = patpos - 1
	end
	if val == "#" then
		sttab[patv] = true
	end
end

-- Compute the gen0 table. We compute values as a bitfield:
-- xssRRRssx =>
-- x6543210x
--    RRR
--    210
-- Note that r1 is center here, r2 is score -1.
gen0 = {}
for val=0,511 do
	c = BAND(BRSH(val,1), 0x7F) -- 7 bit center
	res = 0
	res = res + (sttab[BAND(     c    , 0x1F)] and 1 or 0)
	res = res + (sttab[BAND(BRSH(c, 1), 0x1F)] and 2 or 0)
	res = res + (sttab[BAND(BRSH(c, 2), 0x1F)] and 4 or 0)
	pop = 0
	score = 0
	for i = -4,4 do
		if BAND(val, BRSH(0x100, i+4)) ~= 0 then
			pop = pop + 1
			score = score + i
		end
	end
	gen0[val] = {res = res, abc = val, pop = pop, score = score, hash = val, cache = {}, gen = 0}
end

function evallinear(pots, min, max)
	local pots2 = {}
	pots2.min = math.huge
	pots2.max = -math.huge
	for i=pots.min-3,pots.max+3 do
		local pat = 0
		for j=-2,2 do
			pat = pat + BLSH(pots[i+j] and 1 or 0, 2 - j)
		end
		pots2[i] = sttab[pat]
		if sttab[pat] then
			if i < pots2.min then pots2.min = i end
			if i > pots2.max then pots2.max = i end
		end
	end
	return pots2
end

function prlinear(pots, ins)
	local s = ins or ""
	for i=pots.min-2,pots.max+2 do
		s = s .. (pots[i] and "#" or ".")
	end
	print(pots.min, pots.max, s)
end

function comparlinear(pots1, pots2, min, max)
	min = min or pots1.min
	max = max or pots1.max
	
	for i=min,max do
		assert((not not pots1[i]) == (not not pots2[i]), "linear comparison failure at "..i)
	end
end

--for k,v in pairs(gen0) do print(k,v.res,v.pop,v.score) end

-- hlife hash manipulation routines

function arrsz(arr)
	local sz = 9
	for i=1,arr.gen do
		sz = sz * 3
	end
	return sz
end

-- take a proto-hlife object -- {a,b,c,gen} -- and return a reference to the
-- -- canonical hashed version.  If no canonical hashed version exists, this
-- becomes the canonical hashed version, and pop, score, and hash are filled
-- in.  a,b,c must be canonicalized.
--
-- This is the "hash" part of hashlife.

hlife_nobjs = 0
hlife_savings = 0
hlife_tab = {}

function canonicalize(arr)
	if arr.gen == 0 then return arr end
	
	if not arr.hash then
		function rol16(v, bits)
			return BOR(BAND(BLSH(v, bits), 0xFFFF), BRSH(BAND(v, 0xFFFF), 16-bits))
		end
		arr.hash = BXOR(rol16(arr.a.hash, 5), BXOR(rol16(arr.b.hash, 10), arr.c.hash))
	end
	
	if not hlife_tab[arr.hash] then
		hlife_tab[arr.hash] = {}
	end
	
	for _,arr2 in pairs(hlife_tab[arr.hash]) do
		if arr2.a == arr.a and arr2.b == arr.b and arr2.c == arr.c then
			hlife_savings = hlife_savings + 1
			return arr2
		end
	end
	
	local sz = arrsz(arr)
	if not arr.score then
		arr.score = arr.a.score + arr.a.pop * -(sz / 3) + arr.b.score + arr.c.score + arr.c.pop * (sz / 3)
	end
	if not arr.pop then
		arr.pop = arr.a.pop + arr.b.pop + arr.c.pop
	end
	
	if not arr.cache then
		arr.cache = {}
	end
	
	table.insert(hlife_tab[arr.hash], arr)
	hlife_nobjs = hlife_nobjs + 1
	
	return arr
end

-- empty object of any generation
empty = {}
empty[0] = gen0[0]

function getempty(gen)
	if not empty[gen] then
		local emptym1 = getempty(gen-1)
		local t = { a = emptym1, b = emptym1, c = emptym1, gen = gen }
		t = canonicalize(t) -- should not be in hashes already!
		empty[gen] = t
	end
	return empty[gen]
end

function isempty(arr)
	return arr == empty[arr.gen]
end

function expando_a(arr)
	return canonicalize({a = arr, b = getempty(arr.gen), c = getempty(arr.gen), gen = arr.gen + 1})
end

function expando_b(arr)
	return canonicalize({a = getempty(arr.gen), b = arr, c = getempty(arr.gen), gen = arr.gen + 1})
end

function expando_c(arr)
	return canonicalize({a = getempty(arr.gen), b = getempty(arr.gen), c = arr, gen = arr.gen + 1})
end

function isminimal(arr)
	return (not isempty(arr.a)) or (not isempty(arr.c))
end

function contract(arr)
	while not isminimal(arr) and arr.gen ~= 1 do
		arr = arr.b
	end
	return arr
end

-- consistency check
function dump(arr, pfx)
	print(pfx .. arr.gen)
	if arr.gen == 0 then return end
	dump(arr.a, pfx.." ")
	dump(arr.b, pfx.." ")
	dump(arr.c, pfx.." ")
end

-- step routines

function g0_packbca(bc, a)
	return gen0[BOR(BLSH(BAND(bc.abc, 0x3F), 3), BRSH(a.abc, 6))]
end
function g0_packcab(c, ab)
	return gen0[BOR(BLSH(BAND(c.abc, 0x7), 6), BRSH(ab.abc, 3))]
end
function g0_packres(a, b, c)
	return gen0[BLSH(a, 6) + BLSH(b, 3) + c]
end

function gn_packbca(bc, a)
	return canonicalize({a = bc.b, b = bc.c, c = a.a, gen = bc.gen})
end
function gn_packcab(c, ab)
	-- c.c
	return canonicalize({a = c.c, b = ab.a, c = ab.b, gen = ab.gen})
end
function gn_packres(a, b, c)
	return canonicalize({a = a, b = b, c = c, gen = a.gen + 1})
end

function getres(arr)
	if arr.res then return arr.res end
	
	-- In this function, we use 1, 2, 3, 4, 5, 6, 7, 8, 9 to refer to
	-- a.a, a.b, a.c, b.a, b.b, b.c, c.a, c.b, c.c, ...
	
	-- Gen 1 is very special, since it requires bit packing of gen 0s.

	local packbca
	local packcab
	local packres
	
	if arr.gen == 1 then
		packbca, packcab, packres = g0_packbca, g0_packcab, g0_packres
	else
		packbca, packcab, packres = gn_packbca, gn_packcab, gn_packres
	end
	
	local x_2 = getres(arr.a)
	local x_3 = getres(packbca(arr.a, arr.b))
	local x_4 = getres(packcab(arr.a, arr.b))
	local x_5 = getres(arr.b)
	local x_6 = getres(packbca(arr.b, arr.c))
	local x_7 = getres(packcab(arr.b, arr.c))
	local x_8 = getres(arr.c)
	
	local xx_3 = getres(packres(x_2, x_3, x_4))
	local xx_4 = getres(packres(x_3, x_4, x_5))
	local xx_5 = getres(packres(x_4, x_5, x_6))
	local xx_6 = getres(packres(x_5, x_6, x_7))
	local xx_7 = getres(packres(x_6, x_7, x_8))
	
	local xxx_4 = getres(packres(xx_3, xx_4, xx_5))
	local xxx_5 = getres(packres(xx_4, xx_5, xx_6))
	local xxx_6 = getres(packres(xx_5, xx_6, xx_7))

	arr.res = packres(xxx_4, xxx_5, xxx_6)
	
	return arr.res
end


depth = 0
function dprint(s)
	for i=1,depth do s = "  " .. s end
	print(s)
end

function consist(arr)
	s = "consistency check on arr "..arr.gen.."<"..arr.a.gen..","..arr.b.gen..","..arr.c.gen..">"
	assert(arr.a.gen == arr.gen - 1, s)
	assert(arr.b.gen == arr.gen - 1, s)
	assert(arr.c.gen == arr.gen - 1, s)
end

stepcachehits = 0
stepcachemisses = 0

function step(arr, n)
	local arr00 = arr
	local n0 = n
	depth = depth + 1
	while n > 0 do
		if DEBUG then consist(arr) end
		
		-- Recall that the result of gen 0 is one step; the result
		-- of gen 1 is three steps; the result of gen 2 is 9 steps;
		-- ...  so the result of gen g is 3 ** g steps.  If we can
		-- take at least 3 ** (g + 2) steps, then we
		-- getres(expando(expando(t))).  
		
		local steps_gen = 1
		for i=1,arr.gen do
			steps_gen = steps_gen * 3
		end
		
		if DEBUG then dprint("STEP<"..arr.gen..">: "..n.." steps to go with native step size "..steps_gen) end
		
		local arr0 = arr

		if false then		
		elseif arr.cache[n] then
			stepcachehits = stepcachehits + 1
			arr = arr.cache[n]
			n = 0
		elseif n >= steps_gen * 3 * 3 and arr.cache[steps_gen * 3 * 3] then
			stepcachehits = stepcachehits + 1
			arr = arr.cache[steps_gen * 3 * 3]
			n = n - steps_gen * 3 * 3
		elseif n >= steps_gen * 3 * 3 then
			stepcachemisses = stepcachemisses + 1
			if DEBUG then dprint("STEP<"..arr.gen..">: giant step") end
			while n >= steps_gen * 3 * 3 * 3 do
				arr = expando_b(arr)
				steps_gen = steps_gen * 3
			end
			arr = getres(expando_b(expando_b(arr)))
			arr = contract(arr)
			arr0.cache[steps_gen * 3 * 3] = arr
			n = n - steps_gen * 3 * 3
		elseif n >= steps_gen * 3 and arr.cache[steps_gen * 3] then
			stepcachehits = stepcachehits + 1
			arr = arr.cache[steps_gen * 3]
			n = n - steps_gen * 3
		elseif n >= steps_gen * 3 then
			if DEBUG then dprint("STEP<"..arr.gen..">: medium step") end
			arr = canonicalize({
				a = getres(expando_c(arr)),
				b = getres(expando_b(arr)),
				c = getres(expando_a(arr)),
				gen = arr.gen + 1
				})
			arr = contract(arr)
			arr0.cache[steps_gen * 3] = arr
			n = n - steps_gen * 3
		elseif n >= steps_gen and arr.cache[steps_gen] then
			stepcachehits = stepcachehits + 1
			arr = arr.cache[steps_gen]
			n = n - steps_gen
		elseif n >= steps_gen and arr.gen ~= 0 then
			stepcachemisses = stepcachemisses + 1
			if DEBUG then dprint("STEP<"..arr.gen..">: tiny step") end
			arr = contract(gn_packres(
				gn_packres(
					getempty(arr.c.gen),
					getempty(arr.c.gen),
					getres(gn_packres(
						getempty(arr.a.gen),
						getempty(arr.a.gen),
						arr.a))),
				gn_packres(
					getres(gn_packres(
						getempty(arr.a.gen),
						arr.a,
						arr.b)),
					getres(arr),
					getres(gn_packres(
						arr.b,
						arr.c,
						getempty(arr.c.gen)))),
				gn_packres(
					getres(gn_packres(
						arr.c,
						getempty(arr.c.gen),
						getempty(arr.c.gen))),
					getempty(arr.c.gen),
					getempty(arr.c.gen))
			))
			arr0.cache[steps_gen] = arr
			n = n - steps_gen
		elseif arr.gen == 0 or arr.gen == 1 then -- Single-step.
			if arr.gen == 0 then arr = expando_b(arr) end
			
			stepcachemisses = stepcachemisses + 1
			
			if DEBUG then dprint("STEP<"..arr.gen..">: single-step on gen 1") end
			
			-- Create sub-cracked versions.
			local Ac = g0_packbca(gen0[0], arr.a).res
			local aa = g0_packcab(gen0[0], arr.a).res
			local ab = arr.a.res
			local ac = g0_packbca(arr.a, arr.b).res
			local ba = g0_packcab(arr.a, arr.b).res
			local bb = arr.b.res
			local bc = g0_packbca(arr.b, arr.c).res
			local ca = g0_packcab(arr.b, arr.c).res
			local cb = arr.c.res
			local cc = g0_packbca(arr.c, gen0[0]).res
			local Ca = g0_packcab(arr.c, gen0[0]).res
			
			-- Create normal versions.
			local A = g0_packres(0, 0, Ac)
			local a = g0_packres(aa, ab, ac)
			local b = g0_packres(ba, bb, bc)
			local c = g0_packres(ca, cb, cc)
			local C = g0_packres(Ca, 0, 0)
			
			-- Now pack.
			local zzA = gn_packres(gen0[0], gen0[0], A)
			local abc = gn_packres(a, b, c)
			local Czz = gn_packres(C, gen0[0], gen0[0])
			
			local zzAabcCzz = gn_packres(zzA, abc, Czz)
			
			arr.cache[1] = contract(zzAabcCzz)
			arr = arr.cache[1]
		
			n = n - 1
		else -- Recur into stepping the horrible and painful way.
		
			-- We can only take as many steps at a time as we
			-- have support... otherwise we have to break it up. 
			-- To take n steps, you need n*2 support on either
			-- side, so nstep <= floor(arrsz(arr.a.a) / 2)
			
			local nstep = n
			local stepmax = math.floor(arrsz(arr.a.a) / 2)
			if nstep > stepmax then
				nstep = stepmax
			end
			
			if arr.cache[nstep] then
				stepcachehits = stepcachehits + 1
				arr = arr.cache[nstep]
			else
				-- We construct elements the size of arr.a (g-1),
				-- which we then pass into a step function, which
				-- results in elements the size of arr.a.a (g-2),
				-- which we then reconstruct.
				stepcachemisses = stepcachemisses + 1
			
				if DEBUG then dprint("STEP<"..arr.gen..">: recur: "..nstep.." steps on t<"..arr.gen..">") end
				
				function central(t, g)
					while t.gen < g do
						t = expando_b(t)
					end
					while t.gen > g do
						t = t.b
					end
					return t
				end
				
				local zm1 = getempty(arr.gen - 1)
				local Ac = central(step(gn_packbca(zm1, arr.a), nstep), arr.gen - 2)
				local aa = central(step(gn_packcab(zm1, arr.a), nstep), arr.gen - 2)
				local ab = central(step(arr.a, nstep), arr.gen - 2)
				local ac = central(step(gn_packbca(arr.a, arr.b), nstep), arr.gen - 2)
				local ba = central(step(gn_packcab(arr.a, arr.b), nstep), arr.gen - 2)
				local bb = central(step(arr.b, nstep), arr.gen - 2)
				local bc = central(step(gn_packbca(arr.b, arr.c), nstep), arr.gen - 2)
				local ca = central(step(gn_packcab(arr.b, arr.c), nstep), arr.gen - 2)
				local cb = central(step(arr.c, nstep), arr.gen - 2)
				local cc = central(step(gn_packbca(arr.c, zm1), nstep), arr.gen - 2)
				local Ca = central(step(gn_packcab(arr.c, zm1), nstep), arr.gen - 2)
				
				local zm2 = getempty(arr.gen - 2)
				local A = gn_packres(zm2, zm2, Ac)
				local a = gn_packres(aa, ab, ac)
				local b = gn_packres(ba, bb, bc)
				local c = gn_packres(ca, cb, cc)
				local C = gn_packres(Ca, zm2, zm2)
				if DEBUG then
					consist(A)
					consist(a)
					consist(b)
					consist(c)
					consist(C)
				end
				
				local z = getempty(arr.gen - 1)
				local zzA = gn_packres(z, z, A)
				local abc = gn_packres(a, b, c)
				local Czz = gn_packres(C, z, z)
				if DEBUG then
					consist(zzA)
					consist(abc)
					consist(Czz)
				end
				
				local zzAabcCzz = contract(gn_packres(zzA, abc, Czz))
				
				arr.cache[nstep] = zzAabcCzz
				arr = zzAabcCzz
				if DEBUG then consist(arr) end
			end
			
			n = n - nstep
		end
	end
	
	arr00.cache[n0] = arr
	depth = depth - 1
	return arr
end

-- Now create the input in hlife format.  Remember that b.b.b.b.b.... is pot 0.


-- create a mutated version of array arr, with a bit set at pot p
function putpos(arr, p)
	-- Make sure 'arr' is big enough to hold p.  If it isn't, expand it.
	
	-- gen 0 holds 9 bits; gen 1 holds 27 bits; gen 2 holds 81 bits; in
	-- general, gen n holds 3 ** (gen + 2)
	local sz = arrsz(arr)
	
	while p > (sz - 1) / 2 do
		-- too small? create an expanded arr
		arr = expando_b(arr)
		sz = sz * 3
	end
	
	-- Convert 'p' to an easier-to-think-about representation.
	p = p + (sz - 1) / 2
	
	-- arr now holds a canonicalized expanded version that is large
	-- enough to hold a bit at pot p.  recur down until we find the 
	-- right place to put something.
	if arr.gen == 0 then
		return gen0[BOR(arr.abc, BRSH(0x100, p))]
	end
	
	-- where do we recur?  we convert to an easier-to-think-about representation:
	local submiddle = ((sz / 3) - 1) / 2
	if p < (sz / 3) then
		local pofs = p
		return canonicalize({a = putpos(arr.a, pofs - submiddle), b = arr.b, c = arr.c, gen = arr.gen})
	elseif p < (2 * sz / 3) then
		local pofs = p - sz / 3
		return canonicalize({a = arr.a, b = putpos(arr.b, pofs - submiddle), c = arr.c, gen = arr.gen})
	else
		local pofs = p - 2 * sz / 3
		return canonicalize({a = arr.a, b = arr.b, c = putpos(arr.c, pofs - submiddle), gen = arr.gen})
	end
end

function tolinear(arr, ofs)
	local lmin = math.huge
	local lmax = -math.huge
	local linear = {}
	
	function lput(lpos)
		if lpos < lmin then lmin = lpos end
		if lpos > lmax then lmax = lpos end
		linear[lpos] = true
	end
	
	function tolinear_(arr, lpos)
		if arr == empty[arr.gen] then
			return
		end
		
		if lmax - lmin > 500 then return end
		
		if arr.gen == 0 then
			for i=0,8 do
				if BAND(arr.abc,BRSH(0x100,i)) ~= 0 then
					lput(lpos + i - 4)
				end
			end
			return
		end
		
		local sz = arrsz(arr)

		tolinear_(arr.a, lpos - sz / 3)
		tolinear_(arr.b, lpos)
		tolinear_(arr.c, lpos + sz / 3)
	end
	
	tolinear_(arr, ofs or 0)
	linear.min = lmin
	linear.max = lmax
	
	if lmax - lmin > 500 then return nil end
	return linear
end

cur = getempty(0)
for i=0,pots.max do
	if pots[i] then cur = putpos(cur, i) end
end

--out,min,max = tolinear(cur)
--s = ""
--score = 0
--for i=0,pots.max do
--	s = s .. (pots[i] and "#" or ".")
--	score = score + (pots[i] and i or 0)
--end
--print(s,score)
--s = ""
--for i=0,pots.max do
--	s = s .. (out[i] and "#" or ".")
--end
--print(s,cur.score,min,max,cur.gen)

STEPS = arg[1]:gsub("_","")
cur = step(cur, tonumber(STEPS))
print(cur.score)
out = tolinear(cur)
if out then
	prlinear(out)
else
	print("output too big (population "..cur.pop..")")
end


print("objects:", hlife_nobjs)
print("you saved:", hlife_savings)
print("step cache stats: "..stepcachehits.." hits, "..stepcachemisses.." misses")

occupancy = 0
buckets = 0
maxbkt = 0
zeroes = 0
for k,v in pairs(hlife_tab) do
	buckets = buckets + 1
	if #v > occupancy then occupancy = #v maxbkt = k end
	for _,obj in ipairs(v) do
		if obj.pop == 0 then zeroes = zeroes + 1 end
	end
end
print(buckets.." buckets, max occupancy "..occupancy.." in bucket "..maxbkt, zeroes)
