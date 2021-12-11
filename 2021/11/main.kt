import java.io.File

var flashes = 0
var synced = 0
var step = 0

fun neighbors(p: Pair<Int,Int>): List<Pair<Int,Int>> {
	val o = -1..1
	return o.flatMap{a -> o.map{b -> Pair(p.first + a, p.second + b)}}.filter{(a,b) -> a != p.first || b != p.second}
}

fun step(g: List<List<Int>>): List<List<Int>> {
	val res = g.map{r -> r.map{v -> v+1}.toMutableList()}.toMutableList()
	val done_flashes = mutableListOf<Pair<Int,Int>>()
	do {
		val flashes = res.withIndex().flatMap{y -> y.value.withIndex().map{x -> Pair(x.index, y.index)}}.filter{(x,y) -> res[y][x] > 9}.minus(done_flashes)
		flashes.flatMap{p -> neighbors(p)}.filter{(x,y) -> x >= 0 && y >= 0 && x < res[0].size && y < res.size}.forEach{(x,y) -> res[y][x]++}
		done_flashes.addAll(flashes)
	} while (!flashes.isEmpty())
	flashes += done_flashes.size
	step++
	if (done_flashes.size == g.size * g[0].size) {
		synced = step
	}
	return res.map{r -> r.map{v -> if (v > 9) 0 else v}}
}

fun main() {
	var g = File("input.txt").readText().lines().map{i -> i.toCharArray().map(Character::getNumericValue)}.filter{ l -> !l.isEmpty()}
	// part 1
	repeat(100) {
		g = step(g)
	}
	println(flashes)
	// part 2
	while (synced == 0) {
		g = step(g)
	}
	println(synced)
}
