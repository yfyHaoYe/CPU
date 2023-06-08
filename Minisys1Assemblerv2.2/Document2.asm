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

		#2s 
		lui $s1, 0x0200
		ori $s1,$s1, 0x0000
		#0.5s
		lui $s2, 0x0080
		ori $s2,$s2, 0x0000
		#5s
		lui $s3, 0x0b00
		ori $s3,$s3, 0x0000

		lw $a1,0($a0)
		andi $a1,$a1,7
		or $a3, $a1, $zero
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
		beq $at,$zero,input_case1
		or $v0,$v0,$s7	
	input_case1:

		ori $at,$v1,0x0080
		beq $at,$zero,input_case2
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
		
		or $s0,$s2, $zero

		slt $t0,$a0,$zero
		bne $t0,$zero,flash
		
		or $t0,$a0,$zero
		ori $t1,$zero,0
		ori $t2,$zero,0

	loop0:
		addi $t1,$t1,1
		add $t2,$t1,$t2
		bne $t1,$t0,loop0
		
		or $a3,$t2,$zero
		j output_and_exit

	flash:
		ori $a3,$zero,1
		jal output_and_back
		ori $a3,$zero,0
		jal output_and_back
		j flash
		

test1:
		jal input_unsigned

		or $s0,$s1, $zero
		or $t0,$v0,$zero
		or $t1,$zero,$zero
		or $t2,$zero,$zero
		or $t3,$zero,$zero
		jal func1
		
		or $a3,$t2,$zero
		j output_and_exit

	func1: 
		# $t0: input data
		# $t1: i from 1 to $v0
		# $t2: in and out times
		# $t3: sum of i
		addi $t2,$t2,1
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		addi $t1,$t1,1
		add $t3,$t3,$t1
		beq $t1, $t0 , return1
		jal func1

	return1:
		addi $t2,$t2,1
		lw $ra, 0($sp)
		lw $ra, 0($sp)
		addi $sp,$sp,4
		jr $ra
		
test2:
		jal input_unsigned
		
		or $s0,$s1, $zero
		or $t0,$v0,$zero
		or $t1,$zero,$zero
		or $t2,$zero,$zero
		or $t3,$zero,$zero
		jal func2
		or $a3,$t2,$zero
		j exit

	func2: 
		# $t0: input data
		# $t1: i from 1 to $v0
		# $t2: in and out times
		# $t3: sum of i
		addi $t2,$t2,1

		addi $sp, $sp, -8
		sw $t1, 4($sp)
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


		addi $t1,$t1,1
		beq $t1, $t0 ,return2
		jal func2

	return2:
		add $t3,$t1,$t3
		addi $t2,$t2,1
		lw $ra, 0($sp)
		lw $ra, 0($sp)
		lw $t1, 4($sp)
		lw $t1, 4($sp)
		addi $sp,$sp,8

		jr $ra

test3:
		jal input_unsigned
		
		or $s0,$s1, $zero
		or $t0,$v0,$zero
		or $t1,$zero,$zero
		or $t2,$zero,$zero
		or $t3,$zero,$zero
		jal func3
		or $a3,$t2,$zero
		j exit

	
		# $t0: input data
		# $t1: i from 1 to $v0
		# $t2: in and out tim
		# $t3: sum of i
		# addi $t2,$t2,1

		addi $sp, $sp, -8
		sw $t1, 4($sp)
		sw $ra, 0($sp)

		addi $t1,$t1,1
		beq $t1, $t0 ,return3
		jal func3

	return3:
		add $t3,$t1,$t3
		addi $t2,$t2,1
		lw $ra, 0($sp)
		lw $ra, 0($sp)
		lw $t1, 4($sp)
		lw $t1, 4($sp)
		addi $sp,$sp,8

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


