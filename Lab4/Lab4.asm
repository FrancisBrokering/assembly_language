##########################################################################
# Created by:  Brokering, Francis
#              CruzID: fbrokeri
#              22 May 2020
#
# Assignment:  Lab4: Sorting Integers
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Spring 2020
# 
# Description: This program recieves up to eight hexadecimal inputs and prints it out as hexidecimal, integers, and then sorted integers in the order of least to greates
# 
# Notes:       This program is intended to be run from the MARS IDE. It does not check for input errors and can only recieve inputs as hex
##########################################################################
#pseudocode
#
#
#print(“Program arguments: \n”)
# while i < length of 
# print( $a1)
# print(space)
# store $a1 in array
# $a1 += 4
# i += 1
# print(\n)
# print("Integer values: \n")
# iterate over each hexadecimal by character
# for num in array
# 	for char in num
# 	ignore 0x
# 	if char = 0~9 (which is 0x30~0x39 in ascii)
# 		value_deci = char -0x30
# 	elif char = A~F (which is 0x41~0x46 in ascii)
# 		value_deci = char -0x37
# 	if length of hex is 1 
# exit for loop
# 	else
# 		value_deci shift logical left by 4 (same as x16 in decimal)
# 	if i > 2
# 		value_deci =value_deci + char 
# store value_decdi in new array called sorted_array
# 	i += 1
# print(value_deci)
# print(space)
# print(\n)
# print("Sorted values: \n")
# i = 0
# j = 0
# while j < len(stored_array) 
# While i < len(sorted_array)
# first_value = sorted_array[0]
# second_value = sorted_array[1]
# If first_value > second_value
# 	swap first_value and second_value
# Store values back to sorted_array
# i += 1
# 	j += 1
# i = 0
# while i < len(sorted_array)
# print(sorted_array[i])
# print(\n) 
# #######Example conversion##########
# If input is 0x4AB
# It is 307834414200 where 3078 = 0x, 4 = 34, A = 41, B = 42
# ignore 0x(which is 3078)
# 34 - 0x30 = 4   (0100 in binary)
# 41 - 0x37 = 10 (1010 in binary)
# 42 - 0x37 = 11 (1011 in binary)
# 0100 shift logical right by 4 is 
# 0100 0000
# Add 1010 gives us
# 0100 1010
# Shift logical right by 4 again gives us
# 0100 1010 0000
# Add 1011 gives us
# 0100 1010 1011
# Which is 0x4AB in binary and 1195 in decimal



.data
IntToString: .space 64 			#for extra credidt
Array: .space 64
ArraySorted: .space 64
ProgramArguments: .asciiz "Program arguments: \n"
IntValues: .asciiz "Integer values: \n"
StoredVlues: .asciiz "Sorted values: \n"
newline: .asciiz "\n"
space: .asciiz " "
.text 


add $t0, $t0, $a0			#store number of inputs in $t0
li $v0, 4				#prep for print
la $a0, ProgramArguments 		#print "Progrma arguments: "
syscall
 
li $v0, 4				#prep for print
lw $a0 ($a1)				#print first input as hex
syscall 
add $t5, $a0, $0			#store the value in $a0 which is the first inpur to $t5 
addi $t6, $zero, 0			#Create a register with 0 stored in it
add $t7, $t5, $0			#copy the value in $t5 and store it in $t7
sw $t5, Array($t6)			#store the first input into the beginning of array (0)
addi $t6, $t6, 4			#increment the location of the array by 4 cuz int takes 4 bytes


PrintInputs: nop			#loop till it prints all the given inpusts 

	addi $t1, $t1, 1 		#incriment to prevent infinite loop
	ble $t0, $t1, exitloop 		#exit loop when finished printing all given inputs
	nop

	li $v0, 4			#prep for printing
	la $a0, space			#print space 
	syscall

	addi $a1, $a1, 4		#increment adress by for to get the next value
	lw $a0 ($a1)			#increment adress and print input
	syscall

	add $t5, $a0, $0		#store value in $a0 which is the next input to $t5
	sw $t5, Array($t6)		#add that value in the next location of the array
	addi $t6, $t6, 4		#shift location of array to exept next input

j PrintInputs				#jump back to beginning of the loop
nop
exitloop: nop
 
