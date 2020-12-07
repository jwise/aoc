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

contains = {}
function iter(wantcol)
	for outcol,contents in pairs(bags) do
		for incol,_ in pairs(contents) do
			if incol == wantcol then
				contains[outcol] = true
				iter(outcol)
			end
		end
	end
end
iter("shiny gold")

count = 0
for k,v in pairs(contains) do
	print(k)
	count = count + 1
end
print(count)