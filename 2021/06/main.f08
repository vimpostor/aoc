program aoc
	implicit none

	integer :: i, j, c, stat, part, input_unit = 1
	integer(8) :: spawn = 0
	character(len=1) :: space
	integer(8), dimension(9) :: fish(0:8) = 0.0

	open(input_unit, file='input.txt', action='read')
	DO
		read(input_unit, '(I1,A1)', iostat=stat, advance='no') c,space
		fish(c) = fish(c) + 1
		if (stat /= 0) exit
	END DO

	DO part=80,256-80,256-160
		DO i=1,part
			spawn = fish(0)
			DO j=1,8
				fish(j-1) = fish(j)
			END DO
			fish(6) = fish(6) + spawn
			fish(8) = spawn
		END DO

		WRITE(*,'(I0)') sum(fish)
	END DO
end program aoc
