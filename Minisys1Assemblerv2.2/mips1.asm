.data  0x0000              		        
.text 0x0000	
		# a0: 0xffffff60 input address
		# a1: input data
		# a2: 0xffffff70 output address
		# a3: output data
start:	
		ori $a1,$zero,-1
		lui $a0, 0xffff
		ori $a0,$zero, 0xff60
		addi $a2, $a0, 10

loop:	nop
		lw $a1,0($a0)
		nop
		or $a3,$a1,$zero
		jal output_2sec_and_back
		
		ori $a2,$zero,0
		beq $a1,$a2,test0
		ori $a2,$zero,1
		beq $a1,$a2,test1
		ori $a2,$zero,2
		beq $a1,$a2,test2
		ori $a2,$zero,3
		beq $a1,$a2,test3
		ori $a2,$zero,4
		beq $a1,$a2,test4
		ori $a2,$zero,5
		beq $a1,$a2,test5
		ori $a2,$zero,6
		beq $a1,$a2,test6
		ori $a2,$zero,7
		beq $a1,$a2,test7
		j exit

input:	nop
		lw $a1,2($a0)
		nop
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
		j output_and_exit
test4:
		jal test_extra
		xor $a3,$t0,$t1
		j output_and_exit
test5:
		jal test_extra
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
		addi $sp,$sp,-16
		sw $ra,12($sp)
		sw $t0,8($sp)
		sw $t1,4($sp)
		sw $a3,0($sp)

		jal input
		or $t0, $zero, $a1
		or $a3,$zero,$a1
		jal output_2sec_and_back
		jal input
		or $t1, $zero, $a1
		or $a3,$zero,$a1
		jal output_2sec_and_back
		sll $t2, $t1, 8
		or $a3,$zero,$t0
		or $a3,$a3,$t2
		jal output_2sec_and_back
		
		lw $a3,0($sp)
		lw $t1,4($sp)
		lw $t0,8($sp)
		lw $ra,12($sp)
		addi $sp,$sp,16
		jr $ra

output_and_exit:
		sw $a3, 10($a2)
		j exit

output_2sec_and_back:
		addi $sp,$sp,-8
		sw $s0,4($sp)
		sw $at,0($sp)
		
		sw $a3, 10($a2)
		ori $at, $zero, 1
		lui $s0, 0x0100
		ori $s0,$s0, 0x0000

	out_loop:
		addi $at, $at, 1
		bne $at, $s0, out_loop

		lw $at,0($sp)
		lw $s0,4($sp)
		addi $sp,$sp,8
		jr $ra

exit:
		nop