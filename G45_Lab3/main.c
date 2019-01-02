#include <stdio.h>
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"



int main() {



	int a = 0;
	char display = 0;


	while(1) {
		a = read_slider_switches_ASM();
		write_LEDs_ASM(a);
	//if(read_PB_data_ASM() != 0)

		//if(read_PB_data_ASM() ==1){
			//HEX_flood_ASM(HEX0 | HEX5);
			//HEX_flood_ASM(HEX4 | HEX5);

		if(a>=512){
			HEX_clear_ASM(63);
		}
			else{
				display = a&0x0000000F;	//only looking at numbers from sw0-sw3 (4bit number)
				HEX_flood_ASM(HEX4 | HEX5);
				HEX_write_ASM(read_PB_data_ASM(),display);
		}

//}
	}

	

		//a = read_slider_switches_ASM();
		//if(a>= 512){
		//HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
//
	//	else{
		//display = a&0x0000000F;	//only looking at numbers from sw0-sw3 (4bit number)
		//write_LEDs_ASM(a);
		
		//HEX_flood_ASM(HEX4 | HEX5);
		//HEX_write_ASM(read_PB_data_ASM(), display);
	//}

	


//}

return 0;

}


