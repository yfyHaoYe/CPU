//senario 1
.data  0x0000              		        # 数据定义的首地址
   buf:   .word  0x00000055, 0x000000AA	# 定义数据

.text 0x0000						        # 代码段定义开始
ori $t9,$zero,2000000


ori $a0,$zero,$zero
loop:
addi $a0,$a0,1
bne $a0,$t9,loop
ori $a0,$zero,$zero