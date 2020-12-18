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
function expr(toks)
	local outq = {}
	local opstk = {}
	while #toks ~= 0 do
		local tok = table.remove(toks, 1)
		if type(tok) == "number" then
			table.insert(outq, tok)
		elseif tok == PLUS or tok == TIMES then
			while #opstk ~= 0 and opstk[#opstk] == PLUS do
				table.insert(outq, table.remove(opstk, #opstk))
			end
			table.insert(opstk, tok)
		elseif tok == LPAREN then
			table.insert(opstk, tok)
		elseif tok == RPAREN then
			while opstk[#opstk] ~= LPAREN do
				table.insert(outq, table.remove(opstk, #opstk))
			end
			assert(opstk[#opstk] == LPAREN)
			table.remove(opstk, #opstk)
		else
			abort()
		end
	end
	while #opstk ~= 0 do
		table.insert(outq, table.remove(opstk, #opstk))
	end
	
	local evalstk = {}
	while #outq ~= 0 do
		local tok = table.remove(outq, 1)
		if type(tok) == "number" then
			table.insert(evalstk, tok)
		else
			local l = table.remove(evalstk, #evalstk)
			local r = table.remove(evalstk, #evalstk)
			if tok == PLUS then table.insert(evalstk, l + r)
			elseif tok == TIMES then table.insert(evalstk, l * r)
			else abort()
			end
		end
	end
	assert(#evalstk == 1)
	return evalstk[1]
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