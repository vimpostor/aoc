# Note: This code does not work because Brainfuck is limited to 8bit numbers
# Do not read this code: This code is a disgrace to all of humanity
# I was wrong yesterday when I said that Assembly was the most cursed thing I have ever written: I will take Assembly over Brainfuck any day

# Cursed thing I have to watch out for: Do not use comma or dot in comments because these characters will be interpreted as operations

# Memory overview (register usage)
# 0: the last char read; if the current stage is number reading stage this holds the direct value of that number instead of the ASCII value
# 1: the current operation: 1 is down; minus 1 is up; 0 is forward
# 2: help register that is set to 1 if a condition is true which will probably be tested in the next loop to simulate like an if condition
# 3: x position (increased by forward)
# 4: y position (changed by up and down)
# 5: temporary register for copying numbers
# 6: temporary register for a number to be copied to

# loop until EOF is reached; we init register 0 with 1 so that the loop does not return immediately
+
[
	# reset the current cell to zero; we need to do this to detect EOF because reading EOF is a noop operation
	[-]

	# STAGE 1 find out the operation that we need to do
	>[-]< # reset the current operation register
	, # read a char: f means forward (0); d means down (1); u means up (minus 1)
	# STAGE 1:1 test for f (forward)
	# we need to do nothing in this case because f is zero
	# since the operation register is reset already we can just let it be reset
	# STAGE 1:2 test for d (down)
	# d is ASCII 100
	# yes your eyes are seeing correctly; I really inserted 100 minusses here instead of looping
	----------------------------------------------------------------------------------------------------
	>>>>>[-]>[-]<<<<< # reset copy registers
	[->>>>>+>+<<<<<<] # copy registers now both have the number
	>>>>>[-<<<<<+>>>>>] # copy back to original register
	> # go to copy of char (in register 6)
	<<<<[-]+>>>> # init condition register with 1
	[<<<<[-]>>>>[-]] # reset condition register if char is nonzero
	<<<< # go to the condition register
	[
		# we have a d
		<+ # set operation register to 1
		>- # reset the condition register
	]
	<< # go back to char register
	# STAGE 1:3 test for u (up)
	# u is ASCII 117 so we have to subtract another 17
	-----------------
	>>>>>[-]>[-]<<<<< # reset copy registers
	[->>>>>+>+<<<<<<] # copy registers now both have the number
	>>>>>[-<<<<<+>>>>>] # copy back to original register
	> # go to copy of char (in register 6)
	<<<<[-]+>>>> # init condition register with 1
	[<<<<[-]>>>>[-]] # reset condition register if char is nonzero
	<<<< # go to the condition register
	[
		# we have an u
		<- # set operation register to minus 1
		>- # reset the condition register
	]
	<< # go back to char register

	# STAGE 2 continue reading until we find the number (which conveniently is always after a space)
	, # read one char to reinit the char register; this is safe because all operands have at least a length of 2
	[
		, # read a char
		# space is ASCII 32 so we subtract 32
		--------------------------------
	]
	# we have read a space now so the next characters will be numbers

	# STAGE 3 read numbers
	# from a quick look at input.txt it looks like all numbers are less than 10
	# this is great because we now do not have to implement number parsing but can instead just read one number (sigh)
	,------------------------------------------------ # read one char and decrease it by 48 since zero is 48 in ASCII

	# STAGE 4 apply operation
	# finally we can apply the operation by moving into x direction (register 3) for forward and y direction (register 4) for up/down
	> # move to the operation register
	# STAGE 4.1 move forward (if operation is forward)
	>>>>[-]>[-]<<<< # reset copy registers
	[->>>>+>+<<<<<] # copy registers now both have the number
	>>>>[-<<<<+>>>>] # copy back to original register
	> # go to copy of char (in register 6)
	<<<<[-]+>>>> # init condition register with 1
	[<<<<[-]>>>>[-]] # reset condition register if char is nonzero
	<<<< # go to the condition register
	[
		# moving forward now
		<< # go to number register
		[->>>+<<<] # increase x position by number
		>>- # reset condition register
	]
	# go back to char register
	<<
]
>>>++++++++++++++++++++++++++++++++++++++++++++++++.
