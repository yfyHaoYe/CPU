.data  0x0000              		        # 数据定义的首地址
.text 0x0000						        # 代码段定义开始
start:
	

		ori $at,$zero,1       #寄存器初始化
		sw $at, 3($zero)
		or $at, $zero,$zero
		lw $at, 3($zero)
		lui $a0, 0xffff
		ori $a0,$a0,0xff70
		sw $at, 0($a0)