nums = {}
nbs = 0

line = io.read("*line")
for b in line:gmatch("(%d+)") do
	b = tonumber(b)
	table.insert(nums, b)
end

io.read("*line")

boards = {}
while true do
	line = io.read("*line")
	if not line then break end
	board = {}
	for i=1,5 do
		brow = {}
		for n in line:gmatch("(%d+)") do
			table.insert(brow, tonumber(n))
		end
		table.insert(board,brow)
		line = io.read("*line")
	end
	nbs = nbs + 1
	board.done = false
	table.insert(boards, board)
end

function isdone(b)
	for r=1,5 do
		local done = true
		for c=1,5 do
			if b[r][c] then done = false break end
		end
		if done then
			return true
		end
	end
	
	for c=1,5 do
		local done = true
		for r=1,5 do
			if b[r][c] then done = false break end
		end
		if done then
			return true
		end
	end
end

function sum(b)
	local res = 0
	for r=1,5 do
		for c=1,5 do
			if b[r][c] then res = res + b[r][c] end
		end
	end
	return res
end

for _,num in ipairs(nums) do
	for _,b in ipairs(boards) do
		for r=1,5 do
			for c=1,5 do
				if b[r][c] == num then b[r][c] = false end
			end
		end
		if isdone(b) and not b.done then
			b.done = true
			nbs = nbs - 1
			print("NBS",nbs)
		end
		if nbs == 0 then
			print(sum(b) * num)
			LOL()
		end
	end
end

print(#nums)
print(#boards)
