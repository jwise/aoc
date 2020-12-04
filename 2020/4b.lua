nval = 0

pps = {}
req = {
	byr = function(v)
		if not tonumber(v) then return false end
		return tonumber(v) >= 1920 and tonumber(v) <= 2002
	end,
	iyr = function(v)
		if not tonumber(v) then return false end
		return tonumber(v) >= 2010 and tonumber(v) <= 2020
	end,
	eyr = function(v)
		if not tonumber(v) then return false end
		return tonumber(v) >= 2020 and tonumber(v) <= 2030
	end,
	hgt = function(v)
		if v:match("%d+in") then
			local n = tonumber(v:match("(%d+)"))
			if n >= 59 and n <= 76 then return true end
		elseif v:match("%d+cm") then
			local n = tonumber(v:match("(%d+)"))
			if n >= 150 and n <= 193 then return true end
		end
		return false
	end,
	hcl = function(v)
		return v:match("#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]")
	end,
	ecl = function(v)
		return ({amb = 1, blu = 1, brn = 1, gry = 1, grn = 1, hzl = 1, oth = 1})[v]
	end,
	pid = function(v)
		return v:match("^%d%d%d%d%d%d%d%d%d$")
	end
} --, "cid"}

pp = {}
while true do
	line = io.read("*line")
	if not line then break end
	
	if line == "" then
		local isval = true
		for want,wantfn in pairs(req) do
			if not pp[want] or not wantfn(pp[want]) then isval = false end
		end
		if isval then nval = nval + 1 end
		table.insert(pps, pp)
		pp = {}
	else
		for p in line:gmatch("%l+:[^ ]+") do
			fn,val = p:match("(%l+):([^ ]+)")
			pp[fn] = val
		end
	end
end

print(nval)