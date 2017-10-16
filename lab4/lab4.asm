;Diego Magdaleno
;dmmagdal
;Lab 4 Ceasar Cipher
;TA: Mike Powell

;Using Row Major Method 

;R0 hold user input and temporary storage
;R1 hold row coordinate (for Load and Store and some BR comparisons)
;R2 hold a counter and the column coordinate (for Load and Store)
;R3 hold a counter and used for some comparisons
;R4 hold temporary values accessed from memory
;R5 hold values for calculating address of array
;R6 not used
;R7 used to return for JSR 


	.ORIG x3000
	
START	LEA R0, INTRO	;Load and printout INTRO message to R0
	PUTS		

;takes user input to see what they want to do (encrypt, decrypt, or exit)
INPUT	GETC
	LD R1, ASCX	;Load up ASCX to R1
	ADD R1, R0, R1	;Add ASCX to the input stream to see if input is x (exit)
	BRz END		;If the sum is zero (input is x), jump to END (stop the program)		
	LD R1, ASCE	;Load up ASCE to R1
	ADD R1, R0, R1	;ADD ASCE to the input stream to see if input is e (encrypt)
	BRz GETOS	;If the sum is zero (input is e), jump to get CIPHER at GETOS
	LD R1, ASCD	;Load up ASD to R1
	ADD R1, R0, R1	;ADD ASCD to the input stream to see if input is d (decrypt)
	BRz GETOS	;If the sum is zero (input is d), do the same thing and jump to get CIPHER at GETOS
	BR INPUT
	
;prompt and prep user for CIPHER offest
GETOS	ST R0, MODE	;Store Mode to R0
	LEA R0, CIPIN	;Load up CIPIN to R0
	PUTS
	AND R4, R4, 0	;Clear out R4 to store the number

;takes user input to get CIPHER offset
NUM	GETC
	ADD R1, R0, -10	;Subtract Enter key value from input stream
	BRz ENDIN	;If Enter key is the last key entered, we are done taking in the number
	OUT
	LD R1, ASCZERO	;Load ASCZERO to R1
	ADD R1, R0, R1	;Give decimal of what was pressed 
	AND R2, R2, #0 	;Clear out R2 counter
	ADD R2, R2, #9	;Set R2 to 9
	AND R3, R3, 0	;Clear out R3
	ADD R3, R3, R4	;Set R3 to R4

;convert Ascii to Decimal
MULTI	ADD R4, R4, R3	;Add R3 to R4 and store it to R4
	ADD R2, R2, -1	;Decrement R2 counter with each pass
	BRnp MULTI	;If R2 is not zero, continue back to loop
	ADD R4, R4, R1	;Add R1 (user input) to R4 (final number)
	BR NUM		;Keep getting the next number

;finish building the CIPHER, store it 
ENDIN	ST R4, CIPHER	;Store CIPHER to R4
	AND R2, R2, 0	;Clear out R2 (R2 is now Column Number)
	LEA R0, QSTRING	;Load QSTRING to R0
	PUTS

;take user input for the string to be manipulated
STRIN	GETC
	ADD R1, R0, -10	;When the user enters Enter key, they are done inputing the string
	BRz PRINSTR	;If the user entered Enter key, go the PRINTSTR
	OUT
	LD R1, MODE	;Load MODE to R1
	LD R3, ASCE	;Load ASCE to R3
	ADD R1, R1, R3	;Add MODE to ASCE. If zero, go to ISE
	BRz ISE
	AND R1, R1, 0	;Clear R1 (R1 is now Row Number)
	JSR Store	;Take in the char in R0 and store it (0, 0)
	JSR Decrypt	;Take in the char in R0 and decrypt it and then print it
	ADD R1, R1, 1	;Increment R1
	JSR Store	;Store decrypted number in R1
	ADD R2, R2, 1	;Increment R2
	BR STRIN	;Jump back to read more characters
;For encrypting, perform this otherwise you'll be decrpyting and perform the operations above
ISE	AND R1, R1, 0	;Clear out R1
	ADD R1, R1, 1	;Increment R1
	JSR Store	;Take in the char in R0 and store it to R1
	JSR Encrypt	;Take in the char in R0 and encrypt it and then print it
	AND R1, R1, 0	;Clear out R1 
	JSR Store	;Store the value in R1
	ADD R2, R2, 1	;Increment R2
	BR STRIN	;Jump back to read more characters

