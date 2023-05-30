.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000						       
start:	
		ori $s3, $zero, 19
		lui $s2, 0xffff
		ori $s2, $s2, 0xff60
loop:	sw $s3,0x0000($s2)
		j loop