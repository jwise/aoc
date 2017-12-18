#!/usr/bin/env lua

regs = {}
frq = 0

function reg(x) return regs[x] or 0 end
function val(x) if tonumber(x) then return tonumber(x) else return reg(x) end end

opcs = {
	snd = function(a) frq = reg(a) end,
	set = function(a, b) regs[a] = val(b) print("set ",a,val(b),b) end,
	add = function(a, b) regs[a] = reg(a) + val(b) end,
	mul = function(a, b) regs[a] = reg(a) * val(b) end,
	mod = function(a, b) regs[a] = reg(a) % val(b) end,
	rcv = function(a) if reg(a) ~= 0 then print(frq) os.exit() end end,
	jgz = function(a, b) if val(a) > 0 then pc = pc + val(b) - 1 end end
}

pc = 1

iram = {}
while true do
	l = io.read("*line")
	if not l then break end
	
	insn = {}
	if l:match("(%S+) (%S+) (%S+)") then
		opc,a,b = l:match("(%S+) (%S+) (%S+)")
		insn.nm = opc
		insn.opc = opcs[opc]
		insn.a = a
		insn.b = b
	elseif l:match("(%S+) (%S+)") then
		opc,a = l:match("(%S+) (%S+)")
		insn.nm = opc
		insn.opc = opcs[opc]
		insn.a = a
		insn.b = nil
	end
	if not insn.opc then print(opc, opcs[opc]) end
	table.insert(iram, insn)
end

while true do
	if not iram[pc] then print("pc out of bounds", pc) break end
	print(pc,iram[pc].nm,iram[pc].a,iram[pc].b)
	iram[pc].opc(iram[pc].a, iram[pc].b)
	pc = pc + 1
end
