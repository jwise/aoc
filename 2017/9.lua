#!/usr/bin/env lua

l = io.read("*line")

function getch()
	local c = l:sub(1,1)
	l = l:sub(2)
	print(c)
	return c
end

function peekch()
	local c = l:sub(1,1)
	return c
end

chs = 0

function parse_expr(depth)
	local c = getch()
	
	if c == '<' then
		print(depth,"garbage")
		while peekch() ~= ">" do
			c = getch()
			if c == '!' then
				getch()
			else
				chs = chs + 1
			end
		end
		getch()
		return nil -- garbage
	elseif c == '{' then
		print(depth,"group")
		local t = {}
		while peekch() ~= '}' do
			local grp = parse_expr(depth+1)
			if grp then table.insert(t, grp) end
			
			if peekch() == ',' then
				getch()
			elseif peekch() == '}' then
			else
				print("malformed shit after group", c)
				os.exit(1)
			end
		end
		getch()
		t.score = depth
		return t
	else
		print("malformed shit", c)
		os.exit(1)
	end
end

expr = parse_expr(1)

function score(tree)
	local _score = tree.score
	for _,ch in ipairs(tree) do
		_score = _score + score(ch)
	end
	return _score
end

print(score(expr))

print(chs)