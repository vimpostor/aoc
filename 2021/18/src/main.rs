#[derive(Clone, Copy)]
struct Digit {
	num: u32,
	depth: u32,
}
type Snailfish = Vec<Digit>;

fn parse(s: &str) -> Snailfish {
	let mut result = Vec::new();
	let mut depth = 0;
	for c in s.chars() {
		match c {
			'[' => depth += 1,
			']' => depth -= 1,
			n => match n.to_digit(10) {
				Some(num) => result.push(Digit {num, depth}),
				_ => (),
			},
		}
	}
	result
}

fn deeper(a: Snailfish) -> Snailfish {
	a.iter().map(|x| { Digit {num: x.num, depth: x.depth + 1} }).collect()
}

fn add(a: Snailfish, b: Snailfish) -> Snailfish {
	let mut merged = [deeper(a), deeper(b)].concat();
	return reduce(&mut merged).to_vec();
}

fn explode(s: &mut Snailfish) -> bool {
	for ((i, &a), &b) in s.iter().enumerate().zip(s.iter().skip(1)) {
		if a.depth == 5 && b.depth == 5 {
			if i > 0 {
				s[i - 1].num += a.num;
			}
			if i < s.len() - 2 {
				s[i + 2].num += b.num;
			}
			s.drain(i..i + 2);
			s.insert(i, Digit {num: 0, depth: 4});
			return true;
		}
	}
	false
}

fn split(s: &mut Snailfish) -> bool {
	for (i, &a) in s.iter().enumerate() {
		if a.num > 9 {
			s.remove(i);
			let mut x = Digit {num: a.num / 2, depth: a.depth + 1};
			s.insert(i, x);
			x.num += a.num % 2;
			s.insert(i + 1, x);
			return true;
		}
	}
	false
}

fn reduce(s: &mut Snailfish) -> &Snailfish {
	while explode(s) || split(s) {}
	s
}

fn magnitude(mut s: Snailfish) -> u32 {
	for depth in (1..5).rev() {
		let mut i = 0;
		while i < s.len() - 1 {
			if s[i].depth == depth && s[i+1].depth == depth {
				s[i].num = 3 * s[i].num + 2 * s[i+1].num;
				s[i].depth -= 1;
				s.remove(i + 1);
			}
			i += 1;
		}
	}
	s[0].num
}

fn main() {
	let snailfs: Vec<Snailfish> = include_str!("../input.txt").lines().map(parse).collect();
	let mut result = snailfs.first().unwrap().to_vec();
	let mut last = result.to_vec();
	let mut largest = 0;
	for i in snailfs.iter().skip(1) {
		result = add(result.to_vec(), i.to_vec());
		largest = std::cmp::max(std::cmp::max(magnitude(add(last.to_vec(), i.to_vec())), magnitude(add(i.to_vec(), last))), largest);
		last = i.to_vec();
	}
	println!("{}\n{}", magnitude(result), largest);
}
