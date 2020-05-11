                .data
input_array:    .word     0:40
symTab:         .word     0:40
token_prompt:   	 .asciiz   "Enter a new token: "
type_token_prompt:       .asciiz   "Enter a new  type: "
print_token_prompt:      .asciiz   "\nDumping symTab: \n\n"
exit_token_prompt:	 .asciiz   "\n\nExiting the program..."

        .text
main:
        li      $s0, 0      # index to input_array
        li	$s1, 0		# index for symTab
        li	$s2, 0		# LOC
        li	$s3, 0		# TEMP index for looping, clearing, dumping, etc.
getTokens:
	# Print out token_prompt
    	la  	$a0, token_prompt   		# Loads addr of token_prompt_input into $a0
    	li  	$v0, 4          	# Code 4 means output string.
    	syscall

	# Press enter between the label and the number.

	# Input the label.
    	la  	$a0, input_array($s0)      	# Loads the address of input into $a0
    	li  	$a1, 10         	# Buffer is 8 bytes long for 8 characters.
    	li  	$v0, 8          	# Code 8 means input a string.
    	syscall
    	
    	#  Move forward by 8, to be able to save the integer.
    	addi	$s0, $s0, 8
    	    	
	# Print out token_prompt 2
    	la  	$a0, type_token_prompt   		# Loads addr of token_prompt_input into $a0
    	li  	$v0, 4         	 	# Code 4 means output string.
    	syscall

    	# Input the number.
	li	$v0, 5			# Code 5 means input an integer.
	syscall
	
	# Save the number to input_arrayay
	sw 	$v0, input_array($s0)

	# Save the current input_arrayay value to $s1
	lw	$s3, input_array($s0)

	# Move the array forward by 4. Since we stored a 4 byte integer.
	addi	$s0, $s0, 4
	
	
# Check to see what we found.
chkVar:
        beq     $s3, 2, label		# 0x32 = decimal #2, which is a label.
        beq	$s3, 4, control		# 0x34 = decimal #4, which is a colon or comma.
        beq	$s3, 5, money		# 0x35 = decimal #5, which is the money sign.
        beq	$s3, 6, pound		# 0x36 = decimal #6, which is the pound sign.

        # If we get here, the user entered something strange so just quit!
        b exit


# We found a label, so save the label & it's value into symTab. Also DEFN = 1.
label:
	# Save the two words
	subi 	$s4, $s0, 12		# Go back 12 spaces.
	lw	$v0, input_array($s4)		# Load the first word into $v0
	sw	$v0, symTab($s2)	# Save that word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Get the next word
	sw	$v0, symTab($s2)	# Save this word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the type (integer)
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Save the int into $v0
	sw	$v0, symTab($s2)	# Save the int into the symTab array
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the DEFN (integer)
	li	$v0, 1			# Save 1 into $v0
	sw	$v0, symTab($s2)	# Save DEFN into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	b getTokens 			# Once we've added the label, value & DEFN into symTab, return to getTokens


# Found a colon or a comma, so save that + it's value into symTab. Also DEFN = 0.
control:
	# Save the comma or colon
	subi 	$s4, $s0, 12		# Go back 12 spaces.
	lw	$v0, input_array($s4)		# Load the first word into $v0
	sw	$v0, symTab($s2)	# Save that word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Get the next word
	sw	$v0, symTab($s2)	# Save this word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the type (integer)
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Save the int into $v0
	sw	$v0, symTab($s2)	# Save the int into the symTab array
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the DEFN (integer)
	li	$v0, 0			# Save 1 into $v0
	sw	$v0, symTab($s2)	# Save DEFN into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4
	
	b getTokens 			# Once we've added the label, value & DEFN into symTab, return to getTokens


# Found a money sign, so save a "$", its value (5) and DEFN = 0 into symTab.
money:
	# Save the money sign
	subi 	$s4, $s0, 12		# Go back 12 spaces.
	lw	$v0, input_array($s4)		# Load the first word into $v0
	sw	$v0, symTab($s2)	# Save that word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Get the next word
	sw	$v0, symTab($s2)	# Save this word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the type (integer)
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Save the int into $v0
	sw	$v0, symTab($s2)	# Save the int into the symTab array
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the DEFN (integer)
	li	$v0, 0			# Save 1 into $v0
	sw	$v0, symTab($s2)	# Save DEFN into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	b getTokens 			# Once we've added the label, value & DEFN into symTab, return to getTokens


# Found the pound sign, so we're done! Save the sign, its value (6) and DEFN = 0.
pound:
	# Save the pound sign
	subi 	$s4, $s0, 12		# Go back 12 spaces.
	lw	$v0, input_array($s4)		# Load the first word into $v0
	sw	$v0, symTab($s2)	# Save that word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Get the next word
	sw	$v0, symTab($s2)	# Save this word into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the type (integer)
	addi	$s4, $s4, 4		# Go ahead 4 bytes to get the next word.	
	lw	$v0, input_array($s4)		# Save the int into $v0
	sw	$v0, symTab($s2)	# Save the int into the symTab array
	addi	$s2, $s2, 4		# Move LOC forward by 4.
	
	# Save the DEFN (integer)
	li	$v0, 0			# Save 0 into $v0
	sw	$v0, symTab($s2)	# Save DEFN into symTab
	addi	$s2, $s2, 4		# Move LOC forward by 4.

	# FIRST: Print symTab.
	# SECOND: Clear input_array
	# FINALLY: exit.
	
    	la  	$a0, print_token_prompt   	# Loads address of token_prompt_input into $a0
    	li  	$v0, 4          	# Sys Call Code 4 means output string.
    	syscall

    	# We'll need an index variable and the address of symTab.
    	li	$s1, 0			# index for symTab. LOC ($s2) will be our max number to loop through.
	la 	$a1, symTab		# Loads address of symTab into $a1.	
        
        jal     printSymTable		# Go dump the symTab array
        
printSymTable:
	beq	$s1, $s2, setUpClear	
	
    	li	$s3, 0			
    	jal 	printWords	
    	
    	addi	$s1, $s1, 8		
    	
    	lw  	$a0, symTab($s1)   
    	li  	$v0, 1          
    	syscall
    	
    	addi	$a1, $a1, 4	
    	addi	$s1, $s1, 4		
    	
    	lw  	$a0, symTab($s1)   	
    	li  	$v0, 1          
    	syscall
    	
    	addi	$a1, $a1, 4
    	addi	$s1, $s1, 4	
    	
	b	printSymTable
	
printWords:
	beq	$s3, 8, returnToFunction
	
	lb	$a0, ($a1)
	li 	$v0, 11
	syscall

	addi	$a1, $a1, 1	
	addi	$s3, $s3, 1	
	
	b 	printWords


returnToFunction:
	jr	$ra

setUpClear:
	li 	$s3, 0   	

clearInArr:
	beq	$s0, $s3, exit
	sb 	$0, input_array($s3) 
    addi	$s3, $s3, 1	
    b clearInArr	
        

# Exiting the program at this point.
exit:
	# Print out token_prompt
    	la  	$a0, exit_token_prompt   
    	li  	$v0, 4        
    	syscall

	# Exit the program.
	li	$v0, 10
	syscall	
