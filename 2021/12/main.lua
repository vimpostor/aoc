g = {}

for l in io.lines("input.txt") do
	local a,b = string.match(l, "(%a+)%-(%a+)")
	if not g[a] then g[a] = {} end
	if not g[b] then g[b] = {} end
	if b~= "start" then
		table.insert(g[a], b)
	end
	if a~= "start" then
		table.insert(g[b], a)
	end
end

function count(path, n, small_free)
	if n == "end" then return 1 end
	path[n] = true
	local sum = 0
	for _, i in pairs(g[n]) do
		local needs_small = string.match(i, "%l") and path[i]
		if not needs_small or small_free then
			sum = sum + count(path, i, small_free and not needs_small)
			path[i] = needs_small
		end
	end
	return sum
end

-- part 1
print(count({}, "start", false))
-- part 2
print(count({}, "start", true))
