#? replace(sub = "\t", by = " ")
# OK Nim, if you are going to be so ridiculous about forbidding tabs, then I am going to abuse your preprocessor to still allow for Tabs anyway. Checkmate, compiler!

import sequtils
import strutils
import sugar
import tables

# parse
let content = "input.txt".readFile.strip.split('\n')
var templ = content[0]
let it = toSeq 0..templ.len - 2
let rs = content[2..^1].map(x => x.split(' ')).map(x => (x[0], x[2]))
let rules = newTable(rs)
var freq = rs.map(x => (x[0], 0)).toTable
# create pairs from the input string
for i in zip(it, it.map(x => x + 1)).map(t => templ[t[0]..t[1]]):
	freq[i] += 1

for n in countup(10, 30, 20):
	for i in 0..n-1:
		var new_freq = freq
		for k,v in rules:
			new_freq[k[0]&v] += freq[k]
			new_freq[v&k[1]] += freq[k]
			new_freq[k] -= freq[k]
		freq = new_freq

	var elements = foldl(rs.map(x => x[0]), a & b).deduplicate().map(x => (x, 0)).toOrderedTable
	# We count the second letter of every pair to avoid duplication. But then we miss the first letter of the first pair. Luckily that letter is still the first letter of the input string, so we can add it now.
	elements[templ[0]] = 1
	for a,b in freq:
		elements[a[1]] += b
	elements.sort((x,y) => cmp(x[1], y[1]))
	let sorted = toSeq elements.values
	echo sorted[^1] - sorted[0]
