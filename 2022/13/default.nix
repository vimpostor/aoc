with (import <nixpkgs/lib>);
with (import ../lib);
let
	pairs = map (x: map builtins.fromJSON (read x)) (splitString "\n\n" (readFile ./input.txt));
	cmp = a: b:
		if isInt a && isInt b then
			if a < b then 1 else if a == b then 0 else -1
		else if isInt a then
			cmp [a] b
		else if isInt b then
			cmp a [b]
		else if empty a && empty b then
			0
		else if empty a then
			1
		else if empty b then
			-1
		else
			let c = cmp (head a) (head b); in if c == 0 then cmp (forward a) (forward b) else c;
	r = map (x: cmp (head x) (last x)) pairs;
	part1 = sum (zipListsWith (a: b: a * b) (map (x: (x + 1) / 2) r) (range 1 (length r)));
	d = [[[2]] [[6]]];
	t = sort (a: b: cmp a b == 1) (concatLists pairs ++ d);
	part2 = product (zipListsWith (a: b: if elem a d then b else 1) t (range 1 (length t)));
in {
	inherit part1 part2;
}
