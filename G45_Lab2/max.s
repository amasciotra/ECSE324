			.text
			.global _start

_start:			LDR R0, =NUMBERS 	//give location of array of numbers
				LDR R1, N			//number of elements in array
				PUSH {R0, R1, LR}	//pushing parameters of max function and LR
				BL MAX				//branch to max and store PC to LR register
				POP {R0, R1, LR}	//taking outputs back from stack
				STR R0, RESULT		//moving max to result memory
END:			B END				//infinite loop!





				


MAX: 			PUSH {R0-R4}		//saving the values of the registers
				LDR R3, [SP, #20]	//access parameter in the stack of the memoy location pointerof first number array
				LDR R2, [SP, #24]	//getting number of elements in array
				LDR R0, [R3]		//getting first number in array

LOOP:			SUBS R2, R2, #1		//decrement the loop counter
				BEQ DONE			//end loop if counte has reached 0
				ADD R3, R3, #4		//R3 points to the next nmber in the list
				LDR R1, [R3]		//R1 holds he next number in the list 
				CMP R0, R1			//check if it is greater than the maximum
				BGE LOOP			//if no, branch back to the loop
				MOV R0, R1			//if yes, update the current max
				B LOOP				//branch back to the loop

DONE:			STR R0, [SP, #20]	//store max into Stack where R0 was
				POP {R0-R4}			//restore variables used
				BX LR				//go back to caller and continue

RESULT:			.word 0				//memory assigned for result location
N:				.word 7				//number of entries in the list
NUMBERS:		.word 4, 5, 3, 6	//the list data
				.word 1, 8, 2
