				.text
				.global _start

_start:
				LDR R4, =RESULT		//R4 points to the result location
				LDR R2, [R4, #4]	//R2 holds the number of elements in the list
				ADD R3, R4, #8		//R3 points to the first number
				LDR R0, [R3]		//R0 holds the first number in the list

LOOP:			SUBS R2, R2, #1		//decrement the loop counter
				BEQ DONE			//end loop if counte has reached 0
				ADD R3, R3, #4		//R3 points to the next nmber in the list
				LDR R1, [R3]		//R1 holds he next number in the list 
				CMP R0, R1			//check if it is greater than the maximum
				BGE LOOP			//if no, branch back to the loop
				MOV R0, R1			//if yes, update the current max R0 holds max
				B LOOP				//branch back to the loop

DONE:			LDR R2, [R4, #4]	//R2 holds the number of elements in the list
				ADD R3, R4, #8		//R3 points to the first number
				LDR R7, [R3]		//R0 holds the first number in the list


LOOP2:			SUBS R2, R2, #1		//decrement the loop counter
				BEQ DONE2			//end loop if counte has reached 0
				ADD R3, R3, #4		//R3 points to the next nmber in the list
				LDR R1, [R3]		//R1 holds he next number in the list 
				CMP R7, R1			//check if it is less than the minimum
				BLT LOOP2			//if no, branch back to the loop
				MOV R7, R1			//if yes, update the current min R7 holds min
				B LOOP2				//branch back to the loop


DONE2:			SUBS R2, R0, R7		//subtraction max-min
				LSR R2, R2, #2		//divide by 4 using right shift
				STR R2, [R4]		//store result
				


END:			B END				//infinite loop!


RESULT:			.word 0				//memory assigned for result 
N:				.word 7				//number of entries in the list
NUMBERS:		.word 3, 12, 5, 6	//the list data
				.word 10, 8, 15
