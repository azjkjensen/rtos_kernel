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

# 1 "yaku.h" 1
# 3 "yakk.h" 2
# 12 "yakk.h"
extern int YKCtxSwCount;
extern int YKIdleCount;

void YKInitialize(void);
void YKEnterMutex(void);
void YKExitMutex(void);
void YKinitialize(void);
void YKIdleTask(void);
void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority);
void YKRun(void);
void YKScheduler(unsigned char saveContext);
void YKDispatcher(unsigned char saveContext);
void YKDelayTask(unsigned count);
void YKEnterISR(void);
void YKExitISR(void);
void YKTickHandler(void);
# 5 "yakc.c" 2





struct TCB
{
    unsigned* stackPtr;
    unsigned char state;
    unsigned char priority;
    struct TCB *next;
    int delay;
};

struct TCB YKTCBs[10];

int YKCtxSwCount = 0;
int YKIdleCount = 0;
int YKISRCallDepth = 0;
int YKTickNum = 0;
struct TCB* readyRoot;
struct TCB* currentTask = 0;
struct TCB* saveContextTask = 0;
struct TCB* taskToRun;
char running = 0;

int TCBi = 0;

void YKIdleTask(void);

int YKIdleTasks[256];

void YKInitialize(){
    YKEnterMutex();


    YKNewTask(&YKIdleTask,(void*)&YKIdleTasks[256], 100);



}


void YKIdleTask(void){

    while(1){

        YKEnterMutex();
        YKIdleCount++;

        YKExitMutex();
    }
}

void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){
    unsigned* newStackPointer;
    int i;

    YKTCBs[TCBi].state = 1;
    YKTCBs[TCBi].priority = priority;
    YKTCBs[TCBi].delay = 0;

    newStackPointer = (unsigned*)taskStack - 11;

    for(i = 0; i < 8; i++){
        newStackPointer[i] = 0;
    }

    newStackPointer[8] = (unsigned) task;
    newStackPointer[9] = 0;
    newStackPointer[10] = 0x0200;


    YKTCBs[TCBi].stackPtr = newStackPointer - 1;

    if(TCBi == 0){
        readyRoot = &YKTCBs[TCBi];
        YKTCBs[TCBi].next = 0;
    }else{
        if(priority < readyRoot->priority){
            YKTCBs[TCBi].next = readyRoot;
            readyRoot = &YKTCBs[TCBi];
        }else{
            struct TCB* browser;
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
        YKScheduler(1);
    }
}

void YKScheduler(unsigned char saveContext){
    struct TCB* browser;

    browser = readyRoot;
    while(browser){
        if(browser->state == 1){
            taskToRun = browser;
            break;
        }
        browser = browser->next;
    }

    if(taskToRun != currentTask){
        saveContextTask = currentTask;
        currentTask = taskToRun;
        YKCtxSwCount++;
        YKDispatcher(saveContext);
    }
}

void YKRun() {

    running = 1;
    YKScheduler(0);
}

void YKDelayTask(unsigned count){

    if(!count){
        return;
    }else{

        currentTask->delay = count;
        currentTask->state = 0;

        YKScheduler(1);
    }

}

void YKEnterISR(void){

    YKISRCallDepth++;
}

void YKExitISR(void){
    YKISRCallDepth--;


    if(!YKISRCallDepth){
        YKScheduler(1);
    }
}

void YKTickHandler(void){


    struct TCB* browser;
    YKTickNum++;

    browser = readyRoot;
    while(browser){
        if(browser->state == 0){
            browser->delay--;




            if(!(browser->delay)){
                browser->state = 1;
            }


        }
        browser = browser->next;
    }
}
