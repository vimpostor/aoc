with (import <nixpkgs/lib>);
with (import ../lib);
let
	g = map (x: map strings.charToInt (stringToCharacters x)) (read (readFile ./input.txt));
	startc = strings.charToInt "S";
	endc = strings.charToInt "E";
	d = map (y: map (x: if x == startc then 0 else infty) y) g;
	xl = (length (head g) - 1) / 2.0;
	yl = (length g - 1) / 2.0;
	findchar = g: c: let a = map (y: findIndex c y) g; in { x = head (dropWhile (x: x >= infty) a); y = length (takeWhile (x: x >= infty) a); };
	start = findchar g startc;
	end = findchar g endc;
	u = gridSetAt (gridSetAt g start.x start.y (strings.charToInt "a")) end.x end.y (strings.charToInt "z");
	neighbors = d: x: y: p:
		let
			o = [{ x = x - 1; y = y; } { x = x + 1; y = y; } { x = x; y = y - 1; } { x = x; y = y + 1; }];
		in
			filter (c: abs (c.x - xl) <= xl && abs (c.y - yl) <= yl && gridAt d c.x c.y == infty && (gridAt p c.x c.y - gridAt p x y < 2)) o;
	dijkstra = q: d: a: b: z: p:
		let
			h = head q;
			l = neighbors d h.x h.y p;
			e = foldl' (l: n: gridSetAt l n.x n.y (1 + gridAt l h.x h.y)) d l;
			s = (forward q) ++ map (c: { x = c.x; y = c.y; n = 1 + h.n; } ) l;
		in
			if (h.x == a && h.y == b) || (z && gridAt p h.x h.y == -(strings.charToInt "a")) then
				h.n
			else
				dijkstra s e a b z p;
	part1 = dijkstra [({ x = start.x; y = start.y; n = 0; })] d end.x end.y false u;
	v = map (y: map (x: -x) y) u;
	part2 = dijkstra [({ x = end.x; y = end.y; n = 0; })] d start.x start.y true v;
in {
	inherit part1 part2;
}
