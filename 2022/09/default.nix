with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = read (readFile ./input.txt);
	parsed = concatMap (s: genList (x: { R = [1 0]; U = [0 1]; L = [(-1) 0]; D = [0 (-1)]; }.${substring 0 1 s}) (toInt (suffixFrom 2 s))) lines;
	follow = h: t:
		let
			d = subTuples h t;
			a = map abs d;
			n = addTuples t (map (x: if x > 0 then 1 else if x < 0 then (-1) else 0) d);
		in
			if contains 2 a then n else t;
	noperope = h: r: if empty r then [h] else [h] ++ noperope (follow h (head r)) (forward r);
	go = p: v: r: if empty p then v else
		let
			s = noperope (addTuples (head r) (head p)) (forward r);
		in
			go (forward p) ((v ++ [(last s)])) s;
	dangernoodle = n: length (unique (go parsed [] (genList (x: [0 0]) n)));
	part1 = dangernoodle 2;
	part2 = dangernoodle 10;
in {
	inherit part1 part2;
}
