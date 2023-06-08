.data  0x0000              		        
   buf:   .word  0x00000055, 0x000000AA	
.text 0x0000		
start:				       
	lw $at,  0($at)
	lw $a0, 1($a0)
	sw $at, 2($at)
	sw $a0, 3($a0)
	or $at,$zero,$zero
	or $a0,$zero,$zero
	lw $at,  2($at)
	lw $a0, 3($a0)
	sw $at, 4($at)
	sw $a0, 5($a0)
	or $at,$zero,$zero
	or $a0,$zero,$zero
	lw $at,  4($at)
	lw $a0, 5($a0)
	
	ori $sp, $sp, 0x1000
	ori $ra,$zero,5
	ori $s0,$zero,7
	ori $at,$zero,9
	sw $ra,8($sp)
	sw $s0,4($sp)
	sw $at,0($sp)
	
	ori $ra,$zero,0
	ori $s0,$zero,0
	ori $at,$zero,0
	#sw $a3, 10($a2)
	#ori $at, $zero, 1
	#lui $s0, 0x0000
	#ori $s0,$s0, 0x0007

	#out_loop:
		#addi $at, $at, 1
		#bne $at, $s0, out_loop

	lw $at,0($sp)
	lw $at,0($sp)
	lw $s0,4($sp)
	lw $s0,4($sp)
	lw $ra,8($sp)
	lw $ra,8($sp)