vim9script

def Parse(l: string): dict<number>
	var res = {on: match('xn', l[1])}
	for d in "xyz"->split('\zs')
		const m = matchstr(l, d .. '=.\d*\.\..\d*')->split('\.\.')
		res[d .. 'min'] = str2nr(strcharpart(m[0], 2))
		res[d .. 'max'] = str2nr(m[1])
	endfor
	return res
enddef

def Intersect(a: dict<number>, b: dict<number>): dict<number>
	var res = {on: -b['on']}
	for d in "xyz"->split('\zs')
		res[d .. 'min'] = max([a[d .. 'min'], b[d .. 'min']])
		res[d .. 'max'] = min([a[d .. 'max'], b[d .. 'max']])
	endfor
	return res
enddef

def Reboot(lines: list<dict<number>>, limit: bool): number
	var cuboids = []
	for l in lines
		if limit && abs(l['xmin']) > 50
			continue
		endif

		var pending = []
		if l['on'] == 1
			pending->add(l)
		endif
		for c in cuboids
			const i = Intersect(l, c)
			if i['xmin'] <= i['xmax'] && i['ymin'] <= i['ymax'] && i['zmin'] <= i['zmax']
				pending->add(i)
			endif
		endfor
		cuboids->extend(pending)
	endfor

	var res = 0
	for c in cuboids
		res += c['on'] * (c['xmax'] - c['xmin'] + 1) * (c['ymax'] - c['ymin'] + 1) * (c['zmax'] - c['zmin'] + 1)
	endfor
	return res
enddef

const content = readfile("input.txt")->mapnew((_, v) => Parse(v))
# part 1
echom Reboot(content, true)
# part 2
echom Reboot(content, false)

qa!
