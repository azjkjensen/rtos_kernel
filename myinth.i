# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "myinth.c"
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
# 2 "myinth.c" 2

extern int KeyBuffer;

static int tickCount = 0;
static int someLocalVariable = 0;

void resetHandler(){
    printString("RESETTING");
    exit(0);
}

void tickHandler(){
    printString("\nTick ");
    printInt(tickCount);
 printNewLine();
    tickCount++;
}

void loopLikeABoss(){
    int i = 0;
    for(; i < 5001; i++){
        someLocalVariable++;
    }
}

void keypressHandler(){
    if((char)KeyBuffer == 'd'){
        printString("\nDELAY KEY PRESSED\n");
        loopLikeABoss();
        printString("\nDELAY COMPLETE\n");

    } else{
        printString("\nKEYPRESS (");
        printChar((char)KeyBuffer);
        printString(") IGNORED");
        printNewLine();
    }
}
