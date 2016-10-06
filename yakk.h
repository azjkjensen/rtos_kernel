// yakk.h

#define NULL 0

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