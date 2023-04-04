with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = map (x: builtins.match ".*([[:upper:]]{2})[^0-9]*([[:digit:]]+)[^A-Z]*([[:upper:]]{2}.*)" x) (read (readFile ./input.txt));
	parsed = map (x: { i = head x; n = toInt (elemAt x 1); t = splitString ", " (last x); }) lines;
	start = indexWhere (y: y.i == "AA") parsed;
	g = map (x: { n = x.n; t = map (a: { i = indexWhere (y: y.i == a) parsed; d = 1; }) x.t; }) parsed;
	neigh = map (x: map (t: t.i) x.t) g;
	findleafs = l: c: if empty l then [] else let h = head l; r = forward l; o = elemAt g h.i; in
		if o.n > 0 then
			[h] ++ findleafs r (c ++ [h])
		else
			let s = map (n: { i = n.i; d = h.d + 1; }) o.t;
			in
				findleafs (r ++ filter (x: all (y: x.i != y.i) (c ++ r)) s) (c ++ s);
	m = map (x: { n = x.n; t = findleafs x.t []; }) g; # minimized graph
	solve = i: t: v: w: if t <= 0 then 0 else
		let c = elemAt m i;
			s = t - 1;
			o = if c.n != 0 && !contains i v then [(s * c.n + solve i s (v ++ [i]) [])] else [];
			y = w ++ [i];
		in
			max (o ++ (map (n: solve n.i (t - n.d) v y) (filter (a: !contains a.i w) c.t)));
	part1 = solve start 30 [] [];
in {
	inherit part1;
}
