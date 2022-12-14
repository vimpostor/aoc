with (import <nixpkgs/lib>);
rec {
	charAt = i: s: substring i 1 s;
	charsToString = l: concatStringsSep "" l;
	dropWhile = f: l: if f (head l) then dropWhile f (drop 1 l) else l;
	empty = l: length l == 0;
	findIndex = e: l: if empty l then 1 else if head l == e then 0 else 1 + findIndex e (drop 1 l);
	iter = f: n: if n == 0 then x: x else x: (iter f (n - 1)) (f x);
	read = i: trimLines (splitString "\n" i);
	setAt = l: i: x: (take i l) ++ [x] ++ (drop (i + 1) l);
	shiftr = l: [(head (reverseList l))] ++ (reverseList (drop 1 (reverseList l)));
	sortasc = sort (a: b: a < b);
	sortdec = sort (a: b: a > b);
	sum = foldl' (l: n: l + n) 0;
	transpose = l: [(map head l)] ++ (if length (head l) > 1 then transpose (map (l: drop 1 l) l) else []);
	trimLines = l: filter (s: stringLength s > 0) l;
}
