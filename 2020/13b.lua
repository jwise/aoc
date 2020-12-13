start = tonumber(io.read("*line"))
buses = {}
bid = 0
for b in io.read("*line"):gmatch("[^,]+") do
	if b ~= "x" then
		buses[bid] = tonumber(b)
	end
	bid = bid + 1
end


-- bofs = bus OFFSET, bf = bus FREQUENCY
--  ts        mod bf1 == 0
-- (ts+bofs1) mod bf2 == 0
-- (ts+bofs2) mod bf3 == 0

-- (ts+bofs + fudgefactor) mod bf == 0
-- fudgefactor HAS TO BE of the form n * bf1 * bf2 * bf3 * ...

function modinverse(b, m)
	g, x, y = gcd(b, m)
	if g ~= 1 then abort() end
	return x % m
end

function gcd(a, b)
	if a == 0 then return b, 0, 1 end
	local g, x1, y1 = gcd(b % a, a)
	return g, y1 - (b // a) * x1, x1
end

-- a / b = c
-- a * (1 / b) = c
-- modular inverse is finding an inv such that (a * inv) mod m == c mod m

ts = 0
bftot = 1 -- bf1 * bf2 * bf3 ... for all bus frequencies that we've accumulated so far
for bofs,bf in pairs(buses) do
	-- can add multiples of bftot only at this point to avoid disturbing
	-- (ts + bofs + bftot * n) mod bf == 0, solve for n
	-- (bftot * n) mod bf == (bf - (ts + bofs) mod bf) mod bf
	local inv = modinverse(bftot, bf)
	local res = (bf - (ts + bofs) % bf) % bf
	local n = (inv * res) % bf
	ts = ts + bftot * n
	bftot = bftot * bf -- accumulate this bus frequency into the total frequency
end

print(ts)
