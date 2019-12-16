line = io.read("*line")

seq = {}
for c in line:gmatch(".") do
	table.insert(seq, tonumber(c))
end

function iter(seq)
	local basis = {}
	local gen = 0
	local add = 0
	local tadd = 0
	local dn = 0
	local b0stat = 0
	local nb0stat = 0
	
	-- Basis 1 is the sequence itself.
	-- A basis b has ceil((seq+1)/b) phases.
	basis[1] = {}
	basis[1][0] = 0
	for i=1,#seq do
		basis[1][i] = seq[i]
	end
	
	for b=2,#seq do
		-- A new basis number 'b' is a multiple of a prime with some
		-- other previous basis, 'b0'.  Find the highest possible b0.
		local b0 = 1
		for b0p = 1,b-1 do
			if b % b0p == 0 then
				b0 = b0p
			end
		end
		
		local barr = {}
		local b0arr = basis[b0]
		basis[b] = barr
		local incr = math.floor(b / b0)

		assert(#b0arr+1 == math.ceil((#seq+1)/b0))
		local max = math.floor(#b0arr/incr)
		barr[max] = 0
		for i=0,max do
			gen = gen + 1
			local acc = 0
			local jmax = incr - 1
			if i == max then jmax = #b0arr % incr end
			for j=0,jmax do
				if b0arr[i*incr+j] == nil then assert(i == max)
				else
				acc = acc + (b0arr[i*incr + j] or 0)
				add = add + 1
				tadd = tadd + 1
				end
			end
			barr[i] = acc
		end
		
		dn = dn + 1
		b0stat = b0stat + b0
		nb0stat = nb0stat + #b0arr
		if b % 1000 == 0 or b < 100 then
			print(string.format("b %d = %d / %d, b0 %d has %d, ought have %d, stats %d %d, "..
			                    "avg ops / basis %f, avg ops / bph %f, avg b0 %f, avg #b0 %f",
			                    b, b0, incr, b0, #b0arr+1, math.ceil((#seq+1)/b0), gen, add,
			                    add / dn, add / gen, b0stat / dn, nb0stat / dn))
			gen = 0
			add = 0
			dn = 0
			b0stat = 0
			nb0stat = 0
		end
	end
	
	-- Finally, for all bases b that have phases p, where we represent
	-- the sum associated with phase p in basis b as b_p, the "phase
	-- total" for basis b (i.e., output sum) is the summation of b_p for
	-- all p%4 == 1 minus the summation of b_p for all p%4 == 3.
	local next = {}
	for b=1,#seq do
		local acc = 0
		for p=0,#basis[b] do
			if     p % 4 == 1 then acc = acc + basis[b][p]
			elseif p % 4 == 3 then acc = acc - basis[b][p]
			end
			tadd = tadd + 1
		end
		table.insert(next, math.abs(acc) % 10)
	end
	
	print(tadd)
	
	return next
end

local rofs = 0
if arg[1] == "b" then
	rofs = rofs * 10 + seq[1]
	rofs = rofs * 10 + seq[2]
	rofs = rofs * 10 + seq[3]
	rofs = rofs * 10 + seq[4]
	rofs = rofs * 10 + seq[5]
	rofs = rofs * 10 + seq[6]
	rofs = rofs * 10 + seq[7]
	
	print("Setting up...")
	local xseq = {}
	for i=1,tonumber(arg[3]) or 10000 do
		for j=1,#seq do
			table.insert(xseq, seq[j])
		end
	end
	seq = xseq
	print("ok, #seq "..#seq)
end

for i=1,tonumber(arg[2]) or 100 do
	print(i)
	seq = iter(seq)
end

s=""
for i=1+rofs,8+rofs do
	s = s .. seq[i]
end
print(s)

