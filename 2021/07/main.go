package main

import (
	"io/ioutil"
	"fmt"
	"sort"
	"strconv"
	"strings"
)

// wtf Go, why don't you have this by default
// you have abs for float, so maybe generics would have been useful, wouldn't they 🙊
func abs(x int) int {
	if (x < 0) {
		return -x
	} else {
		return x
	}
}

func main() {
	f, _ := ioutil.ReadFile("input.txt")
	input := strings.Split(string(f), ",")
	var crabs = []int{}
	for _, c := range input {
		n, _ := strconv.Atoi(strings.TrimSpace(c))
		crabs = append(crabs, n)
	}
	sort.Ints(crabs[:])

	// part 1
	// opt is the median
	opt := crabs[len(crabs)/2]
	var fuel int = 0
	for _, c := range crabs {
		fuel += abs(c - opt)
	}
	fmt.Println(fuel)

	// part 2
	fuel = int(^uint(0) >> 1) // max int
	for opt = crabs[0]; opt < crabs[len(crabs) - 1]; opt++ {
		var f int = 0
		for _, c := range crabs {
			var n int = abs(c - opt)
			n = (n * (n + 1)) / 2
			f += n
		}
		if (f < fuel) {
			fuel = f
		}
	}
	fmt.Println(fuel)
}
