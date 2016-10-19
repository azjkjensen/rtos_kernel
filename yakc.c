// yakc.c

#include "clib.h"
#include "yakk.h"

#define IDLE_TASK_PRIORITY 100



struct TCB
{               /* the TCB struct definition */
    unsigned* stackPtr;     /* pointer to current top of stack */
    unsigned char state; 
    unsigned char priority;       /* current priority */
    struct TCB *next;        /* forward ptr for dbl linked list */
    int delay;          /* #ticks yet to wait */
};

struct TCB YKTCBs[MAX_TASK_NUM];
        
int YKCtxSwCount = 0; // Global
int YKIdleCount = 0; // Global
int YKISRCallDepth = 0; // Global
int YKTickNum = 0;
struct TCB* readyRoot;
struct TCB* currentTask = NULL;
struct TCB* saveContextTask = NULL;
struct TCB* taskToRun; 
char running = 0; // Flag for if the kernel has been started.

int TCBi = 0;

void YKIdleTask(void);

int YKIdleTasks[STACK_SIZE];

void YKInitialize(){
    YKEnterMutex(); // Enable interrupts, save context.

    // Create a new task with the given task on the task stack with lowest priority
    YKNewTask(&YKIdleTask,(void*)&YKIdleTasks[STACK_SIZE], IDLE_TASK_PRIORITY);

    // Don't need this?
    // saveContextTask = &YKTCBs[0];
}

// Idle task, lowest priority, spin that fool in the background.
void YKIdleTask(void){
    // Does nothing?
    while(1){
        // Disable interrupts
        YKEnterMutex();
        YKIdleCount++;
        // Enable interrupts
        YKExitMutex();
    }
}

void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){
    unsigned* newStackPointer;
    int i; 

    YKTCBs[TCBi].state = READY_STATE;
    YKTCBs[TCBi].priority = priority;
    YKTCBs[TCBi].delay = 0;

    newStackPointer = (unsigned*)taskStack - 11;

    for(i = 0; i < 8; i++){
        newStackPointer[i] = 0;
    }
    
    newStackPointer[8] = (unsigned) task; // IP
    newStackPointer[9] = 0; // CS
    newStackPointer[10] = 0x0200; // Flags


    YKTCBs[TCBi].stackPtr = newStackPointer - 1;

    if(TCBi == 0){
        readyRoot = &YKTCBs[TCBi];
        YKTCBs[TCBi].next = NULL;
    }else{
        if(priority < readyRoot->priority){
            YKTCBs[TCBi].next = readyRoot;
            readyRoot = &YKTCBs[TCBi];
        }else{
            struct TCB* browser; // NOT firefox
            browser = readyRoot;

            while(browser){
                if(priority < browser->next->priority){
                    YKTCBs[TCBi].next = browser->next;
                    browser->next = &YKTCBs[TCBi];
                    break;
                }
                browser = browser->next;
            }
        }
    }

    TCBi++;
    if(running){
        YKScheduler();
    }
}

void YKRun() {
    // printString("\nYKRun() called\n");
    running = 1;
    YKScheduler(DONT_SAVE_CONTEXT);
}

void YKScheduler(unsigned char saveContext){
    struct TCB* browser;
    
    browser = readyRoot;
    while(browser){
        if(browser->state == READY_STATE){
            taskToRun = browser;
            break;
        }
        browser = browser->next;
    }

    if(taskToRun != currentTask){
        currentTask = taskToRun;
        YKCtxSwCount++;
        YKDispatcher(saveContext);
    }
}

void YKDelayTask(unsigned count){
    // If count is zero, do nothing.
    if(!count){
        return;
    }else{
        // Assign the delay to the running task
        currentTask->delay = count;
        currentTask->state = BLOCKED_ST
        // Call the scheduler to dispatch the right task
        YKScheduler(SAVE_CONTEXT);
    }

}

YKEnterISR(void){
    // Entering a new ISR
    YKISRCallDepth++;
}

YKExitISR(void){
    YKISRCallDepth--;
    // If there are no more registers, it is time
    // to restore context.
    if(!YKISRCallDepth){
        YKScheduler(SAVE_CONTEXT);
    }
}

YKTickHandler(void){
    // Decrement delay for any blocked tasks.
    // Make tasks that are done delaying ready.
    YKTickNum++;
    struct TCB* browser;
    
    browser = readyRoot;
    while(browser){
        if(browser->state == BLOCKED_ST){
            browser->delay--;
            if(!browser->delay){
                browser->state = READY_ST;
            }
            taskToRun = browser;
            break;
        }
        browser = browser->next;
    }
}

// void printTask(TCB t){
//     if(!t.priority){
//         printString("\nNo task to print\n");
//         return;
//     }
//     printNewLine();
//     printString("Task Printout:\n");
//     printString("SP: ");
//     printInt((int)t.stackPtr);
//     printNewLine();
//     printString("Priority: ");
//     printInt(t.priority);
//     printNewLine();
// }
