lw $t0, 1000000 #输入
sw $t0, 2000000 #输出
li $s0,1
li $t1,2
li $t2,4
li $t3,8
li $t4,16
li $t5,32
li $t6,64
li $t7,128

beq $t0,$s0,isPower
beq $t0,$t1,isPower
beq $t0,$t2,isPower
beq $t0,$t3,isPower
beq $t0,$t4,isPower
beq $t0,$t5,isPower
beq $t0,$t6,isPower
beq $t0,$t7,isPower
j end

isPower:
sw $s0, 2000001 # 2幂指示输出

end: