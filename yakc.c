// yakc.c

#include yakk.h
#include yaku.h



typedef struct Task* taskPtr;

typedef struct Task
{               /* the TCB struct definition */
    void* stackPtr;     /* pointer to current top of stack */
    int state;          /* current state */
    int priority;       /* current priority */
    int delay;          /* #ticks yet to wait */
    taskPtr next;        /* forward ptr for dbl linked list */
    taskPtr prev;        /* backward ptr for dbl linked list */
}  ykTasks[MAX_NUM_TASKS+1];

taskPtr YKRdyList;       /* a list of TCBs of all ready tasks
                   in order of decreasing priority */ 
taskPtr YKSuspList;      /* tasks delayed or suspended */
taskPtr YKAvailTCBList;      /* a list of available TCBs */
Task    YKTCBArray[MAXTASKS+1];  /* array to allocate all needed TCBs
                                   (extra one is for the idle task) */
                           
int currentTaskCount;
                                
// Stack frame for the idle stack.
int YKIdleTaskStack[STACK_SIZE];

// Idle task, lowest priority, spin that fool in the background.
void YKIdleTask(void){
    while(1);
}

Task* readyRoot; // The most-ready task in our ready tasks linked-list

void YKinitialize(){
    YKEnterMutex(); // Enable interrupts, save context.
    currentTaskCount = 0;
    YKNewTask(&YKIdleTask,&YKIdleTaskStack,1000);    // Create a new task with the given task on the task stack with lowest priority
}

void YKNewTask(void (*Task)(void), void* taskStack, unsigned char priority){
    // Append a new task struct after the lastcurrentTaskCount element of the task array.
    struct Task* temp;
    YKEnterMutex();
    
    temp = &ykTasks[currentTaskCount];
    
    temp.stackPtr = taskStack;
    //temp.state = ;
    temp.priority = priority;
    temp.delay = 0;
    //temp.next = 
    //temp.prev
    currentTaskCount++;
    YKAddReadyTask(temp);
    
}

/* Adds a task to the current ready task linked-list. */
void YKAddReadyTask(Task readyTask) {
    if(!readyRoot){
        readyRoot = &readyTask;
        return;
    } else{
        // Insert the new readyTask into the linked-list depending on priority.
    }
}

void YKRun() {

}

void YKScheduler(){

}

void YKDispatcher(){

}