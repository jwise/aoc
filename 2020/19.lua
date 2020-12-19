rules = {}

while true do
	local line = io.read("*line")
	if line == "" then break end
	
	local rn,txt = line:match("(%d+): (.*)")
	rn = tonumber(rn)
	if txt:match("\"(.)\"") then
		rules[rn] = txt:match("\"(.)\"")
	else
		local rule = {}
		for prod in txt:gmatch("[^|]+") do
			local branch = {}
			for n in prod:gmatch("%d+") do
				table.insert(branch, tonumber(n))
			end
			table.insert(rule, branch)
		end
		rules[rn] = rule
	end
end

function match(line, n)
	-- returns nil if no match, or residual if there is a match
	if type(rules[n]) == "string" then
		if line:sub(1,1) == rules[n] then
			return line:sub(2)
		else
			return nil
		end
	else
		for _,opt in ipairs(rules[n]) do
			local rem = line
			local ok = true
			for _,n2 in ipairs(opt) do
				rem = match(rem, n2)
				if not rem then ok = false break end
			end
			if ok and (n ~= 0 or rem == "") then
				return rem
			end
		end
	end
	return nil
end

function match2(line)
	-- 0 : 8 11
	-- 8 : 42 | 42 8
	-- 8 : 42+
	-- 11 : 42 31 | 42 11 31
	-- 11 : n*42 n*31
	-- 0 : 42+ n*42 n*31
	local rem = line
	local n42 = 0
	while true do
		local nrem = match(rem, 42)
		if not nrem then break end
		if nrem then
			n42 = n42 + 1
			rem = nrem
		end
	end
	local n31 = 0
	while true do
		local nrem = match(rem, 31)
		if not nrem then break end
		if nrem then
			n31 = n31 + 1
			rem = nrem
		end
	end
	if rem ~= "" and rem ~= nil then
		return nil
	end
	return n42 >= 1 and n31 > 0 and (n42 - 1) >= n31 
end

local acc = 0
while true do
	local line = io.read("*line")
	if not line then break end
	local ok
	if not arg[1] then
		ok = match(line,0)
	else
		ok = match2(line)
	end
	if ok then acc = acc + 1 end
	print(line,ok)
end
print(acc)
