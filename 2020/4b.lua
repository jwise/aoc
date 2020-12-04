-- Parse passports into "pps", as raw key-value pairs.
pps = {}

pp = {}
while true do
	line = io.read("*line")
	if not line then break end
	
	if line == "" then
		table.insert(pps, pp)
		pp = {}
	else
		for p in line:gmatch("%l+:[^ ]+") do
			local key,val = p:match("(%l+):([^ ]+)")
			pp[key] = val
		end
	end
end
table.insert(pps, pp)

function ppval(pp)
	local req = {
		byr = function(v)
			local n = tonumber(v)
			if not n then return nil end
			if n and n >= 1920 and n <= 2002 then
				return n
			end
			return nil
		end,
		iyr = function(v)
			local n = tonumber(v)
			if not n then return nil end
			if n and n >= 2010 and n <= 2020 then
				return n
			end
			return nil
		end,
		eyr = function(v)
			local n = tonumber(v)
			if not n then return nil end
			if n and n >= 2020 and n <= 2030 then
				return n
			end
			return nil
		end,
		hgt = function(v)
			if v:match("%d+in") then
				local n = tonumber(v:match("(%d+)"))
				if n >= 59 and n <= 76 then return { height = n, unit = "in" } end
			elseif v:match("%d+cm") then
				local n = tonumber(v:match("(%d+)"))
				if n >= 150 and n <= 193 then return { height = n, unit = "cm" } end
			end
			return nil
		end,
		hcl = function(v)
			return v:match("#([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f])")
		end,
		ecl = function(v)
			if ({amb = 1, blu = 1, brn = 1, gry = 1, grn = 1, hzl = 1, oth = 1})[v] then return v end
			return nil
		end,
		pid = function(v)
			if v:match("^%d%d%d%d%d%d%d%d%d$") then
				return tonumber(v)
			end
		end
		-- cid = function(v) return tonumber(v) end
		-- cid: country ID.  ignore for now
	}
	
	local isval = true
	local outpp = {}
	for want,valfn in pairs(req) do
		if not pp[want] then isval = false break end
		outpp[want] = valfn(pp[want])
		if not outpp[want] then isval = false break end
	end
	
	if isval then return outpp end
	return nil
end

nval = 0
for _,pp in ipairs(pps) do
	if ppval(pp) then nval = nval + 1 end
end
print(nval)
