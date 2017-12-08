#!/usr/bin/env lua

opcs = {
  inc = function (a,b) return a+b end,
  dec = function (a,b) return a-b end
}

ccmps = {
  [">"] = function (a,b) return a > b end,
  [">="] = function (a,b) return a >= b end,
  ["<"] = function (a,b) return a < b end,
  ["<="] = function (a,b) return a <= b end,
  ["=="] = function (a,b) return a == b end,
  ["!="] = function (a,b) return a ~= b end
}

iram = {}
while true do
	l = io.read("*line")
	if not l then break end
	
	insn = {}
	insn.treg, insn.opc, insn.opr, insn.creg, insn.ccmp, insn.copr = l:match("(%S+) (%S+) (%S+) if (%S+) (%S+) (%S+)")
	
	-- and normalize
	insn.opr = tonumber(insn.opr)
	insn.copr = tonumber(insn.copr)
	insn.opc = opcs[insn.opc]
	insn.ccmp = ccmps[insn.ccmp]
	
	table.insert(iram, insn)
end

regs = {}
gmax = nil
for _,insn in ipairs(iram) do
	if (insn.ccmp(regs[insn.creg] or 0, insn.copr)) then
		regs[insn.treg] = insn.opc(regs[insn.treg] or 0, insn.opr)
		if not gmax or regs[insn.treg] > gmax then
			gmax = regs[insn.treg]
		end
	end
end

max = nil
for k,v in pairs(regs) do
	if not max or v > max then
		max = v
	end
end

print("max: "..max)
print("gmax: "..gmax)