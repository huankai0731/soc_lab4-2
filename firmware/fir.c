#include "fir.h"

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
	//initial your fir


}


int __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
	initfir();

//check ap_idel = 1 (000100)
while (1) {if (reg_fir_control == 4) {break;}}

	reg_fir_length = data_length;

	reg_fir_coeff_0  =   0;
	reg_fir_coeff_1  = -10;
	reg_fir_coeff_2  =  -9;
	reg_fir_coeff_3  =  23;
	reg_fir_coeff_4  =  56;
	reg_fir_coeff_5  =  63;
	reg_fir_coeff_6  =  56;
	reg_fir_coeff_7  =  23;
	reg_fir_coeff_8  =  -9;
	reg_fir_coeff_9  = -10;
	reg_fir_coeff_10 =   0;

	//set ap_start = 1 (000001)
	reg_fir_control = 1;
	//set ap_start = 0 (000000)
	reg_fir_control = 0;




	for (int n = 0; n < data_length ; n++ ){

		while (1) {
			// x is ready to accept data ap_ctl:(010000)
		if (reg_fir_control == 16) {
			reg_fir_input = n+1;
			break;
		}
		}
		while (1) {
			// y is ready to read  ap_ctl:(110000)
		if (reg_fir_control == 48) {	
			//reset when 0x00 is read
			reg_fir_control = 0;

			y = reg_fir_output;
			break;
		}
		
		}
		}
	return y;
}

