				.text
				.global _start

_start:
				LDR R4, =RESULT		//R4 points to the result location
				LDR R2, [R4, #4]	//R2 holds the number of elements in the list
				ADD R3, R4, #8		//R3 points to the first number
				LDR R0, [R3]		//R0 holds the first number in the list
				ADD R3, R3, #4		//R3 2nd number in list is now pointed to
				LDR R5, [R3]		//R5 holds the value of the second number in the list
				ADD R6, R5, R0		//R6 holds the sum of the first two numbers
				SUB R2, R2, #1		// for looping, 0 to n-2 to center array so subtract 1 before in the loop

LOOP:			SUBS R2, R2, #1		//decrement the loop counter
				BEQ DONE			//end loop if counte has reached 0
				ADD R3, R3, #4		//R3 points to the next nmber in the list
				LDR R1, [R3]		//R1 holds he next number in the list 
				ADD R6, R1, R6		//current value + total result
				B LOOP				//branch back to the loop

DONE:			STR R6, [R4]		//store the result to the memory location

				LDR R2, [R4, #4]	//This holds elements in list
				MOV R9, #0			//shifting number

LOOP2:			ADD R9, R9, #1		//up counter
				LSR R2, R2, #1		//shift elements right 
				CMP R2, #1			//compare to 1 and see if value is equal
				BEQ DONE2			// yes exit loop
				B LOOP2				//no, go through loop again

DONE2:			
				LSR R6, R6, R9		//Divide result by N (which is the where the counter got through, N)
				STR R6, [R4]		//store result in memory 
				ADD R3, R4, #8		//Points to first number
				LDR R0, [R3]		//holds first number
				LDR R2, [R4, #4]	//Holds number of elements
				ADD R2, R2, #1		//increment the size by 1 so it can travese array fully

LOOP3:			SUBS R2, R2, #1		//down counter
				BEQ DONE3			//if counter = 0 exit loop
				SUB R0, R0, R6		//subtract average from current value
				STR R0, [R3]		//put back in same location
				ADD R3, R3, #4		//points next number in list
				LDR R0, [R3]		//next number in list
				B	LOOP3			//go back through loop		
DONE3: 


END:			B END				//infinite loop!

RESULT:			.word 0				//memory assigned for result location
N:				.word 8				//number of entries in the list
NUMBERS:		.word 4, 5, 3, 6	//the list data
				.word 1, 8, 2, 5
