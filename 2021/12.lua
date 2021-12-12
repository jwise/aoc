caves = {}
smalls = {}

while true do
	line = io.read("*line")
	if not line then break end
	from,to = line:match("(.+)-(.+)")
	if not caves[from] then caves[from] = {} end
	if not caves[to] then caves[to] = {} end
	caves[from][to] = true
	caves[to][from] = true
	if from:lower() == from then smalls[from] = true end
	if to:lower() == to then smalls[to] = true end
end

function dfs(pos, visited, path)
--	print(path)
	if smalls[pos] and visited[pos] then print("VISITED",pos) return 0 end
	if pos == "end" then return 1 end
	local cave = caves[pos]
	local to
	local opts = 0
	local nvisited = {}
	for vis,_ in pairs(visited) do nvisited[vis] = true end
	nvisited[pos] = true
	for to,_ in pairs(caves[pos]) do
--		print(pos, to)
		opts = opts + dfs(to, nvisited, path .. "-" .. to)
	end
	return opts
end
print(dfs("start", {}, "start"))
