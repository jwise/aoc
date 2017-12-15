#!/usr/bin/env lua5.3

ast = tonumber(arg[1])
bst = tonumber(arg[2])

function upd()
	ast = (ast * 16807) % 0x7FFFFFFF
	bst = (bst * 48271) % 0x7FFFFFFF
end

matched = 0
for i=1,40000000 do
	if (i % 1000000) == 0 then print(i) end
	upd()
	if (ast & 0xFFFF) == (bst & 0xFFFF) then matched = matched + 1 end
end
print(matched)
