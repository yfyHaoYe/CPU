.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000						       
start:
	lui $a0, 0xffff
	ori $a0, $a0, 0xff72
	addi $a1,$a1,1
	ori $a2, $a2, 10
	beq $a1, $a2, loop
	j exit1

loop:
	sw $a2, 0($a0)
	j loop

exit1:
	nop