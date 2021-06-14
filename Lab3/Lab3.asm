##########################################################################
# Created by: Brokering, Francis
# CruzID: fbrokeri
# 11 May 2020
#
# Assignment: Lab3: ASCII-risks (Asterisks)
# CSE 12, Computer Systems and Assembly Language
# UC Santa Cruz, Spring 2020
#
# Description: This program prints triangles with asterisks given a hwight from the user
#
# Notes This program runs on Mars
##########################################################################
#Pseudo code written in Python3
#
# height_of_triangle = int(input("Enter the height of the pattern (must be greater than 0): "))
# while height_of_triangle <= 1:
#   print("Invalid Entry!")
#   height_of_triangle = int(input("Enter the height of the pattern (must be greater than 0): "))
# print("\n")
# i = 1
# x = 1
# c = 0
# while i <= height_of_triangle:
#   k = 2*(height_of_triangle - i)
#   x2 = x
#   while x <= (c+i):
#     print(x, "  ", end="")
#     x += 1  
#   while k > 0:
#     print("*", "  ", end="")
#     k -= 1
#   while x > x2:
#     x -= 1
#     print(x, "  ", end="")
#     #if (x - x2) > 0:
#       #print(" ", end="")
#   print("\n")
#   c = c + i
#   x = x + i
#   i += 1
########################################################################## 


.data
prompt: .asciiz "Enter the height of the pattern (must be greater than 0):	"
newline: .asciiz "\n"
invalidentry: .asciiz "Invalid Entry!"
.text

start: nop
#prompt user to enter height
li $v0, 4 
la $a0, prompt
syscall

#Get the height from user
li $v0, 5
syscall
#if integer is not positive return "Invalid Entry!"
bgt $v0, $zero, skip
li $v0, 4
la $a0, invalidentry
syscall
li $v0, 4 	#prep to print new line
la $a0, newline #print new line
syscall
j start
skip:
		#store the height in $t0
move $t0, $v0
		#assigning integers to use in while loop
		#$t1 = i, $t2 = x, $t3 = c ,$t0 = height 
li $t9, 2 	#constant 
li $t1, 1 	#i  used to end loop once it reaches the value to stop the loop. incremented in while loop 
li $t2, 1 	#x  the value that is printed around the triangle. incremented in loop PrintIntLeftSideOfTriangle
li $t3, 0	#c  used to end loop once it reaches the value to stop the loop. incremented in while loop

li $v0, 4       #prep for printing
la $a0, newline #print new line
syscall

while:  nop 				# loops while i is =< height given by input
	add $t4, $t1, $t3 		# $t4 = i + c 
	bgt $t1, $t0, exit1    		#loop while i is less or eaqual to the height of the triangle
	nop
	add $t6, $zero, $t2 		# $copy the value x and move it to $t6
PrintIntLeftSideOfTriangle: nop		#loops while x =< (c + i)
	bgt $t2, $t4, exit2 		#loops until finished printing all the integers on the left side of trianle
	nop
	li $v0, 1 			#prep for print int
	move $a0, $t2 			#print integers on left
	syscall
				
	li $v0, 11  			#prep for printing
	li $a0, 9  			#print tab after int
	syscall 
			
	addi $t2, $t2, 1 		#incrementing x
				
	j PrintIntLeftSideOfTriangle    #jump back to the beginning of loop
	exit2:
	sub $t5, $t0, $t1 		#(height -i)
	mul $t5 $t9, $t5  		#2(height-i)
PrintAsterisks: nop
	beq  $t5, $zero, exit3  	#loops and prints "*" until $t5 = 0 
	nop
	li $v0, 11            		#prep to print "*"
	li $a0, 42    			#print $t5 numbers of "*" where $t5 = 2((height of triangle) - i))
	syscall
				
	li $v0, 11  			#prep for printing 
	li $a0, 9   			#print tab after "*"
	syscall      
				
	subi $t5, $t5, 1   		# -1 to prevent infinate loop
	j PrintAsterisks                #jump to the biginning of loop
	exit3:
PrintIntRightOfTriangle: nop
	ble $t2, $t6, exit4 		#loop if x is greater than $t6
	nop
	subi $t2, $t2, 1 		#subtract 1 from x 
	li $v0, 1 			#prep for print int
	move $a0, $t2 			#print integer on right
	syscall
				
	sub $t8, $t2, $t6		#used to stop  printing a tab after the last integer of the row
noTabIfLastInt: nop
	beq $t8, $zero, next 		#if $t8 = 0, skips printing tab after integer
	nop
	li $v0, 11  			#prep for printing tab
	li $a0, 9   			#print tab
	syscall 
	next:
	j PrintIntRightOfTriangle  	#jump back to beginnig of loop
	exit4:
			 
	li $v0, 4 			#prep to print new line
	la $a0, newline 		#print new line
	syscall
			
	add $t3, $t3, $t1 		# c = c + i
	add $t2, $t2, $t1  		# x = x + i
	addi $t1, $t1, 1   		# i = i +1
	j while  			#jump back to beginning of loop
				
	exit1:
li $v0, 10  				#end program
syscall
		
