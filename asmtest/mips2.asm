lw $t0, 1000000 #ÊäÈë
sw $t0, 2000000 #Êä³ö
li $t1,1

and $t0,$t0,$t1
beqz $t0, end
sw $t1,2000001
end: