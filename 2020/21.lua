stuffs = {}
allallers = {}
allingrs = {} -- allingr[ingr][aller] is true if ingredient ingr could NOT contain allergen aller
inert = {}

while true do
	local line = io.read("*line")
	if not line then break end
	
	local stuff = { ingrs = {}, allers = {}}
	local ingrs, allers = line:match("([^(]+)%(contains ([^)]+)%)")
	for ingr in ingrs:gmatch("%S+") do
		table.insert(stuff.ingrs, ingr)
		allingrs[ingr] = {}
		stuff.ingrs[ingr] = true
	end
	for aller in allers:gmatch("[^ ,]+") do
		table.insert(stuff.allers, aller)
		stuff.allers[aller] = true
		allallers[aller] = {}
	end
	table.insert(stuffs, stuff)
end

-- if there is an allergen listed, all of the ingredients that are not listed do not contain that allergen

for _,stuff in ipairs(stuffs) do
	for _,aller in ipairs(stuff.allers) do
		for ingr,_ in pairs(allingrs) do
			if not stuff.ingrs[ingr] then
				allingrs[ingr][aller] = true -- ingredient ingr could NOT contain allergen aller
			end
		end
	end
end

local p1count = 0
for ingr,notallers in pairs(allingrs) do
	local noaller = true
	for aller,_ in pairs(allallers) do
		if not notallers[aller] then
			noaller = false
			break
		end
	end
	if noaller then
		for _,stuff in ipairs(stuffs) do
			if stuff.ingrs[ingr] then
				p1count = p1count + 1
			end
		end
		inert[ingr] = true
	end
end
print(p1count)

-- come up with a numbering on allergens
allernum = {}
for aller,_ in pairs(allallers) do
	table.insert(allernum, aller)
	allallers[aller] = #allernum
end

-- if there is a allergen listed, then the ingredient associated with that
-- allergen must appear in the ingredients list
trytab = {}
function trycombo(ingr, aller)
	if not trytab[ingr] then trytab[ingr] = {} end
	if trytab[ingr][aller] ~= nil then return trytab[ingr][aller] end
	for _,stuff in ipairs(stuffs) do
		if stuff.allers[aller] and not stuff.ingrs[ingr] then trytab[ingr][aller] = false return false end
	end
	trytab[ingr][aller] = true
	return true
end

ingrasn = {} -- ingredients that we have already assigned
function try(n)
	if n == #allernum + 1 then return true end
	
	for ingr,_ in pairs(allingrs) do
		if not ingrasn[ingr] and trycombo(ingr, allernum[n]) then
			ingrasn[ingr] = allernum[n]
			if try(n+1) then return true end
			ingrasn[ingr] = nil
		end
	end
	return false
end
print(try(1))

alleringrs = {}
for ingr,aller in pairs(ingrasn) do
	print(ingr,aller)
	table.insert(alleringrs, ingr)
end

table.sort(alleringrs, function(f1, f2)
	return ingrasn[f1] < ingrasn[f2]
end)

s = table.concat(alleringrs,",")
print(s)