st = {}

nflashes = 0

while true do
	line = io.read("*line")
	if not line then break end
	row = {}
	for c in line:gmatch(".") do
		table.insert(row, { nrg = tonumber(c), flashed = false } )
	end
	table.insert(st, row)
end

function step(st)
	local nst = {}
	for y,row in ipairs(st) do
		nst[y] = {}
		for x,oct in ipairs(row) do
			nst[y][x] = { nrg = oct.nrg + 1, flashed = false }
		end
	end
	
	function flash(fy,fx)
		if nst[fy][fx].flashed then return false end
		nst[fy][fx].flashed = true
		inc(fy-1, fx-1)
		inc(fy  , fx-1)
		inc(fy+1, fx-1)
		inc(fy-1, fx  )
		inc(fy+1, fx  )
		inc(fy-1, fx+1)
		inc(fy  , fx+1)
		inc(fy+1, fx+1)
		return true
	end
	function inc(fy,fx)
		if not nst[fy] then return false end
		if not nst[fy][fx] then return false end
		nst[fy][fx].nrg = nst[fy][fx].nrg + 1
		if nst[fy][fx].nrg > 9 then
			return flash(fy, fx)
		end
	end
	local didflash = true
	while didflash do
		didflash = false
		for y,row in ipairs(nst) do
			for x,oct in ipairs(row) do
				if oct.nrg > 9 then
					didflash = flash(y,x) or didflash
				end
			end
		end
	end
	local xflashes = 0
	for y,row in ipairs(nst) do
		for x,oct in ipairs(row) do
			if oct.flashed then
				oct.nrg = 0
				nflashes = nflashes + 1
				xflashes = xflashes + 1
			end
		end
	end
	return nst,xflashes
end

local n = 1
while true do
	st,xflashes = step(st)
	if n == 100 then print(nflashes) end
	if xflashes == 100 then print(n) break end
	n = n + 1
end
