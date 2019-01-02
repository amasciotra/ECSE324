.text
			.equ HEX0_BASE, 0xFF200020
			.equ HEX4_BASE, 0xFF200030	
			.global HEX_clear_ASM
			.global HEX_flood_ASM
			.global HEX_write_ASM

HEX_clear_ASM:
				PUSH {R0-R12,LR}		//convention save states
				LDR R1, =HEX0_BASE	//loading memory lcation fo HEX0 to HEX3
				LDR R2, =HEX4_BASE	//loading memory location for HEX4 and HEX5
				MOV R3, #1			//iterator to compare onehot encoded 
				//MOV R4, 0			//hard coded all 1s to clear 8
				MOV R5, #0			//counter for effective adressing
				

LOOP_clear:		CMP R5, #5			//there are only 5 7 segment lights, exit if its more than 5
				BGT Exit_Hex_Clear

				TST R0, R3			//compare input with on or off segmet
				BNE CLEAR			//bitwise compare
				B end_Clear			

CLEAR:			CMP R5, #3			//checking if in hex0 base or hex 4 base
				MOVGT R1, R2		//give R1 hexbase4 so above code works
				LDR R7, [R1]
				TST R0, #1
				ANDNE R7, R7, #0xFFFFFF00		
				TST R0, #2						
				ANDNE R7, R7, #0xFFFF00FF  	
				TST R0, #4					
				ANDNE R7, R7, #0xFF00FFFF		
				TST R0, #8					
				ANDNE R7, R7, #0x00FFFFFF
				TST R0, #16
				ANDNE R7, R7, #0xFFFFFF00		
				TST R0, #32						
				ANDNE R7, R7, #0xFFFF00FF  			

				STR R7, [R1]		//load contents from register of which hexbase is being used
							

end_Clear:		LSL R3, #1
				ADD R5, R5, #1
				B LOOP_clear

Exit_Hex_Clear:	POP {R0-R12,LR}
				BX LR


HEX_flood_ASM:	PUSH {R0-R12,LR}		//convention save states
				LDR R1, =HEX0_BASE	//loading memory lcation fo HEX0 to HEX3
				LDR R2, =HEX4_BASE	//loading memory location for HEX4 and HEX5
				MOV R3, #1			//iterator to compare onehot encoded 
				//MOV R4, #0xFF		//hard coded all 1s to flood 8
				MOV R5, #0			//counter for effective adressing
				//MOV R6, #0		//access bits to turn on and off in register
				//MOV R8, #0xFF		//all ones


LOOP_flood:		CMP R5, #5
				BGT Exit_Hex_Flood

				TST R0, R3			//compare input with on or off
				BNE FLOOD			//bitwise compare
				B end_Flood			

FLOOD:			CMP R5, #3			//checking if in hex0 base or hex 4 base
				MOVGT R1, R2		//give R1 hexbase4 so above code works
				LDR R7, [R1]
				TST R0, #1
				ORRNE R7, R7, #0x000000FF		
				TST R0, #2						
				ORRNE R7, R7, #0x0000FF00  	
				TST R0, #4					
				ORRNE R7, R7, #0x00FF0000		
				TST R0, #8					
				ORRNE R7, R7, #0xFF000000
				TST R0, #16
				ORRNE R7, R7, #0x000000FF		
				TST R0, #32						
				ORRNE R7, R7, #0x0000FF00  			

				STR R7, [R1]		//load contents from register of which hexbase is being used
							
end_Flood:		LSL R3, #1
				ADD R5, R5, #1
				B LOOP_flood

Exit_Hex_Flood:	POP {R0-R12,LR}
				BX LR




HEX_write_ASM:
				PUSH {R0-R12,LR}		//convention save states
				LDR R2, =HEX0_BASE	//loading memory lcation fo HEX0 to HEX3
				LDR R3, =HEX4_BASE	//loading memory location for HEX4 and HEX5
				MOV R4, #1			//iterator to compare onehot encoded 
				MOV R6, #0			//number to write on the display
				MOV R5, #0			//counter for which HEX to display



display_to_Hex:
	
				CMP 	R1, #0		//0
				MOVEQ	R6, #0x3F
	
				CMP 	R1, #1		//1
				MOVEQ	R6, #0x6

				CMP 	R1, #2		//2
				MOVEQ	R6, #0x5B

				CMP 	R1, #3		//3
				MOVEQ	R6, #0x4F

				CMP 	R1, #4		//4
				MOVEQ	R6, #0x66

				CMP 	R1, #5		//5
				MOVEQ	R6, #0x6D

				CMP 	R1, #6		//6
				MOVEQ	R6, #0x7D

				CMP 	R1, #7		// 7
				MOVEQ	R6, #0x7

				CMP 	R1, #8		// 8
				MOVEQ	R6, #0x7F

				CMP 	R1, #9		// 9
				MOVEQ	R6, #0x67

				CMP 	R1, #10		// A
				MOVEQ	R6, #0x77

				CMP 	R1, #11		// B
				MOVEQ	R6, #0x7C

				CMP 	R1, #12		// C
				MOVEQ	R6, #0x39

				CMP 	R1, #13		// D
				MOVEQ	R6, #0x5E
	
				CMP 	R1, #14		// E
				MOVEQ	R6, #0x79

				CMP 	R1, #15		// F
				MOVEQ	R6, #0x71

LOOP_write:
				CMP 	R5, #5				//to know when to stop
				BGT 	Exit_write
	
				TST	 	R0, R4				// checks to see if write needed
				BNE 	WRITE
				B		end_WRITE

WRITE:			CMP R5, #3			//checking if in hex0 base or hex 4 base
				MOVGT R2, R3		//give R1 hexbase4 so above code works
				LDR R7, [R2]
				TST R0, #1
				ANDNE R7, R7, #0xFFFFFF00
				ADDNE R7, R7, R6, LSL #0		
				TST R0, #2						
				ANDNE R7, R7, #0xFFFF00FF 
				ADDNE R7, R7, R6, LSL #8	
				TST R0, #4					
				ANDNE R7, R7, #0xFF00FFFF	
				ADDNE R7, R7, R6, LSL #16	
				TST R0, #8					
				ANDNE R7, R7, #0x00FFFFFF
				ADDNE R7, R7, R6, LSL #24
				TST R0, #16
				ANDNE R7, R7, #0xFFFFFF00	
				ADDNE R7, R7, R6, LSL #0	
				TST R0, #32						
				ANDNE R7, R7, #0xFFFF00FF
				ADDNE R7, R7, R6, LSL #8  			

				STR R7, [R2]		//load contents from register of which hexbase is being used


end_WRITE:		LSL R4, #1
				ADD R5, R5, #1
				B LOOP_write

Exit_write:	POP {R0-R12,LR}
				BX LR




.end





