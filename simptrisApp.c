
#include "simptris.h"
#include "yakk.h"
#include "clib.h"

#define TASK_STACK_SIZE 512
#define FIELD_WIDTH 6
#define FIELD_HEIGHT 16

#define CLOCKWISE 1
#define COUNTER_CLOCKWISE 0
#define LEFT 0
#define RIGHT 1
#define MSGQSIZE 20
#define MSGARRAYSIZE 30

#define STRAIGHT_LIMIT 7

extern unsigned NewPieceID;
extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;
extern unsigned NewPieceColumn;

unsigned MyNewPieceID;
unsigned MyNewPieceType;
unsigned MyNewPieceOrientation;
unsigned MyNewPieceColumn;

unsigned straightCounter;
unsigned cornerCounter;

YKQ* commandQPtr;
YKSem* communicateSem;
YKSem* newPieceSem;

int TaskStatStk[TASK_STACK_SIZE];
int CommunicateTaskStk[TASK_STACK_SIZE];
int NewPieceTaskStk[TASK_STACK_SIZE];


long seed = 1247;

int columns[FIELD_WIDTH];

// message queue
typedef struct msg {
    void (*func)(int,int);
    int direction;
    int id;
} msg;

void *MsgQ[MSGQSIZE];           /* space for message queue */
YKQ *MsgQPtr;                   /* actual name of queue */
msg MsgArray[MSGARRAYSIZE];  /* buffers for message content */
// end message queue

int getMinValueIndex();
void slide(int targetCol, unsigned* next);
void rotate(int targetOrientation, unsigned* next);
void myPost(void (*func)(int, int), int id, int direction, unsigned* next);
void communicateTask();

void buildColumnsArray(int centerCol, int rotation, int type) {
    if (type == 0) {    // corner piece
        switch(rotation) {
            case 0:
                columns[centerCol] += 2;
                columns[centerCol + 1] += 1;
                break;
            case 1:
                columns[centerCol] += 2;
                columns[centerCol - 1] += 1;            
                break;
            case 2:
                columns[centerCol] += 2;
                columns[centerCol - 1] += 1;             
                break;
            case 3:
                columns[centerCol] += 2;
                columns[centerCol + 1] += 1;                
                break;
        }
    } else {
        switch(rotation) {
            case 0:
                columns[centerCol] += 1;
                columns[centerCol + 1] += 1;
                columns[centerCol - 1] += 1;                            
                break;
            case 1:
                columns[centerCol] += 3;            
                break;
        }
    }
}

void placement(int bestX, int rotation, int type, unsigned* next) {
    if (MyNewPieceColumn == 0) {
        // printString("\nSliding ");
        // printInt(MyNewPieceID);
        // printString(" right\n");
        myPost(&SlidePiece, MyNewPieceID, RIGHT, next);
        MyNewPieceColumn++;
    } else if (MyNewPieceColumn == 5) {
        // printString("column 5");
        // printString("\nSliding ");
        // printInt(MyNewPieceID);
        // printString(" left\n");
        myPost(&SlidePiece, MyNewPieceID, LEFT, next);
        MyNewPieceColumn--;
    } 

    // printString("\nTarget: ");
    // printInt(bestX);
    // printString(" Column: ");
    // printInt(MyNewPieceColumn);
    // printString("Piece ID ");
    // printInt(MyNewPieceID);

    slide(bestX, next);
    rotate(rotation, next);
    buildColumnsArray(bestX, rotation, type);

    // printString("\nbest x: ");
    // printInt(bestX);
    // printString("\nrotation: ");
    // printInt(rotation);
}

