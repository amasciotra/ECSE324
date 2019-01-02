#ifndef __HPS_TIM
#define __HPS_TIM

	typedef enum {
		TIM0 = 0x00000001,
		TIM1 = 0x00000002,
		TIM2 = 0x00000004,
		TIM3 = 0x00000008
	}	HPS_TIM_t;

	typedef struct {
		HPS_TIM_t tim;
		int timeout; // in usec
		int LD_en;
		int INT_en;
		int enable;
	}	HPS_TIM_config_t;
	
	extern void HPS_TIM_config_ASM(HPS_TIM_config_t *param);	//takes a struct pointer
	


//reads the value from the s-bit (offset = 0x10)
//the nature of the return will depend on whether function is able to read the s-bit
//value of multiple timers in the same call
	extern int HPS_TIM_read_INT_ASM(HPS_TIM_t tim);


	//resets the s-bit and the f-bit
	//this function should support multiple timers in the same argument
	extern void HPS_TIM_clear_INT_ASM(HPS_TIM_t tim);

#endif
