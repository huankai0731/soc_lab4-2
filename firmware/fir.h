#ifndef __FIR_H__
#define __FIR_H__

#include <stdint.h>



#define reg_fir_control  (*(volatile uint32_t*)0x30000000)
#define reg_fir_length   (*(volatile uint32_t*)0x30000010)
#define reg_fir_input    (*(volatile uint32_t*)0x30000080)
#define reg_fir_output   (*(volatile uint32_t*)0x30000084)

#define reg_fir_coeff_0  (*(volatile uint32_t*)0x30000020)
#define reg_fir_coeff_1  (*(volatile uint32_t*)0x30000024)
#define reg_fir_coeff_2  (*(volatile uint32_t*)0x30000028)
#define reg_fir_coeff_3  (*(volatile uint32_t*)0x3000002c)
#define reg_fir_coeff_4  (*(volatile uint32_t*)0x30000030)
#define reg_fir_coeff_5  (*(volatile uint32_t*)0x30000034)
#define reg_fir_coeff_6  (*(volatile uint32_t*)0x30000038)
#define reg_fir_coeff_7  (*(volatile uint32_t*)0x3000003c)
#define reg_fir_coeff_8  (*(volatile uint32_t*)0x30000040)
#define reg_fir_coeff_9  (*(volatile uint32_t*)0x30000044)
#define reg_fir_coeff_10 (*(volatile uint32_t*)0x30000048)


#define N 11
#define data_length 64


int y;
int final_y;

#endif
