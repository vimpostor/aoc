# Beware, the following code is an utter dumpster fire and should only be consumed under medical supervision.
# It is probably the most cursed thing I have ever written. You have been warned, proceed with caution!!!
	.text
	.section	.rodata
.OPEN_READ:
	.string	"r"
.INPUT_FILE:
	.string	"input.txt"
.PRINT_INT:
	.string	"%d\n"
	.text
	.globl	main
	.type	main, @function

# register usage:
# sp: stack pointer
# s0: temp variable
# s1: temp variable
# s2: stores the last read number
# s3: the amount of times that one read value was larger than the previous, this stores the solution to part1 at the end
# s4: the amount of times that one sliding window was larger than the previous, this stores the solution to part2 at the end
# s5: Let [abc] be the sliding window, than this variable holds a
# s6: Let [abc] be the sliding window, than this variable holds b. Note that s2 automatically stores c.
# t1: the maximum length that we assume a line to be (7)
# t2: the sum of the last sliding window
# t3: the sum of the current sliding window
main:
	# Store some hardcoded stack addresses
	addi	sp,sp,-80
	sd	ra,72(sp)
	sd	s0,64(sp)
	sd	s1,56(sp)
	# Initialize variables
	addi	s0,sp,80
	li	s2,0
	# we need to subtract 1 from our "larger" counter, because the first iteration will increment the counter (since there is no predecessor to compare to) even though it shouldn't
	li	s3,-1
	# we need to subtract 3 from our "larger" sliding window counter for the same reason as above, except that the sliding window will be incremented by 3 in the first iterations, even though it shouldn't
	li	s4,-3
	li	s5,0
	li	s6,0
	mv	t1,sp
	mv	s1,t1
	# t1 holds the size of the line buffer (7, we just assume that lines cannot be longer lol)
	li	t1,7
	sw	t1,-36(s0)
	mv	t3,t1
	addi	t3,t3,-1
	# initialize the dimension of the string
	sd	t3,-48(s0)
	mv	t3,t1
	mv	a6,t3
	li	a7,0
	srli	t3,a6,61
	slli	a3,a7,3
	or	a3,t3,a3
	slli	a2,a6,3
	mv	a3,t1
	mv	a0,a3
	li	a1,0
	# create the string on the stack
	srli	a3,a0,61
	slli	a5,a1,3
	or	a5,a3,a5
	slli	a4,a0,3
	mv	a5,t1
	addi	a5,a5,15
	srli	a5,a5,4
	slli	a5,a5,4
	sub	sp,sp,a5
	mv	a5,sp
	sd	a5,-56(s0)
	# set fopen parameters
	lui	a5,%hi(.OPEN_READ)
	addi	a1,a5,%lo(.OPEN_READ)
	# open our text file
	lui	a5,%hi(.INPUT_FILE)
	addi	a0,a5,%lo(.INPUT_FILE)
	call	fopen
	sd	a0,-64(s0)
	# loop over all lines
	j	.LINES_LOOP
.LINE_HANDLER:
	ld	a0,-56(s0)
	call	atoi
	# when the current number (a0) is larger than the last one (s2), increment the counter (s3)
	ble	a0,s2,.SKIP_INCREMENT
	addi	s3,s3,1
.SKIP_INCREMENT:
	# When the current sliding window is larger than the last one, increment the counter (s4)
	# first we add up the last sliding window and store it in t2, i.e. add up s5 + s6 + s2
	add	t2,s5,s6
	add	t2,t2,s2
	# next we add up the current sliding window and store it in t3, i.e. add up s6 + s2 + a0
	add	t3,s6,s2
	add	t3,t3,a0
	# when the current sliding window (t3) is less or equal than the last one (t2), then we should skip the incrementing
	ble	t3,t2,.SKIP_INC_SLIDE
	addi	s4,s4,1
.SKIP_INC_SLIDE:
	# move the sliding window, remember that s2 is also part of the sliding window, so we only need to move 2 variables
	mv	s5,s6
	mv	s6,s2
	# store the current number as last number
	mv	s2,a0
.LINES_LOOP:
	lw	a5,-36(s0)
	ld	a2,-64(s0)
	mv	a1,a5
	ld	a0,-56(s0)
	call	fgets
	mv	a5,a0
	# when there is still a line, jump into the line handler
	bne	a5,zero,.LINE_HANDLER
	ld	a0,-64(s0)
	call	fclose
	# print solution to part 1
	lui	a5,%hi(.PRINT_INT)
	addi	a0,a5,%lo(.PRINT_INT)
	mv	a1,s3
	call	printf
	# print solution to part 2
	lui	a5,%hi(.PRINT_INT)
	addi	a0,a5,%lo(.PRINT_INT)
	mv	a1,s4
	call	printf
	# exit
	mv	sp,s1
	li	a5,0
	mv	a0,a5
	# restore stack for main function
	addi	sp,s0,-80
	ld	ra,72(sp)
	ld	s0,64(sp)
	ld	s1,56(sp)
	addi	sp,sp,80
	# jump back where we came from
	jr	ra
	.size	main, .-main
