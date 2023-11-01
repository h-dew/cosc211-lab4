
#-----------------------------------------------------------------
#Benjamin Scown
#62071873
#COSC 211
#Computer Science
#Lab 4, excercise 2
#-----------------------------------------------------------------
#code section
      .text  		# directive for code section
      .globl main  	# directive: main is visible to other files 
main: 
	add $s1, $zero, $zero # $t0 -> counter
	li $t1, 100 #$t1 -> final value
	
loop1:
	add $a0, $s1, $zero
	jal test_prime
	add $s0, $v0, $zero
	
	li $v0, 1
	syscall
	
	beq $s0, $zero, no_prime
	
yes_prime:
	la $a0, prime_true
	j print_prime
	
no_prime:
	la $a0, prime_false

print_prime:
	li $v0, 4
	syscall
	
	beq $s1, $t1, exit
	addi $s1, $s1, 1
	j loop1

test_prime:
	# $a0 -> n (is prime?)
	# $a1 -> i (counter)
	# $v0 -> result
	
	# store $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# clear $a2
	and $a2, $a2, $zero

	# set $v0 to 0
	li $v0, 0
	
	and $a1, $a0, $zero
	# base cases
	beq $a1, $a0, test_prime_exit
	addi $a1, $a1, 1
	beq $a1, $a0, test_prime_exit
	addi $a1, $a1, 1 # $a1 is now 2
	
test_prime_loop:
	
	#test if i = n
	beq $a1, $a0, test_prime_true
	
	#test if n%i = 0
	div $a0, $a1
	mfhi $t0
	beq $t0, $zero, test_prime_exit
	
	addi $a1, $a1, 1 # increment counter
	
	j test_prime_loop
	
test_prime_true:
	li $v0, 1
	
test_prime_exit:
	# restore $ra from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

exit:
	li $v0, 10
	syscall  


#-------------------------------------------------------------------
#data section

     .data   #directive for

prime_true:
	.asciiz " is a prime number.\n"
	.space 2
	
prime_false:
	.asciiz " is NOT a prime number.\n"
	.space 2