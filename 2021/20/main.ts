declare var require: any
const fs = require('fs');

const outofbounds = (y, x: number, size: number) => {
	return [y, x].some(i => Math.abs(i - (size - 1) / 2) > size / 2);
}

const transform = (grid: boolean[][], y, x: number, pad: boolean) => {
	const indices = Array.from(Array(3).keys());
	return indices.flatMap((_, b) => indices.map((_, a) => [b - 1, a - 1])).map(([b, a]) => [b + y, a + x]).map(([b, a]) => outofbounds(b, a, grid.length) ? pad : grid[b][a]).reverse().map((b, i) => +b * Math.pow(2, i)).reduce((res, i) => res + i, 0);
};

// ENHANCE
const enhance = (grid: boolean[][], alg: boolean[], pad: boolean) => {
	const indices = [-1].concat(Array.from(Array(grid.length + 1).keys()));
	return indices.map(y => indices.map(x => alg[transform(grid, y, x, pad)]));
};

const light = (grid: boolean[][]) => {
	return grid.flatMap(x => x).reduce((res, i) => res + +i, 0);
};

const [algl, data] = fs.readFileSync('input.txt').toString().split("\n\n");
const alg = algl.split('').map(c => c == '#');
const imgdata = data.split("\n").filter(i => i);
let img = imgdata.map(line => line.split('').map(c => c == '#'));

for (let end = 2; end <= 48; end += 46) {
	for (let i = 0; i < end; ++i) {
		img = enhance(img, alg, i % 2 == 1);
	}
	console.log(light(img));
}
