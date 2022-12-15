with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = splitString "\n" (readFile ./input.txt);
	add = l: n: if n == "" then
					[0] ++ l
				else
					[(head l + toInt n)] ++ forward l;
	elves = sortdec (foldl' add [0] lines);
	part1 = head elves;
	part2 = sum (take 3 elves);
in {
	inherit part1 part2;
}
