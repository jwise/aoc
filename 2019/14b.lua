local rxns = {}
while true do
	local line = io.read("*line")
	if not line then break end
	
	local inps,oqty,orctnt = line:match("([^=]+)=> ([%d]+) (.+)")
	
	oqty = tonumber(oqty)
	local rxn = { out = orctnt, qty = oqty, reactants = {} }
	
	print(orctnt, oqty)
	for qty,rctnt in inps:gmatch("(%d+) ([A-Z]+)") do
		rxn.reactants[rctnt] = qty
		
		print("",rctnt,qty)
	end
	
	rxns[orctnt] = rxn
end

local needed = { ["FUEL"] = tonumber(arg[1]) or 1 }
local produced = {}

while true do
	local did_work = false
	
	-- Find something that is unmet, then solve for it.
	for need, nqty in pairs(needed) do
		if need == "ORE" then
			-- that doesn't count
		elseif not produced[need] or produced[need] < nqty then
			-- React one.
			local runs = math.ceil((nqty - (produced[need] or 0)) / rxns[need].qty)
			for irctnt, iqty in pairs(rxns[need].reactants) do
				needed[irctnt] = (needed[irctnt] or 0) + iqty * runs
			end
			
			produced[need] = (produced[need] or 0) + rxns[need].qty * runs
			did_work = true
		end
	end
	
	if not did_work then
		break
	end
end

print(needed["ORE"])