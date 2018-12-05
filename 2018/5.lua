l = io.read("*line")

function react(l)
	while true do
		reacted = false
--		print(l:len())
		l0 = ""
		for i = 1,(l:len()-1) do
			c0 = l:sub(i,i)
			c1 = l:sub(i+1,i+1)
			if (c0:lower() == c1:lower()) and (c0 ~= c1) then
				l = l:sub(1,i-1) .. l:sub(i+2)
				reacted = true
				break
			end
		end
		if not reacted then break end
	end
	return l
end


l = react(l)
print(l:len())

lowest = nil
for i=65,90 do
	lm = l:gsub(string.char(i),""):gsub(string.char(i):lower(),"")
	lmr = react(lm)
	if (not lowest) or lmr:len() < lowest then
		lowest = lmr:len()
	end
end
print("lowest", lowest)
