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
# 23 "yakk.h"
typedef int YKSem;

typedef struct {
    void** queueAddress;
    unsigned length;
    void** nextEmpty;
    void** nextRemove;
    unsigned state;
} YKQ;



typedef struct YKEVENT
{
    unsigned flag;
} YKEVENT;

extern int YKCtxSwCount;
extern int YKIdleCount;
extern YKSem* NSemPtr;
extern int YKTickNum;
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
YKSem* YKSemCreate(int val);
void YKSemPend(YKSem *sem);
void YKSemPost(YKSem *sem);
YKQ* YKQCreate(void** start, unsigned size);
void* YKQPend(YKQ* q);
int YKQPost(YKQ* q, void* msg);
YKEVENT *YKEventCreate(unsigned initialValue);
unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode);
void YKEventSet(YKEVENT *event, unsigned eventMask);
void YKEventReset(YKEVENT *event, unsigned eventMask);
# 5 "yakc.c" 2
# 1 "yaku.h" 1
# 6 "yakc.c" 2



struct TCB
{
    unsigned* stackPtr;
    unsigned char state;
    unsigned char priority;
    struct TCB *next;
    int delay;
    YKSem* semBlock;
    YKQ* qBlock;

    YKEVENT* event;
    int mode;
    unsigned mask;
};

struct TCB YKTCBs[10];
YKSem YKSEMS[50];
YKQ YKQS[10];
YKEVENT YKEvents[50];

int YKCtxSwCount = 0;
int YKIdleCount = 0;
int YKISRCallDepth = 0;
int YKTickNum = 1;

struct TCB* readyRoot;
struct TCB* currentTask = 0;
struct TCB* saveContextTask = 0;
struct TCB* taskToRun;

char running = 0;

int TCBi = 0;
int semi = 0;
int Qi = 0;
int eventIndex = 0;

int YKIdleTasks[256];

void YKIdleTask(void);

void YKInitialize(){
    YKEnterMutex();


    YKNewTask(YKIdleTask,(void*)&YKIdleTasks[256], 100);



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

    YKEnterMutex();
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
    YKEnterMutex();
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

    YKEnterMutex();

    if(!count){

        return;
    }else{


        currentTask->delay = count;
        currentTask->state = 0;

        YKScheduler(1);
        YKExitMutex();
    }

}

void YKEnterISR(void){

    YKISRCallDepth++;
}

void YKExitISR(void){
    YKISRCallDepth--;


    if(!YKISRCallDepth){
        YKScheduler(1);
        YKExitMutex();
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

YKSem* YKSemCreate(int val){
    YKSem* newSem;
    if(val < 0){
        return 0;
    }

    newSem = &YKSEMS[semi];
    *newSem = val;
    semi++;
    return newSem;
}

void YKSemPend(YKSem* sem){
    YKEnterMutex();
    if(!(*sem)){
        currentTask->state = 2;
        currentTask->semBlock = sem;
        YKScheduler(1);
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
        if(browser->state == 2 && browser->semBlock == sem){
                browser->state = 1;
                browser->semBlock = 0;
                break;
        }
        browser = browser->next;
    }

    if(YKISRCallDepth == 0){
        YKScheduler(1);
    }
    YKExitMutex();
}

YKQ* YKQCreate(void** start, unsigned size){
    YKQS[Qi].length = size;
    YKQS[Qi].queueAddress = start;
    YKQS[Qi].nextEmpty = start;
    YKQS[Qi].nextRemove = start;
    YKQS[Qi].state = 0;

    Qi++;

    return &YKQS[Qi - 1];
}

void* YKQPend(YKQ* q){
    void* t;
    YKEnterMutex();
    if(q->state == 0){
        currentTask->state = 3;
        currentTask->qBlock = q;
        YKScheduler(1);
    }

    t = (void*)* q->nextRemove;
    q->nextRemove++;

    if(q->nextRemove == q->queueAddress + q->length){
        q->nextRemove = q->queueAddress;
    }

    if(q->state == 1){
        q->state = 2;
    } else if(q->nextRemove == q->nextEmpty){
        q->state = 0;
    }
    YKExitMutex();
    return t;
}

int YKQPost(YKQ* q, void* msg){
    struct TCB* browser;
    YKEnterMutex();

    if(q->state == 1){
        YKExitMutex();
        return 0;
    }

    *(q->nextEmpty) = msg;
    q->nextEmpty++;

    if(q->nextEmpty == q->queueAddress + q->length){
        q->nextEmpty = q->queueAddress;
    }

    if(q->state == 0){
        q->state = 2;
    } else if(q->nextRemove == q->nextEmpty){
        q->state = 1;
    }
    browser = readyRoot;

    while(browser){
        if(browser->state == 3){
            if(browser->qBlock == q){
                browser->state = 1;
                browser->qBlock = 0;
                break;
            }
        }
        browser = browser->next;
        YKExitMutex();
    }

    if(YKISRCallDepth == 0){
        YKScheduler(1);
    }

    YKExitMutex();
    return 1;
}
# 348 "yakc.c"
YKEVENT *YKEventCreate(unsigned initialValue) {
    YKEvents[eventIndex].flag = initialValue;
    eventIndex++;

    return &YKEvents[eventIndex-1];
}
# 367 "yakc.c"
unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode) {
    YKEnterMutex();

    if(waitMode == 2){
        if(event->flag == eventMask) {
            return event->flag;
        }
    }
    else if(waitMode == 1){
        if(event->flag & eventMask){
            return event->flag;
        }
    }

    currentTask->event = event;
    currentTask->mask = eventMask;
    currentTask->mode = waitMode;
    currentTask->state = 5;

    YKScheduler(1);

    YKExitMutex();
    return event->flag;
}
# 399 "yakc.c"
void YKEventSet(YKEVENT *event, unsigned eventMask) {
    struct TCB* browser;
    event->flag = event->flag | eventMask;

    YKEnterMutex();

    browser = readyRoot;
    while(browser){
        if ((browser->state == 5) && (browser->event == event)) {
            if(browser->mode == 2){
                if(event->flag == browser->mask){
                    printString("ALL");
                    browser->state = 1;
                    browser->event = 0;
                    browser->mask = 0;
                    browser->mode = 0;
                }
            }
            else if(browser->mode == 1){
                if(event->flag & browser->mask){
                    printString("ANY");
                    browser->state = 1;
                    browser->event = 0;
                    browser->mask = 0;
                    browser->mode = 0;
                }
            }
        }

        browser = browser->next;
        YKExitMutex();
    }

    if(YKISRCallDepth == 0){
        YKScheduler(1);
    }

    YKExitMutex();
}

void YKEventReset(YKEVENT *event, unsigned eventMask) {
    event->flag = event->flag & ~eventMask;
}
