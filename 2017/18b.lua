#!/usr/bin/env lua

frq = 0

function reg(st, x) return st.regs[x] or 0 end
function val(st, x) if tonumber(x) then return tonumber(x) else return reg(st, x) end end

opcs = {
	snd = function(st, a) table.insert(st.q, reg(st, a)) st.sent = st.sent + 1 end,
	set = function(st, a, b) st.regs[a] = val(st, b) end,
	add = function(st, a, b) st.regs[a] = reg(st, a) + val(st, b) end,
	mul = function(st, a, b) st.regs[a] = reg(st, a) * val(st, b) end,
	mod = function(st, a, b) st.regs[a] = reg(st, a) % val(st, b) end,
	rcv = function(st, a) if #st.rq == 0 then st.pc = st.pc - 1 return true end
	                      st.regs[a] = table.remove(st.rq, 1) end,
	jgz = function(st, a, b) if val(st, a) > 0 then st.pc = st.pc + val(st, b) - 1 end end
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


ast = { pc = 1, q = {}, alive = true, sent = 0, regs = { p = 0 } }
bst = { pc = 1, q = {}, alive = true, sent = 0, regs = { p = 1 } }

ast.rq = bst.q
bst.rq = ast.q

function ex(st)
	if not st.alive then return end
	rv = iram[st.pc].opc(st, iram[st.pc].a, iram[st.pc].b)
	st.pc = st.pc+1
	return rv
end

while true do
	arv = ex(ast)
	brv = ex(bst)
	if ((not ast.alive) and (not bst.alive)) or (arv and brv) then
		print(bst.sent)
		os.exit()
	end
end
