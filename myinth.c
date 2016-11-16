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
    GlobalFlag = 1; // This may not be required according to lab7 spec
    char c;
    c = KeyBuffer;

    if(c == 'a') YKEventSet(charEvent, EVENT_A_KEY);
    else if(c == 'b') YKEventSet(charEvent, EVENT_B_KEY);
    else if(c == 'c') YKEventSet(charEvent, EVENT_C_KEY);
    else if(c == 'd') YKEventSet(charEvent, EVENT_A_KEY | EVENT_B_KEY | EVENT_C_KEY);
    else if(c == '1') YKEventSet(numEvent, EVENT_1_KEY);
    else if(c == '2') YKEventSet(numEvent, EVENT_2_KEY);
    else if(c == '3') YKEventSet(numEvent, EVENT_3_KEY);
    else {
        print("\nKEYPRESS (", 11);
        printChar(c);
        print(") IGNORED\n", 10);
    }
}
