# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"


# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 4 "yakc.c" 2
# 1 "yakk.h" 1




extern int YKCtxSwCount;
extern int YKIdleCount;
extern int tickCount;

void YKinitialize();
void YKEnterMutex();
void YKExitMutex();
void YKinitialize();
void YKIdleTask();
void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority);
void YKRun();
void YKScheduler(unsigned contextSave);
void YKDispatcher(unsigned contextSave, int* taskFnPtr);
# 5 "yakc.c" 2
# 1 "yaku.h" 1
# 6 "yakc.c" 2



typedef struct Task* TaskPtr;

typedef struct Task
{
    int* taskFnPtr;
    void* stackPtr;
    int priority;
    int delay;
    TaskPtr next;
    TaskPtr prev;
} Task;

Task ykTasks[10 +1];

TaskPtr YKSuspList;
TaskPtr YKAvailTCBList;

int YKCtxSwCount;
int YKIdleCount;

int currentTaskCount;

int YKRunTask;

int* YKContextSP;
int* YKRestoreSP;
TaskPtr YKCurrentRunningTask;


int YKIdleTaskStack[256];


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

TaskPtr readyRoot;
TaskPtr readyTail;

void YKInitialize(){
    YKEnterMutex();

    currentTaskCount = 0;
    YKRunTask = 0;
    YKCurrentRunningTask = 0;
    YKCtxSwCount = 0;
    YKIdleCount = 0;
    YKContextSP = 0;
    YKRestoreSP = 0;
    readyRoot = 0;


    YKNewTask(&YKIdleTask,&YKIdleTaskStack[256], 255);
}


void YKAddReadyTask(TaskPtr readyTask) {
    printString("\nYKAddReadyTask() called\n");
    if(readyTask == 0){
        return;


    }else if(readyRoot == 0){
        readyTask->next = 0;
        readyTask->prev = 0;
        readyRoot = readyTask;
        readyTail = readyTask;
        return;
    } else{
        TaskPtr currentNode = readyRoot;
        while(currentNode != 0) {
            if (readyTask->priority > currentNode->priority) {
                if(currentNode->next == 0){
                    currentNode->next = readyTask;
                    readyTask->prev = currentNode;
                    readyTask->next = 0;
                    readyTail = readyTask;
                    return;
                }else if(readyTask->priority < (currentNode->next)->priority) {

                    TaskPtr temp = currentNode->next;
                    readyTask->next = temp;
                    currentNode->next = readyTask;
                    temp->prev = readyTask;
                    readyTask->prev = currentNode;
                    return;

                }

                currentNode= currentNode->next;
            } else{
                    readyTask->next = currentNode;
                    readyTask->prev = 0;
                    currentNode->prev = readyTask;
                    readyRoot = readyTask;
                    return;
            }
        }
    }
}

void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){

    TaskPtr temp;
 int *tempSP;
    int k;
    YKEnterMutex();

    temp = &ykTasks[currentTaskCount];

    temp->taskFnPtr = (int*)task;
    temp->stackPtr = (int*)taskStack;
    temp->priority = priority;
    temp->delay = 0;
    temp->next = 0;
    temp->prev = 0;
    currentTaskCount++;
    YKAddReadyTask(temp);




    if(YKRunTask){
        YKScheduler(1);
        YKExitMutex();
    }
}

void YKRun() {
    printString("\nYKRun() called\n");
    printTask(*readyRoot);

    printTask(*YKCurrentRunningTask);

    if(readyRoot == 0){
        printString("readyRoot is null");
        return;
    }

    YKRunTask = 1;
    YKRestoreSP = (int*)(readyRoot->stackPtr);
    printString("\n\nFunction Pointer: ");
    printInt(readyRoot->taskFnPtr);

    YKCurrentRunningTask = readyRoot;
    YKCtxSwCount++;
    YKDispatcher(0, readyRoot->taskFnPtr);
}

void YKScheduler(unsigned contextSave){
    printString("SCHEDULER: \n");


    if (readyRoot != YKCurrentRunningTask) {
        YKCtxSwCount++;
        YKContextSP = (int*)(YKCurrentRunningTask->stackPtr);
        YKRestoreSP = (int*)(readyRoot->stackPtr);
        printNewLine();
        printInt(YKContextSP);
        printNewLine();
        printInt(YKRestoreSP);

        YKCurrentRunningTask = readyRoot;
        YKDispatcher(contextSave, readyRoot->taskFnPtr);
    }
}

void printhelp() {
    printString("Finished dispatcher");

}
