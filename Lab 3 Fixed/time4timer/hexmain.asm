  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0, 17		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	
	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  
hexasc:	
	andi $a0, $a0, 15
	slti  $t1, $a0, 10			#set less than imm, if $a0 < 10, $t1 is 1
	beq $t1, 1, range_1
		
	addi $v0, $a0, 55 
	jr $ra
	nop
range_1:

	addi $v0, $a0, 48
	jr $ra
	nop
	# Question assignment 2:
	# When the argument to 17 it prints H because it is 2 steps after 15, 2 steps after F is H.
	# The return value in register $v0 is 72 which is H in ASCII 
	# If the value in $a0 is less than 10, then it will branch to the label "range_1", essentially representing
	# a if-statement saying if(a0 < 10) { range_1: ... }

	
	
	

