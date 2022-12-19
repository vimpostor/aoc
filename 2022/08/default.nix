with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = read (readFile ./input.txt);
	parsed = map (x: map toInt (stringToCharacters x)) lines;
	a = map reverseList parsed;
	b = transpose parsed;
	c = map reverseList b;
	n = length parsed;
	m = n - 1;
	r = range 0 m;
	look = l: x: all (i: i < elemAt l x) (take x l);
	visible = x: y: look (elemAt parsed y) x || look (elemAt a y) (m - x) || look (elemAt b x) y || look (elemAt c x) (m - y);
	apply = f: flatten (map (y: map (x: f x y) r) r);
	part1 = length (filter (x: x == true) (apply visible));
	around = l: x: count (drop (x + 1) l) (elemAt l x);
	count = l: v: if empty l then 0 else if v <= head l then 1 else 1 + count (forward l) v;
	score = x: y: around (elemAt parsed y) x * around (elemAt a y) (m - x) * around (elemAt b x) y * around (elemAt c x) (m - y);
	part2 = max (apply score);
in {
	inherit part1 part2;
}
