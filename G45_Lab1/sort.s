			.text
			.global _start

_start:
			LDR R4, =ISSORTED			//points to location of boolean
			LDR R5, [R4]				//contains the sorted boolean
			LDR R2, [R4, #4]			//holds # elements
			ADD R3, R4, #8				//location of first number
			LDR R0, [R3]				//first number in list

LOOP:		CMP R5, #1					//check if list is sorted
			BEQ DONE					//end
			MOV R5, #1					//set to true
			LDR R2, [R4, #4]			//holds list
			ADD R3, R4, #8				//location of first number
			LDR R0, [R3]				//holds first number

LOOP2:		SUBS R2, R2, #1				//down counter
			BEQ DONE2					//exit
			ADD R3, R3, #4				//R3 points to next number
			LDR R1, [R3]				//get next number in list
			LDR R0, [R3, #-4]			//gets previous number
			CMP R1, R0					//compare next value to previous and check if its smaller
			BGE LOOP2					//no, branch back to loop 2
			MOV R5, #0					//yes, set bool to false
			MOV R8, R1					//temp hold for swap
			MOV R9, R0					//temp for swap
			MOV R1, R9					//swap
			MOV R0, R8					//swap
			STR R0, [R3, #-4]			//store small number
			STR R1, [R3]				//store large number
			B LOOP						//restart from top

DONE2:		B LOOP						//back to top
DONE: 		STR R0, [R4]				//store result to memory


END: 		B END

ISSORTED:		.word 0
N:				.word 8
NUMBERS:		.word 5, 4, 2, 3
				.word 1, 9, 6, 11

