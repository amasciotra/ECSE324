				.text
				.global _start

_start:			LDR R5, =A			//holding memory location of first element in array
				LDR R8, =STACK		//our stack memory location
				LDR R0, [R5]		//holds first number in array
				STR R0, [R8]		//pushing R0 onto stack
				ADD R8, R8, #4		//add peek memory location by 4
				LDR R0, [R5, #4]	//load second number in array in to R0
				STR R0, [R8]		//push second value
				ADD R8, R8, #4		//move stack pointer peek 4 memory locations down
				LDR R0, [R5, #8]	//load 3rd value of array into R0
				STR R0, [R8]		//push 3rd value on stack
				LDR R0, [R8]		//pop top of stack into R0
				SUB R8, R8, #4		//decrement peek down 4
				LDR R1, [R8]		//pop stack into R1
				SUB R8, R8, #4		//decrement peek down 4
				LDR R2, [R8]		//pop stack


A: .word 9, 8, 7
STACK: .word 0, 0, 0
	.end
