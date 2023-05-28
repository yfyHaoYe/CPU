.data  0x0000              		        
.text 0x0000						       
start:	
		ori $a1,$zero,-1
		lui $a0, 0xffff
loop:	lw $a1,0xff60($a0)
		beq $a1,$zero,loop
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
		beq $a1,$a2,test
		j exit

test0:
		lui $a0, 0xffff
		lw $a1,0xff62($a0) 
		or $a2,$a1,$a1
		ori $a3,$zero,1
loop0:	
		srl $a2,$a2,$a3
		beq $a2,$a3,yes
		beq $a2,$zero,no
		j loop0
yes0: 
		ori $a4,$zero,1
		j output
no0:
		ori $a4,$zero0
		j output
output0:
		sw $a1,0xff70($a0)
		sw $a4,0xff72($a0)
		j output


test1:

test2:

test3:

test4:

test5:

test6:

test7:

exit: