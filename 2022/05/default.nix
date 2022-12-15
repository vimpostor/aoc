with (import <nixpkgs/lib>);
with (import ../lib);
let
	parts = trimLines (splitString "\n\n" (readFile ./input.txt));
	stackPart = map (l: dropWhile (x: x == " ") (init l)) (filter
		(l: null != builtins.match ".*[[:digit:]]" (toString l))
		(transpose (map stringToCharacters (read (head parts)))));
	parsed = map (l:
		let
			r = builtins.match ".* ([[:digit:]]+) .* ([[:digit:]]+) .* ([[:digit:]]+)" l;
		in
			[(toInt (head r))] ++ (map (x: toInt x - 1) (tail r))) (read (elemAt parts 1));
	move = l: o: c:
		let
			n = head o;
			from = elemAt o 1;
			to = elemAt o 2;
			m = elemAt l from;
		in
			setAt (setAt l from (drop n m)) to (c (take n m) ++ elemAt l to);
	work = s: l: c: if empty l then s else work (move s (head l) c) (forward l) c;
	top = c: charsToString (foldl' (l: n: l ++ [(head n)]) [] (work stackPart parsed c));
	part1 = top reverseList;
	part2 = top (x: x);
in {
	inherit part1 part2;
}