void decidePlacementTask(void) {
    static unsigned next = 0;
    static unsigned orientFlag = 0;
    int temp;
    int swap;
    YKEnterMutex();
    straightCounter = 0;
    cornerCounter = 0;
    YKExitMutex();
    // while (1) {
    //     YKSemPend(newPieceSem);
    //     YKEnterMutex();
    //     MyNewPieceID = NewPieceID;
    //     MyNewPieceType = NewPieceType;
    //     MyNewPieceOrientation = NewPieceOrientation;
    //     MyNewPieceColumn = NewPieceColumn;

    //     YKExitMutex();
    //     if(MyNewPieceType == 0){ // Corner piece
    //         printString("\nCorner\n");
    //         // Check for edge
    //         if(MyNewPieceColumn == 5){
    //             slide(4,&next);
    //             MyNewPieceColumn--;
    //         } else if(MyNewPieceColumn == 0){
    //             slide(1,&next);
    //             MyNewPieceColumn++;
    //         }
    //         if(orientFlag){ // Orientation 2

    //             if(swap){
    //                 // printString("\nTarget: ");
    //                 // printInt(2);
    //                 // printString(" Column: ");
    //                 printInt(MyNewPieceColumn);
    //                 rotate(2, &next);
    //                 slide(2, &next);
    //             }else{
    //                 // printString("\nTarget: ");
    //                 // printInt(5);
    //                 // printString(" Column: ");
    //                 printInt(MyNewPieceColumn);
    //                 rotate(2, &next);
    //                 slide(5, &next);
    //             }

                
    //             // printString("\nTarget: ");
    //             // printInt(2);
    //             // printString(" Orientation: ");
    //             // printInt(MyNewPieceOrientation);
    //             // placement(5,2,MyNewPieceType,&next);
    //         }else{
    //             if(cornerCounter > straightCounter){
    //                 // Switch sides for two corner pieces
    //                 swap = (swap == 1)? 0:1;
    //                 temp = cornerCounter;
    //                 cornerCounter = straightCounter;
    //                 straightCounter = temp;
    //             }
    //             // Slide then rotate
    //             if(swap){
    //                 placement(0,0,MyNewPieceType,&next);
    //             }else{
    //                 placement(3,0,MyNewPieceType,&next);
    //             }
    //         }
    //         orientFlag = (orientFlag == 1)? 0:1;
    //         if(orientFlag == 0){
    //             cornerCounter++;
    //         }
    //     }else{
    //         printString("\nStraight\n");
    //         if(cornerCounter < straightCounter && orientFlag == 0){
    //             swap = (swap == 1)? 0:1;
    //             temp = cornerCounter;
    //             cornerCounter = straightCounter;
    //             straightCounter = temp;
    //             //Place on the right.
    //             straightCounter = 0;
    //         }
    //         straightCounter++;
    //         if(swap){
    //             // printString("\nHERE ");
    //             // printInt(MyNewPieceType);
    //             placement(4,0,MyNewPieceType, &next);
    //         }else{
    //             placement(1,0,MyNewPieceType, &next);
    //         }

    //     }

    // printString("\ndeciding...\n");
    //     printString("\ntype: ");
    //     printInt(NewPieceType);
    //     printString("\norientation: ");
    //     printInt(NewPieceOrientation);
    //     printString("\ncolumn: ");
    //     printInt(NewPieceColumn);
        if (MyNewPieceType == 0) {    // 0 for corner
            int col;
            int bestX1, bestX2;
            int bestHeight1, bestHeight2;
            int rotation;
            bestX1 = -1;
            bestX2 = -1;
            bestHeight1 = 100;
            bestHeight2 = 100;

            // Rotation 2
            printNewLine();
            for (col = 0; col < FIELD_WIDTH -1; col++) {
                // printInt(columns[col]);
                if (columns[col] == columns[col + 1] + 1) {
                    if (columns[col] < bestHeight1) {
                        bestX1 = col + 1;
                        bestHeight1 = columns[col];
                        rotation = 2;
                        // printString("\nchecking rotation 2\n");
                    }
                }
            }
            printNewLine();
            // Rotation 3
            for (col = 0; col < FIELD_WIDTH -1; col++) {
                if (columns[col] == columns[col + 1] - 1) {
                    if (columns[col] < bestHeight2) {
                        bestX2 = col;
                        bestHeight2 = columns[col] + 1;
                        rotation = 3;
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
                placement(bestX1, rotation, 0, &next);

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
                    placement(bestX1, rotation, 0, &next);

                } else {
                    // actually place the piece using bestHeight2
                    /*
                        SlidePiece(int ID, int direction)
                        RotatePiece(int ID, int direction) 
                    */ 
                    placement(bestX2, rotation, 0, &next);

                } 
            }
        }

    // // *****************************************************************************
    // // *****************************************************************************

        else {   
                            // 1 for straight piece
            // printString("examining straight piece\r\n");
            int col;
            int bestX;
            int bestHeight;
            int rotation;

            bestX = -1;
            bestHeight = 100;

            // rotation 0
            printString("\n");
            for (col = 0; col < FIELD_WIDTH - 1; col++) {
                printInt(columns[col]);
                if (columns[col] == columns[col + 1] && columns[col] == columns[col + 2]) {
                    if (columns[col] < bestHeight) {
                        bestX = col;
                        bestHeight = columns[col];
                    }
                }
            }
            printString("\n");
            if (bestX != -1) {
                rotation = 0;
                bestX++;        // center is in the middle of the piece
                //done
                
            // rotation 1            
            } else {
                bestX = getMinValueIndex();
                rotation = 1;
            }

            // actually place the piece 
            /*
                SlidePiece(int ID, int direction)
                RotatePiece(int ID, int direction) 
            */
            placement(bestX, rotation, 1, &next);
        }
    // }
}

void slide(int targetCol, unsigned* next) {
    int vectorMovement;
    int isLeft;
    isLeft = 0;
    vectorMovement = targetCol - MyNewPieceColumn;

    if (vectorMovement < 0) {    // moving left
        vectorMovement = -vectorMovement;
        isLeft = 1;
    }

    while (vectorMovement > 0) {
        // add to queue
        if (isLeft) {
            // move left 
            // printString("\nSliding ");
            // printInt(MyNewPieceID);
            // printString(" left\n");
            myPost(&SlidePiece, MyNewPieceID, LEFT, next);
        } else {
            // move right
            // printString("\nSliding ");
            // printInt(MyNewPieceID);
            // printString(" right\n");
            myPost(&SlidePiece, MyNewPieceID, RIGHT, next);
        }
        vectorMovement--;
    }
}

void rotate(int targetOrientation, unsigned* next) {
    // if(MyNewPieceType == 1){
    //     if(targetOrientation != MyNewPieceOrientation){
    //         // Rotate
    //         myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
    //     }
    // }else{
    //     if(targetOrientation == MyNewPieceOrientation){
    //         return;
    //     }else if (targetOrientation == 0){
    //         switch(MyNewPieceOrientation){
    //             case 1:
    //                 myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
    //                 break;
    //             case 2:
    //                 myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
    //                 myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
    //                 break;
    //             case 3:
    //                 myPost(&RotatePiece, MyNewPieceID, COUNTER_CLOCKWISE, next);
    //                 break;
    //         }
    //     }else if(targetOrientation == 2){
    //         switch(MyNewPieceOrientation){
    //             case 0:
    //                 myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
    //                 myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
    //                 break;
    //             case 1:
    //                 myPost(&RotatePiece, MyNewPieceID, COUNTER_CLOCKWISE, next);
    //                 break;
    //             case 3:
    //                 myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
    //                 break;
    //         }
    //     }
    // }
    int vectorRotation;
    int isClockwise;
    isClockwise = 0;
    vectorRotation = targetOrientation - MyNewPieceOrientation;

    if (vectorRotation < 0) {   //rotate CLOCKWISE
        if (vectorRotation == -3) {
            // rotate CLOCKWISE 1
            // printString("\nRotating ");
            // printInt(MyNewPieceID);
            // printString(" clockwise\n");
            myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
            return;
        }
        vectorRotation = -vectorRotation;
        isClockwise = 1;
    }
    if (vectorRotation == 3) {
        // rotate COUNTER_CLOCKWISE 1
        // printString("\nRotating ");
        // printInt(MyNewPieceID);
        // printString(" counterclockwise\n");
        myPost(&RotatePiece, MyNewPieceID, COUNTER_CLOCKWISE, next);
        return;
    }
    while (vectorRotation > 0) {
        // add to queue
        if (isClockwise) {
            // rotate CLOCKWISE
            // printString("\nRotating ");
            // printInt(MyNewPieceID);
            // printString(" clockwise\n");
            myPost(&RotatePiece, MyNewPieceID, CLOCKWISE, next);
        } else {
            // rotate COUNTER_CLOCKWISE
            // printString("\nRotating ");
            // printInt(MyNewPieceID);
            // printString(" counterclockwise\n");
            myPost(&RotatePiece, MyNewPieceID, COUNTER_CLOCKWISE, next);
        }
        vectorRotation--;
    }
}

int getMinValueIndex() {
    int i;
    int minVal;
    int returnIndex;

    minVal = 20;    // arbitrary bigger than 16
    for (i = 0; i < FIELD_WIDTH; i++) {
        if (columns[i] < minVal) {
            minVal = columns[i];
            returnIndex = i;
        }
    }
    return returnIndex;
}

void TaskStat(void)                /* a task to track statistics */
{
    unsigned max, switchCount, idleCount;
    int tmp;
    
    YKDelayTask(1);
    // printString("Welcome to the YAK kernel\r\n");
    // printString("Determining CPU capacity\r\n");
    YKDelayTask(5);
    max = YKIdleCount / 25;
    YKIdleCount = 0;

    YKNewTask(communicateTask, (void*)&CommunicateTaskStk[TASK_STACK_SIZE], 15);
    YKNewTask(decidePlacementTask, (void*)&NewPieceTaskStk[TASK_STACK_SIZE], 10);
    SeedSimptris(seed);
    StartSimptris();
    
    while (1)
    {
        YKDelayTask(20);
        YKEnterMutex();
        switchCount = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKExitMutex();
        printString("<CS: ");
        printInt((int)switchCount);
        printString(", CPU: ");
        tmp = (int) (idleCount/max);
        printInt(100-tmp);
        printString(">\r\n");
        
        YKEnterMutex();
        YKCtxSwCount = 0;
        YKIdleCount = 0;
        YKExitMutex();
    }
}  

void myPost(void (*func)(int, int), int id, int direction, unsigned* next) {
    MsgArray[*next].func = func;
    MsgArray[*next].id = id;
    MsgArray[*next].direction = direction;
    // printString("\nNext Index: ");
    // printInt(*next);
    // printString("\n");
    YKQPost(commandQPtr, (void*)&(MsgArray[*next]));
    //*next = (*next +1) % MSGARRAYSIZE;
    *next = (*next +1) % MSGARRAYSIZE;
}

void communicateTask() {
    msg* cmd;
    char* dir;
    char* fn;
    while(1) {
        YKSemPend(communicateSem);
        cmd = (msg*)YKQPend(commandQPtr);
        // fn = cmd->func == SlidePiece ?  "\nC: Sliding piece " : "\nC: Rotating piece ";
        // printString(fn);
        // printInt(cmd->id);
        // if(fn == "\nRotating piece "){
        //     dir = cmd->direction == 1 ? " clockwise\n" : " counterclockwise\n";
        // } else{
        //     dir = cmd->direction == 1 ? " right\n" : " left\n";
        // }
        // printString(dir);
        // printString("  ");
        // printInt((int)cmd);
        (cmd->func)(cmd->id, cmd->direction);
    }
}


void main() {
    YKInitialize();
    // charEvent = YKEventCreate(0);
    // numEvent = YKEventCreate(0);
    commandQPtr = YKQCreate(MsgQ, MSGQSIZE);
    newPieceSem = YKSemCreate(0);
    communicateSem = YKSemCreate(1);

    

    YKNewTask(TaskStat, (void*) &TaskStatStk[TASK_STACK_SIZE], 20);

    YKRun();
}