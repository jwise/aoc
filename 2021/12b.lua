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

function dfs(pos, visited, nvtwice, path)
	if smalls[pos] and visited[pos] and visited[pos] == 2 then return 0 end
	if smalls[pos] and visited[pos] and visited[pos] == 1 then
		if nvtwice then
			return 0
		else
			nvtwice = 1
		end
	end
	if pos == nil then pos = "start" end
	if pos == "end" then return 1 end
	local cave = caves[pos]
	local to
	local opts = 0
	local nvisited = {}
	for vis,_ in pairs(visited) do nvisited[vis] = visited[vis] end
	nvisited[pos] = (nvisited[pos] or 0) + 1
	for to,_ in pairs(caves[pos]) do
--		print(pos, to)
		opts = opts + dfs(to, nvisited, nvtwice, path .. "-" .. to)
	end
	return opts
end
print(dfs(nil, {start = 1}, false, "start"))
