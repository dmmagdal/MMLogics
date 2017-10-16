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
    LA $a0,Greeting
    JAL puts
    NOP
    
    LA $t1, TRISD   /*Set D to input*/
    LI $t2, 0xFFFF
    SW $t2, 0($t1)
    
    LA $t1, TRISE   /*Set E to output*/
    LI $t2, 0
    SW $t2, 0($t1)
    
    LA $t1, PORTD   /*Load respective Port addresses to registers*/
    LA $t2, PORTE
    
    LI $t6,1
    SW $t6,0($t2)
    
endless:
    LW $t4, 0($t1)
    ANDI $t4,$t4, 0xF00
    SRL $t4,$t4,8
    ADDI $t4,$t4,1
    
    LI $t5,0x8000   /*Delay counter*/
    MULT $t5,$t4    /*multiply by factor of two (two to power of n)*/
    MFLO $t5
    
mydelay:
    ADDI $t5,$t5,-1 /*Decrement from delay "counter"*/
    BNE $t5,$zero,mydelay
    NOP

    SLL $t6,$t6,1   /*shift/ move led light to the left*/
    LI $t7,0x0100
    BNE $t6,$t7,skip
    NOP
    LI $t6,1
    
skip:
    SW $t6,0($t2)
    JAL endless
    NOP
    
    
.end main



.data
Greeting: .asciiz "Slowwwww Motioooooon! \n"