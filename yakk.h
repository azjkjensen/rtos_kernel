// yakk.h
#include "yaku.h"

#define NULL 0
// TASK STATES
#define DELAYED_ST 0
#define READY_ST 1
#define BLOCKED_ST 2
#define BLOCKED_Q_ST 3
#define RUN_STATE 4

#define EMPTYQ 0
#define FULLQ 1
#define SOMEQ 2

#define SAVE_CONTEXT 1
#define DONT_SAVE_CONTEXT 0

typedef int YKSem;

typedef struct {
    void** queueAddress;
    unsigned length;
    void** nextEmpty;
    void** nextRemove;
    unsigned state;
} YKQ;

extern int YKCtxSwCount;
extern int YKIdleCount;
extern YKSem* NSemPtr;

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