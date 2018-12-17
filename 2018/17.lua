map = {} -- [y][x]
CLAY = {}
WATER = {}
HYPOTHETICAL = {}
minx = math.huge
maxx = -math.huge
miny = math.huge
maxy = -0
nwater = 0

while true do
	l = io.read("*line")
	if not l then break end
	
	x,ytop,ybot = l:match("x=(%d+), y=(%d+)%.%.(%d+)")
	if x then
		x = tonumber(x)
		ytop = tonumber(ytop)
		ybot = tonumber(ybot)
		for y=ytop,ybot do
			if y < miny then miny = y end
			if y > maxy then maxy = y end
			if not map[y] then
				map[y] = {}
			end
			if x < minx then minx = x end
			if x > maxx then maxx = x end
			map[y][x] = CLAY
		end
	end
	
	y,xl,xr = l:match("y=(%d+), x=(%d+)%.%.(%d+)")
	if y then
		y = tonumber(y)
		xl = tonumber(xl)
		xr = tonumber(xr)
		if y > maxy then maxy = y end
		if y < miny then miny = y end
		if not map[y] then
			map[y] = {}
		end
		for x=xl,xr do
			map[y][x] = CLAY
			if x < minx then minx = x end
			if x > maxx then maxx = x end
		end
	end
end
minx = minx - 1
maxx = maxx + 1

function isclay(y, x) return map[y] and (map[y][x] == CLAY) end
function iswater(y, x) return map[y] and (map[y][x] == WATER) end
function ishypo(y, x) return map[y] and (map[y][x] == HYPOTHETICAL) end
function avail(y, x) return not isclay(y,x) and not iswater(y,x) end
function put(y, x, v) if not map[y] then map[y] = {} end map[y][x] = v end

function prmap()
	for y=miny,maxy do
		s = string.format("%5d ", y)
		for x = minx,maxx do
			if isclay(y, x) then
				s = s .. "#"
			elseif iswater(y, x) then
				s = s .. "~"
			elseif ishypo(y, x) then
				s = s .. "|"
			else
				s = s .. "."
			end
		end
		print(s)
	end
	print("EOM")
end

function score()
	local n = 0
	for y=miny,maxy do
		for x = minx,maxx do
			if iswater(y, x) or ishypo(y, x) then
				n = n + 1
			end
		end
	end
	return n
end

function nwater()
	local n = 0
	for y=miny,maxy do
		for x = minx,maxx do
			if iswater(y, x) then
				n = n + 1
			end
		end
	end
	return n
end


droppoints = { {wx = 500, wy = 0} }

dropped = {}
function hash(wy, wx) return wy * 10000 + wx end
function adddrop(wy, wx)
	if dropped[hash(wy, wx)] then return end
	table.insert(droppoints, { wx = wx, wy = wy })
	dropped[hash(wy, wx)] = true
end

function dprint(...) if DEBUG then print(...) end end

function hasbelow(wy, wx)
	while avail(wy, wx) and wy <= maxy do
		wy = wy + 1
	end
	return wy <= maxy
end

local niters = 0
while #droppoints ~= 0 do
	niters = niters + 1
	
	DEBUG = false

	while true do
		if #droppoints == 0 then break end
		wx = droppoints[1].wx
		wy = droppoints[1].wy
		if avail(wy, wx) then break end
		table.remove(droppoints, 1)
	end
	if #droppoints == 0 then break end
	overflow = false
	
	if niters % 1000 == 0 or DEBUG then
		print(niters, #droppoints, score())
	end
	if DEBUG then prmap() end
	dprint(#droppoints)
	
	while true do
		if wy > maxy then
			overflow = true
			break
		end
		
		dprint(wy, wx)
		local full = false
		
		-- Drop as low as we can.
		while avail(wy+1, wx) do
			put(wy+1, wx, HYPOTHETICAL)
			wy = wy + 1
			if wy > maxy then
				overflow = true
				break
			end
		end
		if overflow then
			dprint("OVERFLOW")
			break
		end
		
		foundhome = false
		
		-- There is something below us -- either water, or clay.
		if isclay(wy+1, wx) then
			dprint("","CLAY BELOW")
			foundhome = true
		end
		
		-- If it's water, we can try to push water below us around.
		if iswater(wy+1, wx) then
			dprint("","PUSHING", wy, wx)
			-- Start by pushing water below us to the left.
			local mwx = wx
			while iswater(wy+1, mwx) do
				mwx = mwx - 1
			end
			if avail(wy+1, mwx) then
				dprint("","PUSHED LEFT")
				foundhome = true
				wy = wy+1
				wx = mwx
			end
			
			-- Try pushing water below us to the right.
			if not foundhome then
				mwx = wx
				while iswater(wy+1, mwx) do
					mwx = mwx + 1
				end
				if avail(wy+1, mwx) then
					dprint("PUSHED RIGHT")
					foundhome = true
					wy = wy + 1
					wx = mwx
				end
			end
			
			if not foundhome then
				dprint("DID NOT PUSH")
				foundhome = true
			end
		end
		
		-- If we're maybe home, look for an opportunity to fall off left or right.
		if foundhome then
			dprint("","FOUND HOME", wy, wx)
			local mwx = wx
			local fallwx = nil
			while avail(wy, mwx) do
				put(wy, mwx, HYPOTHETICAL)
				if avail(wy+1, mwx) then
					adddrop(wy, mwx)
					dprint("","CAN FALL RIGHT", hasbelow(wy, wx))
					overflow = true
					if hasbelow(wy, wx) then
						fallwx = mwx
					end
					mwx = mwx + 1
					break
				end
				mwx = mwx - 1
			end

			mwx = wx
			while avail(wy, mwx) do
				put(wy, mwx, HYPOTHETICAL)
				if avail(wy+1, mwx) then
					adddrop(wy, mwx)
					dprint("", "CAN FALL LEFT", hasbelow(wy, wx))
					if hasbelow(wy, wx) then
						fallwx = mwx
					end
					overflow = true
					break
				end
				mwx = mwx + 1
			end
			
			if fallwx then
				wx = fallwx
				foundhome = false
				overflow = false
			end
		end
		
		if overflow then break end
		
		if foundhome then
			assert(avail(wy, wx), wy..","..wx..","..niters)
			put(wy, wx, WATER)
			break
		end
	end
	
	if overflow then
		dprint("GOODBYE", wy, #droppoints)
		table.remove(droppoints, 1)
	end
	
--	dprint("")
--	prmap()
end


prmap()
print(score(), nwater())