##############################################################
# name: Devon Maguire
# date: 4/10/2015
##############################################################
.text
#################
# STRLEN
#################
strlen:
	addi $sp, $sp, -8	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the given string
	
	li $t0, 0	# stores count of characters in t0
	li $t1, 0x0	# stores the value of the null character '\0'

	la $t2, ($a0)	# stores the current address of the string
	
loopLen:
	lb $t3, ($t2)
	beq $t3, $t1, finishLen
	
	addi $t0, $t0, 1	# add one to the count of the string
	addi $t2, $t2, 1	# add one to the address of the string
	
	j loopLen	# jump back to beginning of loop
	
finishLen:
	move $v0, $t0	# put the string length into v0

	lw $ra, 0($sp)	# restore the return address
	lw $a0, 4($sp)	# restore the value in a0
	addi $sp, $sp, 8 # give space on the stack back

	jr $ra	# jump back to the main program


#EASY STRING FUNCTIONS
#################
# STRCMP
#################
	# a0 holds the first string
	# a1 holds the second string
	# return the answer in v0
strcmp:
	addi $sp, $sp, -12	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the first string
	sw $a1, 8($sp)	# store the second string
	
	la $t0, ($a0)	# stores the address of the first string in t0
	la $t1, ($a1)	# stores the address of the second string in t1

	li $t5, 1
	
loopCmp:
	lb $t2, ($t0)	# load the next char in string 1
	lb $t3, ($t1)	# load the next char in string 2
	
	bne $t2, $t3, notEqual	# compare the current char in each string
	
	beq $t2, $zero, check2	# checks if string 1 is equal to \0
	beq $t3, $zero, check1	# checks if string 2 is equal to \0
	
	addi $t0, $t0, 1	# move to the next char in string 1
	addi $t1, $t1, 1	# move to the next char in string 2
	
	j loopCmp	# jump back to beginning of loop
	
check2:
	bne $t3, $zero, notEqual	# checks to see if string 2 is also euqal to \0
	move $v0, $t5	# if the two strings are equal set result to one
	
	j finishCmp	# jump to end of function
	
check1:
	bne $t2, $zero, notEqual	# checks to see if string 1 is also equal to \0
	move $v0, $t5	# if the two strings are equal set result to one
	
	j finishCmp	# jump to end of function
	
notEqual:
	move $v0, $0	# if the two strings are not equal set result to zero
	j finishCmp	# jump to end of function
	
finishCmp:
	lw $a1, 8($sp)	# restore the return address
	lw $a0, 4($sp)	# restore the value in a0
	lw $ra, 0($sp)	# restore the value in a1
	addi $sp, $sp, 12 # give space on the stack back
	
	jr $ra # return to the main program
	
#################
# STRNCPY
#################
	# a0 holds the buffer
	# a1 holds the string to be copied (src)
	# a2 holds n
	# return butter in v0
strncpy:
	addi $sp, $sp, -16	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the string dst
	sw $a1, 8($sp)	# store the string src
	sw $a2, 12($sp)	# store the valule of n
	
	li $t0, 0	# counter
	la $t1, ($a1)	# store src in t1
	la $t2, ($a0)	# store dst in t2
	la $t3, ($a0)	# stores original address of dst
	
loopCpy:
	beq $a2, $t0, reachBound	# is n == to counter?
	
	lb $t4, ($t1)	# stores current char of src
	
	beq $t4, $zero, nullDst	# is src char == '\0'?
	
	sb $t4, ($t2)	# move the char of src into dst
	
	addi $t1, $t1, 1	# move to next char in src
	addi $t2, $t2, 1	# move to next char in dst
	addi $t0, $t0, 1	# add one to the counter
	
	j loopCpy	# jump back to beginning of loop
	
nullDst:
	beq $a2, $t0, reachBound	# is n == to counter?
	
	sb $zero, ($t2)	# make dst null terminated
	addi $t2, $t2, 1	# add one to move to next char in dst
	addi $t0, $t0, 1	# add one to counter
	
	j nullDst	# jump to the beginning of the loop
	
reachBound:
	la $v0, ($t3)	# return the original address of dst to the main program

	lw $a2, 12($sp)	# restore the return address
	lw $a1, 8($sp)	# restore the value in a0
	lw $a0, 4($sp)	# restore the value in a1
	lw $ra, 0($sp)	# restore the value in a2
	addi $sp, $sp, 16 # give space on the stack back
	
	jr $ra	# jump back to the main program

#################
# INDEXOF
#################
	# a0 holds the string address
	# a1 holds the char we want to find in the string
indexOf:
	addi $sp, $sp, -12	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the string
	sw $a1, 8($sp)	# store the char to find in string
	
	li $t0, 0	# stores index in t0
	la $t1, ($a0)	# stores the current address of the string
	la $t2, ($a1)	# stores the value of the character
	
