with (import <nixpkgs/lib>);
with (import ../lib);
let
	monkeys = splitString "\n\n" (readFile ./input.txt);
	ops = { "+" = add; "*" = builtins.mul; };
	parse = x:
		let
			l = read x;
			o = suffixFrom 23 (elemAt l 2);
			s = suffixFrom 2 o;
			d = toInt (suffixFrom 21 (elemAt l 3));
		in
			{
				hold = map toInt (splitString ", " (suffixFrom 18 (elemAt l 1)));
				op = i: ops.${substring 0 1 o} i (if s == "old" then i else toInt s);
				d = d;
				to = i: if mod i d == 0 then toInt (suffixFrom 29 (elemAt l 4)) else toInt (suffixFrom 30 (elemAt l 5));
				n = 0;
			};
	parsed = map parse monkeys;
	ooga = m: h: t: if empty h then m else
		let
			i = head t;
			c = elemAt m i;
		in
			ooga (setAt m i (c // { hold = c.hold ++ [(head h)]; })) (forward h) (forward t);
	inspect = m: i: d:  if i >= length m then m else
		let
			c = elemAt m i;
			h = map (i: mod (c.op i / d) (foldl' (l: n: l * n.d) 1 m)) c.hold;
			t = map c.to h;
			n = c // { hold = []; n = c.n + length h; };
		in
			inspect (ooga (setAt m i n) h t) (i + 1) d;
	oogabooga = d: r: product (take 2 (sortdec (map (x: x.n) (iter (x: inspect x 0 d) r parsed))));
	part1 = oogabooga 3 20;
	part2 = oogabooga 1 10000;
in {
	inherit part1 part2;
}
