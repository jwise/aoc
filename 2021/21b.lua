wts = {}
for i=1,3 do for j=1,3 do for k=1,3 do wts[i+j+k] = (wts[i+j+k] or 0) + 1 end end end

wtab = {}
function wins(pos1, pos2, score1, score2)
	local key = string.format("%d %d %d %d", pos1, pos2, score1, score2)
	if wtab[key] then return wtab[key] end
	local wins1 = 0
	local wins2 = 0
	for p1inc=3,9 do
		local npos1 = (pos1 - 1 + p1inc) % 10 + 1
		local nscore1 = score1 + npos1
		
		if nscore1 >= 21 then wins1 = wins1 + wts[p1inc]
		else
			for p2inc=3,9 do
				local npos2 = (pos2 - 1 + p2inc) % 10 + 1
				
				local nscore2 = score2 + npos2
				
				if nscore2 >= 21 then wins2 = wins2 + wts[p2inc] * wts[p1inc] 
				else
					local xwins = wins(npos1, npos2, nscore1, nscore2)
					wins1 = wins1 + xwins[1] * wts[p1inc] * wts[p2inc]
					wins2 = wins2 + xwins[2] * wts[p1inc] * wts[p2inc]
				end
			end
		end
	end
	wtab[key] = { wins1, wins2 }
	return wtab[key]
end

endwins = wins(6, 10, 0, 0)
print(string.format("%d %d", endwins[1], endwins[2]))
