  # analyze.asm
  # This file written 2015 by F Lundevall
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30
loop:
	move	$a0,$s0		# copy from s0 to a0
	
	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window

	addi	$s0,$s0,3	# what happens if the constant is changed?
		
	li	$t0,0x5d	#0x5d = 93 (in decimal)
	bne	$s0,$t0,loop
	nop			# delay slot filler (just in case)
# Question assignment 1: Line 14 and line 16 had to be changed, explanation below	
# set imm on line 14 to 3 and change imm on line 16 to 0x5d (93) to print out every 3rd character
# change on line 14 adds 3 to $s0 every time instead of 1, change on line 16 makes it so $t0 gets the result 93
# which is where $s0 will end on (when Z is printed) and so the program stops as intended and doesnt loop forever

stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)
	

