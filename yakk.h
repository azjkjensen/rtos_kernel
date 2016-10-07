// yakk.h
#include "yaku.h"

#define NULL 0

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