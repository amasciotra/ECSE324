//
//  subroutineMAX.c
//  
//
//  Created by Alex Masciotra on 2018-02-11.
//
//


extern int MAX_2(int x, int y);

//int main(){
//    int a, b, c;
//    
//    a = 1;
//    b = 2;
//    c = MAX_2(a,b);
//    return c;
//    
//}
//


int main () {
    int a[5] = {1, 20, 3, 4, 5};    //initilize array
    int max_val = 0; //initialize max value
    int i; //iterator to iterate through array
    int temp; //hold max value and the return of the subroutine
    
    for (i = 0; i < 4; i++) {
        
        temp = MAX_2(a[i], a[i+1]); //calling subroutine to find max of both numbers
        if (temp > max_val){ //if the maximum returned from the 2 numbers compared in the subroutine is > than the stored max_value, update the max value
            max_val = temp;
        }
        
    }
    
    return max_val;
    
}


