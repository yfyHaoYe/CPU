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
		j test1


input:
		lw $a1,2($a0)
		srl $a1,$a1,8
		jr $ra

test1:
		jal input 
		andi $t0, $a1, 1
		beq $t0, $zero, even
		ori $t1, $zero, 0x0100
	even:
		or $a3, $t1, $a1
		j output_and_exit

loop:	
		ori $a3,$a3,0x0055
		sw $a3, 0($a2)
		j loop

output_and_exit:
		sw $a3, 10($a2)

exit:
		nop