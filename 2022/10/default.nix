with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = read (readFile ./input.txt);
	parsed = map (s: if s == "noop" then 0 else toInt (suffixFrom 5 s)) lines;
	run = l: c: if empty l then [] else
		let
			n = head l;
			m = forward l;
		in
			if n == 0 then
				[c] ++ run m c
			else
				[c c] ++ run m (c + n);
	r = run parsed 1;
	part1 = sum (map (x: x * elemAt r (x - 1)) (genList (x: 20 + x * 40) 6));
	split = x: if empty x then [] else [(take 40 x)] ++ split (drop 40 x);
	draw = l: i: if empty l then "" else
		let
			n = head l;
			c = if i >= n && i < n + 3 then "#" else ".";
		in
			c + draw (forward l) (i + 1);
	part2 = concatStringsSep "\n" (map (x: draw x 1) (split r));
in {
	inherit part1 part2;
}
