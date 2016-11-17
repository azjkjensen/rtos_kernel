// yakc.c

#include "clib.h"
#include "yakk.h"
#include "yaku.h"

#define IDLE_TASK_PRIORITY 100

struct TCB
{               /* the TCB struct definition */
    unsigned* stackPtr;     /* pointer to current top of stack */
    unsigned char state; 
    unsigned char priority;       /* current priority */
    struct TCB *next;        /* forward ptr for dbl linked list */
    int delay;          /* #ticks yet to wait */
    YKSem* semBlock; /* The semaphore blocking this task, NULL if none. */
    YKQ* qBlock;
    // Lab7 event properties
    YKEVENT* event;
    int mode;
    unsigned mask;
};

struct TCB YKTCBs[MAX_TASK_NUM];
YKSem YKSEMS[MAX_SEM_NUM];
YKQ YKQS[MAX_Q_NUM];
YKEVENT YKEvents[MAX_EVENT_SIZE];

int YKCtxSwCount = 0; // Global
int YKIdleCount = 0; // Global
int YKISRCallDepth = 0; // Global
int YKTickNum = 1;

struct TCB* readyRoot;
struct TCB* currentTask = NULL;
struct TCB* saveContextTask = NULL;
struct TCB* taskToRun; 

char running = 0; // Flag for if the kernel has been started.

int TCBi = 0;
int semi = 0;
int Qi = 0;
int eventIndex = 0;

int YKIdleTasks[STACK_SIZE];

void YKIdleTask(void);

void YKInitialize(){
    YKEnterMutex(); // Enable interrupts, save context.

    // Create a new task with the given task on the task stack with lowest priority
    YKNewTask(YKIdleTask,(void*)&YKIdleTasks[STACK_SIZE], IDLE_TASK_PRIORITY);

    // Don't need this?
    // saveContextTask = &YKTCBs[0];
}

// Idle task, lowest priority, spin that fool in the background.
void YKIdleTask(void){
    // Does nothing?
    while(1){
        // printString("idle running");
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

    YKEnterMutex();
    YKTCBs[TCBi].state = READY_ST;
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
        YKScheduler(SAVE_CONTEXT);
    }
}

void YKScheduler(unsigned char saveContext){
    struct TCB* browser;
    //printString("Begin YKScheduler\r\n");
    browser = readyRoot;
    YKEnterMutex();
    while(browser){
        if(browser->state == READY_ST){
            taskToRun = browser;
            break;
        }
        browser = browser->next;
    }

    if(taskToRun != currentTask){
        //printString("taskToRun\r\n");
        saveContextTask = currentTask;
        currentTask = taskToRun;
        //printString("stackpointer : ");
        //printInt((int)currentTask->stackPtr);
        YKCtxSwCount++;
        YKDispatcher(saveContext);
    }
    // printString("End of scheduler\r\n");
}

void YKRun() {
    // printString("\nYKRun() called\n");
    running = 1;
    YKScheduler(DONT_SAVE_CONTEXT);
}

void YKDelayTask(unsigned count){
    // printString("Entering DelayTask\r\n");
    YKEnterMutex();
    // If count is zero, do nothing.
    if(!count){
        //printString("!count\r\n");
        return;
    }else{
        //printString("count\r\n");
        // Assign the delay to the running task
        currentTask->delay = count;
        currentTask->state = DELAYED_ST;
        // Call the scheduler to dispatch the right task
        YKScheduler(SAVE_CONTEXT);
        YKExitMutex();
    }
    //printString("Befor exit mutex\r\n");
}

void YKEnterISR(void){
    // Entering a new ISR
    YKISRCallDepth++;
}

void YKExitISR(void){
    YKISRCallDepth--;
    // If there are no more registers, it is time
    // to restore context.
    if(!YKISRCallDepth){
        YKScheduler(SAVE_CONTEXT);
        YKExitMutex();
    }
}