li $v0, 4				#prep for printing
la $a0, space				#print space at the end of last input
syscall

li $v0, 4 				#prep for print new line
la $a0, newline 			#print new line
syscall

li $v0, 4 				#prep to print new line
la $a0, newline 			#print new line
syscall

#########################################finish printing given input as hex
li $v0, 4				#prep for printing
la $a0, IntValues			#print "Integer values:"
syscall

li $t1, 0				#store the value 0 in $t1 
addi $t4, $zero, 0			#store the value 0 in $t4

IterateHex:  nop			#a loop that iterates through each char of hex and convert to int

	lw $t5, Array($t4)		#load number stored in (00) of the array and store it to $t5
	ble $t0, $t1, end		#exit loop when finish printing all integers
	nop
	addi $t1, $t1, 1		#increment to prevent infinite loop
	lb $t2 2($t5)			#store the first byte stored in $t5
	bge $t2, 0x41, Alphabet1	#if the hex is (A~F) jump to alphabet conversion
	nop
	subi $t2, $t2, 0x30		#convert value written in ascii to int by -0x30 
	BackToIterate1:	nop	
	lb $t9 3($t5)			#store the next byte in $t5 into $t9
	beq $t9, 00, NoShift		#if the given iput is one digit inlength, no need to x16
	nop
	sll $t2, $t2, 4			#shifting left by 4 in binary is the same as x16 in decimal
	lb $t3 3($t5)			#store next byte in $t5 into $t3
	bge $t3, 0x41, Alphabet2	#if the hex is (A~F) jump to alphabet conversion
	nop
	subi $t3, $t3, 0x30		#convert value written in ascii to int by -0x30 
	BackToIterate2:	nop		
	add $t2, $t2, $t3		#add the two digits given so far
	lb $t9 4($t5)			#store the next byte in $t5 and store it into $t9
	beq $t9, 00, NoShift		#if the given iput is two digits long, no need to x16
	nop
	sll $t2, $t2, 4			#shifting left by 4 in binary is the same as x16 in decimal
	lb $t3 4($t5)			#load next byte in $t5 and store it in $t3
	bge $t3, 0x41, Alphabet3	#if the hex is (A~F) jump to alphabet conversion
	nop
	subi $t3, $t3, 0x30		#convert value written in ascii to int by -0x30
	BackToIterate3: nop
	add $t2, $t2, $t3		#add all the digits to get final output as integer
	NoShift: nop
	
	sw $t2, ArraySorted($t4)	#store value in $t2 to a array to sort from greatest to least
	
##################################extra credit: use syscall 11 instead of syscall 1#####################		
li $t8, 0				#create a register that has the value 0 stored in it
li $t6, 0x30				#0x30 is used to convert decimal value back to ascii
sw $t6, IntToString($t8)		#store 0x30 to the array to create null terminal
ConvertInt1:
nop
	beq $t2, $zero, exitconversion1 #when the number equals 0 (no longer divisible) exit loop
	nop
	div $t2, $t2, 10		#divide number by 10
	mflo $t2			#store the divided value (quotient) in register $t2
	mfhi $t6			#store the remainder value in register $t6
	addi $t6, $t6, 0x30		#add 0x30 to convert to ascii
	addi $t8, $t8, 4		#increment Array location by 4 to store next value
	sw $t6, IntToString($t8)	#store ascii number in the array
j ConvertInt1
nop					#jump back to beginning of the loop
exitconversion1:
nop
	
PrintString1:
nop
	lw $t2, IntToString($t8)	#get the value stored in array atarting at the end
	subi $t8, $t8, 4		#subtract location of array by 4 to get next value
	
	li $v0, 11			#prep for printing char
	la $a0, ($t2)			#print char
	syscall
	
	ble $t8, $zero, finishprinting1 #when loop reaches the last location in array, exit loop
	nop
	j PrintString1			#jump back to print more char
	nop
	finishprinting1:
	nop
######################################end of code for extra credit###############################	
	

	li $v0, 4			#prep for printing
	la $a0, space			#print space
	syscall

	addi $t4, $t4, 4		#add 4 to get the next value stored in the array

