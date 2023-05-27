.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000						       
start:	
		ori $s2, $zero, 19
		lui $s2, 0xffff
		sw $s3,0xff60($s2)