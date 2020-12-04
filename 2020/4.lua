nval = 0

pps = {}
req = {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"} --, "cid"}

pp = {}
while true do
	line = io.read("*line")
	if not line then break end
	
	if line == "" then
		local isval = true
		for _,want in ipairs(req) do
			if not pp[want] then isval = false end
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