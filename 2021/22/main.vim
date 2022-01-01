vim9script

set t_ti=
set t_te=
set nomore

def Parse(l: string): dict<number>
	var res = {on: match(l[1], 'n') + 1}
	for d in "xyz"->split('\zs')
		const m = matchstr(l, d .. '=.\d*\.\..\d*')->split('\.\.')
		res[d .. 'min'] = str2nr(strcharpart(m[0], 2))
		res[d .. 'max'] = str2nr(m[1])
	endfor
	return res
enddef

def Reboot(lines: list<dict<number>>, limit: bool): number
	var voxels_x = []
	var voxels_y = []
	var voxels_z = []
	for l in lines
		voxels_x->extend([l['xmin'], l['xmax'] + 1])
		voxels_y->extend([l['ymin'], l['ymax'] + 1])
		voxels_z->extend([l['zmin'], l['zmax'] + 1])
	endfor
	sort(voxels_x, 'n')
	sort(voxels_y, 'n')
	sort(voxels_z, 'n')
	var voxels = map(range(len(voxels_x) * len(voxels_y) * len(voxels_z)), 0)
	const lx = len(voxels_x)
	const ly = len(voxels_y)
	const lz = len(voxels_z)
	var xv = 0
	var yv = 0
	var zv = 0

	for l in lines
		if limit && abs(l['xmin']) > 50
			continue
		endif
		for x in range(lx)
			xv = voxels_x[x]
			if xv >= l['xmin'] && xv < (l['xmax'] + 1)
				for y in range(ly)
					yv = voxels_y[y]
					if yv >= l['ymin'] && yv < (l['ymax'] + 1)
						for z in range(lz)
							zv = voxels_z[z]
							if zv >= l['zmin'] && zv < (l['zmax'] + 1)
								voxels[x + lx * y + lx * ly * z] = l['on']
							endif
						endfor
					endif
				endfor
			endif
		endfor
	endfor

	var res = 0
	for x in range(lx)
		for y in range(ly)
			for z in range(lz)
				if voxels[x + lx * y + lx * ly * z] == 1
					res += (voxels_x[x + 1] - voxels_x[x]) * (voxels_y[y + 1] - voxels_y[y]) * (voxels_z[z + 1] - voxels_z[z])
				endif
			endfor
		endfor
	endfor
	return res
enddef

const lines = readfile("input.txt")->mapnew((_, v) => Parse(v))
# part 1
echoc Reboot(lines, true)
# part 2
echoc Reboot(lines, false)

qa!
