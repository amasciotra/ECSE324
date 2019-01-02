	.text
	
	.equ VGA_PIXEL_BUF_BASE, 0xC8000000
	.equ VGA_CHAR_BUF_BASE, 0xC9000000

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM
	.global HEX_ASCII
		
VGA_clear_pixelbuff_ASM:
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =VGA_PIXEL_BUF_BASE

	MOV R0, #0
PIXEL_LOOPX:
	MOV R1, #0
	ADD R4, R3, R0, LSL #1
PIXEL_LOOPY:
	ADD R5, R4, R1, LSL #10
	
	STRH R2, [R5]
	
	ADD R1, R1, #1
	CMP R1, #240
	BLT PIXEL_LOOPY
	
	ADD R0, R0, #1
	CMP R0, #320
	BLT PIXEL_LOOPX

	POP {R4-R5}
	BX LR

VGA_draw_point_ASM:
	LDR R3, =319
	CMP R0, #0
	BXLT LR
	CMP R1, #0
	BXLT LR
	CMP R0, R3
	BXGT LR
	CMP R1, #239
	BXGT LR
	
	LDR R3, =VGA_PIXEL_BUF_BASE
	ADD R3, R3, R0, LSL #1
	ADD R3, R3, R1, LSL #10
	STRH R2, [R3]
	BX LR
	
VGA_clear_charbuff_ASM:
	
	PUSH {R1-R12,LR}
	LDR R0, =VGA_CHAR_BUF_BASE	//get address
	LDR R1, [R0]				//load the register
	MOV R2, #79 //max value x can be, will be used as counter
	MOV R3, #59	//max value y can be, will be used as counter decrementing
	MOV R4, #0x0	//to clear 

CLEARcharY:			//actually clears everything
	
	CMP R3, #0		//exit if gone through every y position
	BLT	CLEARcharX	//go to clear the x's
	MOV R6, R3		//keep y counter value in R3 so doesnt fuck up
	LSL R6, #7		//skip the x bits in register, go directly to Y bits
	ORR R6, R6, R0		//adding the clearing pixel to what is in register to clear, making halfword
	MOV R5, R2		//saving x counter so dont fuck up, no need to shift
	ORR R6, R6, R5		//make halfword of x and y
	STRB R4, [R6]	//store 0s into R6
	SUB R3, R3, #1	//decrement counter
	B CLEARcharY

CLEARcharX:
	CMP R2, #0		//check to see if gone through all x's
	BLT ENDCLEARBUFF	//if it has go to end of clear to pop and bx lr
	SUB R2, R2, #1		//decrement before going through the clea
	MOV R3, #59		//make the Y counter to 59 so it can keep going through the clearchary loop
	B CLEARcharY	//go to clear x and ys

ENDCLEARBUFF:

	POP {R1-R12,LR}
	BX LR

VGA_write_char_ASM:

	PUSH {R4-R12,LR}
	LDR R4,=VGA_CHAR_BUF_BASE	//getting charbuff register
	CMP R0, #0	//check to see the x coordinate falls within range
	BLT DONEWRITECHAR
	CMP	R0, #79
	BGT DONEWRITECHAR

	CMP R1, #0	//checking y coordinates
	BLT DONEWRITECHAR
	CMP R1, #59
	BGT DONEWRITECHAR

	
	ORR R4, R4, R0	//add x offset
	MOV R5, R1	//moving y offset into another register
	LSL R5, #7	//go into y bits position
	ORR R5, R5, R4	//adding y offset into bits
	STRB R2, [R5]
	
DONEWRITECHAR:
	
	POP {R4-R12,LR}
	BX LR
	
VGA_write_byte_ASM:
	

	PUSH {R4-R12,LR}
	LDR R4,=VGA_CHAR_BUF_BASE	//getting charbuff register
	CMP R0, #0	//check to see the x coordinate falls within range
	BLT DONEWRITEBYTE
	CMP	R0, #79
	BGT DONEWRITEBYTE

	CMP R1, #0	//checking y coordinates
	BLT DONEWRITEBYTE
	CMP R1, #59
	BGT DONEWRITEBYTE
	
	LDR R12, =HEX_ASCII
	AND R10, R2, #0xF0	//getting the first character
	LSR R10, #4		//moving back 4 bits over because and from the AND
	LDRB R10, [R12,R10]

	AND R11, R2, #0x0F	//getting second character	//no need to shift
	LDRB R11, [R12, R11]
	
	ORR R4, R4, R0	//add x offset
	MOV R5, R1	//moving y offset into another register
	LSL R5, #7	//go into y bits position
	ORR R5, R5, R4	//adding y offset into bits
	
	STRB R10, [R5]	//store first
	STRB R11, [R5,#1]	//store second next to it

DONEWRITEBYTE:
	
	POP {R4-R12,LR}
	BX LR
	
HEX_ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	//      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F  // 
	.end
	
