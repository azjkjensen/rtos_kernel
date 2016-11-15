#include "lab6defs.h"
#include "clib.h"
#include "yakk.h"

extern int KeyBuffer;
extern YKQ* MsgQPtr;
extern int YKTickNum;
extern int GlobalFlag;

extern struct msg MsgArray[];

int tickCount = 1;
static int someLocalVariable = 0;

void resetHandler(){
    // printString("RESETTING");
    exit(0);
}

void tickHandler(){
    
    static int curMsgi = 0;
    static int data = 0;

    MsgArray[curMsgi].tick = YKTickNum;
    data = (data + 89) % 100;
    MsgArray[curMsgi].data = data;

    // curMsgi++;

    if(!YKQPost(MsgQPtr, (void*) &MsgArray[curMsgi])){
        // Overflow has occured
    } else if(++curMsgi >= MSGARRAYSIZE){
        curMsgi = 0;
    }

    // printString("\nTick ");
    // printInt(tickCount);
	// printNewLine();
    // tickCount++;
    YKTickHandler();
}

void loopLikeABoss(){
    int i = 0;
    for(; i < 5001; i++){
        someLocalVariable++;
    }
}

void keypressHandler(){
    GlobalFlag = 1;
    // if((char)KeyBuffer == 'd'){
    //     printString("\nDELAY KEY PRESSED\n");
    //     loopLikeABoss();
    //     printString("\nDELAY COMPLETE\n");

    // } else if((char)KeyBuffer == 'p'){
    //     YKSemPost(NSemPtr);
    // } else{
    //     printString("\nKEYPRESS (");
    //     printChar((char)KeyBuffer);
    //     printString(") IGNORED");
    //     printNewLine();
    // }
}
