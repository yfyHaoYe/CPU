.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000						       
start:	
		ori $t0, $t0, 5	
		jal Label1
		jal exit

Label1:
		lui $t1,0xffff
		ori $t1, $t1, 0xff70
		sw $t0,0x0000($t1)
		jr $ra

exit:
		nop