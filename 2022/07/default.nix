with (import <nixpkgs/lib>);
with (import ../lib);
let
	lines = filter (s: s != "$ ls") (forward (read (readFile ./input.txt)));
	parseCd = l: p: t: x:
		let
			r = if x == ".." then init p else p ++ [x];
		in
			parse l r t;
	parseDir = l: p: t: x: parse l p (recursiveUpdate t (setAttrByPath (p ++ [x]) {}));
	parseFile = l: p: t: x:
		let
			i = splitString " " x;
			size = toInt (head i);
			name = elemAt i 1;
			new = getAttrFromPath p t // { ${name} = size; };
		in
			parse l p (recursiveUpdate t (setAttrByPath p new));
	parse = l: p: t: if empty l then t else
		let
			next = head l;
			c = head (stringToCharacters next);
			y = forward l;
		in
			if c == "$" then
				parseCd y p t (suffixFrom 5 next)
			else if c == "d" then
				parseDir y p t (suffixFrom 4 next)
			else
				parseFile y p t next;
	folderSize = x: foldl' (l: n:
		let
			i = if isAttrs n then folderSize n else n;
		in
			l + i
		) 0 (attrValues x);
	parsed = parse lines [] {};
	count = p: foldl' (l: n:
		let
			s = if isAttrs n then folderSize n else 0;
			r = if s < 100000 then s else 0;
			c = if isAttrs n then count n else 0;
		in
			l + r + c
		) 0 (attrValues p);
	part1 = count parsed;
	free = folderSize parsed - 40000000;
	sizes = p: foldl' (l: n: if isAttrs n then l ++ [(folderSize n)] ++ sizes n else l) [] (attrValues p);
	part2 = head (dropWhile (x: x < free) (sortasc (sizes parsed)));
in {
	inherit part1 part2;
}
