
##########################################################################
# Created by:  Brokering, Francis
#              CruzID: fbrokeri
#              4 June 2020
#
# Assignment:  Lab 5: Functions and Graphics
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Spring 2020
# 
# Description: This program contains functions that perform graphic operationsn on a small simulated display. First it clears the whole display to a specific color. Next it draws nine solid circles, and at the end it will draw eight unfilled colored circles. We used Bitmap display to display these circles.
# 
# Notes:       This program is intended to be run from the MARS IDE. it uses 128 x 128 memory-mapped bitmap graphics display in MARS
##########################################################################

#Spring20 Lab5 Template File

##########################################################################
# Macro that stores the value in %reg on the stack 
#  and moves the stack pointer.
# pseudocode for push(%reg)
#
# def push(value):
# 	$sp = $sp - 4
# 	%$sp == value					#store word to pointed location "sw %reg 0($sp)"
#
##########################################################################
.macro push(%reg)
	subi $sp $sp 4					#allocate space to store in stack
	sw %reg 0($sp)					#store word to the pointed location
.end_macro 

##########################################################################
# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
#
# pseudocode for pop(%reg)
#
# def pop(value)
#	value == $sp					#load word from pointed location "lw %reg 0($sp)"
#	%sp = $sp + 4
#
##########################################################################
.macro pop(%reg)
	lw %reg 0($sp)					#load word from the pointed location
	addi $sp $sp 4					#release the space to change pointer
.end_macro

##########################################################################
# Macro that takes as input coordinates in the format
# (0x00XX00YY) and returns 0x000000XX in %x and 
# returns 0x000000YY in %y
#
#pseudocode for getCoordinates(%input %x %y)
#
# def getCoordinates(input, x, y):
#
#	y = and operation (input, 0x0000FFFF)
#	x =  input(shift right logical by 16)
#	input = input
#
##########################################################################
.macro getCoordinates(%input %x %y)
	move %y, %input					#sotre input value 0x00XX00YY in  y
 	andi %y, %y, 0x0000FFFF				#do an and operation with 0x0000FFFF to get 0x000000YY
 	move %x, %input					#store input valie 0x00XX00YY in x
 	srl %x, %x 16					#shift right logical to get 0x000000XX
.end_macro

##########################################################################
# Macro that takes Coordinates in (%x,%y) where
# %x = 0x000000XX and %y= 0x000000YY and
# returns %output = (0x00XX00YY)
#
#pseudicide for formatCoordinates(%output %x %y)
#
# def formatCoordinates(output, x, y):
#	output = (x shift logical left by 16) + y
#
#
##########################################################################

.macro formatCoordinates(%output %x %y)
 	sll %output, %x, 16				#shift left logical 0x000000XX by 16 to get 0x00XX0000
 	or %output, %output, %y				#0x00XX0000 or 0x000000YY to get 0x00XX00YY
.end_macro 	


.data
originAddress: .word 0xFFFF0000

.text
j done
    
    done: nop
    li $v0 10 						#end program
    syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
#Clear_bitmap: Given a color, will fill the bitmap display with that color.
#   Inputs:
#    $a0 = Color in format (0x00RRGGBB) 
#   Outputs:
#    No register outputs
#    Side-Effects: 
#    Colors the Bitmap display all the same color
#*****************************************************
#pseudocode for clear_bitmap
#
# address = 0xFFFF0000
# last_address = 0xFFFFFFFC
# while address <= last address
#	address == color				#store color in address "sw $color, (address)"
# address = address + 4
#
##########################################################################

clear_bitmap: nop
	li $t0, 0xFFFF0000				#make $t0 the value 0xFFFF0000 (address)
	pcolor: nop				
	bgt $t0, 0xFFFFFFFC, exitclear_bitmap		#loop until it fills all pixels with color
	sw $a0, ($t0)					#store color in address
	addi $t0, $t0, 4				#increment address by for to store the next one
	j pcolor					#jump back to loop
	exitclear_bitmap:				#end loop when all the pixels are filled
	nop
	jr $ra						
	
