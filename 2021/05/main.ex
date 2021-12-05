import Enum

defmodule Aoc do
	def rasterize(line, diag \\ false) do
		r = fn
			[a,b,a,d], _ -> map(b..d, &{a, &1})
			[a,b,c,b], _ -> map(a..c, &{&1, b})
			[a,b,c,d], true -> zip(a..c, b..d)
			_, _ -> []
		end
		r.(line, diag)
	end

	def danger(points) do
		uniq(points -- uniq(points)) |> length
	end
end

lines = "input.txt" |> File.read!() |> String.split("\n") |> map(fn s -> Enum.map(String.split(s, ~r([^\d]+), trim: true), &String.to_integer/1) end)

# part 1
lines |> Enum.flat_map(&Aoc.rasterize/1) |> Aoc.danger() |> IO.inspect()

# part 2
lines |> Enum.flat_map(fn l -> Aoc.rasterize(l, true) end) |> Aoc.danger() |> IO.inspect()
