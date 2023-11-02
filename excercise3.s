#-----------------------------------------------------------------
#Benjamin Scown
#62071873
#COSC 211
#Computer Science
#Lab 4, excercise 3
#-----------------------------------------------------------------
#code section
      .text  		# directive for code section
      .globl main  	# directive: main is visible to other files 
main:
	li $v0, 4
	la $a0, msg_1
	syscall

	li $v0, 5
	syscall
	
	la $s0, towers
	sb $v0, 0($s0)
	sb $zero, 1($s0)
	sb $zero, 2($s0)
	
	jal load_towers
	jal print_towers
	
	la $s0, towers
	lb $a0, 0($s0)
	li $a1, 0
	li $a2, 1
	li $a3, 2
	jal hanoi
	
	j exit
	
hanoi:
# $a0 -> n
# $a1 -> src
# $a2 -> helper
# $a3 -> destination

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# n == 1
	li $t0, 1
	beq $t0, $a0, n_one
	
	addi $sp, $sp, -4
	sb $a0, 0($sp)
	sb $a1, 1($sp)
	sb $a2, 2($sp)
	sb $a3, 3($sp)
	
	add $t0, $a2, $zero
	add $a2, $a3, $zero
	add $a3, $t0, $zero
	
	addi $a0, $a0, -1
	jal hanoi
	
	lb $a0, 0($sp)
	lb $a1, 1($sp)
	lb $a2, 2($sp)
	lb $a3, 3($sp)
	addi $sp, $sp, 4
	
	jal move_disc
	
	addi $a0, $a0, -1
	
	add $t0, $a1, $zero
	add $a1, $a2, $zero
	add $a2, $t0, $zero
	jal hanoi
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

n_one:
	jal move_disc
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

print_towers:
	add $s0, $a0, $zero
	add $s1, $a1, $zero
	add $s2, $a2, $zero
	
	li $v0, 11
	li $a0, 0x5b
	syscall
	
	li $v0, 1
	add $a0, $s0, $zero
	syscall
	
	li $v0, 11
	li $a0, 0x2c
	syscall
	
	li $a0, 0x20
	syscall
	
	li $v0, 1
	add $a0, $s1, $zero
	syscall
	
	li $v0, 11
	li $a0, 0x2c
	syscall
	
	li $a0, 0x20
	syscall
	
	li $v0, 1
	add $a0, $s2, $zero
	syscall
	
	li $v0, 11
	li $a0, 0x5d
	syscall
	
	li $a0, 0x0a
	syscall
	
	add $a0, $s0, $zero
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	
	jr $ra
	
load_towers:
	la $t0, towers
	
	lb $a0, 0($t0)
	lb $a1, 1($t0)
	lb $a2, 2($t0)
	
	jr $ra
	
store_towers:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	sb $a0, 0($s0)
	sb $a1, 1($s0)
	sb $a2, 2($s0)
	
	sw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
move_disc:
# $a1 -> source
# $a3 -> dest

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	la $t0, towers
	# $t0 -> source adr
	# $t1 -> dest adr
	# $t2 -> temp
	add $t1, $t0, $a3
	add $t0, $t0, $a1 
	
	lb $t2, 0($t0)
	addiu $t2, $t2, -1
	sb $t2, 0($t0)
	
	lb $t2, 0($t1)
	addiu $t2, $t2, 1
	sb $t2, 0($t1)
	
	addi $sp, $sp, -4
	sb $a0, 0($sp)
	sb $a1, 1($sp)
	sb $a2, 2($sp)
	sb $a3, 3($sp)
	
	jal load_towers
	jal print_towers
	
	lb $a0, 0($sp)
	lb $a1, 1($sp)
	lb $a2, 2($sp)
	lb $a3, 3($sp)
	addi $sp, $sp, 4
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
exit:

	li $v0, 10
	syscall

#-------------------------------------------------------------------
#data section

     .data   #directive for

msg_1:
	.align 2
	.asciiz "Enter the number of discs: " 
towers:
	.align 2
	.space 4