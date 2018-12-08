l = io.read("*line")
toks = {}
for w in l:gmatch("%d+") do
	table.insert(toks, tonumber(w))
end

function poptok()
	tok = table.remove(toks, 1)
	return tok
end

function mktree()
	local ent = {}
	
	local children = poptok()
	local metadata = poptok()
	
	ent.children = {}
	ent.metadata = {}
	ent.mdsum = 0
	
	for i=1,children do
		t = mktree()
		table.insert(ent.children, t)
		ent.mdsum = ent.mdsum + t.mdsum
	end
	for i=1,metadata do
		md = poptok()
		table.insert(ent.metadata, md)
		ent.mdsum = ent.mdsum + md
	end
	
	return ent
end

function val(t)
	if #t.children == 0 then
		return t.mdsum
	end
	
	local _val = 0
	for k,v in ipairs(t.metadata) do
		if t.children[v] then
			_val = _val + val(t.children[v]) 
		end
	end
	
	return _val
end

t = mktree()
print(t.mdsum)
print(val(t))
