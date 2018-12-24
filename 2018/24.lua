BOOST = tonumber(arg[1]) or 0

function parsearmy(boost)
	local army = {}
	while true do
		local l = io.read("*line")
		if not l or l == "" then break end
		
		local u,hp,qual,dam,type,init =
			l:match("(%d+) units each with (%d+) hit points %(?([^)]*)%)? ?with an attack that does (%d+) ([^ ]+) damage at initiative (%d+)")
		local immunities = qual:match("immune to ([a-z, ]+)") or ""
		local weaknesses = qual:match("weak to ([a-z, ]+)") or ""
		
		assert(u)
		
		local group = {}
		group.units = tonumber(u)
		group.hp = tonumber(hp)
		group.adamage = tonumber(dam) + boost
		group.atype = type
		group.initiative = tonumber(init)
		group.immune = {}
		group.weak = {}
		group.alive = true
		group.id = #army + 1
		group.army = army
		
		for i in immunities:gmatch("[a-z]+") do group.immune[i] = true end
		for i in weaknesses:gmatch("[a-z]+") do group.weak[i] = true end
		
		table.insert(army, group)
	end
	return army
end

io.read("*line")
immunesys = parsearmy(BOOST)
immunesys.name = "Immune System"
io.read("*line")
infection = parsearmy(0)
infection.name = "Infection"

function efp(u) return u.units * u.adamage end

function damage(atku, defu)
	if defu.immune[atku.atype] then return 0 end
	if defu.weak[atku.atype] then return efp(atku) * 2 end
	return efp(atku)
end

DEBUG = false

function targetsel(atk, def)
	table.sort(atk,
		function (u1, u2) -- u1 < u2
			return (efp(u1) > efp(u2)) or
			       ((efp(u1) == efp(u2)) and u1.initiative > u2.initiative)
		end)
	
	for _,defu in ipairs(def) do
		defu.targetof = nil
	end
	
	for _,atku in ipairs(atk) do
		-- now, choose
		atku.mytarget = nil
		
		table.sort(def,
			function (u1, u2) -- u1 < u2
				if u1.targetof or not u1.alive then return false end
				if u2.targetof or not u2.alive then return true end
				if damage(atku, u1) > damage(atku, u2) then return true end
				if damage(atku, u1) < damage(atku, u2) then return false end
				if efp(u1) > efp(u2) then return true end
				if efp(u1) < efp(u2) then return false end
				if u1.initiative > u2.initiative then return true end
				return false
			end)
		
		if atku.alive and not def[1].targetof and damage(atku, def[1]) ~= 0 then
			if DEBUG then
				print(atku.army.name.." group "..atku.id.." would deal defending group "..def[1].id.." "..damage(atku, def[1]).." damage ('"..atku.atype.."', weak "..tostring(def[1].weak[atku.atype])..")")
			end
			atku.mytarget = def[1]
			def[1].targetof = atku
		end
	end
end

function score(a1, a2)
	local totscore = 0
	if DEBUG then print(a1.name..":") end
	for _,u in ipairs(a1) do
		if DEBUG and u.alive then print("Group "..u.id.." has "..u.units.." units") end
		totscore = totscore + u.units
	end
	if DEBUG then print(a2.name..":") end
	for _,u in ipairs(a2) do
		if DEBUG and u.alive then print("Group "..u.id.." has "..u.units.." units") end
		totscore = totscore + u.units
	end
	if DEBUG then print("") end
	return totscore	
end

function fight(a1, a2)
	score(a1, a2)

	targetsel(a2, a1)
	targetsel(a1, a2)
	if DEBUG then print("") end
	
	-- now everyone fights!
	local all = {}
	for _,u in ipairs(a1) do
		if u.alive then table.insert(all, u) end
	end
	for _,u in ipairs(a2) do
		if u.alive then table.insert(all, u) end
	end
	table.sort(all, function(u1, u2) return u1.initiative > u2.initiative end)
	
	local ukilltot = 0
	for _,u in ipairs(all) do
		if u.alive and u.mytarget then
			local tgt = u.mytarget
			local dmg = damage(u, tgt)
			local ukill = math.floor(dmg / tgt.hp)
			if ukill > tgt.units then ukill = tgt.units end
			if DEBUG then
				print(u.army.name.." group "..u.id.." attacks defending group "..tgt.id..", killing "..ukill.." units ("..dmg.." damage total)")
			end
			tgt.units = tgt.units - ukill
			ukilltot = ukilltot + ukill
			if tgt.units <= 0 then tgt.alive = false end
		end
	end
	
	if DEBUG then print"" end
	
	a1alive = false
	for _,u in ipairs(a1) do
		if u.alive then a1alive = true end
	end
	a2alive = false
	for _,u in ipairs(a2) do
		if u.alive then a2alive = true end
	end
	
	if ukilltot == 0 then
		print("*** DRAW! ***")
	end
	
	return a1alive and a2alive and ukilltot > 0
end

while fight(immunesys, infection) do
	if DEBUG then print("---") end
end

DEBUG = true
print(score(immunesys, infection).." total units alive")
