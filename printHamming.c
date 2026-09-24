#include <stdio.h>
extern unsigned char ram[];     //RAM declared in assembly
extern void checkHam(void);     // Assembly function 
extern unsigned long hamResult;

int main()
{
    checkHam();    //Run assembly code
    printf("Hamming distnace: %lu\n", hamResult);

    return 0;

}