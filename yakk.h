// yakk.h
#include "yaku.h"

#define NULL 0
// TASK STATES
#define BLOCKED_ST 0
#define READY_ST 1

#define SAVE_CONTEXT 1
#define DONT_SAVE_CONTEXT 0

extern int YKCtxSwCount;
extern int YKIdleCount;

void YKinitialize(void);
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