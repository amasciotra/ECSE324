//
//  subroutine.s
//  
//
//  Created by Alex Masciotra on 2018-02-11.
//
//


            .text
            .global MAX_2

MAX_2:
            CMP R0, R1  //compare values sent by the C program, parameters R0 and R1
            BXGE LR     //if R0 >= R1 skip the move part and go back to top
            MOV R0, R1  //if R0 < R1, switch the register values so R0 holds max
            BX LR       //branch back to subroutine returning the max of 2 numbers
            .end


