.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000						       
start:	
		ori $a1,$zero, 0x00ff
		lui $a2,0xffff
		ori $a2, $a2, 0xff70
		ori $a3,$zero,0x0001
loop:
		jal output_2sec_and_back
		addi $a3, $a3,1
		beq $a3, $a1, exit

output_2sec_and_back:
		
		sw $a3, 2($a2)
		ori $at, $zero, 1
		lui $s0, 0x0004
		ori $s0,$s0, 0x0000

	out_loop:
		addi $at, $at, 1
		bne $at, $s0, out_loop
		jr $ra

exit:
	nop