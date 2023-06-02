.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000						       
start:	
		lui $s2, 0xffff
		ori $s2, $s2, 0xff70
		lw $s3,0x0000($s2)
		nop
		sw $s3,0x0000($s2)