void YKTickHandler(void){
    // Decrement delay for any blocked tasks.
    // Make tasks that are done delaying ready.
    struct TCB* browser;
    YKTickNum++;
    
    browser = readyRoot;
    while(browser){
        if(browser->state == DELAYED_ST){
            browser->delay--;
            //printString("Delaying task ");
            //printInt((int)browser->stackPtr);
            //printNewLine();
            //printInt(browser->delay);
            //printNewLine();
            if(!(browser->delay)){
                browser->state = READY_ST;
            }
            // taskToRun = browser;
            // break;
        }
        browser = browser->next;
    }
}

YKSem* YKSemCreate(int val){
    YKSem* newSem;
    if(val < 0){
        return NULL;
    }

    newSem = &YKSEMS[semi];
    *newSem = val;
    semi++;
    return newSem;
}

void YKSemPend(YKSem* sem){
    YKEnterMutex();
    if(!(*sem)){
        currentTask->state = BLOCKED_ST;
        currentTask->semBlock = sem;
        YKScheduler(SAVE_CONTEXT);
    }
    (*sem)--;
    YKExitMutex();

}

void YKSemPost(YKSem* sem){
    struct TCB* browser;

    YKEnterMutex();
    (*sem)++;
    browser = readyRoot;

    while(browser){
        if(browser->state == BLOCKED_ST && browser->semBlock == sem){
                browser->state = READY_ST;
                browser->semBlock = NULL;
                break;
        }
        browser = browser->next;
    } 

    if(YKISRCallDepth == 0){
        YKScheduler(SAVE_CONTEXT);
    }
    YKExitMutex();
}

YKQ* YKQCreate(void** start, unsigned size){
    YKQS[Qi].length = size;
    YKQS[Qi].queueAddress = start;
    YKQS[Qi].nextEmpty = start;
    YKQS[Qi].nextRemove = start;
    YKQS[Qi].state = EMPTYQ;

    Qi++;
    //printString("Before return YKQCreate\r\n");
    return &YKQS[Qi - 1];
}

void* YKQPend(YKQ* q){
    void* t;
    YKEnterMutex();
    if(q->state == EMPTYQ){
        currentTask->state = BLOCKED_Q_ST;
        currentTask->qBlock = q;
        YKScheduler(SAVE_CONTEXT);
    }

    t = (void*)* q->nextRemove;
    q->nextRemove++;

    if(q->nextRemove == q->queueAddress + q->length){
        q->nextRemove = q->queueAddress;
    }

    if(q->state == FULLQ){
        q->state = SOMEQ;
    } else if(q->nextRemove == q->nextEmpty){
        q->state = EMPTYQ;
    }
    YKExitMutex();
    return t;
}

int YKQPost(YKQ* q, void* msg){
    struct TCB* browser;
    YKEnterMutex();

    if(q->state == FULLQ){
        YKExitMutex();
        return NULL;
    }

    *(q->nextEmpty) = msg;
    q->nextEmpty++;
    // printString("NextEmpty: ")
    if(q->nextEmpty == q->queueAddress + q->length){
        q->nextEmpty = q->queueAddress;
    }

    if(q->state == EMPTYQ){
        q->state = SOMEQ;
    } else if(q->nextRemove == q->nextEmpty){
        q->state = FULLQ;
    }
    browser = readyRoot;

    while(browser){
        if(browser->state == BLOCKED_Q_ST){
            if(browser->qBlock == q){
                browser->state = READY_ST;
                browser->qBlock = NULL;
                break;
            }
        }
        browser = browser->next;
        YKExitMutex();
    }

    if(YKISRCallDepth == 0){
        YKScheduler(SAVE_CONTEXT);
    }

    YKExitMutex();
    return 1;
}

