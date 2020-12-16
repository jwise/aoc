rules = {}

local line
while true do
	line = io.read("*line")
	local name,s1,e1,s2,e2 = line:match("([^:]+): (%d+)-(%d+) or (%d+)-(%d+)")
	if not name then break end
	s1 = tonumber(s1)
	e1 = tonumber(e1)
	s2 = tonumber(s2)
	e2 = tonumber(e2)
	
	rules[name] = { s1 = s1, e1 = e1, s2 = s2, e2 = e2, name = name, couldntbe = {} }
end

-- line is ""

tkts = {}

io.read("*line") -- "your ticket"

function ptkt(ln)
	local tkt = {}
	for n in ln:gmatch("%d+") do
		table.insert(tkt, tonumber(n))
	end
	return tkt
end

mytkt = ptkt(io.read("*line"))

io.read("*line") -- ""
io.read("*line") -- "nearby"

while true do
	line = io.read("*line")
	if not line then break end
	table.insert(tkts, ptkt(line))
end

terr = 0
vldtkts = {}
for _,tkt in ipairs(tkts) do
	local vldtkt = true
	for _,fld in ipairs(tkt) do
		local isvld = false
		for _,rule in pairs(rules) do
			if fld >= rule.s1 and fld <= rule.e1 then isvld = true end
			if fld >= rule.s2 and fld <= rule.e2 then isvld = true end
		end
		if not isvld then terr = terr + fld vldtkt = false end
	end
	if vldtkt then table.insert(vldtkts, tkt) end
end
print(terr)

couldnotbe = {}
for _,tkt in ipairs(vldtkts) do
	for fldn,fld in ipairs(tkt) do
		local fldmaybe = couldnotbe[fldn] or {}
		couldnotbe[fldn] = fldmaybe
		
		for rulen,rule in pairs(rules) do
			if (not (fld >= rule.s1 and fld <= rule.e1)) and
			   (not (fld >= rule.s2 and fld <= rule.e2)) then
			   	rule.couldntbe[fldn] = true
			end
		end
	end
end

ncols = #vldtkts[1]

rulelist = {}
for rulen,rule in pairs(rules) do
	table.insert(rulelist,rule)
end

asntab = {}
function try(n)
	if n == (ncols+1) then return true end
	local rule = rulelist[n]
	
	for couldbe=1,ncols do
		if not rule.couldntbe[couldbe] and not asntab[couldbe] then
			-- try assigning rule #n to column couldbe
			asntab[couldbe] = rule
			if try(n+1) then return true end
			asntab[couldbe] = nil
		end
	end
	return false
end
print(try(1))

-- Produce a mapping of rule names to columns (i.e., invert the assignment
-- table, asntab).
rulemap = {}
for fldn,rule in pairs(asntab) do
	rulemap[rule.name] = fldn
end

want = {"departure location", "departure station", "departure platform", "departure track", "departure date", "departure time"}
res = 1
for _,thiswant in ipairs(want) do
	res = res * mytkt[rulemap[thiswant]]
end
print(res)