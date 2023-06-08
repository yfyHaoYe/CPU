.data  0x0000              		        
.text 0x0000	
		# a0: 0xffffff60 input address
		# a1: input data
		# a2: 0xffffff70 output address
		# a3: output data

start:
		lui $sp,0x7fff
		ori $sp, $sp, 0x0000
		lui $a0, 0xffff
		ori $a0,$zero, 0xff60
		addi $a2,$a0,16

		#0.5s 
		lui $s1, 0x00a8
		ori $s1,$s1, 0x0000
		#2s
		lui $s2, 0x0150
		ori $s2,$s2, 0x0000
		#5s
		lui $s3, 0x0690
		ori $s3,$s3, 0x0000

		#input testcase
		lw $a1,0($a0)
		andi $a1,$a1,7
		or $a3, $a1, $zero
		
		ori $s0,$s0,0x0010
		jal output_and_back
		
		ori $at,$zero,0
		beq $a1,$at,test0
		ori $at,$zero,1
		beq $a1,$at,test1
		ori $at,$zero,2
		beq $a1,$at,test2
		ori $at,$zero,3
		beq $a1,$at,test3
		ori $at,$zero,4
		beq $a1,$at,test4
		ori $at,$zero,5
		beq $a1,$at,test5
		ori $at,$zero,6
		beq $a1,$at,test6
		ori $at,$zero,7
		beq $a1,$at,test7
		j exit

input_signed:	
		lw $a1,2($a0)
		srl $v0,$a1,8
		andi $v1,$a1,0x00ff
		
		lui $s7,0xffff
		ori $s7,$s7,0xff00
		
		ori $at,$v0,0x0080
		beq $at,$zero,input_case1 #v0 is positive
		or $v0,$v0,$s7	
	input_case1:

		ori $at,$v1,0x0080
		beq $at,$zero,input_case2 #v1 is positive
		or $v1,$v1,$s7	
	input_case2:
		
		jr $ra

input_unsigned:
		lw $a1,2($a0)
		srl $v0,$a1,8
		andi $v1,$a1,0x00ff
		jr $ra

test0:
		jal input_signed
		or $s0,$s1, $zero #flash time 0.5s

		slt $t0,$a0,$zero
		bne $t0,$zero,flash
		
		or $t0,$a0,$zero
		or $t1,$zero,$zero
		or $t2,$zero,$zero
		
		#t0 input data, t1 i from 1 to t0, t2 sum of i

	loop0:
		addi $t1,$t1,1
		add $t2,$t1,$t2
		bne $t1,$t0,loop0
		
		or $a3,$t2,$zero
		j output_and_exit

	flash:
		ori $a3, $zero, 1
		jal output_and_back
		ori $a3,$zero,0
		jal output_and_back
		j flash
		

test1:
		jal input_unsigned

		or $s0,$s2, $zero #output 2s

		or $t0, $v0, $zero
		or $t1, $zero, $zero
		or $t2, $zero, $zero
		ori $t3, $zero, 1
		jal func1

		or $a3,$t2,$zero
		j output_and_exit

	func1: 
		# $t0: input data from n to 1
		# $t1: in and out times
		# $t2: sum of i
		# $t3: constant 1

		addi $t1, $t1, 1
		addi $sp, $sp, -8
		sw $t0, 4($sp)
		sw $ra, 0($sp)
		

		addi $t0, $t0, -1
		beq $t0, $t3, return1
		jal func1

	return1:
		add $t2, $t2, $t0
		lw $ra, 0($sp)
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t0, 4($sp)
		addi $sp, $sp, 8
		addi $t1, $t1, 1
		jr $ra
		
test2:
		jal input_unsigned

		or $s0,$s2, $zero #output 2s

		or $t0, $v0, $zero
		or $t1, $zero, $zero
		or $t2, $zero, $zero
		ori $t3, $zero, 1
		jal func2

		or $a3, $t1, $zero
		j output_and_exit

	func2: 
		# $t0: input data from n to 1
		# $t1: in and out times
		# $t2: sum of i
		# $t3: constant 1

		addi $t1, $t1, 1
		addi $sp, $sp, -8
		sw $t0, 4($sp)
		sw $ra, 0($sp)

		or $a3, $zero, $t0
		jal output_and_back
		or $a3, $zero, $t1
		jal output_and_back
		or $a3, $zero, $t2
		jal output_and_back
		or $a3, $zero, $t3
		jal output_and_back
		or $a3, $zero, $sp
		jal output_and_back

		addi $t0, $t0, -1
		beq $t0, $t3, return2
		jal func2

	return2:
		add $t2, $t2, $t0
		lw $ra, 0($sp)
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t0, 4($sp)
		addi $sp, $sp, 8
		addi $t1, $t1, 1
		jr $ra
		