loopIO:
	lb $t3, ($t1)	# load the byte of the string
	beq $t3, $t2, finishIO	# see if current char is one we're looking for
	
	addi $t0, $t0, 1	# add one to the index number
	addi $t1, $t1, 1	# go to next char in string
	
	j loopIO	# jump back to beginning of loop
	
finishIO:
	move $v0, $t0	# put the index into v0
	
	lw $a1, 8($sp)	# restore the return address
	lw $a0, 4($sp)	# restore the value in a0
	lw $ra, 0($sp)	# restore the value in a1
	addi $sp, $sp, 12 # give space on the stack back
	
	jr $ra	# return to the main program

#MEDIUM STRING FUNCTIONS
#################
# REVERSE_STR
#################
	# a0 holds the string address
reverse_str:
	addi $sp, $sp, -8	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the given string
	
	la $t0, ($a0)	# hold starting position of string (will could to end position)
	la $t1, ($a0)	# hold starting position of string
	la $t2, ($a0)	# stores starting address (pass back to function)
	
findEndOfString:
	lb $t3, ($t0)	# load the char into t3
	beq $t3, $zero, reverseLoop	# check to see if char is null
	
	addi $t0, $t0, 1	# add one to the original string address
	
	j findEndOfString	# jump to beginning of loop
	
reverseLoop:
	addi $t0, $t0, -1	# subtract from end string
	
	bgt $t1, $t0, finishReverse	# see if strings meet
	
	lb $t4, ($t0)	# temp char end
	lb $t5, ($t1)	# temp char beginning
	
	sb $t4, ($t1)	# swap chars
	sb $t5, ($t0)	# swap chars
	
	addi $t1, $t1, 1	# add to beginning string
	
	j reverseLoop	# jump to beginning of loop
	
finishReverse:
	move $v0, $t2	# pass string address back to main function
	
	lw $ra, 0($sp)	# restore the return address
	lw $a0, 4($sp)	# restore the value in a0
	addi $sp, $sp, 8 # give space on the stack back
	
	jr $ra	# return to the main program

#################
# ATOI
#################
	# a0 holds the string address
atoi:
	addi $sp, $sp, -8	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the given string
	
	la $t0, ($a0)	# stores the beginning address of the string
	li $t1, 48	# stores the beginning of number ascii values
	li $t2, 57	# stores the end of the number ascii values
	
	li $t4, 0	# stores the integer value
	li $t5, 10	# used to move the integers over one digit
	
loopAI:
	lb $t3, ($t0)	# load the first char in string
	
	blt $t3, $t1, notANum	# check to see if char is a number
	bgt $t3, $t2, notANum	# check to see if char is a number
	
	addi $t3, $t3, -48	# turn char into an integer
	add $t4, $t4, $t3	# add integer to the result register
	
	mul $t4, $t4, $t5	# move integer over one digit
	
	addi $t0, $t0, 1	# move to next char in string
	
	j loopAI	# jump to beginning of loop
	
notANum:
	divu $t4, $t5	# divide by ten to get proper number (undo last mul)
	mflo $t4	# get the answer of the division
	move $v0, $t4	# return value to main program

	lw $ra, 0($sp)	# restore the return address
	lw $a0, 4($sp)	# restore the value in a0
	addi $sp, $sp, 8 # give space on the stack back
	
	jr $ra	# return to the main program

#HARD STRING FUNCTIONS
#################
# CUT
#################
	# a0 is the source string (string you are cutting from)
	# a1 is the start of the cut pattern
	# a2 is the end of the cut pattern
cut:
	addi $sp, $sp, -16	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the string src
	sw $a1, 8($sp)	# store the string ptrn_start
	sw $a2, 12($sp)	# store the stirng ptrn_end
	
	la $t0, ($a0)	# places src string address in t0
	la $t1, ($a1)	# place the start pattern in t1
	la $t2, ($a2)	# place the end pattern in t2
	
	li $t7, 0	# count for cut string length
	
	j loopCBeg
	
adjust:
	addi $t0, $t0, 1	# adjusts to move to next char in src string
	
loopCBeg:
	lb $t3, ($t0)	# stores the first char of src string
	lb $t4, ($t1)	# stores the first char of the start pattern
	la $t5, ($t0)	# stores the current place of src string (to be changed in check loop)
	la $t6, ($t1)	# stores the current place of the start pattern (for reset if first char is false)
	
	move $v0, $t5	# **moves the start of the cut string into v0**
	
	beq $t3, $t4, checkStart	# checks to see if chars are equal
	beq $t3, $zero, noCut	# if there is nothing in the src string to cut
	
	addi $t0, $t0, 1	# add one to the address of the source string
	li $t7, 0	# count for cut string length
	
	j loopCBeg	# jump to the beginning of the loop
	
