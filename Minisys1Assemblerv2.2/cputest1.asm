.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000						       
start:	
		lui $s0, 0x0000 #s0 constant 6000
		ori $s0,$s0, 0x0030
		lui $a2,0xffff #a2 constant output address ffffff70
		ori $a2, $a2, 0xff70
		ori $a3,$zero,0x0000
		lw $a1, 0($a2)

loop:
		addi $a3, $a3,1
		jal output_1sec_and_back
		bne $a3, $a1, loop
		j exit

output_1sec_and_back:
		sw $a3, 2($a2)
		ori $at, $zero, 1

	out_loop:
		addi $at, $at, 1
		bne $at, $s0, out_loop
		jr $ra
	
exit:
		nop