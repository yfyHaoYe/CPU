.data  0x0000              		        # ���ݶ�����׵�ַ
.text 0x0000						        # ����ζ��忪ʼ
start:
	

		ori $at, $zero,5
		ori $v0, $zero,7
		ori $v1, $zero,9
		sw $at,0($sp)
		sw $v0,4($sp)
		sw $v1,8($sp)
		ori $at, $zero,0
		ori $v0, $zero,0
		ori $v1, $zero,0
		lw $at,0($sp)
		lw $at,0($sp)
		lw $v0,4($sp)
		lw $v0,4($sp)
		lw $v1,8($sp)
		lw $v1,8($sp)
		ori $at, $zero,0
		ori $v0, $zero,0
		ori $v1, $zero,0
		lw $at,0($sp)
		lw $at,0($sp)
		lw $v0,4($sp)
		lw $v0,4($sp)
		lw $v1,8($sp)
		lw $v1,8($sp)