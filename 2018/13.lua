CART_LEFT = {x=-1,y=0}
CART_RIGHT = {x=1,y=0}
CART_UP = {x=0,y=-1}
CART_DOWN = {x=0,y=1}

CART_LEFT.left = CART_DOWN
CART_LEFT.right = CART_UP
CART_RIGHT.left = CART_UP
CART_RIGHT.right = CART_DOWN
CART_UP.left = CART_LEFT
CART_UP.right = CART_RIGHT
CART_DOWN.left = CART_RIGHT
CART_DOWN.right = CART_LEFT
CART_LEFT.straight = CART_LEFT
CART_RIGHT.straight = CART_RIGHT
CART_UP.straight = CART_UP
CART_DOWN.straight = CART_DOWN

HORIZ = {}
VERT = {}
CURV_POS = {[CART_LEFT] = CART_DOWN, [CART_RIGHT] = CART_UP, [CART_DOWN] = CART_LEFT, [CART_UP] = CART_RIGHT}	-- /
CURV_NEG = {[CART_LEFT] = CART_UP, [CART_RIGHT] = CART_DOWN, [CART_DOWN] = CART_RIGHT, [CART_UP] = CART_LEFT}	-- \
INTER = {}


seq = { "left", "straight", "right" }

map = {}
carts = {}

-- make sure to avoid bss-ol bar later
function newcart(y,x,dir)
	local cart = {}
	cart.x = x
	cart.y = y
	cart.dir = dir
	cart.seqno = 1
	table.insert(carts, cart)
end

while true do
	l = io.read("*line")
	if not l then break end
	
	row = {}
	for c in l:gmatch(".") do
		if c == " " then
			table.insert(row, "")
		elseif c == "|" then
			table.insert(row, HORIZ)
		elseif c == "-" then
			table.insert(row, VERT)
		elseif c == "\\" then
			table.insert(row, CURV_NEG)
		elseif c == "/" then
			table.insert(row, CURV_POS)
		elseif c == "+" then
			table.insert(row, INTER)
		elseif c == "v" then
			print(c)
			newcart(#map+1, #row+1, CART_DOWN)
			table.insert(row, VERT)
		elseif c == "^" then
			print(c)
			newcart(#map+1, #row+1, CART_UP)
			table.insert(row, VERT)
		elseif c == ">" then
			print(c)
			newcart(#map+1, #row+1, CART_RIGHT)
			table.insert(row, HORIZ)
		elseif c == "<" then
			newcart(#map+1, #row+1, CART_LEFT)
			table.insert(row, HORIZ)
		else
			print("error: ",c)
			abort()
		end
	end
	table.insert(map, row)
end

function tick_cart(cart)
	cart.x = cart.x + cart.dir.x
	cart.y = cart.y + cart.dir.y
	
	if map[cart.y][cart.x] == " " then
		abort()
	end
	
	if map[cart.y][cart.x] == CURV_NEG or map[cart.y][cart.x] == CURV_POS then
		cart.dir = map[cart.y][cart.x][cart.dir]
	elseif map[cart.y][cart.x] == INTER then
		cart.dir = cart.dir[seq[cart.seqno]]
		cart.seqno = cart.seqno + 1
		if cart.seqno > #seq then cart.seqno = 1 end
	end
	
	for n,cartp in pairs(carts) do
		if cart ~= cartp and cart.x == cartp.x and cart.y == cartp.y then
			return true,cart.x,cart.y
		end
	end
end

function tick()
	table.sort(carts, function(a,b) return a.y < b.y or (a.y == b.y and a.x < b.x) end)
	for _,cart in ipairs(carts) do
		local collide,cx,cy = tick_cart(cart)
		if collide then return true,cx,cy end
	end
end

time = 0
done = false
while not done do
	print("STEP",time)
	local collide,x,y = tick()
	if collide then done = true print("***",x-1,y-1) end
--	for n,cart in pairs(carts) do
--		print("->", n,cart.x,cart.y)
--	end
	time = time+1
end
