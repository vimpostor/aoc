with (import <nixpkgs/lib>);
rec {
	charAt = i: s: substring i 1 s;
	charsToString = l: concatStringsSep "" l;
	dropWhile = f: l: if f (head l) then dropWhile f (forward l) else l;
	empty = l: length l == 0;
	findIndex = e: l: if empty l then 1 else if head l == e then 0 else 1 + findIndex e (forward l);
	forward = drop 1;
	iter = f: n: if n == 0 then x: x else x: (iter f (n - 1)) (f x);
	min = l: head (sortasc l);
	max = l: head (sortdec l);
	product = foldl' (l: n: l * n) 1;
	read = i: trimLines (splitString "\n" i);
	setAt = l: i: x: (take i l) ++ [x] ++ (drop (i + 1) l);
	shiftr = l: [(head (reverseList l))] ++ (reverseList (forward (reverseList l)));
	sortasc = sort (a: b: a < b);
	sortdec = sort (a: b: a > b);
	suffixFrom = i: s: substring i (stringLength s) s;
	sum = foldl' (l: n: l + n) 0;
	takeWhile = f: l: if empty l then [] else (if f (head l) then [(head l)] ++ takeWhile f (forward l) else []);
	transpose = l: [(map head l)] ++ (if length (head l) > 1 then transpose (map (l: forward l) l) else []);
	trimLines = l: filter (s: stringLength s > 0) l;
}
