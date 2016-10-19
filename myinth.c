#include "clib.h"
#include "yakk.h"

extern int KeyBuffer;

int tickCount = 1;
static int someLocalVariable = 0;

void resetHandler(){
    // printString("RESETTING");
    exit(0);
}

void tickHandler(){
    printString("\nTick ");
    printInt(tickCount);
	printNewLine();
    tickCount++;
    YKTickHandler();
}

void loopLikeABoss(){
    int i = 0;
    for(; i < 5001; i++){
        someLocalVariable++;
    }
}

void keypressHandler(){
    if((char)KeyBuffer == 'd'){
        printString("\nDELAY KEY PRESSED\n");
        loopLikeABoss();
        printString("\nDELAY COMPLETE\n");

    } else{
        printString("\nKEYPRESS (");
        printChar((char)KeyBuffer);
        printString(") IGNORED");
        printNewLine();
    }
}
