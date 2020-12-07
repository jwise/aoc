bags = {}
while true do
	line = io.read("*line")
	if not line then break end
	
	local bag = {}
	
	color,contains = line:match("(.-) bags contain (.-)%.")
	print(color,contains)
	if contains == "no other bags" then
	else
		for m in contains:gmatch("%d+ .- bags?") do
			local count,contained = m:match("(%d+) (.-) bags?")
			print(count, contained)
			bag[contained] = count
		end
	end
	bags[color] = bag
end

function totbags(col)
	local count = 1
	for incol,n in pairs(bags[col]) do
		count = count + n * totbags(incol)
	end
	return count
end
print(totbags("shiny gold") - 1)
