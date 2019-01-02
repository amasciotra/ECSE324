#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
//#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
//#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
//#include "./drivers/inc/HEX_displays.h"
//#include "./drivers/inc/slider_switches.h"



int amplitude = 1; //amplitude that will change with volume keys
int buttons[8] = {0, 0, 0, 0, 0, 0, 0, 0};  //the 8 possible buttons booleans of is pressed or not
double frequency[8] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626}; //array holding frequencies for each possible key
char *prev ; //holds last keyboard data, this is to bypass the breakcode when button is released, the 0xFO and then the code that was pressed






int get_signal(double freq, double time){       //this function calculates the proper signal to send into the audiocodec

		int index = (int)(freq * time)% 48000;		//floor of freqeuncy
		double decimal = (freq * time) - (int) (freq * time);//getting decimal number
		int signal = ((1 - decimal) * sine[index]) + ((decimal)*sine[index+1]);
		//int signal = sine[index];
		 return  signal;
	}

void keyboardcontrol(char *data){         //this function calculates the frequency to be played instructed from the keyboard
    
    double freq;// sum frequency to return
   // int i;  //iterator
    
    //we will check the *data argument to see what buttons are pressed and then activate the right code
    
    if(*data == 0x79){//plus ++++++ is pressed on numberpad, increase amplitude
        if(*prev != 0xF0){//check the breakcode
            amplitude = amplitude + 1; //increase volume
            
        }
        
    }else if(*data == 0x7B){ //minus ------ button is pressed on numberpad
        if(*prev != 0xF0){//checking breakcode
            if(amplitude != 0){//cant make my int negative for the amplitude, so itll stop at 0
                amplitude = amplitude - 1;
            }
            
        }
        
    }else if(*data == 0x1C){//AAAAAA is pressed play note CCCCCC
        if(*prev == 0xF0){//A is being released
            buttons[0] = 0;//making boolean 0
        
        }else{ //button A is being pressed
            buttons[0] = 1;
            
        }
        
        
    }else if(*data == 0x1B){//SSSS is pressed play note DDDD
        if(*prev == 0xF0){//button is being released
            buttons[1] = 0;
            
        }else {//button is being pressed
            buttons[1] = 1;
        }
    }else if(*data == 0x23){ //DDDD is pressed note EEEEEE
        if(*prev == 0xF0){
            buttons[2] = 0;
            
        }else{
            buttons[2] = 1;
        }
        
        
    }else if(*data == 0x2B){ //FFFFF is pressed note FFFFF
        if(*prev == 0xF0){
            buttons[3] = 0;
            
        }else{
            buttons[3] = 1;
        }
        
    }else if(*data == 0x3B){ //JJJJJJ is pressed note GGGGGGG
        if(*prev == 0xF0){//button is being released
            buttons[4] = 0; //set my bolean to off
            
        }else{
            buttons[4] = 1; //set my boolean to on
        }
        
    }else if(*data == 0x42){ //KKKKK is pressed note AAAAAAA
        if(*prev == 0xF0){//button is being released
            buttons[5] = 0; //set my bolean to off
            
        }else{
            buttons[5] = 1; //set my boolean to on
        }
        
    }else if(*data == 0x4B){ //LLLLL is pressed note BBBBBBBB
        if(*prev == 0xF0){//button is being released
            buttons[6] = 0; //set my bolean to off
            
        }else{
            buttons[6] = 1; //set my boolean to on
        }
        
    }else if(*data == 0x4C){ //;;;;;;;;; is pressed note CCCCCCC
        if(*prev == 0xF0){//button is being released
            buttons[7] = 0; //set my bolean to off
            
        }else{
            buttons[7] = 1; //set my boolean to on
        }
    }


}


 




int main() {
    int_setup(1, (int[]){199});	//setting the lengths and the id's # of the interrupts wuith respect to the header files convention and int_setup file
   
    
    int time = 1;
    //double freq; //frequency sent to the draw and the getsignal
    char *data;//reading keyboard
    int sum = 0;
	int signals[8][48000];
	int x = 0;
	int y = 0;
	int tracky[320] = {120};
	int *prevprev;
	

	int i, j;

	for (i = 0; i < 8; i++){
		for (j = 0; j < 48000; j++){
			signals[i][j] = get_signal(frequency[i],j);
		}
	}
	

    HPS_TIM_config_t hps_tim;
    hps_tim.tim = TIM0;
    hps_tim.timeout = 20;	//cause of 48k sample inverse of 48k to get time
    hps_tim.LD_en = 1;
    hps_tim.INT_en = 1;
    hps_tim.enable = 1;
    
    HPS_TIM_config_ASM(&hps_tim);		//configure timer
    
    VGA_clear_pixelbuff_ASM();
    while(1) {
       
        if(read_ps2_data_ASM(data)){//if theres something in the data queue, here data is already a pointer char
           	keyboardcontrol(data);
			 if(*prev != *data){//do not recalculate same frequency once the button is already pressed
				*prevprev = *prev;
                *prev = *data;   
				x=0;
            }
			
			
        }
        
        if(hps_tim0_int_flag){
		int i;
		time = (time + 1) % 48000;
		sum = 0;
		hps_tim0_int_flag = 0;
		for (i=0; i < 8; i++){//iterating through to see what signals need to be calucaltued
            if(buttons[i] != 0){
				sum = (sum + signals[i][time]); 
			}
		}
		sum = amplitude * sum;
       
        

		//signal = get_signal(freq, time);
		
			while(!audio_write_data_ASM(sum,sum)){
			}
				 if(x < 320){
				y = 120 - sum/0x00fffff; //scale down
				VGA_draw_point_ASM(x, tracky[x], 0);	//clear pixel
				VGA_draw_point_ASM(x, y, 0xFFFFF);
				tracky[x]=y;
				x++;
				}
	
				
				
			
		}
	 

      

   
	}

	return 0;
}