test3:
		jal input_unsigned

		or $s0,$s2, $zero #output 2s

		or $t0, $v0, $zero
		or $t1, $zero, $zero
		or $t2, $zero, $zero
		ori $t3, $zero, 1
		jal func3

		or $a3, $t1, $zero
		j output_and_exit

	func3: 
		# $t0: input data from n to 1
		# $t1: in and out ti
		# $t2: sum of i
		# $t3: constant 1

		addi $t1, $t1, 1
		addi $sp, $sp, -8
		sw $t0, 4($sp)
		sw $ra, 0($sp)

		addi $t0, $t0, -1
		beq $t0, $t3, return3
		jal func3

	return3:
		add $t2, $t2, $t0
		
		lw $ra, 0($sp)
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t0, 4($sp)

		or $a3, $zero, $t0
		jal output_and_back
		or $a3, $zero, $t1
		jal output_and_back
		or $a3, $zero, $t2
		jal output_and_back
		or $a3, $zero, $t3
		jal output_and_back
		or $a3, $zero, $sp
		jal output_and_back

		addi $sp, $sp, 8
		addi $t1, $t1, 1
		jr $ra

test4:
		jal input_signed
		or $t0,$v0,$zero
		or $t1,$v1,$zero

		slt $t2,$t0,$zero
		slt $t3,$t1,$zero
		add $t0,$t0,$t1
		slt $t1,$t0,$zero
		# t0: in1+in2
		# t1: in1+in2 signal
		# t2: in1 signal
		# t3: in2 signal

		and $t4,$t2,$t3
		xori $t5,$t1,1
		and $t4,$t5,$t4
		
		xori $t6,$t2,1
		nop
		xori $at,$t3,1
		and $t6,$t6,$at
		and $t6,$t6,$t1

		or $t4,$t4,$t6
		or $t1,$zero,$zero
		beq $t4,$zero,no_overflow4
		ori $t1, $zero, 0x0100
	no_overflow4:
		or $a3,$t0,$zero
		or $a3,$a3,$t1
		j output_and_exit
		
test5:
		jal input_signed
		or $t0,$v0,$zero
		or $t1,$v1,$zero

		slt $t2,$t0,$zero
		slt $t3,$t1,$zero
		sub $t0,$t0,$t1
		slt $t1,$t0,$zero
		# t0: in1-in2
		# t1: in1-in2 signal
		# t2: in1 signal
		# t3: in2 signal
		
		xori $t4,$t3,1
		and $t4,$t2,$t4
		xori $t5,$t1,1
		and $t4,$t5,$t4
		
		xori $t6,$t2,1
		and $t6,$t6,$t3
		and $t6,$t6,$t1

		or $t4,$t4,$t6
		or $t1,$zero,$zero
		beq $t4,$zero,no_overflow5
		ori $t1, $zero, 0x0100
	
	no_overflow5:
		or $a3,$t0,$zero
		or $a3,$a3,$t1
		j output_and_exit



test6:
		jal input_signed
		or $t0,$v0,$zero
		or $t1,$v1,$zero
		ori $t5,$t5,8
		# t0:lier, t1:cand t2:product t3:cnt
	loop6:
		ori $t4,$t0,1
		beq $t4,$zero,out6
		add $t2,$t2,$t1
		
	out6:
		sll $t1,$t1,1
		srl $t0,$t0,1
		addi $t3,$t3,1
		bne $t3,$t5, loop6
		or $a3,$t2,$zero
		j output_and_exit
		
		
test7:
		jal input_signed
		or $t0,$v0,$zero
		or $t1,$v1,$zero
		ori $t5,$t5,8
		# t0:dend, t1:sor t2:quotient t3:remainder t4 cnt
	loop7:
		sub $t3,$t3,$t1
		slt $t6,$t3,$zero
		beq $t6,$zero,case1
		j case2
	case1:
		sll $t2,$t2,1
		ori $t2,$t2,1
		j out7
	case2:
		add $t3,$t1,$t3
		sll $t2,$t2,1
		j out7
	out7:
		srl $t1,$t1,1
		addi $t4,$t4,1
		bne $t4,$t5,loop7
		or $s0,$s3,$zero
	endloop7:
		or $a3,$t2,$zero
		jal output_and_back
		or $a3,$t3,$zero
		jal output_and_back
		j endloop7

output_and_back:
		addi $sp,$sp,-4
		sw $at,0($sp)
		
		sw $a3, 10($a2)
		ori $at, $zero, 1
		

	out_loop:
		addi $at, $at, 1
		bne $at, $s0, out_loop

		lw $at,0($sp)
		lw $at,0($sp)
		addi $sp,$sp,4
		jr $ra

output_and_exit:
		sw $a3, 10($a2)

exit:
		nop