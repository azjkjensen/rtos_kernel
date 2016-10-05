# 1 "lab4bapp.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab4bapp.c"






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
# 8 "lab4bapp.c" 2
# 1 "yakk.h" 1




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
void YKDispatcher(unsigned contextSave);
# 9 "lab4bapp.c" 2





int AStk[256];
int BStk[256];
int CStk[256];

void ATask(void);
void BTask(void);
void CTask(void);

void main(void)
{


    printString("Creating task A...\n");




    printString("made it!");
}

void ATask(void)
{
    printString("Task A started!\n");
# 46 "lab4bapp.c"
}

void BTask(void)
{
    printString("Task B started! Oh no! Task B wasn't supposed to run.\n");
    exit(0);
}

void CTask(void)
{
    int count;
    unsigned numCtxSwitches;
# 72 "lab4bapp.c"
}