;print the string 
PRINSTR	JSR PrintA	;print out every cell in the array
	AND R1, R1, 0	;Clear out R1
	AND R2, R2, 0	;Clear out R2
	AND R0, R0, 0	;Clear out R0
	LD R3, ARRAYSZ	;Load ARRAYSZ to R3

;clear out the columns and rows to allow for more strings 
CLEAR	JSR Store	;Store zeroes into the array
	ADD R1, R1, 1	;Increment R1
	JSR Store	;Clear out (1, 0)
	ADD R2, R2, 1	;Increment R2
	AND R1, R1, 0	;Reset R1 back to 0
	ADD R3, R3, -1	;Decrement R3 counter
	BRp CLEAR	;Loops back and continues until each column in every row is clear
	BR START

END	HALT

;Main program variables
INTRO	.STRINGZ "\nWould you like to (e)ncrypt, (d)ecrypt, or e(x)it?\n"
CIPIN	.STRINGZ "\nPick an offset from 1 to 25 or e(x)it\n"
QSTRING	.STRINGZ "\nEnter the string\n"
STRENCR	.STRINGZ "\nEncrypted: "
STRDECR	.STRINGZ "\nDecrypted: "
ASCX	.FILL -120	;Ascii value of x
ASCE	.FILL -101	;Ascii value of e
ASCD	.FILL -100	;Ascii value of d
ASCZERO	.FILL -48	;Ascii value of 0
MODE	.FILL 0		;Sets mode for encrypt or decrypt
CIPHER	.FILL 0		;The cipher itself

;subroutine that stores the value of R0 to memory for (R1, R2)
Store
	LEA R5, ARRAY	;Load ARRAY (Starting address)
	ADD R1, R1, 0	;Make R1 the last register accessed
	BRz EMPTYST	;If R1 is empty (stores value 0), go to EMPTYST
	LD R4, ARRAYSZ	;Load size of ARRAY (200) into R4
	ADD R5, R5, R4	;Make row value (R5) 200 if the value is not zero
EMPTYST	ADD R5, R5, R2	;Add offset (Column) to current row
	STR R0, R5, 0	;Store R0 to address of R5 (R1 coords, R2 in array)
	RET

;subroutine that loads the value of R0 from memory
Load
	LEA R5, ARRAY	;Load ARRAY (Starting address)
	ADD R1, R1, 0	;Make R1 the last register accessed
	BRz EMPTYLD	;If R1 is empty, go to the EMPTYLD
	LD R4, ARRAYSZ	;Load size of ARRAY into R4
	ADD R5, R5, R4	;Make row value (R5) 200 if the value is not zero
EMPTYLD	ADD R5, R5, R2	;Add offest to current row
	LDR R0, R5, 0	;Load R0 to address of R5
	RET

;subroutine that prints each character and the appropriate label
PrintA
	ST R7, RTRNR7	;Store R7 so we can return to it after the subroutine
	LEA R0, STRENCR	;Load STRENCR to R0 and print it
	PUTS
	AND R1, R1, 0	;Clear out R1
	AND R2, R2, 0	;Clear out R2
	LD R3, ARRAYSZ	;Load ARRAY size to R3
;loop through the row 0
ROW0	JSR Load	;Load and print out the character
	OUT
	ADD R2, R2, 1	;Increment R2
	ADD R3, R3, -1	;Decrement R3 counter
	BRnp ROW0	;If R3 is not zero, continue the loop
	LEA R0, STRDECR	;Load and print STRDECR
	PUTS
	ADD R1, R1, 1	;Take characters in decrypted row
	AND R2, R2, 0	;Clear R2
	LD R3, ARRAYSZ	;Load ARRAY size 200 to R3 to reset the counter
;loop through the row 1
ROW1	JSR Load	;Load and print out the character
	OUT
	ADD R2, R2, 1	;Increment R2
	ADD R3, R3, -1	;Decrement R3 counter
	BRnp ROW1	;If R3 is not zero, continue the loop
	LD R7, RTRNR7	;Return the value of R7 (TRAP commands have changed the value up until now)
	RET

