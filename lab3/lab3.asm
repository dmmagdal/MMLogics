;Diego Magdaleno
;dmmagdal
;Lab 3 Decimal Converter
;TA Mike Powell

	.ORIG x3000	
;R0 holds strings INTRO and INSTR
;R1 holds EOL
;R2 holds user INPUT
;R3 holds MASKaddress
;R4 holds counters TEN and COUNT
;R5 holds character size of INPUT and 2SC of INPUT
;R6 holds Flag
;R7 temporarily holds R5


;print out introduction
	LEA R0, INTRO			;Welcome message (prints on once at program startup)
	PUTS	


;print out instructions
STRTPT	LEA R0, INSTRU				;Sort of "real" starting point of the program
	AND R6, R6, #0				;Initialize the flag to "0". flag is a marker to check if the input is negative for flag != 0
	LEA R3, MASK0				;Initialize R3 to MASK0	

	PUTS

	AND R5, R5, #0				;Clear out R5


;read user input character by character
READ	GETC					;Read chars from user input
	OUT					;Allow user to see their input 
	LD R1, EOL				;Load EOL to R1
	ADD R2, R0, R1				;Add INPUT and EOL(-10) to inputstream (R2)

	BRnp EXITX				;If user didnt enter EOL, did it enter X?
	BR CNVRT				;If X wasn't entered, start converting decimal


;check to see if x was entered as user input
EXITX	LD R1, X				;Load X to R1
	ADD R2, R0, R1				;Add INPUT - EOL
	BRnp NEGSIGN				;If X wasn't entered, check for negative sign
	BR END					;If X was entered, quit the program


;check for negative sign
NEGSIGN	LD R1, NEG				;Load NEG to R1
	ADD R2, R0, R1				;Add INPUT - NEG(R1)
	BRnp CRNUM				;If INPUT is negative or positive, go on to create the number

	NOT R6, R6				;Change flag to be not zero for negative number
	BR READ					;Go back to reading the next char in INPUT


;create number for negative input
CRNUM	LD R1, GETASC				;Load GETASC to R1
	ADD R2, R0, R1				;Add R0 and GETASC (-48) to obtain INPUT ASCII value and load it to R2
	AND R4, R4, #0				;Clear out R4
	ADD R4, R4, #9				;Initialize R4 to 9 (COUNT)
	AND R7, R7, 0				;Clear out R7
	ADD R7, R7, R5				;Set R7 to initial value of R5


;multiplies character size of INPUT (R5) by 10 (TEN) and adds it to INPUT (R2)
MULTI	ADD R5, R5, R7	
	ADD R4, R4, -1				;Decrement COUNT by 1
	BRnp MULTI				;Loop if TEN != 0
	ADD R5, R5, R2				;ADD INPUT to number			 
	BR READ					;Go back to READ for another number


;convert INPUT to 2SC
CNVRT	AND R4, R4, 0				;Clear out R4
	ADD R4, R4, 15				;Set R4 to 15 (COUNT)
	ADD R6, R6, 0				;Add nothing to Flag (R6). Just use it to make it the last register used
	BRz PSTN				;If Flag = 0, we dont need to convert the number with additive inverse
	NOT R5, R5				;Invert R5
	ADD R5, R5, 1				;Add the 1 (additive inverse complete)


;AND MASKaddress to print binary
PSTN	LDR R1, R3, 0				;Store MASKaddress (MASK0/R3) to R1 to be used later
	AND R2, R5, R1				;AND R5 (final number) and R1 
	BRz PRINTZ				;If the result = 0, print out a zero
	LD R0, ONE				;Load ONE to R0
	OUT					;Print out
	BR INCRMNT				;Loop to increment


;print a '0'
PRINTZ	LD R0, ZERO				;Load ZERO to R0
	OUT					;Print out


;increments the MASKaddress and decrement COUNT
INCRMNT	ADD R3, R3, 1				;Increment the MASKaddress by 1
	ADD R4, R4, -1				;Decrement COUNT by 1
	BRzp PSTN				;Go to PSTN if COUNT >= 0

	BR STRTPT				;Loop back to the start of the program until user enters X
		

END	HALT					;End of program


;variables/ labels
EOL	.FILL -10	;End of Line (Enter key)
X	.FILL -120	;Ascii value of "x"
NEG	.FILL -45	;Ascii value of negative sign "-"
GETASC	.FILL -48	;Subtract this value to obtain a number's ASCII value
INTRO	.STRINGZ "Welcome to this conversion program"
INSTRU	.STRINGZ "\nEnter a decimal number or enter X to quit\n"
ZERO	.FILL 48	;ASCII value of zero
ONE	.FILL 49	;ASCII value of one
MASK0	.FILL x8000	;MASKs from x8000 (1000 0000 0000 0000) to x0001 (0001)
MASK1	.FILL x4000
MASK2	.FILL x2000 
MASK3	.FILL x1000
MASk4	.FILL x0800
MASK5	.FILL x0400
MASK6	.FILL x0200
MASK7	.FILL x0100
MASK8	.FILL x0080
MASK9	.FILL x0040
MASK10	.FILL x0020
MASK11	.FILL x0010
MASK12	.FILL x0008
MASK13	.FILL x0004
MASK14	.FILL x0002
MASK15	.FILL x0001

.END