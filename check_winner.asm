
.text
.globl checkwinall, wincondition1, wincondition2, wincondition3, wincondition4, wincondition5, wincondition6,
.globl wincondition7, wincondition8, win, player1win, player2win, draw, newline, addspace

checkwinall:
	bge $s4, 5, wincondition1 #if $s4>=5 check the winning condition)
	j turn #if not jump to turn
	jr $ra

#check if all the values in first row has the same value
wincondition1:
	li $s6, 0 #set $s6 to 0
	li $s5, 1 #set$s5 to 1
	la $t1, grid #load grid to $t1
	add $t1, $t1, $s5 #add $t1 + $s5 to access the value in position 1
	lb $t2, ($t1) #load $t1 to $t2
	addi $t1, $t1, 1 #increment address $t1 + 1 
	lb $t3, ($t1) #load $t1 to $t3
	addi $t1, $t1, 1 #increment address $t1 + 1 
	lb $t4, ($t1) #load $t1 to $t4
	add $s6, $s6, $t2 #add $s6 +$t2 for further checking
	bne $t2, $t3, wincondition2 #check if the values are same, jump to next wincondition
	bne $t3, $t4, wincondition2 #check if the values are same, jump to next wincondition
	beq $t2, 0, wincondition2 #check if $t2 is equal to 0 which is empty, jump to next wincondition
	j win #else jump to win
	jr $ra

#check if all the values in first column has the same value
wincondition2:
	li $s6, 0
	li $s5, 1
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 3
	lb $t3, ($t1)
	addi $t1, $t1, 3
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, wincondition3
	bne $t3, $t4, wincondition3
	beq $t2, 0, wincondition3
	j win
	jr $ra
#check if the position 1,5,9(diagonal) have the same value
wincondition3:
	li $s6, 0
	li $s5, 1
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 4
	lb $t3, ($t1)
	addi $t1, $t1, 4
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, wincondition4
	bne $t3, $t4, wincondition4
	beq $t2, 0, wincondition4
	j win
	jr $ra

#check if all the values in second column have the same value
wincondition4:
	li $s6, 0
	li $s5, 2
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 3
	lb $t3, ($t1)
	addi $t1, $t1, 3
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, wincondition5
	bne $t3, $t4, wincondition5
	beq $t2, 0, wincondition5
	j win
	jr $ra

#check if all the values in second row are same
wincondition5:
	li $s6, 0
	li $s5, 4
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 1
	lb $t3, ($t1)
	addi $t1, $t1, 1
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, wincondition6
	bne $t3, $t4, wincondition6
	beq $t2, 0, wincondition6
	j win
	jr $ra
#check if positon 3,5,7(second diagonal) are same
wincondition6:
	li $s6, 0
	li $s5, 3
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 2
	lb $t3, ($t1)
	addi $t1, $t1, 2
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, wincondition7
	bne $t3, $t4, wincondition7
	beq $t2, 0, wincondition7
	j win
	jr $ra
#check all the values in third column are same
wincondition7:
	li $s6, 0
	li $s5, 3
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 3
	lb $t3, ($t1)
	addi $t1, $t1, 3
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, wincondition8
	bne $t3, $t4, wincondition8
	beq $t2, 0, wincondition8
	j win
	jr $ra

#check if all the values in third row are same
wincondition8:
	li $s6, 0
	li $s5, 7
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 1
	lb $t3, ($t1)
	addi $t1, $t1, 1
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, turn #check if $t2!=t$t3 return to turn
	bne $t3, $t4, turn #check if $t4!=t$t3 return to turn
	beq $t2, 0, turn #check if $t2 has mssing values, retur to turn
	j win #else jump to win
	jr $ra 
#to make new line	
newline:
	li $a0, 10 #load line
	li $v0, 11 #print line
	syscall
	jr $ra
#to make space
addspace:
	li $a0, 32 #load space
	li $v0, 11 #print space
	syscall
	jr $ra

#to display the winner
win:
	beq $s6, 1, player1win #check if $s6==1(x),jump to player1win
	beq $s6, 2, player2win #check if $s6==2(O),jump to player2win
	

#load and display win1
player1win:
	jal newline
	la $a0, win1
	li $v0, 4
	syscall
	j end
	
#load and display win2
player2win:
	jal newline
	la $a0, win2
	li $v0, 4
	syscall
	j end

#load and display lastdraw
draw:
	jal newline
	la $a0, lastdraw
	li $v0, 4
	syscall
	j end

end:
	li $v0, 10
	syscall
