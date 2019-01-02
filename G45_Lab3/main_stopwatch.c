#include <stdio.h>
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_tim.h"

int main() {
	int count0 = 0, count1=0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;

	HPS_TIM_config_t hps_tim;		//creating instances
	HPS_TIM_config_t hps_poller;

	hps_poller.tim = TIM1; //for button clocking
	hps_poller.timeout = 1000;	//10x faster than stopwatch
	hps_poller.LD_en = 1;
	hps_poller.INT_en = 1;
	hps_poller.enable = 1;

	hps_tim.tim = TIM0; //for hex displays|stopwatch
	hps_tim.timeout = 10000;	//10000000 was in micro seconds, need milliseconds
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 0;		//set to 0 to wait for the start button to enable to 1

	HPS_TIM_config_ASM(&hps_tim);	//giving the pointer of the struct for timer
	HPS_TIM_config_ASM(&hps_poller);//giving pointer of the other struct 
	
//setting all displays to 0 waiting for start
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);


	while(1) {
	//polling timer to check if buttons are pressed or not
	if(HPS_TIM_read_INT_ASM(TIM1)) {
			HPS_TIM_clear_INT_ASM(TIM1);
			if(read_PB_edgecap_ASM() != 0){//a button is pressed, check to see which one
				if(read_PB_edgecap_ASM() & 1){//0001 pb0 is pressed, start the stopwatch
					hps_tim.enable = 1;	//start
					HPS_TIM_config_ASM(&hps_tim);//reconfigure my timer
					}else if(read_PB_edgecap_ASM() & 2){//0010 pb1 is pressed
						hps_tim.enable = 0;//stop
						HPS_TIM_config_ASM(&hps_tim);//reconfigure my timer
					}if(read_PB_edgecap_ASM() & 4) {//0100 pb2 is pressed
						
							hps_tim.enable = 0; //wait for start
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
						}

				} 
					PB_clear_edgecap_ASM(0xF);//clear edgecap
				//while(!read_PB_data_ASM){}


	}

		if(HPS_TIM_read_INT_ASM(TIM0)) {
			HPS_TIM_clear_INT_ASM(TIM0);
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
		







