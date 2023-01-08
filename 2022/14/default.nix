with (import <nixpkgs/lib>);
with (import ../lib);
let
	parse = a:
		let
			r = map (b: map toInt (splitString "," b)) (splitString " -> " a);
		in
			zipListsWith (x: y: { a = head x; b = last x; c = head y; d = last y; }) r (forward r);
	lines = concatLists (map parse (read (readFile ./input.txt)));
	abyss = max (map (a: max [a.b a.d]) lines);
	intersect = x: y: s:
		elem { x = x; y = y; } s
		|| any (l: ((l.a <= x && l.c >= x) || (l.c <= x && l.a >= x)) && ((l.b <= y && l.d >= y) || (l.d <= y && l.b >= y))) lines
		|| y == (abyss + 2);
	sim = x: y: s: p:
		if p && y >= abyss then
			[]
		else if !intersect x (y + 1) s then
			sim x (y + 1) s p
		else if !intersect (x - 1) (y + 1) s then
			sim (x - 1) (y + 1) s p
		else if !intersect (x + 1) (y + 1) s then
			sim (x + 1) (y + 1) s p
		else
			[{ x = x; y = y; }] ++ s;
	fill = s: p: let r = sim 500 0 s p; in if empty r then s else if (head r).y == 0 then r else fill r p;
	part1 = length (fill [] true);
	part2 = length (fill [] false);
in {
	inherit part1 part2;
}
