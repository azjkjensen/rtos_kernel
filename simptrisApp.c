
#include "simptris.h"
#include "yakk.h"
#include "clib.h"

#define TASK_STACK_SIZE 512
#define FIELD_WIDTH 6
#define FIELD_HEIGHT 16

int STaskStk[TASK_STACK_SIZE];
int TaskStatStk[TASK_STACK_SIZE];
long seed = 37428;




int columns[FIELD_WIDTH];

void buildColumnsArray() {
    // int x, y;
    // for (x= 0; x < FIELD_WIDTH; x++) {
    //     for (y = 0; y < FIELD_HEIGHT; y++) {
    //         field[x][y] = node();
    //     }
    // }
}

void decidePlacement() {
    if (NewPieceType == 0) {    // 0 for corner
        int col;
        int bestX1, bestX2;
        int bestHeight1, bestHeight2;
        int rotation;
        bestX1 = -1;
        bestX2 = -1;
        bestHeight1 = 100;
        bestHeight2 = 100;

        // Rotation 2
        for (col = 0; col < FIELD_WIDTH -1; col++) {
            if (columns[col] == columns[col + 1] + 1) {
                if (columns[col] < bestHeight1) {
                    bestX1 = col + 1;
                    bestHeight1 = columns[col];
                }
            }
        }
        // Rotation 3
        for (col = 0; col < FIELD_WIDTH -1; col++) {
            if (columns[col] == columns[col + 1] - 1) {
                if (columns[col] < bestHeight2) {
                    bestX2 = col;
                    bestHeight2 = columns[col] + 1;
                }
            }
        }    
        // Rotation 0 & 1
        if (bestX1 == -1 && bestX2 == -1) {
            for (col = 0; col < FIELD_WIDTH - 1; col++) {
                if (columns[col] == columns[col + 1]) {
                    if (columns[col] < bestHeight1) {
                        bestX1 = col;
                        bestHeight1 = columns[col];
                        rotation = 0;
                    }
                }
            }
            // actually place the piece using bestHeight1
            /*
                SlidePiece(int ID, int direction)
                RotatePiece(int ID, int direction) 
            */
            if (bestX1 == -1) {
                printString("There was no good spot found");
            }            

        } else {

            // compare two results
            if (bestHeight1 < bestHeight2) {
                // actually place the piece using bestHeight1
                /*
                    SlidePiece(int ID, int direction)
                    RotatePiece(int ID, int direction) 
                */
            } else {
                // actually place the piece using bestHeight2
                /*
                    SlidePiece(int ID, int direction)
                    RotatePiece(int ID, int direction) 
                */            
            } 
        }

    }

// *****************************************************************************
// *****************************************************************************

    else {   
                           // 1 for straight piece
        int col;
        int bestX;
        int bestHeight;
        int rotation;

        bestX = -1;
        bestHeight = 100;

        // rotation 0
        for (col = 0; col < FIELD_WIDTH - 2; col++) {
            if (columns[col] == columns[col + 1] && column[col] == columns[col + 2]) {
                if (columns[col] < bestHeight) {
                    bestX = col;
                    bestHeight = columns[col];
                }
            }
        }
        if (bestX != -1) {
            rotation = 0;
            bestX++;        // center is in the middle of the piece
            //done
            
        // rotation 1            
        } else {
            bestX = getMinValueIndex();
            rotation = 1;
        }

    }
    // actually place the piece 
    /*
        SlidePiece(int ID, int direction)
        RotatePiece(int ID, int direction) 
    */
}


int getMinValueIndex() {
    int i;
    int minVal;
    int returnIndex;

    minVal = 20;    // arbitrary bigger than 16
    for (i = 0; i < FIELD_WIDTH; i++) {
        if (columns[i] < minVal) {
            minVal = arr[i];
            returnIndex = i;
        }
    }
    return returnIndex;
}

int getScore(int col, int rot) {
    int score;
    score = 0;

    return score;
}

void STask() {
     while(1) {
         YKDelayTask(20);
        //  printString("You made it\n");
    }
}

void TaskStat(void)                /* a task to track statistics */
{
    unsigned max, switchCount, idleCount;
    int tmp;
        
    YKDelayTask(1);
    // printString("Welcome to the YAK kernel\r\n");
    // printString("Determining CPU capacity\r\n");
    YKDelayTask(1);
    YKIdleCount = 0;
    YKDelayTask(5);
    max = YKIdleCount / 25;
    YKIdleCount = 0;

    // YKNewTask(TaskPrime, (void *) &TaskPRMStk[TASK_STACK_SIZE], 32);
    // YKNewTask(TaskWord,  (void *) &TaskWStk[TASK_STACK_SIZE], 10);
    // YKNewTask(TaskSpace, (void *) &TaskSStk[TASK_STACK_SIZE], 11);
    // YKNewTask(TaskPunc,  (void *) &TaskPStk[TASK_STACK_SIZE], 12);
    
    while (1)
    {
        YKDelayTask(20);
        topRow = 0;
        YKEnterMutex();
        switchCount = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKExitMutex();
        <CS: #, CPU: #>
        printString ("<CS: ");
        printInt((int)switchCount);
        printString (", CPU: ");
        tmp = (int) (idleCount/max);
        printInt(100-tmp);
        printString(">\r\n");
        
        YKEnterMutex();
        YKCtxSwCount = 0;
        YKIdleCount = 0;
        YKExitMutex();
    }
}  

void main() {
    YKInitialize();
    topRow = 0;
    deepestNodeX = 0;
    deepestNodeY = 0;
    // charEvent = YKEventCreate(0);
    // numEvent = YKEventCreate(0);
    YKNewTask(STask, (void *) &STaskStk[TASK_STACK_SIZE], 10);
    
    StartSimptris();
    SeedSimptris(seed);
    YKNewTask(TaskStat, (void *) &TaskStatStk[TASK_STACK_SIZE], 30);

    YKRun();
}