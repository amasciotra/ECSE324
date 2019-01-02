			.text
			.global _start

_start:		LDR R6, =FIBNUM			//point to location of fibonacci number
			LDR R0, [R6]			//get fib number
			MOV R1, #0				//Hold answer to return
			BL FIB					//Go to FIB to get result
			STR R1, RESULT			//store result in right place	
END: B END		
			



FIB:		PUSH {R0, LR}				//storing registers that might be used used in FIB in SR
			CMP R0, #2					//check if R0 is greater than 2
			BLT ELSE					//if FIB = 0 or 1 go to else to return 1 as result
			SUB R0, R0, #1				//subtract 1 to call fib next line
			BL FIB						//go back to top of fib
			SUB R0, R0, #1				//subtract again 1 to call fib again
			BL FIB						//call fib again
			POP {R0, LR}				//erasing registers used
			BX LR						//go back to top
			
			
			

ELSE:		ADD R1, R1, #1				//add 1 to result
			POP {R0, LR}				//done with registers so empty off the stack
			BX LR						//go back to start where we left off  
			




FIBNUM: .word 8
RESULT: .word 0
		.end
