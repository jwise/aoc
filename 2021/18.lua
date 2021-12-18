function parse(line)
	local n,rest = line:match("^(%d+)(.*)")
	if n then
		return { n = tonumber(n) }, rest
	else
		local pair = {}
		assert(line:sub(1,1) == "[")
		line = line:sub(2)
		local a,rest = parse(line)
		assert(rest:sub(1,1) == ",")
		rest = rest:sub(2)
		local b,rest = parse(rest)
		assert(rest:sub(1,1) == "]")
		rest = rest:sub(2)
		pair.a = a
		pair.b = b
		a.parent = pair
		a.parentptr = "a"
		b.parent = pair
		b.parentptr = "b"
		return pair, rest
	end
end

function mag(num)
	if num.n then
		return num.n
	else
		return 3*mag(num.a) + 2*mag(num.b)
	end
end

function add(num1,num2)
	local pair = {}
	pair.a = num1
	pair.b = num2
	num1.parent = pair
	num1.parentptr = "a"
	num2.parent = pair
	num2.parentptr = "b"
	return pair
end

function upleft(num, depth)
	if num.parent == nil then return nil end
	if num.parentptr == "b" then
		-- there HAS to be something in "a" that is a regular number
		local node = num.parent.a
		while not node.n do
			node = node.b
			depth = depth + 1
		end
		return node,depth
	end
	-- we are a left leaf, recur
	return upleft(num.parent, depth -1)
end

function upright(num,depth)
	if num.parent == nil then return nil end
	if num.parentptr == "a" then
		-- there HAS to be something in "B" that is a regular number
		local node = num.parent.b
		while not node.n do
			node = node.a
			depth = depth + 1
		end
		return node,depth
	end
	-- we are a right leaf, recur
	return upright(num.parent,depth-1)
end

function split(num, depth)
	local pair = {}
	pair.a = { n = math.floor(num.n/2), parent = pair, parentptr = "a" }
	pair.b = { n = math.ceil (num.n/2), parent = pair, parentptr = "b" }
	pair.parentptr = num.parentptr
	pair.parent = num.parent
	num.parent[num.parentptr] = pair
--	if depth >= 4 then
--		explode(pair, depth)
--	end
end

function explode(num, depth)
	assert(num.a.n)
	assert(num.b.n)
		
	-- look for something to the LEFT of this
	local upl,upld = upleft(num,depth)
	if upl then
		upl.n = upl.n + num.a.n
--		if upl.n >= 10 then
--			split(upl, upld)
--		end
	end
	
	local upr,uprd = upright(num,depth)
	if upr then
		upr.n = upr.n + num.b.n
--		if upr.n >= 10 then
--			split(upr, uprd)
--		end
	end
	
	local newzero = { n = 0, parent = num.parent, parentptr = num.parentptr }
	num.parent[num.parentptr] = newzero	
end

function reduce_for_split(num)
	if num.n and num.n >= 10 then
		split(num)
		return true
	end
	if num.n then return end
	if reduce_for_split(num.a) then return true end
	if reduce_for_split(num.b) then return true end
end

function reduce_for_explode(num, depth)
	if num.n then return end
	if num.a and depth == 4 then
		explode(num, depth)
		return true
	end
	if reduce_for_explode(num.a, depth+1) then return true end
	return reduce_for_explode(num.b, depth+1)
end

function reduce(num)
	if reduce_for_explode(num, 0) then return true end
	return reduce_for_split(num)
end

function pr(num)
	if num.n then return tostring(num.n) end
	return "[" .. pr(num.a) .. "," .. pr(num.b) .. "]"
end

lines = {}
while true do
	line = io.read("*line")
	if not line then break end
	table.insert(lines, line)
end

num = parse(lines[1])
for i=2,#lines do
	num = add(num, parse(lines[i]))
	while reduce(num, 0) do end
end
print(mag(num))

maxmag = 0
for i=1,#lines do
	for j=i+1,#lines do
		num = add(parse(lines[i]), parse(lines[j]))
		while reduce(num, 0) do end
		if mag(num) > maxmag then maxmag = mag(num) end
	end
end
print(maxmag)