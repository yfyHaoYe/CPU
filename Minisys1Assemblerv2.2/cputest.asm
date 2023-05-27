.data  0x0000              		        # 数据定义的首地址
   buf:   .word  0x00000055, 0x000000AA	# 定义数据
.text 0x0000						        # 代码段定义开始
start:		
		ori $at,$zero,1       #寄存器初始化
		ori $v0,$zero,2
		ori $v1,$zero,3
		ori $a0,$zero,4
		ori $a1,$zero,5
		ori $a2,$zero,6
		ori $a3,$zero,7
		ori $t0,$zero,8
		ori $t1,$zero,9
		ori $t2,$zero,10
		ori $t3,$zero,11
		ori $t4,$zero,12
		ori $t5,$zero,13
		ori $t6,$zero,14
		ori $t7,$zero,15
		ori $s0,$zero,16
		ori $s1,$zero,17
		ori $s2,$zero,18
		ori $s3,$zero,19
		ori $s4,$zero,20
		ori $s5,$zero,21
		ori $s6,$zero,22
		ori $s7,$zero,23
		ori $t8,$zero,24
		ori $t9,$zero,25
		ori $i0,$zero,26
		ori $i1,$zero,27
		ori $s9,$zero,28
		ori $sp,$zero,29
		ori $s8,$zero,30
		ori $ra,$zero,31
		sw $s3,0xff60($zero)