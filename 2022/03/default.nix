with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = map stringToCharacters (trimLines (splitString "\n" (readFile ./input.txt)));
	score = c: let s = strings.charToInt c; in if s < 91 then s - 38 else s - 96;
	split = c:
		let
			len = length c / 2;
		in score (head (intersectLists (take len c) (drop len c)));
	group = x: if empty x then [] else unique (intersectLists (intersectLists (head x) (elemAt x 1)) (elemAt x 2)) ++ group (drop 3 x);
	part1 = sum (map split lines);
	part2 = sum (map score (group lines));
in {
	inherit part1 part2;
}
