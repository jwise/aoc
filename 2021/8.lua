count = 0
while true do
	line = io.read("*line")
	if not line then break end
	oups = line:match("| (.+)")
	for n in oups:gmatch("([^ ]+)") do
		if n:len() == 2 or n:len() == 4 or n:len() == 3 or n:len() == 7 then
			count = count + 1
		end
	end
end
print(count)
