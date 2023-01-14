with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = map (x: map toInt (builtins.match ".*=(.?[[:digit:]]+), y=(.?[[:digit:]]+).*=(.?[[:digit:]]+), y=(.?[[:digit:]]+).*" x)) (read (readFile ./input.txt));
	sensors = map (l: let a = head l; b = elemAt l 1; x = elemAt l 2; y = elemAt l 3; in { a = a; b = b; x = x; y = y; d = manhattan a b x y; }) lines;
	left = min (map (x: x.a - x.d) sensors);
	right = max (map (x: x.a + x.d) sensors);
	check = x: y: any (s: manhattan s.a s.b x y <= s.d) sensors && all (s: x != s.x || y != s.y) sensors;
	part1 = length (filter (x: check x 2000000) (range left right));
	limit = 4000000;
	gen = s: a: b: c: d: zipListsWith (x: y: { x = x; y = y; }) (autorange (s.a + a) (s.a + b)) (autorange (s.b + c) (s.b + d));
	points = s: gen s (-s.d) (-1) 1 s.d ++ gen s 1 (-s.d) (-s.d) 1 ++ gen s 1 s.d (-s.d) (-1) ++ gen s s.d (-1) (-1) s.d;
	locate = l:
		let
			s = head l;
			r = filter (p: p.x >= 0 && p.y >= 0 && p.x <= limit && p.y <= limit && all (s: manhattan s.a s.b p.x p.y > s.d) sensors) (points s);
		in
			if empty r then
				locate (forward l)
			else
				let z = head r; in z.x * limit + z.y;
	part2 = locate sensors;
in {
	inherit part1 part2;
}
