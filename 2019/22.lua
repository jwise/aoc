NCARDS = tonumber(arg[1]) or 10007

deck = {}
for i=0,NCARDS-1 do
	deck[i] = i
end

while true do
	local line = io.read("*line")
	if not line then break end
	
	if line:match("deal with increment (.*)") then
		local incr = tonumber(line:match("deal with increment (.*)"))
		local ndeck = {}
		for i=0,NCARDS-1 do
			ndeck[(i * incr) % NCARDS] = deck[i]
		end
		deck = ndeck
	elseif line:match("cut (.*)") then
		local cutn = tonumber(line:match("cut (.*)"))
		local ndeck = {}
		
		if cutn < 0 then
			cutn = -cutn
			cutn = NCARDS - cutn
		end
		for i=cutn,NCARDS-1 do
			ndeck[i-cutn] = deck[i]
		end
		for i=0,cutn-1 do
			ndeck[i+NCARDS-cutn] = deck[i]
		end
		deck = ndeck
	elseif line:match("deal into new stack") then
		local ndeck = {}
		for i=0,NCARDS-1 do
			ndeck[i] = deck[NCARDS-i-1]
		end
		deck = ndeck
	else
		abort()
	end

end

if arg[3] then
	print(deck[tonumber(arg[2]) or 2019])
else
for i=0,NCARDS-1 do
	if deck[i] == tonumber(arg[2]) or 2019 then print(i) end
end

end

