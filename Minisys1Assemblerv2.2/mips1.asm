.data  0x0000              		        
.text 0x0000	
		# a0: 0xffffff60 input address
		# a1: input data
		# a2: 0xffffff70 output address
		# a3: output data
start:
		ori $sp, $sp, 0x1000
		lui $a0, 0xffff
		ori $a0,$zero, 0xff60
		addi $a2,$a0,16

		lw $a1,0($a0)
		andi $a1,$a1,7
		or $a3, $a1, $zero
		jal output_2sec_and_back
		
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

input:	
		lw $a1,2($a0)
		srl $a1,$a1,8
		jr $ra

test0:
		jal input
		or $t0, $a1, $zero
		ori $t1, $zero, 1
		ori $t2, $zero, 1

	loop0:	
		sll $t2,$t2,1
		beq $t2, $t0, power_of_two0
		beq $t2, $zero, output0
		j loop0

	power_of_two0: 
		ori $t2, $zero, 0x0100

	output0:
		or $a3, $t2, $a1 
		j output_and_exit


test1:
		jal input 
		andi $t0, $a1, 1
		beq $t0, $zero, even
		ori $t1, $zero, 0x0100
	even:
		or $a3, $t1, $a1
		j output_and_exit

test2:
		jal test_extra
		or $a3,$t0,$t1
		j output_and_exit

test3:
		jal test_extra
		nor $a3,$t0,$t1
		andi $a3,$a3,0x1111
		j output_and_exit

test4:
		jal test_extra
		xor $a3,$t0,$t1
		andi $a3,$a3,0x1111
		j output_and_exit

test5:
		jal test_extra
		lui $t2,0xffff
		srl $at, $t0,7
		beq $at, $zero, test5_case1
		or $t0,$t0,$t2
	test5_case1:
		srl $at, $t1,7
		beq $at, $zero, test5_case2
		or $t1,$t1,$t2
	test5_case2:
		slt $a3,$t0,$t1
		j output_and_exit

test6:
		jal test_extra
		sltu $a3,$t0,$t1
		j output_and_exit

test7:
		jal test_extra
		j exit

test_extra:
		addi $sp,$sp,-4
		sw $ra,0($sp) #64

		jal input
		or $t0, $zero, $a1
		jal input
		or $t1, $zero, $a1
		sll $a3, $t0, 8
		or $a3,$a3,$t1
		jal output_2sec_and_back
		
		lw $ra,0($sp)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra


output_2sec_and_back:
		addi $sp,$sp,-8
		sw $s0,4($sp)
		sw $at,0($sp)
		
		sw $a3, 10($a2)
		ori $at, $zero, 1
		lui $s0, 0x0000
		ori $s0,$s0, 0x0004

	out_loop:
		addi $at, $at, 1
		bne $at, $s0, out_loop

		lw $at,0($sp)
		lw $at,0($sp)
		lw $s0,4($sp)
		lw $s0,4($sp)
		addi $sp,$sp,8
		jr $ra

output_and_exit:
		sw $a3, 10($a2)

exit:
		nop