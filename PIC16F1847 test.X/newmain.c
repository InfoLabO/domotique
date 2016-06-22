/*
 * File:   newmain.c
 * Author: sornet
 *
 * Created on 22 juin 2016, 22:38
 */


#include <xc.h>

void delay(int time);

void main(void)
{
    TRISA = 0x00;
    LATA = 0;
    
    while(1)
    {
        LATA|=1<<2;
        delay(100);
        LATA&=~(1<<2);
        delay(100);
    }
    
    return;
}

void delay(int time)
{
    const int dlunit = 20;
    
    int i,j;
    for(i=0;i<time;++i)
        for(j=0;j<dlunit;++j);
}
