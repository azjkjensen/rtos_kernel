// yakk.h

#define NULL 0

extern int YKCtxSwCount;
extern int YKIdleCount;

void YKinitialize();
void YKEnterMutex();
void YKExitMutex();
void YKinitialize();
void YKIdleTask();
void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority);
void YKRun();
void YKScheduler();
void YKDispatcher();