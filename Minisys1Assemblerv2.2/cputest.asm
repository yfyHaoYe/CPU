.data  0x0000              		        # ���ݶ�����׵�ַ
.text 0x0000						        # ����ζ��忪ʼ
start:
	

		ori $at,$zero,1       #�Ĵ�����ʼ��
		sw $at, 3($zero)
		or $at, $zero,$zero
		lw $at, 3($zero)
		lui $a0, 0xffff
		ori $a0,$a0,0xff70
		sw $at, 0($a0)