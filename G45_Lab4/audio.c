#include <stdio.h>

#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/vga.h"
#include "./drivers/inc/ps2_keyboard.h"\
#include "./drivers/inc/audio.h"




int main(){
	int high = 0, low = 0;
	int highMAG = 0x7FFFFFFF;
	int lowMAG = 0;
while(1) {
		//Here, it is 240 for a 100HZ square wave. MATH: 48k sampling rate / 100HZ frequency / 2 for a half wave = 240
		while(high<240) if(write_audio_out_ASM(highMAG))	high++;
		while(low<240)	if(write_audio_out_ASM(lowMAG))		low++;
		high = low = 0;


		}

return 0;
}