//senario 1
.data  0x0000              		        # ���ݶ�����׵�ַ
   buf:   .word  0x00000055, 0x000000AA	# ��������

.text 0x0000						        # ����ζ��忪ʼ
ori $t9,$zero,2000000


ori $a0,$zero,$zero
loop:
addi $a0,$a0,1
bne $a0,$t9,loop
ori $a0,$zero,$zero