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
livecarts = 0
carts = {}

-- make sure to avoid bss-ol bar later
function newcart(y,x,dir)
	local cart = {}
	cart.x = x
	cart.y = y
	cart.dir = dir
	cart.seqno = 1
	cart.alive = true
	table.insert(carts, cart)
	livecarts = livecarts + 1
	cart.id = #carts
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
	if not cart.alive then return false end
	
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
		if cart ~= cartp and cart.x == cartp.x and cart.y == cartp.y and cartp.alive then
			print("die", cart.id, cartp.id)
			livecarts = livecarts - 2
			cart.alive = false
			cartp.alive = false
			return true,cart.x,cart.y
		end
	end
end

function tick()
	cartsmove = {}
	for y=1,#map do
		for x = 1,#(map[y]) do
			for n,cart in ipairs(carts) do
				if cart.y == y and cart.x == x and cart.alive then
					table.insert(cartsmove, cart)
				end
			end
		end
	end
	for _,cart in ipairs(cartsmove) do
		local collide,cx,cy = tick_cart(cart)
		if collide then
			print("***",cx-1,cy-1)
		end
	end
end

time = 0
done = false
while livecarts > 1 do
	print("STEP",time,livecarts)
	local collide,x,y = tick()
	if collide then done = true print("***",x-1,y-1) end
	time = time+1
end

for n,cart in ipairs(carts) do
	if cart.alive then
		print(n,cart.x-1,cart.y-1)
	end
end
