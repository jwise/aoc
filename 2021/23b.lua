-- everything is bad, no mouse, no audio, no video, ... whatever

-- THIS FUCKING SUCKS I AM OWNED
-- I WISH I HAD A MOUSE
-- I WISH IC OULD COPY TEST INPUTS
-- UGH
-- THIS IS GOING TO TAKE A FUCKING HOUR
-- timne to write code

-- hallway length is 11
-- hallway extents are 0,10
-- doors are at 2,4,6,8
-- so this is a pathfinding problem on... state vector of eight APs with X-Y coordinates, and a 'locked' bit (whether the AP is locked in place)
-- desired stvec is A0 = 2,1 or 2,2; A1 = 2,1 or 2,2; B0 = 4,1
-- hallway is y=0

MAXH=2

function mkstartst(str)
	local aps = {}
	MAXH=str:len()/4
	for r=1,MAXH do
		for c=1,4 do
			local ap = { x = c * 2, y = r }
			local n = (r-1)*4+(c-1)+1
			aps[str:sub(n,n)] = aps[str:sub(n,n)] or {}
			table.insert(aps[str:sub(n,n)], ap)
		end
	end
	aps.cost = 0
	return aps
end

local sts = {}
function stcanon(st)
	function sortfn(a,b)
		if a.x < b.x then return true end
		if a.x == b.x then return a.y < b.y end
		return false
	end
	if not st.key then
		st.key = stkey(st)
	end
	if not st.cost then
		st.cost = math.huge
	end
	if sts[st.key] then
		return sts[st.key]
	end
	sts[st.key] = st
	table.sort(st["A"], sortfn)
	table.sort(st["B"], sortfn)
	table.sort(st["C"], sortfn)
	table.sort(st["D"], sortfn)
	return st
end

function stkey(st)
	local key = ""
	for _,apc in ipairs({"A","B","C","D"}) do
		aps = st[apc]
		for _,ap in ipairs(aps) do
			key = key .. ap.x .. ","..ap.y..","
		end
	end
	return key
end

function stname(st)
	local s = ""
	for y=0,MAXH do
		for x=0,10 do
			local stc = "."
			for apc,_ in pairs({A=true,B=true,C=true,D=true}) do
				aps = st[apc]
				for _,ap in ipairs(aps) do
					if ap.y == y and ap.x == x then stc = apc end
				end
			end
			s = s .. stc
		end
		s = s.."\n"
	end
	return s
end

function stcopy(st0)
	local st = {}
	for apc,aps in pairs(st0) do
		if apc:len() == 1 then -- lol
			st[apc] = {}
			for apn,ap in ipairs(aps) do
				st[apc][apn] = { x = ap.x, y = ap.y }
			end
		end
	end
	return st
end

WANTX = { A = 2, B = 4, C = 6, D = 8 }
MVWEIGHT = { A = 1, B = 10, C = 100, D = 1000 }

local frontier = {}
function visit(st)
	local demap = { [0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {} }
	for apc,aps in pairs(st) do
		if apc:len() == 1 then
			for apn,ap in ipairs(aps) do
				demap[ap.y][ap.x] = apc
			end
		end
	end
	
	local colisok = {}
	local coltop = {}
	for c,x in pairs(WANTX) do
		local isok = true
		local top = 1
		for r=1,MAXH do
			if demap[r][x] and demap[r][x] ~= c then isok = false end
			if demap[r][x] == nil then top = r+1 end
		end
		colisok[x] = isok
		coltop[x] = top
	end
	
	st.visited = true
	
	function maybeins(st2, cost)
		st2 = stcanon(st2)
		local nam = st2.key
		if st2.visited then
			assert(cost >= st2.cost)
			return
		end
		if st2.frontier then
			if cost >= st2.cost then return end
			-- remove from frontier
			for i=1,#frontier do
				if frontier[i] == st2 then table.remove(frontier, i) break end
			end
		end
		st2.cost = cost
		-- insert in place
		for i=1,#frontier+1 do
			if not frontier[i] or frontier[i].cost > st2.cost then table.insert(frontier, i, st2) break end
		end
		st2.frontier = true
	end
	
	for apc,aps in pairs(st) do
		if apc:len() == 1 then for apn,ap in ipairs(aps) do
			if ap.y == coltop[ap.x] and -- ap is at the top of a stack
			   not colisok[ap.x] then -- ap is not locked into a stack that's correct
				-- ap can move into the hallway and then freeze in place
				local lminx = ap.x
				local lmaxx = ap.x
				while not demap[0][lminx-1] and lminx > 0 do
					lminx = lminx - 1
				end
				while not demap[0][lmaxx+1] and lmaxx < 10 do
					lmaxx = lmaxx + 1
				end
				for nx=lminx,lmaxx do
					if nx ~= 2 and nx ~= 4 and nx ~= 6 and nx ~= 8 then
						local nst = stcopy(st)
						nst[apc][apn].x = nx
						nst[apc][apn].y = 0
						maybeins(nst, st.cost + MVWEIGHT[apc] * (ap.y + math.abs(ap.x - nx)))
					end
				end
			end
			
			if ap.y == 0 and colisok[WANTX[apc]] then
				local path0 = math.min(WANTX[apc],ap.x)
				local path1 = math.max(WANTX[apc],ap.x)
				local occlude = false
				for x=path0,path1 do
					if demap[0][x] and x ~= ap.x then occlude = true break end
				end
				if not occlude then
					-- ap can move into its room
					local nst = stcopy(st)
					local ny = coltop[WANTX[apc]]-1
					nst[apc][apn].x = WANTX[apc]
					nst[apc][apn].y = ny
					maybeins(nst, st.cost + MVWEIGHT[apc] * (ny + math.abs(WANTX[apc] - ap.x)))
				end
			end
		end end
	end
end

-- well that was a fucking odyssey
-- part 1: sample
--startst = mkstartst("BCBDADCA")
--wantst = mkstartst("ABCDABCD")

-- part 1: real
--startst = mkstartst("CBADBCDA")
--wantst = mkstartst("ABCDABCD")

-- part 2: sample
--startst = mkstartst("BCBDDCBADBACADCA")
--wantst = mkstartst("ABCDABCDABCDABCD")

-- part 2: real
startst = mkstartst("CBADDCBADBACBCDA")
wantst = mkstartst("ABCDABCDABCDABCD")


startst = stcanon(startst)
startst.cost = 0
print(startst.key)

wantst.cost = math.huge
wantst = stcanon(wantst)

table.insert(frontier, startst)
startst.frontier = true
done = 0
while #frontier > 0 do
	local nextst = table.remove(frontier, 1)
	if nextst == wantst then
		print("FOUND WANTST",wantst.cost)
		break
	end
	visit(nextst)
	done = done + 1
	if done % 500 == 0 then
		print(done, #frontier, frontier[1].cost)
		print(frontier[1].key)
		print(stname(frontier[1]))
	end
end

