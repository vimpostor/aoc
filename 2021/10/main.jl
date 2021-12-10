function parse(line::String)
	braces = [('(',')',3),('[',']',57),('{','}',1197),('<','>',25137)]
	stack = []
	for c in line
		i = findfirst(a -> a == c, [getfield.(braces, 1); getfield.(braces, 2)])
		if (i < 5)
			push!(stack, i)
		elseif last(stack) == i-4
			pop!(stack)
		else
			return braces[i-4][3]
		end
	end
	return -foldl((a,b) -> 5*a + b, reverse(stack))
end

l = map(a -> parse(a), eachline("input.txt"))
# part 1
println(sum(filter(a -> a > 0, l)))
# part 2
incompl = sort(filter(a -> a < 0, l))
println(-incompl[ceil(Int, length(incompl)/2)])