j IterateHex
nop

	Alphabet1:			#convertion when hex is (A~F) and not (0~9)
	subi $t2, $t2, 0x37		#convert value stored as an ascii value to decimal
	j BackToIterate1		#jump back to loop to iterate through the given input 
	Alphabet2:			#second digit
	subi $t3, $t3, 0x37		#convert value stored as an ascii value to decimal
	j BackToIterate2		#jump back to loop to iterate through the given input 
	Alphabet3:			#third digit
	subi $t3, $t3, 0x37		#convert value stored as an ascii value to decimal
	j BackToIterate3		#jump back to loop to iterate through the given input 
end: nop

li $v0, 4 				#prep to print new line
la $a0, newline 			#print new line
syscall

li $v0, 4 				#prep to print new line
la $a0, newline				 #print new line
syscall

li $v0, 4
la $a0, StoredVlues
syscall

li $t2, 0				#make $t2 equal 0

sortagain:

	addi $t2, $t2, 1		#increment to prevent infinite loop
	bgt, $t2, $t0, finish		#exit loop when finish sorting 
	nop

	li $t1, 1			#make $t1 equal 1
	li $t9, 4			#make $t9 equal 4
	move $t4, $0			#make $t4 equal 0
Sort: nop

	ble $t0, $t1, bye		#exit loop when finished sorting first round
	nop
	addi $t1, $t1, 1		#increment to prevent infinte loop

	lw $t5, ArraySorted($t4)	#load number sotred in the first location (00) of the array
	lw $t6, ArraySorted($t9)	#load number stored in the next location (04) of the array
	blt $t5, $t6, noswap		#if first int is larger than second int, swap the two int
	nop
	add $t7, $t5, $0		#process of swapping numbers
	add $t5, $t6, $0		#process of swapping numbers
	add $t6, $t7, $0		#process of swapping numbers
	noswap: nop
	sw $t5, ArraySorted($t4)	#sotre value back to array in the correct order
	sw $t6, ArraySorted($t9)	#store value back to array in the correct order

	addi $t4, $t4, 4		#increment array address by 4 to get the next value in the array
	addi $t9, $t9, 4		#increment array addrees by 4 to get the next value in the array
	j Sort 
	nop			#jump back to continue sorting array
bye: nop
j sortagain 
nop

finish:
nop

li $t2, 0				#make $t2 equal 0			
li $t1, 0				#make $t1 equal 0
printSortedArray:
	bge $t1, $t0, done		#if finish printed all given inputs end loop
	nop
	lw $t5, ArraySorted($t2)	#load value stored in Array to $t5
	
	
	
##################################extra credit: use syscall 11 instead of syscall 1#####################		
li $t4, 0				#create a register that has the value 0 stored in it
li $t6, 0x30				#0x30 is used to convert decimal value back to ascii
sw $t6, IntToString($t4)		#store 0x30 to the array to create null terminal
ConvertInt:
nop
	beq $t5, $zero, exitconversion	#when the number equals 0 (no longer divisible) exit loop
	nop
	div $t5, $t5, 10		#divide number by 10
	mflo $t5			#store the divided value in register $t5
	mfhi $t6			#store the remainder in register $t6
	addi $t6, $t6, 0x30		#add 0x30 to the value to convert to ascii
	addi $t4, $t4, 4		#increment array location by four to store next value
	sw $t6, IntToString($t4)	#store value to arra
j ConvertInt
nop			
exitconversion:
nop

		
PrintString:
nop
	lw $t5, IntToString($t4)	#load value starting at the end of the array
	subi $t4, $t4, 4		#subtract 4 to get the value stored in next location of the array
	
	li $v0, 11			#prep for printing char
	la $a0, ($t5)			#print char
	syscall
	ble $t4, $zero, finishprinting	#when the loop reaches the very beginning of the array, exit loop
	nop
j PrintString
nop
finishprinting:
nop
######################################end of code for extra credit###############################	
	
	addi $t2, $t2, 4		#increment array address

	li $v0, 4			#prep for printing 
	la $a0, space			#print space
	syscall

	addi $t1, $t1, 1		#increment to prevent infinite loop
j printSortedArray			#jump back till finished printing all input values
nop
done:
nop

li $v0, 4 				#prep to print new line
la $a0, newline 			#print new line
syscall

li $v0, 10  				#end program
syscall




