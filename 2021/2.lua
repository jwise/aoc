x = 0
d = 0

while true do
	line = io.read("*line")
	if not line then break end
	if line:match("forward") then
		x = x + tonumber(line:match("forward (%d+)"))
	elseif line:match("up") then
		d = d + tonumber(line:match("up (%d+)"))
	elseif line:match("down") then
		d = d - tonumber(line:match("down (%d+)"))
	else
		ass()
	end
end

print(x*d)
