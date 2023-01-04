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
	neighbors = g: d: x: y:
		let
			o = [{ x = x - 1; y = y; } { x = x + 1; y = y; } { x = x; y = y - 1; } { x = x; y = y + 1; }];
		in
			filter (c: abs (c.x - xl) <= xl && abs (c.y - yl) <= yl && gridAt d c.x c.y == infty && (gridAt g c.x c.y - gridAt g x y < 2)) o;
	dijkstra = g: d: x: y: a: b: if x == a && y == b then 0 else
		let
			r = map (c: 1 + dijkstra g (gridSetAt d c.x c.y (1 + gridAt d x y)) c.x c.y a b) (neighbors g d x y);
		in
			if empty r then infty else min r;
	p = gridSetAt (gridSetAt g start.x start.y (strings.charToInt "a")) end.x end.y (strings.charToInt "z");
	part1 = dijkstra p d start.x start.y end.x end.y;
in {
	inherit part1;
}
