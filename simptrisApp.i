# 1 "simptrisApp.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "simptrisApp.c"

# 1 "simptris.h" 1


void SlidePiece(int ID, int direction);
void RotatePiece(int ID, int direction);
void SeedSimptris(long seed);
void StartSimptris(void);
# 3 "simptrisApp.c" 2
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
# 4 "simptrisApp.c" 2
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
# 5 "simptrisApp.c" 2



int STaskStk[512];
long seed = 37428;

void STask() {
     while(1) {
         YKDelayTask(20);
         printString("You made it\n");
    }
}

void main() {
    YKInitialize();




    YKNewTask(STask, (void *) &STaskStk[512], 10);

    StartSimptris();
    SeedSimptris(seed);

    YKRun();
}
