with (import <nixpkgs/lib>);
with (import ../lib);
let
	parsed = init (stringToCharacters (readFile ./input.txt));
	find = l: n: if length (unique (take n l)) == n then n else 1 + find (forward l) n;
	part1 = find parsed 4;
	part2 = find parsed 14;
in {
	inherit part1 part2;
}
