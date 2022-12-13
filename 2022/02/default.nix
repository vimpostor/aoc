with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = trimLines (splitString "\n" (readFile ./input.txt));
	# 0 = rock, 1 = paper, 2 = scissors
	parseme = s: strings.charToInt (charAt 2 s) - 88;
	parseother = s: strings.charToInt (charAt 0 s) - 65;
	parsed = map (s: { me = parseme s; other = parseother s; }) lines;
	shapescore = s: s + 1;
	winscore = a: b: elemAt (iter shiftr a [3 0 6]) b;
	calc = p: sum (map ({ me, other }: shapescore me + winscore me other) p);
	part1 = calc parsed;
	# 0 = lose, 1 = draw, 2 = win
	translated = map ({ me, other }: { me = findIndex (me * 3) (iter shiftr other [3 6 0]); other = other; }) parsed;
	part2 = calc translated;
in {
	inherit part1 part2;
}