checkStart:
	lb $t3, ($t5)	# load the char in the src string
	lb $t4, ($t6)	# load the char in the start pattern
	beq $t3, $zero, noCut	# if there is nothing in the src string to cut
	beq $t4, $zero, loopCEnd	# check to see if end of the start pattern
	bne $t3, $t4, adjust	# check to see if the chars are NOT equal
	
	addi $t5, $t5, 1	# move to next char in src string
	addi $t6, $t6, 1	# move to next char in start pattern
	addi $t7, $t7, 1	# increment the counter
	
	j checkStart	# jump to the beginning of the loop
	
adjust2:
	addi $t5, $t5, 1	# adjusts to move to next char in src string
	
loopCEnd:
	lb $t3, ($t5)	# load the char of the src string
	lb $t4, ($t2)	# load the char of the end pattern
	la $t8, ($t5)	# keeps the current char of the src string
	la $t9, ($t2)	# keeps the current char of the pattern string
	beq $t3, $t4, checkEnd	# check if the src char and end char are the same
	beq $t3, $zero, noCut	# if there is nothing in the src string to cut
	
	addi $t5, $t5, 1	# increments the src string to next char
	addi $t7, $t7, 1	# increments the counter
	
	j loopCEnd	# jump to the beginning of the loop
	
checkEnd:
	lb $t3, ($t8)	# load the char of the src string
	lb $t4, ($t9)	# load the char of the end pattern
	
	beq $t4, $zero, yesCut	# found it! now pass the correct values
	bne $t3, $t4, adjust2	# check to see if the chars are NOT equal
	beq $t3, $zero, noCut	# src is null and they don't equal so noCut
	
	addi $t8, $t8, 1	# advance to next char in src
	addi $t9, $t9, 1	# advacne to next char in end pattern
	addi $t7, $t7, 1	# increment the count
	
	j checkEnd	# jump to the beginning of the loop
	
noCut:
	li $v0, 0	# loads repsonse to nothing cut in v0
	li $v1, -1	# loads repsonse to nothing cut in v1
	
	j finishCut	# jump to the end of the function
	
yesCut:
	# **look at loopCBeg** pass the beginnnig of cut chars to main program
	move $v1, $t7	# pass the count of chars to cut to the main program
	
finishCut:
	lw $a2, 12($sp)	# restore the return address
	lw $a1, 8($sp)	# restore the value in a0
	lw $a0, 4($sp)	# restore the value in a1
	lw $ra, 0($sp)	# restore the value in a2
	addi $sp, $sp, 16 # give space on the stack back
	
	jr $ra	# return to the main program

#################
# STRTOK
#################
	# a0 holds the address of the string
	# a1 holds the char delimeter
strtok:
################## FIX SO THE DELIM IS ALWAYS JUST ONE CHAR #######################
	addi $sp, $sp, -16	# create space on the stack
	sw $ra, 0($sp)	# store the return address
	sw $a0, 4($sp)	# store the first string
	sw $a1, 8($sp)	# store the second string
	sw $s0, 12($sp)	# store the flag in $s0
	
	bnez $a0, noPtr	# check if a0 is zero (if next token is in Ptr)
	
	lw $a0, Ptr	# move Ptr address to a0
	
	beqz $a0, noDelim	# end of src string, no more possible tokens
	
noPtr:
	la $t0, ($a0)	# places src string address in t0
	la $t1, ($a1)	# place the delimeter in t1
	
	li $t3, 0	# null to replace delim with
	
	j loopToken	# jump to the token loop
	
adjustSrc:
	addi $t0, $t0, 1	# adjusts to move to next char in src string
	
loopToken:
	lb $t2, ($t0)	# stores the first char of src
	
	beq $t1, $t2, yesDelim	# see if src char and delim are same, go to check
	beq $t2, $zero, noDelim	# if src is null and no delim is found, no tokens
	
	addi $t0, $t0, 1	# add one to the address of src
	
	j loopToken	# jump to the beginning of the loop
	
noDelim:
	move $v0, $a0	# loads repsonse to no delimeter, no tokens in the string
	li $t4, 0
	sw $t4, Ptr	# loads zero back into the Ptr
	
	j finishToken	# jump to the end of the function

yesDelim:
	sb $t3, ($t0)	# replace delim in src with null char
	
	addi $t0, $t0, 1	# add one to get beginning of next token
	li $s0, 1	# sets flag to say that at least one cut has been found

	move $v0, $a0	# place beginning of current token in v0
	sw $t0, Ptr	# place beginning of next token in Ptr
	
finishToken:
	lw $s0, 12($sp)	# restore the flag in s0
	lw $a1, 8($sp)	# restore the return address
	lw $a0, 4($sp)	# restore the value in a0
	lw $ra, 0($sp)	# restore the value in a1
	addi $sp, $sp, 16 # give space on the stack back
	
	jr $ra	# return to the main program

.data
Ptr: .word 0