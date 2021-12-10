errscore = 0
acscors = {}

while true do
	line = io.read("*line")
	if not line then break end
	local stk = {}
	local err = false
	local acscor = 0
	for c in line:gmatch(".") do
		if c == "(" or c == "<" or c == "{" or c== "[" then table.insert(stk, c)
		else
			local topc = table.remove(stk, #stk)
			if c == ")" and topc ~= "(" then errscore = errscore + 3 err = true break end
			if c == "]" and topc ~= "[" then errscore = errscore + 57 err = true break end
			if c == "}" and topc ~= "{" then errscore = errscore + 1197 err = true break end
			if c == ">" and topc ~= "<" then errscore = errscore + 25137 err = true break end
		end
	end
	if not err then
		for n=#stk,1,-1 do
			local topc = stk[n]
			acscor = acscor * 5
			if topc == "(" then acscor = acscor + 1
			elseif topc == "[" then acscor = acscor + 2
			elseif topc == "{" then acscor = acscor + 3
			elseif topc == "<" then acscor = acscor + 4
			end
		end
		table.insert(acscors, acscor)
	end
end

print(errscore)
table.sort(acscors)
print(#acscors, acscors[(#acscors + 1) / 2])