#*****************************************************
# draw_pixel:
#  Given a coordinate in $a0, sets corresponding value
#  in memory to the color given by $a1	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#*****************************************************
#pseudocode for draw_pixel
#
# getCoordinates(cooedinate x y)
# location = 4 * (y * 128 + x)
# address = location + 0xFFFF0000
# address == color					#store color in address "sw $color, (address)"
#
##########################################################################
draw_pixel: nop
	push($t0)
	push($t1)
	push($s0)
	push($s1)
	push($s2)
	push($s3)
	push($s4)
	push($s5)
	push($s6)
	push($s7)
	
	
	li $s0, 0					#have $s0 equal 0
	li $s1, 0					#have $s1 equal 0
	li $s2, 0					#have $s2 equal 0
	getCoordinates($a0 $s1 $s0)			#get coordinate and store values to x and y
	mul $s0, $s0, 128				#multiply x by 128
	add $s0, $s0, $s1				#add y to product above
	mul $s0, $s0, 4					#multiply by for because each address increments by 4
	addi $s2, $s0, 0xFFFF0000			#add above value to the strting point address
	sw $a1, ($s2)					#store the color given to the address above
	
	pop($s7)
	pop($s6)
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	pop($t1)
	pop($t0)
	
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#   Outputs:
#    Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
#pseudocode for get_pixel
#
# getCoordinates(cooedinate x y)
# location = 4 * (y * 128 + x)
# address = location + 0xFFFF0000
# output == address(colorstored in this address)	#recive color stored in address and return it as an output "lw $output, ($address)"
#
##########################################################################

get_pixel: nop
	push($t0)
	push($t1)
	push($s0)
	push($s1)
	push($s2)
	push($s3)
	push($s4)
	push($s5)
	push($s6)
	push($s7)
	
	li $s4, 0					#have $s4 equal 0
	li $s5, 0					#have $s5 equal 0
	li $s6, 0					#have $s6 equal 0
	getCoordinates($a0 $s5 $s4)			#get coordinate and store values to x and y
	mul $s4, $s4, 128				#multiply x by 128
	add $s4, $s4, $s5				#add y to product above
	mul $s4, $s4, 4					#multiply by for because each address increments by 4
	addi $s6, $s4, 0xFFFF0000			#add above value to the strting point address
	lw $v0, ($s6)					#load color stored in the address
	
	pop($s7)
	pop($s6)
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	pop($t1)
	pop($t0)
	jr $ra

