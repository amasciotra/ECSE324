			.text
			.equ PS2_BASE, 0xFF200100 			
			.global read_PS2_data_ASM

read_PS2_data_ASM:	//R0 is the char pointer
			PUSH {R1-R12,LR}
			LDR R1, =PS2_BASE
			LDR R2, [R1]			//contains data
			
			ANDS R3, R2, #0x8000		//isolate RVALID
			MOVEQ	R0, #0
			POPEQ	{R1-R12,LR}
			BXEQ	LR
			
			AND	 R3, R2, #0xFF			//isolate character
			STRB R3, [R0]				//store in char pointer
			MOV	 R0, #1
			BX LR



.end
