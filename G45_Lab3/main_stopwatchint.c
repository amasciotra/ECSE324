#include <stdio.h>


#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/int_setup.h"

int main(){
	int count0 = 0, count1=0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;
	int holdpbkeydata = 0;
//setting all displays to 0 waiting for start
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		int_setup(2, (int[]){73,199});	//setting the lengths and the id's # of the interrupts wuith respect to the header files convention and int_setup file
		//int count = 0;
		HPS_TIM_config_t hps_tim;
		
	
		hps_tim.tim = TIM0;		//stopwatch timer
		hps_tim.timeout = 10000;	//miliseconds
		hps_tim.LD_en = 1;
		hps_tim.INT_en = 1;
		hps_tim.enable = 0;		//set to 0 to stopwatch doesnt start right away

		HPS_TIM_config_ASM(&hps_tim);		//configure timer
		enable_PB_INT_ASM(PB0|PB1|PB2);		//enabling interrupt mask register
		
		while(1){
			
			if(pb_keys_int_flag != 0) {// a button was presed
				holdpbkeydata = pb_keys_int_flag;
				pb_keys_int_flag = 0; //set back to 0 for next interrupt
					if(holdpbkeydata & 1){
						hps_tim.enable = 1;
						HPS_TIM_config_ASM(&hps_tim);
					}else if(holdpbkeydata & 2){
						hps_tim.enable = 0;
						HPS_TIM_config_ASM(&hps_tim);
					}else if(holdpbkeydata & 4){
							hps_tim.enable = 0;
						 	count0 = 0;//clearing my counters to 0
							count1 = 0;
							count2 = 0;
							count3 = 0;
							count4 = 0;
							count5 = 0;
							HEX_write_ASM(HEX0, count0);
							HEX_write_ASM(HEX1, count1);
							HEX_write_ASM(HEX2, count2);
							HEX_write_ASM(HEX3, count3);
							HEX_write_ASM(HEX4, count4);
							HEX_write_ASM(HEX5, count5);
							HPS_TIM_config_ASM(&hps_tim);			
					}
			}
			if(hps_tim0_int_flag) {		//timer interrupt, waiting for flag to equal 1, sets every clock cycle
				hps_tim0_int_flag = 0;
				if(++count0 == 10){
				count0 = 0;
				count1 = count1 + 1;
				}
					if(count1 == 10){
						count1 = 0;
						count2 = count2 + 1;
				}
					if(count2 == 10){
					count2 = 0;
					count3 = count3 + 1;
				}
					if(count3 == 6){//second display to update minute one
					count3 = 0;
					count4 = count4 + 1;
				}
					if(count4 == 10){
					count4 = 0;
					count5 = count5 + 1;
				}
					if(count5 == 6){//end of stopwatch capacity
						count5 = 0;
				}
			
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		
			}
		}
	
	return 0;
}

		