#***********************************************
# draw_solid_circle:
#  Considering a square arround the circle to be drawn  
#  iterate through the square points and if the point 
#  lies inside the circle (x - xc)^2 + (y - yc)^2 = r^2
#  then plot it.
#-----------------------------------------------------
# draw_solid_circle(int xc, int yc, int r) 
#    xmin = xc-r
#    xmax = xc+r
#    ymin = yc-r
#    ymax = yc+r
#    for (i = xmin; i <= xmax; i++) 
#        for (j = ymin; j <= ymax; j++) 
#            a = (i - xc)*(i - xc) + (j - yc)*(j - yc)	 
#            if (a < r*r ) 
#                draw_pixel(x,y) 	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of circle center in format (0x00XX00YY)
#    $a1 = radius of the circle
#    $a2 = color in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_solid_circle: nop
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	push($t5)
	push($t6)
	push($t7)
	push($t8)
	push($t9)
	li $t0, 0					#clear any value storedin $t0 and make it equal 0
	li $t1, 0					#clear any value storedin $t1 and make it equal 0
	li $t2, 0					#clear any value storedin $t2 and make it equal 0
	li $t3, 0					#clear any value storedin $t3 and make it equal 0
	li $t4, 0					#clear any value storedin $t4 and make it equal 0
	li $t5, 0					#clear any value storedin $t5 and make it equal 0
	li $t6, 0					#clear any value storedin $t6 and make it equal 0
	li $t7, 0					#clear any value storedin $t7 and make it equal 0
	li $t8, 0					#clear any value storedin $t8 and make it equal 0
	li $t9, 0					#clear any value storedin $t9 and make it equal 0
	getCoordinates($a0 $t1 $t0)			#$a0 = coordinate $t0 = x $t1 = y

	sub $t2, $t0, $a1				# t2 = min x $a1 = radius
	add $t3, $t0, $a1				# t3 = max x
	sub $t4, $t1, $a1				# t4 = min y
	add $t5, $t1, $a1				# t5 = max y
	xloop: nop
	bgt $t2, $t3, xdone				# while xmin < xmax
	sub $t4, $t1, $a1				# x - r

	yloop: nop
	bgt $t4, $t5, ydone				#while ymin < ymax
	sub $t9, $t2, $t0 				#$t5 = (i – xc)
	mul $t9, $t9, $t9				#(i – xc)(i – xc)
	sub $t6, $t4, $t1				#(j – yc)
	mul $t6, $t6, $t6				#(j – yc)(j – yc)
	add $t7, $t9, $t6				#(i – xc)*(i – xc) + (j – yc)*(j – yc)	
	mul $t8, $a1, $a1				#r^2
	

	
	bge $t7, $t8, skipdraw_pixel			#if (a < r*r ) draw_pixel
	push($a1)
	push($ra)
	add $a1, $a2, $zero				#store color in $a1

	formatCoordinates($a0 $t4 $t2)			# get address by x and y values
	
	jal draw_pixel					#if (a < r*r ) draw_pixel(x,y)
	nop
	pop($ra)
	pop($a1)
	skipdraw_pixel: nop
	addi $t4, $t4, 1				#incremtent min y
	j yloop						#jump back to loop y coordinate
	ydone:nop
	addi $t2, $t2, 1				#increment min x
	j xloop						#jump back to loop x coordinate
	xdone: nop					#end of loop

	pop($t9)
	pop($t8)
	pop($t7)
	pop($t6)
	pop($t5)
	pop($t4)
	pop($t3)
	pop($t2)
	pop($t1)
	pop($t0)
	
	jr $ra
		
#***********************************************
# draw_circle:
#  Given the coordinates of the center of the circle
#  plot the circle using the Bresenham's circle 
#  drawing algorithm 	
#-----------------------------------------------------
# draw_circle(xc, yc, r) 
#    x = 0 
#    y = r 
#    d = 3 - 2 * r 
#    draw_circle_pixels(xc, yc, x, y) 
#    while (y >= x) 
#        x=x+1 
#        if (d > 0) 
#            y=y-1  
#            d = d + 4 * (x - y) + 10 
#        else
#            d = d + 4 * x + 6 
#        draw_circle_pixels(xc, yc, x, y) 	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of the circle center in format (0x00XX00YY)
#    $a1 = radius of the circle
#    $a2 = color of line in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_circle: nop

		
	li $t2, 0					# x = 0 
	li $t3, 3					# $t3 = constant 3
	move $t6, $a1					# t6 = r =y
	mul $t4, $t6, 2					
	sub $t5, $t3, $t4 				# d = 3 - 2 * r 
	
	
	
	
	move $a1, $a2					#store color of line in format (0x00RRGGBB) in $a1
	push($a2)
	push($a0)
	move $a2, $t2					# $a2 = current x value from the Bresenham's circle algorithm
	move $a3, $t6					# $a3 = current y value from the Bresenham's circle algorithm
	push($ra)
	jal draw_circle_pixels				#jump to draw circles
	nop
	pop($ra)
	pop($a0)
	pop($a2)
	
	
	continue_draw_circle:
	nop
	blt $t6, $t2, end_draw_circle			# while (y >= x)
	addi $t2, $t2, 1				# x = x+ 1
	ble $t5, 0, else				# if (d > 0)
	subi $t6, $t6, 1				# y=y-1  
	sub $t7, $t2, $t6				# (x - y)
	mul $t8, $t7, 4					# 4 * (x - y)
	addi $t8, $t8, 10				# 4 * (x - y) + 10
	add $t5, $t5, $t8				# d + 4 * (x - y) + 10
	j skipelse
	else:						#else
	nop
	mul $t9, $t2, 4					# 4 * x
	addi $t9, $t9, 6				# 4 * x + 6 
	add $t5, $t5, $t9				#d + 4 * x + 6
	skipelse:
	nop
	move $a2, $t2					# $a2 = current x value from the Bresenham's circle algorithm
	move $a3, $t6					# $a3 = current y value from the Bresenham's circle algorithm
	push($a0)
	push($ra)
	jal draw_circle_pixels				#jump to draw cicles on display map
	pop($ra)
	pop($a0)
	j continue_draw_circle				#jump to the beginning of the loop
	nop
	end_draw_circle:				#end of loop
	nop
	skp:
	
	jr $ra
	
