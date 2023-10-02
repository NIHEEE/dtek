  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la 	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li $a0, 1000
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw 	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

 	#Hexasc	
hexasc:
	andi $a0, $a0, 15
	slti $t1, $a0, 10
    	beq $t1, 1, range_1

   	range_2:
             addi $v0, $a0, 55 

    	jr $ra
    	nop
range_1:
        addi $v0, $a0, 48
	jr $ra
	nop
	#Exercise C

delay:	
	li $t6, 130000
	li $t5, 0				# Sets the limit for $a0
	bgt  $a0, $0, while_loop		# "while $a0 > 0 the while-loop runs"
	nop
while_loop:	
		beq  $a0, 0, klar 
		addi $a0, $a0, -1		# Decrements $a0 by 1
		bne  $t5, $t6, for_loop		# "if $t5 =/= $t6, run the for-loop and increment $t5 by 1
		nop
		
for_loop:					# the for-loop
		addi $t5, $t5, 1
		bne $t5, $t6, for_loop 		# run delay again as long as $t5 =/= $t6
		nop
klar:
	jr $ra					# if $t5 == $t6, jump back to main routine
	nop
	# Questions: Assignment 4
	# 1. All instructions are executed and delay will run once and then $a0 is decremented by 1 ($a0 = -1), then 
	#    $t7 > $a0 and the 'klar:' subroutine is called immediately when the 'delay:' subroutine is called.
	# 2. Same as the example above except delay will not get pass line 95 instead if will jump directly
	# to 'klar:' and the subroutine delay is not run anymore.

	#Exercise D
	# Converts BCD, binary coded decimal, to a string
	# done by extracting the LSD in $a1 to $a0 iteratively and shifting the value of $a0 1 step to the right
	# this is done 4 times, once for the ones place (D), tens place (C), hours place (B) and thousands place (A) 
	# the time is represented like this: AB:CD 
time2string:
	PUSH ($ra)
    	PUSH ($s0)
    	PUSH ($s1)
    	move $s0, $a0           # save the address in a0 in s0, preserves the original adress in $a0
    	move $s1, $a1
    
    	andi $a0, $a1, 15       # andi-operation a1 with 1111 and save the value to a0 where 15 is bitmask
    	jal hexasc              # call hexasc
    	nop
    	sb  $v0, 4($s0)         # save the second (ones place)
    	move $t5, $a0
    	srl $a1, $a1, 4         # Shift the value in a0

    	andi $a0, $a1, 15       # andi-operation a1 with 1111 and save the vale to a0 (bitmask)
    	jal hexasc              # call hexasc
    	nop
    	sb $v0, 3($s0)          # save the second (ones place)
    	move $t4, $a0
    	srl $a1, $a1, 4         # Shift the value in a0
	
    	li $t1,0x3A		# adding semicolon 
    	sb $t1, 2($s0)

    	andi $a0, $a1, 15       # andi-operation a1 with 1111 and save the vaue to a0 (bitmask)
	jal hexasc              # call hexasc
	nop
	sb $v0, 1($s0)          # save the second (ones place)
	srl $a1, $a1, 4         # Shift the value in a0
				
	andi $a0, $a1, 15       # and a1 with 1111 and save the vaue to a0
	jal hexasc              # call hexasc
	nop
	sb $v0, 0($s0)	        # save the second (ones place)
							# except for line 133-134, line 117-149 is the same code 4 times over
							# for the 4 integers showing the time, line 133-134 adds the semicolon between
	li $t6, 0x2
	beq $t5, $t6, TWO
		
end_1:	
   	li $t2, 0x00
	sb $t2, 5($s0)
   	POP $s1
	POP $s0
	POP $ra
	jr $ra
	nop
end_2:
	li $t2, 0x00
	sb $t2, 7($s0)
   	POP $s1
	POP $s0
	POP $ra
	jr $ra
	nop
	
TWO:
	li $t3, 84
	li $t4, 87
	li $t5, 79
	sb $t3, 4($s0)
	sb $t4, 5($s0)
	sb $t5, 6($s0)
	j end_2
	nop
	
	
