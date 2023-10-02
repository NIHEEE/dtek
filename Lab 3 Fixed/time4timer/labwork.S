  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
  # Please keep the two macros PUSH and POP unchanged
  #
.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
.data
.text
.globl hexasc
.globl time2string
.globl delay 
	
  #
  # Please add your own code below this line
  #
  
  # Hexasc
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
# delay
delay:	
	li $t6, 9000000
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
	
	
# time2string
time2string:
	PUSH $ra
    	PUSH $s0
    	PUSH $s1
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
	


