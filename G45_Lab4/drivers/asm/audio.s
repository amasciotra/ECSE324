			.text
			.equ Audio_BASE, 0xFF203040
			.equ Audio_FIFO, 0xFF203044
			.equ Audio_LEFT, 0xFF203048
			.equ Audio_RIGHT,0xFF20304C			
			.global write_audio_out_ASM

write_audio_out_ASM:	//R0 is the magnitude to be stored
			PUSH {R1-R12,LR}
			LDR R1, =Audio_BASE
			LDR R2, =Audio_FIFO
			LDR R3, =Audio_LEFT
			LDR R4, =Audio_RIGHT
			LDR R5, [R2]			//contains WSLC && WSRC
			
			ANDS R6, R5, #0xFF000000		//R3 contains WSLC
			MOVEQ	R0, #0
			POPEQ	{R1-R12,LR}
			BXEQ	LR

			ANDS R7, R5, #0x00FF0000		//R4 contains WSRC
			MOVEQ	R0, #0
			POPEQ	{R1-R12,LR}
			BXEQ	LR

			STR	R0, [R3]
			STR R0, [R4]
			
			MOV R0, #1
			POP {R1-R12,LR}
			BX LR



.end
