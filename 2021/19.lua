BCNPAIR = 12

rotations = { }

function rotnam(rot)
	return rot.x.n .. rot.x.ax .. rot.y.n .. rot.y.ax .. rot.z.n .. rot.z.ax
end

function rot90x(rot) -- rotate 90 degrees clockwise around x
	return { x = rot.x, y = rot.z, z = { n = -rot.y.n, ax = rot.y.ax } }
end

function rot90y(rot) -- rotate 90 degrees clockwise around y
	return { x = rot.z, y = rot.y, z = { n = -rot.x.n, ax = rot.x.ax } }
end

function rot90z(rot) -- rotate 90 degrees clockwise around z
	return { x = rot.y, y = { n = -rot.x.n, ax = rot.x.ax }, z = rot.z }
end

function insrot(rot)
	rotations[rotnam(rot)] = rot
end

insrot({ x = { n = 1, ax = "x" }, y = {n = 1, ax = "y" }, z = {n = 1, ax = "z" }})

function nrots() local n = 0 for _,_ in pairs(rotations) do n = n + 1 end return n end
while nrots() < 24 do
	for _,rot in pairs(rotations) do
		insrot(rot90x(rot))
		insrot(rot90y(rot))
		insrot(rot90z(rot))
	end
end

scanners = {}
while true do
	line = io.read("*line")
	if not line then break end
	-- ignore the scanner number
	
	scnr = { id = #scanners + 1 }
	while true do
		line = io.read("*line")
		if line == "" or not line then break end
		local x,y,z = line:match("(%-?%d+),(%-?%d+),(%-?%d+)")
		assert(x)
		x,y,z = tonumber(x),tonumber(y),tonumber(z)
		table.insert(scnr, { x = x, y = y, z = z })
	end
	table.insert(scanners, scnr)
end

function trnpoint(rot, ofs, pt)
	if not ofs then ofs = { x = 0, y = 0, z = 0 } end
	return { x = pt[rot.x.ax] * rot.x.n + ofs.x,
	         y = pt[rot.y.ax] * rot.y.n + ofs.y,
	         z = pt[rot.z.ax] * rot.z.n + ofs.z }
end

function trnpointlocked(scanner, pt)
	return trnpoint(scanner.rot, scanner.pos, pt)
end

function lockedpairs(labspts, unlabspts)
	local hist = {}
	for _,lpt in ipairs(labspts) do
		local x,y,z,s
		for _,unlpt in ipairs(unlabspts) do
			x = lpt.x-unlpt.x
			y = lpt.y-unlpt.y
			z = lpt.z-unlpt.z
			s = (x+1000)*2000000 + (y+1000)*2000 + z --x..","..y..","..z
			if not hist[s] then hist[s] = { x = x, y = y, z = z, pts = {} } end
			hist[s].pts[unlpt] = true
		end
	end
	for hn,hist in pairs(hist) do
		local n = 0
		for _,_ in pairs(hist.pts) do
			n = n + 1
		end
		if n >= BCNPAIR then
			return hist
		end
	end
	return nil
end

function tryscanners(ls, unls)
	for rnam,rot in pairs(rotations) do
		local abspts = {}
		for _,pt in ipairs(unls) do
			table.insert(abspts, trnpoint(rot, nil, pt))
		end
		local lockofs = lockedpairs(ls.abspts, abspts)
		if lockofs then
			for _,pt in ipairs(abspts) do
				pt.x = pt.x + lockofs.x
				pt.y = pt.y + lockofs.y
				pt.z = pt.z + lockofs.z
			end
			unls.abspts = abspts
			unls.rot = rot
			unls.pos = lockofs
			unls.locked = true
			return true
		end
	end
	return false
end

scanners[1].rot = rotations["1x1y1z"]
scanners[1].pos = { x = 0, y = 0, z = 0 }
scanners[1].locked = true
scanners[1].abspts = scanners[1] -- lol?

unlocked = #scanners - 1
lastunlocked = 0
while unlocked > 0 do
	-- for each scanner that is unlocked ...
	for unln,unls in pairs(scanners) do
		if not unls.locked then
			-- for each scanner that is locked ...
			for ln,ls in pairs(scanners) do
				if ls.locked then
					-- unls is unlocked, ls is locked
					if tryscanners(ls,unls) then
						print("LOCKED "..ls.id-1 .. "+"..unls.id-1 .. " @ " .. unls.pos.x ..","..unls.pos.y..","..unls.pos.z)
						unlocked = unlocked - 1
						break
					end
				end
			end
		end
	end
	if lastunlocked == unlocked then assert(false, "NO PROGRESS -- ABORT") end
	lastunlocked = unlocked
	print("...")
end

beacons = {}
for _,sc in ipairs(scanners) do
	for _,b in ipairs(sc.abspts) do
		beacons[b.x..","..b.y..","..b.z] = {x = b.x, y = b.y, z = b.z}
	end
end

nb = 0
for bnam,b in pairs(beacons) do
	nb = nb + 1
end
print("*",nb)

local bigman = 0
for _,b1 in pairs(scanners) do
	for _,b2 in pairs(scanners) do
		local man = math.abs(b1.pos.x-b2.pos.x) +
		            math.abs(b1.pos.y-b2.pos.y) +
		            math.abs(b1.pos.z-b2.pos.z)
		if man > bigman then bigman = man end
	end
end
print("**",bigman)