// Lab 7 EVent functions 
/*This function creates and initializes an event flags group and returns a pointer to the kernel's
data structure used to maintain that flags group. 
YKEVENT is a typedef defined in a kernel header file that must be included in any user file that uses event flags. 
The structure it defines will be used to keep track of the event flags. 
The function must be called exactly once for each event group, and that call is typically done in main in the user code.
The parameter initialValue gives the initial value that the flags group is to have.
A one bit means that the event is set and a zero bit means that it is not set.
Each event flags group is represented by a 16-bit value, allowing for 16 events in a single flags group.*/
YKEVENT *YKEventCreate(unsigned initialValue) {
    YKEvents[eventIndex].flag = initialValue;
    eventIndex++;

    return &YKEvents[eventIndex-1];
}

/*This function tests the value of the given event flags group against the mask and mode given in the eventMask and waitMode parameters.
If the conditions for the event flags are met then the function should return immediately.
Otherwise the calling task is suspended by the kernel until the the conditions are met and the scheduler is called.
The two wait modes supported are EVENT_WAIT_ALL, where the task should block until all the bits set 
in eventMask are also set in the event flags group, and EVENT_WAIT_ANY,
where the task should block until any of the bits set in eventMask are also set in the event flags group. 
EVENT_WAIT_ANY and EVENT_WAIT_ALL should each be defined in your kernel header file using #define. 
(Their actual values are not important as long as they are distinct.)
The value returned by the function is always the value of the event flags group at the time the function returns -- 
when the calling task resumes execution.
(Note that other function calls to set or reset event flags may have executed between this point in time and when the task was unblocked.)
This function is called only by tasks and never by ISRs or interrupt handlers.*/
unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode) {
    YKEnterMutex();

    if(waitMode == EVENT_WAIT_ALL){
        if(event->flag == eventMask) {
            return event->flag;
        } 
    }
    else if(waitMode == EVENT_WAIT_ANY){
        if(event->flag & eventMask){
            return event->flag;
        }
    }

    currentTask->event = event;
    currentTask->mask = eventMask;
    currentTask->mode = waitMode;
    currentTask->state = BLOCKED_EV_ST;

    YKScheduler(SAVE_CONTEXT);

    YKExitMutex();
    return event->flag;
}

/*This function is similar to a post function. 
It causes all the bits that are set in the parameter eventMask to be set in the given event flags group. 
Any tasks waiting on this event flags group need to have their wait conditions checked against the new values of the flags. 
Any task whose conditions are met should be made ready. This function can be called from both task code and interrupt handlers. 
If one or more tasks was made ready and the function is called from task code then the scheduler should be called at the end of the function. 
If called from an interrupt handler then the scheduler should not be called. 
It will be called shortly in YKExitISR after all ISR actions are completed.*/
void YKEventSet(YKEVENT *event, unsigned eventMask) {
    struct TCB* browser;
    event->flag = event->flag | eventMask;
    
    YKEnterMutex();

    browser = readyRoot;
    while(browser){
        if ((browser->state == BLOCKED_EV_ST) && (browser->event == event)) {
            if(browser->mode == EVENT_WAIT_ALL){
                if(event->flag == browser->mask){
                    printString("ALL");
                    browser->state = READY_ST;
                    browser->event = NULL;
                    browser->mask = NULL;
                    browser->mode = NULL;
                } 
            }
            else if(browser->mode == EVENT_WAIT_ANY){
                if(event->flag & browser->mask){
                    printString("ANY");
                    browser->state = READY_ST;
                    browser->event = NULL;
                    browser->mask = NULL;
                    browser->mode = NULL;
                }
            }
        }
        
        browser = browser->next;
        YKExitMutex();
    }

    if(YKISRCallDepth == 0){
        YKScheduler(SAVE_CONTEXT);
    }

    YKExitMutex();
}

void YKEventReset(YKEVENT *event, unsigned eventMask) {
    event->flag = event->flag & ~eventMask;
}


// void printTask(TCB t){
//     if(!t.priority){
//         printString("\nNo task to print\n");
//         return;
//     }
//     printNewLine();
//     printString("Task Printout:\n");
//     printString("SP: ");
//     printIninitialValuet((int)t.stackPtr);
//     printNewLine();
//     printString("Priority: ");
//     printInt(t.priority);
//     printNewLine();
// }
