str = io.read("*line")
io.read("*line")
substs = {}

while true do
	line = io.read("*line")
	if not line or line == "" then break end
	c1,c2,ins = line:match("(.)(.) .. (.)")
	substs[c1] = substs[c1] or {}
	substs[c1][c2] = ins
end

hm = {}

-- THERE IS A MEMOIZATION FUNCTION ON ANY PAIR OF LETTERS WITH THAT PAIR, AND THE DEPTH, TO A HISTOGRAM
function histo_depth(c1, c2, steps)
	if steps == 0 or not substs[c1] or not substs[c1][c2] then
		return { }
	end
	if hm[c1..c2..steps] then return hm[c1..c2..steps] end
	local cn = substs[c1][c2]
	local h0 = histo_depth(c1, cn, steps - 1)
	local h1 = histo_depth(cn, c2, steps - 1)
	local hmerge = {}
	for c,count in pairs(h0) do
		hmerge[c] = count
	end
	for c,count in pairs(h1) do
		hmerge[c] = (hmerge[c] or 0) + count
	end
	hmerge[cn] = (hmerge[cn] or 0) + 1
	hm[c1..c2..steps] = hmerge
	return hmerge
end

function histo_string(str, steps)
	local hmerge = {}
	for i=1,#str do
		local c1 = str:sub(i,i)
		local c2 = str:sub(i+1,i+1)
		hmerge[c1] = (hmerge[c1] or 0) + 1
		local hres = histo_depth(c1, c2, steps)
		for c,count in pairs(hres) do
			hmerge[c] = (hmerge[c] or 0) + count
		end
	end
	return hmerge
end

function mclc(counts)
	local icounts = {}
	for c,count in pairs(counts) do
		print("",c,count)
		table.insert(icounts, count)
	end
	table.sort(icounts)
	return icounts[#icounts] - icounts[1]
end

print(mclc(histo_string(str, 40)))