#*****************************************************
# draw_circle_pixels:
#  Function to draw the circle pixels 
#  using the octans' symmetry
#-----------------------------------------------------
# draw_circle_pixels(xc, yc, x, y)  
#    draw_pixel(xc+x, yc+y) 
#    draw_pixel(xc-x, yc+y)
#    draw_pixel(xc+x, yc-y)
#    draw_pixel(xc-x, yc-y)
#    draw_pixel(xc+y, yc+x)
#    draw_pixel(xc-y, yc+x)
#    draw_pixel(xc+y, yc-x)
#    draw_pixel(xc-y, yc-x)
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of circle center in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#    $a2 = current x value from the Bresenham's circle algorithm
#    $a3 = current y value from the Bresenham's circle algorithm
#   Outputs:
#    No register outputs	
#*****************************************************
draw_circle_pixels: nop
	
	getCoordinates($a0 $t1 $t0)			#$a0 = coordinate $t0 = xc $t1 = yc
	
	add $t3, $t0, $a2				# xc+x
	add $t4, $t1, $a3				# yc+y
	formatCoordinates($a0 $t4 $t3)			#$a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)					
	jal draw_pixel					#jump to draw_pixel
	nop
	pop($ra)
	
	
	sub $t3, $t0, $a2				# xc-x
	add $t4, $t1, $a3				# yc+y
	formatCoordinates($a0 $t4 $t3)			# $a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)
	jal draw_pixel					#jump to draw_pixel
	nop	
	pop($ra)
	
	add $t3, $t0, $a2				# xc+x
	sub $t4, $t1, $a3				# yc-y
	formatCoordinates($a0 $t4 $t3)			# $a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)
	jal draw_pixel					#jump to draw_pixel
	nop	
	pop($ra)	

	sub $t3, $t0, $a2				# xc-x
	sub $t4, $t1, $a3				# yc-y
	formatCoordinates($a0 $t4 $t3)			#$a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)
	jal draw_pixel					#jump to draw_pixel
	nop	
	pop($ra)
	
	add $t3, $t0, $a3				# xc+y
	add $t4, $t1, $a2				# yc+y
	formatCoordinates($a0 $t4 $t3)			#$a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)
	jal draw_pixel					#jump to draw_pixel
	nop
	pop($ra)				
	
	
	sub $t3, $t0, $a3				# xc-y
	add $t4, $t1, $a2				# yc+y
	formatCoordinates($a0 $t4 $t3)			#$a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)
	jal draw_pixel					#jump to draw_pixel
	nop	
	pop($ra)
		
	add $t3, $t0, $a3				# xc+y
	sub $t4, $t1, $a2				# yc-y
	formatCoordinates($a0 $t4 $t3)			# $a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)
	jal draw_pixel					# jump to draw_pixel
	nop
	pop($ra)
	
	sub $t3, $t0, $a3				# xc-y
	sub $t4, $t1, $a2				# yc-y
	formatCoordinates($a0 $t4 $t3)			# $a0 = coordinates of circle center in format (0x00XX00YY)
	push($ra)
	jal draw_pixel					# jump to draw_pixel
	nop
	pop($ra)
	
	jr $ra
