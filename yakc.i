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



extern int YKCtxSwCount;
extern int YKIdleCount;

void YKinitialize(void);
void YKEnterMutex(void);
void YKExitMutex(void);
void YKinitialize(void);
void YKIdleTask(void);
void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority);
void YKRun(void);
void YKScheduler(void);
void YKDispatcher(void);
# 5 "yakc.c" 2
# 13 "yakc.c"
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



    YKNewTask(&YKIdleTask,(void*)&YKIdleTasks[256], 100);

    saveContextTask = &YKTCBs[0];
}


void YKIdleTask(void){

    while(1){
        YKIdleCount++;
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
        YKScheduler();
    }
}

void YKRun() {

    running = 1;
    YKScheduler();
}

void YKScheduler(){
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
        currentTask = taskToRun;
        YKCtxSwCount++;
        YKDispatcher();
    }
}
