bitstr = ""
line = io.read("*line")
bittab = {
["0"] = "0000",
["1"] = "0001",
["2"] = "0010",
["3"] = "0011",
["4"] = "0100",
["5"] = "0101",
["6"] = "0110",
["7"] = "0111",
["8"] = "1000",
["9"] = "1001",
["A"] = "1010",
["B"] = "1011",
["C"] = "1100",
["D"] = "1101",
["E"] = "1110",
["F"] = "1111",
}
for c in line:gmatch(".") do
	bitstr = bitstr .. bittab[c]
end

totvers = 0

-- returns bits,pkt
function eatpkt(bits, pfx)
	local pkt = {}
	local bits = bits
	
	pkt.vers = tonumber(bits:sub(1,3),2)
	bits = bits:sub(4)
	totvers = totvers + pkt.vers
	
	pkt.type = tonumber(bits:sub(1,3),2)
	bits = bits:sub(4)
	
	if pkt.type == 4 then
		pkt.literal = ""
		while bits:sub(1,1) == "1" do
			pkt.literal = pkt.literal .. bits:sub(2,5)
			bits = bits:sub(6)
		end
		pkt.literal = pkt.literal .. bits:sub(2,5)
		bits = bits:sub(6)
--		print(pfx.."LITERAL "..pkt.literal)
	else
		pkt.ltyp = tonumber(bits:sub(1,1),2)
		bits = bits:sub(2)
		pkt.subpkts = {}
		if pkt.ltyp == 0 then
			pkt.subbitlen = tonumber(bits:sub(1,15), 2)
			bits = bits:sub(16)
			pkt.subbits = bits:sub(1,pkt.subbitlen)
			bits = bits:sub(pkt.subbitlen+1)
--			print(pfx.."SUBPKT BY BITS "..pkt.subbitlen)
			
			while #pkt.subbits > 0 do
				local nextpkt
				pkt.subbits,nextpkt = eatpkt(pkt.subbits, pfx .. "  ")
				table.insert(pkt.subpkts, nextpkt)
			end
		else
			pkt.subpktcnt = tonumber(bits:sub(1,11), 2)
--			print(pfx.."SUBPKT PKTS "..pkt.subpktcnt)
			bits = bits:sub(12)
			for i=1,pkt.subpktcnt do
				local nextpkt
				bits,nextpkt = eatpkt(bits, pfx .. "  ")
				table.insert(pkt.subpkts, nextpkt)
			end
		end
	end
	
	return bits,pkt
end

bits,pkt = eatpkt(bitstr, "")
print("A: ",totvers)

function evalpkt(pkt)
	if pkt.type == 0 then
		local sum = 0
		for _,pkt in ipairs(pkt.subpkts) do
			sum = sum + evalpkt(pkt)
		end
		return sum
	elseif pkt.type == 1 then
		local prod = 1
		for _,pkt in ipairs(pkt.subpkts) do
			prod = prod * evalpkt(pkt)
		end
		return prod
	elseif pkt.type == 2 then
		local res = math.huge
		for _,pkt in ipairs(pkt.subpkts) do
			local pkte = evalpkt(pkt)
			if pkte < res then res = pkte end
		end
		return res
	elseif pkt.type == 3 then
		local res = -math.huge
		for _,pkt in ipairs(pkt.subpkts) do
			local pkte = evalpkt(pkt)
			if pkte > res then res = pkte end
		end
		return res
	elseif pkt.type == 4 then
		return tonumber(pkt.literal, 2)
	elseif pkt.type == 5 then
		local a0 = evalpkt(pkt.subpkts[1])
		local a1 = evalpkt(pkt.subpkts[2])
		if a0 > a1 then return 1 else return 0 end
	elseif pkt.type == 6 then
		local a0 = evalpkt(pkt.subpkts[1])
		local a1 = evalpkt(pkt.subpkts[2])
		if a0 < a1 then return 1 else return 0 end
	elseif pkt.type == 7 then
		local a0 = evalpkt(pkt.subpkts[1])
		local a1 = evalpkt(pkt.subpkts[2])
		if a0 == a1 then return 1 else return 0 end
	else
		print("WTF",pkt.type)
	end
end
print("B: ",evalpkt(pkt))