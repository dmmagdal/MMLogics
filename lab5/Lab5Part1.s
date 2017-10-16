/*
Diego Magdaleno
dmmagdal
TA: Mike Powell
Lab5: Intro to Uno32 and MIPS
     */
    
    
#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
.global main
    

.text
.set noreorder

.ent main
main:
    /* this code blocks sets up the ability to print, do not alter it */
    ADDIU $v0,$zero,1
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)
    
    /* your code goes underneath this */
    LA $t1, TRISD   /*Set D to input*/
    LI $t2, 0xFFFF
    SW $t2, 0($t1)
    
    LA $t1, TRISE   /*Set E to output*/
    LI $t2, 0
    SW $t2, 0($t1)
    
    LA $t1, TRISF   /*Set F to input*/
    LI $t2, 0xFFFF
    SW $t2, 0($t1)
    
    LA $t1, PORTD   /*Load respective Port addresses to registers*/
    LA $t2, PORTE
    LA $t3, PORTF
    
    
Loop:
    LW $t7, 0($t1)  /*Load PORTD to t7 and then AND with hex value to mask unwanted bits*/
    ANDI $t7,$t7, 0xF0

    LW $t4, 0($t3)  /*Load PORTF to t4 and then AND with hex value to mask unwanted bits*/
    ANDI $t4,$t4, 0x2
    SLL $t4,$t4,3   /*Shift by 3 and OR it (Combine values) to t7*/
    OR $t7,$t7,$t4 

    LW $t5, 0($t1)  /*Load PORTD to t5 and then AND with hex value to mask unwanted bits*/
    ANDI $t5,$t5, 0xF00
    SRL $t5,$t5,8   /*Shift by 8 and OR it (Combine values) to t7*/
    OR $t7,$t7,$t5

    SW $t7, 0($t2)  /*Write t7 to t2 (PORTE)*/
    JAL Loop	    /*Repeat*/
    NOP
    
    
.end main



.data
