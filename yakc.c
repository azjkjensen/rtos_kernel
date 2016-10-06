// yakc.c

#include "clib.h"
#include "yakk.h"
#include "yaku.h"

#define IDLE_TASK_PRIORITY 255

typedef struct Task* TaskPtr;

typedef struct Task
{               /* the TCB struct definition */
    int* taskFnPtr;
    void* stackPtr;     /* pointer to current top of stack */
    int priority;       /* current priority */
    int delay;          /* #ticks yet to wait */
    TaskPtr next;        /* forward ptr for dbl linked list */
    TaskPtr prev;        /* backward ptr for dbl linked list */
} Task;

Task ykTasks[MAX_NUM_TASKS+1];

TaskPtr YKSuspList;      /* tasks delayed or suspended */
TaskPtr YKAvailTCBList;      /* a list of available TCBs */
        
int YKCtxSwCount;
int YKIdleCount;

int currentTaskCount;

int YKRunTask;

int* YKContextSP;
int* YKRestoreSP;
TaskPtr YKCurrentRunningTask;
                                
// Stack frame for the idle stack.
int YKIdleTaskStack[STACK_SIZE];

// Idle task, lowest priority, spin that fool in the background.
void YKIdleTask(void){
    while(1){
        YKIdleCount++;
    }
}

void printTask(Task t){
    if(!t.priority){
        printString("\nNo task to print\n");
    }
    printNewLine();
    printString("Task Printout:\n");
    printString("SP: ");
    printInt(t.stackPtr);
    printNewLine();
    printString("Priority: ");
    printInt(t.priority);
    printNewLine();
}

TaskPtr readyRoot; // The most-ready task in our ready tasks linked-list
TaskPtr readyTail; // The lowest priority task in our ready task linked-list.

void YKInitialize(){
    YKEnterMutex(); // Enable interrupts, save context.

    currentTaskCount = 0;
    YKRunTask = 0;
    YKCurrentRunningTask = NULL;
    YKCtxSwCount = 0;
    YKIdleCount = 0;
    YKContextSP = NULL;
    YKRestoreSP = NULL;
    readyRoot = NULL;

    // Create a new task with the given task on the task stack with lowest priority
    YKNewTask(&YKIdleTask,&YKIdleTaskStack[STACK_SIZE], IDLE_TASK_PRIORITY);
}

/* Adds a task to the current ready task linked-list. */
void YKAddReadyTask(TaskPtr readyTask) {
    printString("\nYKAddReadyTask() called\n");
    if(readyTask == NULL){
        return;
        
    // Insert the new readyTask into the linked-list depending on priority.
    }else if(readyRoot == NULL){
        readyTask->next = NULL;
        readyTask->prev = NULL;
        readyRoot = readyTask;
        readyTail = readyTask;
        return;
    } else{
        TaskPtr currentNode = readyRoot;
        while(currentNode != NULL) {
            if (readyTask->priority > currentNode->priority) {
                if(currentNode->next == NULL){
                    currentNode->next = readyTask;
                    readyTask->prev = currentNode;
                    readyTask->next = NULL;
                    readyTail = readyTask;
                    return;
                }else if(readyTask->priority < (currentNode->next)->priority) { 
                    // Insert the new task between readyTask and readyTask->next 
                    TaskPtr temp = currentNode->next;
                    readyTask->next = temp;
                    currentNode->next = readyTask;
                    temp->prev = readyTask;
                    readyTask->prev = currentNode;
                    return;
                    
                }
                // Keep going
                currentNode= currentNode->next; 
            } else{ // Insert at the root
                    readyTask->next = currentNode;
                    readyTask->prev = NULL;
                    currentNode->prev = readyTask;
                    readyRoot = readyTask;
                    return;
            }
        }
    }
}

void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){
    // Append a new task struct after the lastcurrentTaskCount element of the task array.
    TaskPtr temp;
	int *tempSP;
    int k;
    YKEnterMutex();
    
    temp = &ykTasks[currentTaskCount];
    
    temp->taskFnPtr = (int*)task;
    temp->stackPtr = (int*)taskStack;
    temp->priority = priority;
    temp->delay = 0;
    temp->next = NULL;
    temp->prev = NULL;
    currentTaskCount++;
    YKAddReadyTask(temp);
    // printString("SP should be: ");
    // printInt((int*)taskStack);
    // printTask(*temp);

    if(YKRunTask){
        YKScheduler(1);
        YKExitMutex();
    }
}

void YKRun() {
    printString("\nYKRun() called\n");
    printTask(*readyRoot);

    printTask(*YKCurrentRunningTask);

    if(readyRoot == NULL){
        printString("readyRoot is null");
        return; // Error, no ready tasks
    }

    YKRunTask = 1;
    YKRestoreSP = (int*)(readyRoot->stackPtr);
    printString("\n\nFunction Pointer: ");
    printInt(readyRoot->taskFnPtr);
    // printInt(YKRestoreSP);
    YKCurrentRunningTask = readyRoot;
    YKCtxSwCount++;
    YKDispatcher(0, readyRoot->taskFnPtr);
}

void YKScheduler(unsigned contextSave){
    printString("SCHEDULER: \n");
    // printTask(*readyRoot);
    // printTask(*YKCurrentRunningTask);
    if (readyRoot != YKCurrentRunningTask) {
        YKCtxSwCount++;
        YKContextSP = (int*)(YKCurrentRunningTask->stackPtr);
        YKRestoreSP = (int*)(readyRoot->stackPtr);
        printNewLine();
        printInt(YKContextSP);
        printNewLine();
        printInt(YKRestoreSP);
        // print context and restore, and then check in dispatcher
        YKCurrentRunningTask = readyRoot;
        YKDispatcher(contextSave, readyRoot->taskFnPtr); //Dispatch that junk and save context if necessary
    }
}

void printhelp() {
    printString("Finished dispatcher");
    // YKContextSaver();
}
