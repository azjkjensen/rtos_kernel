// yakc.c

#include yakk.h
#include yaku.h



typedef struct task* taskPtr;

typedef struct task
{               /* the TCB struct definition */
    void *stackptr;     /* pointer to current top of stack */
    int state;          /* current state */
    int priority;       /* current priority */
    int delay;          /* #ticks yet to wait */
    taskPtr next;        /* forward ptr for dbl linked list */
    taskPtr prev;        /* backward ptr for dbl linked list */
}  YKtasks[MAX_NUM_TASKS+1];

taskPtr YKRdyList;       /* a list of TCBs of all ready tasks
                   in order of decreasing priority */ 
taskPtr YKSuspList;      /* tasks delayed or suspended */
taskPtr YKAvailTCBList;      /* a list of available TCBs */
task    YKTCBArray[MAXTASKS+1];  /* array to allocate all needed TCBs
                                   (extra one is for the idle task) */
                                   
int YKIdleTaskStack[STACK_SIZE];


void YKIdleTask(void){
    while(1);
}

void YKinitialize(){
    YKEnterMutex(); // Enable interrupts, save context.
    YKNewTask(&YKIdleTask,&YKIdleTaskStack,1000);    // Create a new task with the given task on the task stack with lowest priority
 
}

void YKEnterMutex(){

}

void YKExitMutex(){

}

void YKinitialize(){

}

void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){

}

void YKRun(){
    
}

void YKScheduler(){

}

void YKDispatcher(){

}