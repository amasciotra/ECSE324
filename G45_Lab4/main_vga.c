#include <stdio.h>

#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/vga.h"


void test_char() {
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++){
		for(x = 0; x <= 79; x++){
			VGA_write_char_ASM(x, y, c++);
		}
	}
}

void test_byte() {
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++) {
		for(x = 0; x <= 79; x+=3) {
			VGA_write_byte_ASM(x, y, c++);
		}
	}
}

void test_pixel() {
	int x, y;
	unsigned short colour = 0;

	for(y = 0; y <= 239; y++){
		for(x = 0; x <= 319; x++){
			VGA_draw_point_ASM(x, y, colour++);
		}
	}
}

int main(){
	int pbvalue = 0;
	VGA_clear_charbuff_ASM();		//start cleared
	
while(1) {
	
			if(read_PB_data_ASM() != 0){//a button is pressed, check to see which one
				pbvalue = 0;
				pbvalue = read_PB_data_ASM();
				
				if(pbvalue == 1){//0001 pb0 is pressed,
					if(read_slider_switches_ASM()!=0){
						test_byte();
						}else{
						test_char();
					}
				}else if(pbvalue == 2){//0010 pb1 is pressed
						test_pixel();
						}
					else if(pbvalue == 4) {//0100 pb2 is pressed
						VGA_clear_charbuff_ASM();
						
						}else if(pbvalue == 8){
						VGA_clear_pixelbuff_ASM();
						

				}
			} 


					}

return 0;
}


