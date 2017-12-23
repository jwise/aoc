#!/usr/bin/env lua

frq = 0

function reg(st, x) return st.regs[x] or 0 end
function val(st, x) if tonumber(x) then return tonumber(x) else return reg(st, x) end end

opcs = {
	set = function(st, a, b) st.regs[a] = val(st, b) end,
	sub = function(st, a, b) st.regs[a] = reg(st, a) - val(st, b) end,
	mul = function(st, a, b) st.regs[a] = reg(st, a) * val(st, b) st.mulcnt = st.mulcnt + 1 end,
	jnz = function(st, a, b) if val(st, a) ~= 0 then st.pc = st.pc + val(st, b) - 1 end end
}

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

ast = { pc = 1, alive = true, regs = { p = 0 }, mulcnt = 0 }

function ex(st)
	if not st.alive then return end
	if not iram[st.pc] then st.alive = false return end
	rv = iram[st.pc].opc(st, iram[st.pc].a, iram[st.pc].b)
	st.pc = st.pc+1
	return rv
end

while ast.alive do
	ex(ast)
end
print(ast.mulcnt)