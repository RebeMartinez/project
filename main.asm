
.data
	msg1: .asciiz "Welcome to tic tac toe"
	turn1: .asciiz "Player 1's turn: "
	turn2: .asciiz "Player 2's turn: "
	win1: .asciiz "Player 1 win."
	win2: .asciiz "Player 2 win."
	lastdraw: .asciiz "Draw."
	line1: .asciiz "1 2 3"
	line2: .asciiz "4 5 6"
	line3: .asciiz "7 8 9"
	guide: .asciiz "Enter the location[1-9] to play the games."
	guide1: .asciiz "Player 1: X and Player 2: O."
	grid: .asciiz  #we use grid to store the array of tic-tac-toe 3x3
.text

#display the main and guide the player to play the games
main:
	li $s3, 0
	li $s4, 0
	la $a0, msg1
	li $v0, 4
	syscall
	jal newline
	j displaysample

#to determine the turn of player 1 and player 2
turn:
	jal newline
	beq $s3, 0, play1 #0 for player 1
	beq $s3, 1, play2 #1 for player 2

#manage player 1's turn	
play1:
	la $a0, turn1
	li $v0, 4
	syscall
	jal newline
	j play

#manage player 2's turn	
play2:
	la $a0, turn2
	li $v0, 4
	syscall
	jal newline
	j play

#manage the game. this function will jumep to three function: getinput, checkinput and storeinput
play:
	jal newline
	beq $s4, 9, draw
	jal getinput
	jal checkinput
	j storeinput

#display the initial sample(location of the tic-tac-toe[1-9])
#load and display line1, line2, line3, line4
displaysample:
    # Step 1: Allocate stack space
    addiu $sp, $sp, -20

    # Step 2: Write to stack
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    # Step 3: Call function
    la $a0, line1
    li $v0, 4
    syscall
    jal newline

    la $a0, line2
    li $v0, 4
    syscall
    jal newline

    la $a0, line3
    li $v0, 4
    syscall
    jal newline

    la $a0, guide
    li $v0, 4
    syscall
    jal newline

    la $a0, guide1
    li $v0, 4
    syscall
    jal newline

    # Step 4: Read from stack
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)

    # Step 5: Deallocate stack space
    addiu $sp, $sp, 20

    # Continue with the control flow
    j turn
# Function to initialize display
display:
    # Step 1: Allocate stack space
    addiu $sp, $sp, -8

    # Step 2: Write to stack
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    # Step 3: Call function
    li $s0, 0
    li $s1, 0
    j displayline

    # Step 4: Read from stack
    lw $ra, 4($sp)
    lw $s0, 0($sp)

    # Step 5: Deallocate stack space
    addiu $sp, $sp, 8
    
# Function to display newline for displaying griddisplayline

displayline:
   
    addi $s1, $s1, 3
    jal newline
    jal displaygrid


#displaying all the information in grid
displaygrid:
	beq $s0, 9, checkwinall #if $s0==9(all the value in grid are displayed), check the winning condition
	beq $s0, $s1, displayline
	addi $s0, $s0, 1 #increment $s0
	la $t2, grid #load the current grid address
	add $t2, $t2, $s0  #add the address with $s0
	lb $t3, ($t2) #load byte of $t2 to $t3
	jal addspace #to make space
	beq $t3, 0, displayspace #if the value in $t3==0 jump to displayspace
	beq $t3, 1, displayx #if $t3==1 jump to displayx
	beq $t3, 2, displayo #if $t3==2 jump to displayo

#to display 1 to x
displayx:
	li $a0, 88 #load x
	li $v0, 11 #print x
	syscall
	j displaygrid

#to display 2 to O
displayo:
	li $a0, 79 #load O
	li $v0, 11 #print O
	syscall
	j displaygrid

#to display ? if the value in grid is 0
displayspace:
	li $a0, 63 #load ?
	li $v0, 11 #print ?
	syscall
	j displaygrid #jump back to grid

#get input from user
# Function to get input from user
getinput:
    # Step 1: Allocate stack space
    addiu $sp, $sp, -4

    # Step 2: Write to stack
    sw $ra, 0($sp)

    # Step 3: Call function
    li $v0, 5
    syscall
    li $s2, 0
    add $s2, $s2, $v0

    # Step 4: Read from stack
    lw $ra, 0($sp)

    # Step 5: Deallocate stack space
    addiu $sp, $sp, 4

#check the input is it within the range of [1-9] or not
checkinput:
	la $t1, grid  #load the grid address
	add $t1, $t1, $s2 #add the $s2 to $t1 to get the exact location
	lb $t2, ($t1) #load the $t1 into $t2
	bne $t2, 0, turn # check if $t2!=0 jump to turn
	bge $s2, 10, turn # check if $s2 >= 10, jump to turn
	ble $s2, 0, turn # check if $s2 <= 0, jump to turn
	jr $ra #return to previous function

#store the input into grid	
storeinput:
	addi $s4, $s4, 1 #increment $s4 for every turn
	beq $s3, 0, storex #if player 1's turn jump to storex
	beq $s3, 1, storeo #if player 2's turn jump to storeo

#to store the player 1's turn
storex:
	la $t1, grid #load the grid
	add $t1, $t1, $s2 #add $s2 location to $t1 to get the exact location
	li $t2, 1 
	sb $t2, ($t1) #store $t1 to $t2
	li $s3, 1 #change the turn to player 2
	j display #jump to display
	
#to store the player 2's turn
storeo:
	la $t1, grid
	add $t1, $t1, $s2
	li $t2, 2
	sb $t2, ($t1)
	li $s3, 0 #change the turn to player 1
	j display
	
checkwinner:
	#step 1: allocates memory to stack
	addiu $sp,$sp,-4 	
	#Step 2: write from stack
	sw $ra, 0($sp)		
	jal checkwinall
	jal win
	jal draw
	#Step 3: read from stack
	lw $ra, 0($sp)	
	#Step 4: deallocates stack space	
	addiu $sp,$sp, 4	
	

#exit the program
end:
	li $v0, 10
	syscall
