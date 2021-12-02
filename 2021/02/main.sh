#!/usr/bin/env bash

x=0
y=0
aim=0
h=0
d=0

while IFS= read -r line; do
	op="${line::1}"
	num="${line: -1}"
	case "$op" in
		f)
			x=$((x + num))
			h=$((h + num))
			d=$((d + aim * num))
			;;
		u)
			y=$((y - num))
			aim=$((aim - num))
			;;
		d)
			y=$((y + num))
			aim=$((aim + num))
			;;
	esac
done < "$*"

echo $((x * y))
echo $((h * d))
