line = io.read("*line")
from,to = line:match("(%d+)-(%d+)")
from,to = tonumber(from),tonumber(to)

function ispassword(n)
	digits = {}
	for d in tostring(n):gmatch("%d") do
		table.insert(digits, tonumber(d))
	end
	
	hasdouble = false
	prev = 0
	for k,d in ipairs(digits) do
		if digits[k+1] == d then hasdouble = true end
		if d < prev then return false end
		prev = d
	end
	
	return hasdouble
end

ctr = 0
for i=from,to do
	if ispassword(i) then
		ctr = ctr + 1
	end
end
print(ctr)
