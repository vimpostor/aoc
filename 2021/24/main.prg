PROCEDURE Main()
	LOCAL f
	LOCAL buf := " "
	LOCAL z := 1
	LOCAL line := ""
	LOCAL index := 0
	LOCAL value, i, mod
	LOCAL xvalues := {}
	LOCAL yvalues := {}
	LOCAL xstack := {}
	LOCAL ystack := {}
	LOCAL indexstack := {}
	LOCAL x, y, oldx, oldy, oldindex
	LOCAL mem := Array(14)

	// parse
	f := FOpen("input.txt")
	DO WHILE z != 0
		z := FRead(f, @buf, 1)
		IF buf != Chr(10)
			// line not finished yet
			line := line + buf
		ELSE
			// finished reading line
			value := Val(SubStr(line, 7))
			mod := index % 18
			IF mod == 5
				AAdd(xvalues, value)
			ELSEIF mod == 15
				AAdd(yvalues, value)
			ENDIF
			line := ""
			index++
		ENDIF
	ENDDO

	// stack machine
	FOR value := 0 to 1
		AFill(mem, 0)
		FOR z := 1 to Len(xvalues)
			x := xvalues[z]
			y := yvalues[z]
			IF x >= 10
				AAdd(xstack, x)
				AAdd(ystack, y)
				AAdd(indexstack, z)
			ELSE
				oldx := xstack[Len(xstack)]
				oldy := ystack[Len(ystack)]
				oldindex := indexstack[Len(indexstack)]
				ASize(xstack, Len(xstack) - 1)
				ASize(ystack, Len(ystack) - 1)
				ASize(indexstack, Len(indexstack) - 1)

				IF oldy + x >= 0
					IF value == 0
						mem[z] := 9
						mem[oldindex] := mem[z] - oldy - x
					ELSE
						mem[oldindex] := 1
						mem[z] := mem[oldindex] + oldy + x
					ENDIF
				ELSE
					IF value == 0
						mem[oldindex] := 9
						mem[z] := mem[oldindex] + oldy + x
					ELSE
						mem[z] := 1
						mem[oldindex] := mem[z] - oldy - x
					ENDIF
				ENDIF
			ENDIF
		NEXT

		// concatenate
		line := ""
		FOR z := 1 to Len(mem)
			line += Str(mem[z], 1)
		NEXT
		? line
	NEXT
	?
RETURN
