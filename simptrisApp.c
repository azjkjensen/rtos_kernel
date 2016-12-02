
#include "simptris.h"
#include "yakk.h"
#include "clib.h"

#define TASK_STACK_SIZE 512

int STaskStk[TASK_STACK_SIZE];
long seed = 37428;

void STask() {
     while(1) {
         YKDelayTask(20);
         printString("You made it\n");
    }
}

void main() {
    YKInitialize();


    // charEvent = YKEventCreate(0);
    // numEvent = YKEventCreate(0);
    YKNewTask(STask, (void *) &STaskStk[TASK_STACK_SIZE], 10);
    
    StartSimptris();
    SeedSimptris(seed);

    YKRun();
}