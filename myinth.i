# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "myinth.c"
# 1 "lab6defs.h" 1
# 9 "lab6defs.h"
struct msg
{
    int tick;
    int data;
};
# 2 "myinth.c" 2
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
# 3 "myinth.c" 2
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
# 4 "myinth.c" 2
# 1 "lab7defs.h" 1
# 15 "lab7defs.h"
extern YKEVENT *charEvent;
extern YKEVENT *numEvent;
# 5 "myinth.c" 2
extern int KeyBuffer;
extern YKQ* MsgQPtr;
extern int YKTickNum;




int tickCount = 1;
static int someLocalVariable = 0;

void resetHandler(){

    exit(0);
}

void tickHandler(){

    static int curMsgi = 0;
    static int data = 0;


    data = (data + 89) % 100;
# 41 "myinth.c"
    YKTickHandler();
}

void loopLikeABoss(){
    int i = 0;
    for(; i < 5001; i++){
        someLocalVariable++;
    }
}

void keypressHandler(){
    char c;

    c = KeyBuffer;
# 68 "myinth.c"
}
