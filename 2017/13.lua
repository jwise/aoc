#!/usr/bin/env lua

layers = {}
maxl = 0
while true do
	layer = {}
	
	l = io.read("*line")
	if not l then break end

	local d,r = l:match("(%d+): (%d+)")
	layer.depth = tonumber(d)
	layer.range = tonumber(r)
	layer.pos = 0
	layer.dir = 1
	layer.nextbad = -layer.depth
	
	if layer.range == 1 then layer.per = 1
	else layer.per = (layer.range - 1) * 2
	end
	
	layers[layer.depth] = layer
	if layer.depth > maxl then maxl = layer.depth end
end

function sev(delay)
	local sev = 0
	local ncaught = 0
	
	-- reset everything
	for _,layer in pairs(layers) do
		layer.pos = 0
		layer.dir = 1
	end
	
	function step()
		for _,layer in pairs(layers) do
			layer.pos = layer.pos + layer.dir
			if layer.pos == 0 or layer.pos == (layer.range - 1) then
				layer.dir = -layer.dir
			end
		end
	end

	for _=0,(delay-1) do step() end
	
	for curl=0,maxl do
		if layers[curl] and layers[curl].pos == 0 then
			-- print("caught at layer "..curl)
			ncaught = ncaught + 1
			sev = sev + curl * layers[curl].range
		end
		
		step()
	end
	
	return (ncaught > 0), sev
end

print(sev(0))

-- build a list of times when this will work for each layer
dly = 0
while true do
	bad = false
	
	for _,l in pairs(layers) do
		while dly > l.nextbad do
			l.nextbad = l.nextbad + l.per
		end
		
		if l.nextbad == dly then
			bad = true
		end
	end
	
	if not bad then
		print("min dly "..dly)
		break
	end
	
	dly = dly + 1
end
