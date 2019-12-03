arr = {}

function put(y,x,val)
	if not arr[y] then arr[y] = {} end
	arr[y][x] = val
end

function get(y,x)
	if not arr[y] then return nil end
	return arr[y][x]
end


local closest = 99999

while true do
	line = io.read("*line")
	if not line then break end
	
	local x,y = 0,0
	local wire = {}
	local steps = 0
	
	for a in line:gmatch("[^,]+") do
		local dir=a:sub(1,1)
		local count=tonumber(a:sub(2))
		
		local xd,yd
		if dir == "R" then xd,yd=1,0
		elseif dir == "L" then xd,yd=-1,0
		elseif dir == "U" then xd,yd=0,-1
		elseif dir == "D" then xd,yd=0,1
		end
		
		for _=1,count do
			x = x + xd
			y = y + yd
			steps = steps + 1
			other = get(y,x)
			if get(y,x) and get(y,x).wire ~= wire and y ~= 0 and x ~= 0 then
				delay = other.steps + steps
				if closest > delay then
					closest = delay
					print(closest)
				end
			end
			if not get(y,x) then
				put(y,x,{wire = wire, steps = steps})
			end
		end
	end
end
