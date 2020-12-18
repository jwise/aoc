LPAREN = "("
RPAREN = ")"
-- num
PLUS = "+"
TIMES = "*"

function tok(str)
	local toks = {}
	while str ~= "" do
		if str:sub(1,1) == "(" then
			table.insert(toks, LPAREN)
			str = str:sub(2)
		elseif str:sub(1,1) == ")" then
			table.insert(toks, RPAREN)
			str = str:sub(2)
		elseif str:sub(1,1) == "+" then
			table.insert(toks, PLUS)
			str = str:sub(2)
		elseif str:sub(1,1) == "*" then
			table.insert(toks, TIMES)
			str = str:sub(2)
		elseif str:sub(1,1) == " " then
			str = str:sub(2)
		elseif str:match("%d+") then
			local num,nstr = str:match("(%d+)(.*)")
			table.insert(toks, tonumber(num))
			str = nstr
		else
			abort()
		end
	end
	return toks
end

-- EXPR := LPAREN EXPR RPAREN
--       | EXPR OP NUMBER
--       | NUMBER
function expr(toks,many)
	while #toks ~= 1 and toks[2] ~= RPAREN do
		if toks[1] == LPAREN then
			table.remove(toks, 1)
			print("LPAREN")
			table.insert(toks, 1, expr(toks, true))
			print("RPAREN")
			if toks[2] ~= RPAREN then
				abort()
			end
			table.remove(toks, 2)
			if not many then
				return table.remove(toks,1)
			end
			-- toks[1] is a number now
		else -- toks[1] is a number now
			if #toks == 1 then 
				return
			end
			local lside = table.remove(toks, 1) -- a number
			local op = table.remove(toks, 1)
			if toks[1] == LPAREN then
				table.insert(toks, 1, expr(toks, false))
			end
			local rside = table.remove(toks, 1)
			print(lside,op,rside)
			if op == PLUS then
				rv = lside + rside
			elseif op == TIMES then
				rv = lside * rside
			else
				print(lside,op)
				abort()
			end
			table.insert(toks, 1, rv)
		end
	end
	assert(type(toks[1]) == "number")
	return table.remove(toks, 1)
end

local acc = 0
while true do
	local line = io.read("*line")
	if not line then break end
	local toks = tok(line)
	local rv,optr = expr(toks,1)
	acc = acc + rv
end
print(acc)