;encryption subroutine
Encrypt
	LD R3, ASCUPRA	;Load ASCUPRA to R3
	ADD R3, R0, R3	;Add user input (R0) to ASCUPRA (R3)
	BRn ENDENCR	;If R3 is negative, jump to ENDENCR
	LD R4, OFFSET	;Load OFFSET to R4
	ADD R3, R4, R3	;Add user input (R3) to OFFSET and store it to R3
	BRnz ENCHAR	;Go to ENCHAR if there is an uppercase letter
	LD R3, ASCLWRA	;Load ASCLWRA to R3
	ADD R3, R0, R3	;ADD user input (R0) to ASCLWRA (R3)
	BRn ENDENCR	;If R3 is negative, jump to ENDENCR
	ADD R3, R4, R3	;Add user input to OFFSET and store it
	BRnz ENCHAR	;Go to ENCHAR if ther is a lowercase letter
	BR ENDENCR	;If not uppercase nor lowercase, the character will not be encrypted and the subroutine would end
;encrypt the alphabetic character 
ENCHAR	LD R5, CIPHER	;Load CIPHER to R5
	ADD R3, R3, R5	;(Char-OFFSET) + CIPHER
	BRnz NOEN	;Jump out of loop to not go back to beginning of alphabet 
	ADD R0, R0, R4	;Add -25 (R4) to user input (R0)
	ADD R0, R0, -1	;Add -1 to user input so you have (R0-26)
	ADD R0, R5, R0	;Add CIPHER with curren value of R0-26
	BR ENCHAR
NOEN	ADD R0, R5, R0	;Add the CIPHER to R0
ENDENCR	RET

;decryption subroutine
Decrypt
	LD R3, ASCUPRA	;Load ASCUPRA to R3
	ADD R3, R0, R3	;Add user input (R0) to ASCUPRA (R3)
	BRn ENDDECR	;If R3 is negative, jump to ENDENCR
	LD R4, OFFSET	;Load OFFSET to R4
	ADD R3, R4, R3	;Add user input (R3) to OFFSET and store it to R3
	BRnz DECHAR	;Go to ENCHAR if there is an uppercase letter
	LD R3, ASCLWRA	;Load ASCLWRA to R3
	ADD R3, R0, R3	;ADD user input (R0) to ASCLWRA (R3)
	BRn ENDDECR	;If R3 is negative, jump to ENDENCR
	ADD R3, R4, R3	;Add user input to OFFSET and store it
	BRnz DECHAR	;Go to ENCHAR if ther is a lowercase letter
	BR ENDDECR	;If not uppercase nor lowercase, the character will not be encrypted and the subroutine would end
;decrypt the alphabetic character
DECHAR	LD R5, CIPHER	;Load CIPHER to R5
	NOT R5, R5	;Invert CIPHER
	ADD R5, R5, 1	;Add 1 to CIHER (additive inverse to create negative CIPHER)
	ADD R4, R4, -1	;Add -1 to OFFSET
	NOT R4, R4	;Invert OFFSET (reverse additive inverse to create negative OFFSET)
	ADD R3, R4, R3	;Add OFFSET to user input (R3)
	ADD R3, R3, R5	;Add negative CIPHER to user input
	BRzp NODE	;Jump out of loop to not go back to beginning of alphabet 
	ADD R0, R0, R4	;Add OFFSET to user input (R0)
	ADD R0, R0, 1	;Add 1 to user input
	ADD R0, R5, R0	;Add negative CIPHER to R0+26
	BR DECHAR
NODE	ADD R0, R5, R0	;Subtract CIPHER from R0
ENDDECR	RET

;subroutine variables
ASCLWRA	.FILL -97	;Ascii value of lowercase a
ASCUPRA	.FILL -65	;Ascii value of uppercase A
OFFSET	.FILL -25	;Variable offest 
ARRAYSZ	.FILL 200	;Size of a row
RTRNR7	.FILL 0		;Save R7 to use TRAP commands
ARRAY	.BLKW 400	;Array

	.END