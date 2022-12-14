with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = read (readFile ./input.txt);
	parsed = map (l: map toInt (builtins.match "([[:digit:]]+)-([[:digit:]]+),([[:digit:]]+)-([[:digit:]]+)" l)) lines;
	gatekeep = l: head l <= elemAt l 2 && elemAt l 1 >= elemAt l 3;
	weakGatekeep = l: head l <= elemAt l 3 && elemAt l 1 >= elemAt l 2;
	count = f: length (filter (l: f l || f (drop 2 l ++ take 2 l)) parsed);
	part1 = count gatekeep;
	part2 = count weakGatekeep;
in {
	inherit part1 part2;
}
