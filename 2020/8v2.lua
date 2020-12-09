prog = {}
pc = 1
acc = 0
executed = {}

opcs = {
	nop = function(st,opc)
		st.pc = st.pc + 1
	end,
	acc = function(st,opc)
		st.acc = st.acc + opc.param
		st.pc = st.pc + 1
	end,
	jmp = function(st,opc)
		st.pc = st.pc + opc.param
	end
}

function step(st)
	local opc = st.imem[st.pc]
	opcs[opc.opc](st, opc)
end

function stdup(st)
	local nst = {imem = {}, pc = st.pc, acc = st.acc}
	for adr,da in pairs(st.imem) do
		nst.imem[adr] = { opc = da.opc, param = da.param }
	end
	return nst
end

function stnew()
	return {imem = {}, pc = 1, acc = 0}
end

st = stnew()

while true do
	line = io.read("*line")
	if not line then break end
	
	local opc,param = line:match("(%S+) ([+-]%d+)")
	local param = tonumber(param)
	
	table.insert(st.imem, { opc = opc, param = param })
end

while not executed[st.pc] do
	executed[st.pc] = true
	
	step(st)
end
print(st.acc)