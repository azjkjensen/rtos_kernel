; Generated by c86 (BYU-NASM) 5.1 (beta) from lab4bapp.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
L_lab4bapp_2:
	DB	0xA,"Starting kernel...",0xA,0
L_lab4bapp_1:
	DB	0xA,"Creating task A...",0xA,0
	ALIGN	2
main:
	; >>>>> Line:	23
	; >>>>> { 
	jmp	L_lab4bapp_3
L_lab4bapp_4:
	; >>>>> Line:	26
	; >>>>> printString("\nCreating task A...\n"); 
	mov	ax, L_lab4bapp_1
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	27
	; >>>>> YKNewTask(ATask, (void *)&AStk[256], 5); 
	mov	al, 5
	push	ax
	mov	ax, (AStk+512)
	push	ax
	mov	ax, ATask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	29
	; >>>>> printString("\nStarting kernel...\n"); 
	mov	ax, L_lab4bapp_2
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	30
	; >>>>> YKRun(); 
	call	YKRun
	mov	sp, bp
	pop	bp
	ret
L_lab4bapp_3:
	push	bp
	mov	bp, sp
	jmp	L_lab4bapp_4
L_lab4bapp_9:
	DB	"Task A is still running! Oh no! Task A was supposed to stop.",0xA,0
L_lab4bapp_8:
	DB	"Creating task C...",0xA,0
L_lab4bapp_7:
	DB	0xA,"Creating low priority task B...",0xA,0
L_lab4bapp_6:
	DB	0xA,"Task A started!",0xA,0
	ALIGN	2
ATask:
	; >>>>> Line:	34
	; >>>>> { 
	jmp	L_lab4bapp_10
L_lab4bapp_11:
	; >>>>> Line:	36
	; >>>>> printString("\nTask A started!\n"); 
	mov	word [bp-2], 2
	; >>>>> Line:	36
	; >>>>> printString("\nTask A started!\n"); 
	mov	ax, L_lab4bapp_6
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	38
	; >>>>> printString("\nCreating low priority task B...\n"); 
	mov	ax, L_lab4bapp_7
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	39
	; >>>>> YKNewTask(BTask, (void *)&BStk[256], 7); 
	mov	al, 7
	push	ax
	mov	ax, (BStk+512)
	push	ax
	mov	ax, BTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	41
	; >>>>> printString("Creating task C...\n"); 
	mov	ax, L_lab4bapp_8
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	42
	; >>>>> YKNewTask(CTask, (void *)&CStk[256], 2); 
	mov	al, 2
	push	ax
	mov	ax, (CStk+512)
	push	ax
	mov	ax, CTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	44
	; >>>>> printString("Task A is still running!  
	mov	ax, L_lab4bapp_9
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	45
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4bapp_10:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_lab4bapp_11
L_lab4bapp_13:
	DB	"Task B started! Oh no! Task B wasn't supposed to run.",0xA,0
	ALIGN	2
BTask:
	; >>>>> Line:	49
	; >>>>> { 
	jmp	L_lab4bapp_14
L_lab4bapp_15:
	; >>>>> Line:	50
	; >>>>> printString("Task B started! Oh no! Task B wasn't supposed to run.\n"); 
	mov	ax, L_lab4bapp_13
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	51
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4bapp_14:
	push	bp
	mov	bp, sp
	jmp	L_lab4bapp_15
L_lab4bapp_19:
	DB	"Executing in task C.",0xA,0
L_lab4bapp_18:
	DB	" context switches!",0xA,0
L_lab4bapp_17:
	DB	"Task C started after ",0
	ALIGN	2
CTask:
	; >>>>> Line:	55
	; >>>>> { 
	jmp	L_lab4bapp_20
L_lab4bapp_21:
	; >>>>> Line:	59
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	60
	; >>>>> numCtxSwitches = YKCtxSwCount; 
	mov	ax, word [YKCtxSwCount]
	mov	word [bp-4], ax
	; >>>>> Line:	61
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	63
	; >>>>> printString("Task C started after "); 
	mov	ax, L_lab4bapp_17
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	64
	; >>>>> printUInt(numCtxSwitches); 
	push	word [bp-4]
	call	printUInt
	add	sp, 2
	; >>>>> Line:	65
	; >>>>> printString(" context switches!\n"); 
	mov	ax, L_lab4bapp_18
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	67
	; >>>>> while (1) 
	jmp	L_lab4bapp_23
L_lab4bapp_22:
	; >>>>> Line:	69
	; >>>>> printString("Executing in task C.\n"); 
	mov	ax, L_lab4bapp_19
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	70
	; >>>>> for(count = 0; count < 
	mov	word [bp-2], 0
	jmp	L_lab4bapp_26
L_lab4bapp_25:
L_lab4bapp_28:
	inc	word [bp-2]
L_lab4bapp_26:
	cmp	word [bp-2], 5000
	jl	L_lab4bapp_25
L_lab4bapp_27:
L_lab4bapp_23:
	jmp	L_lab4bapp_22
L_lab4bapp_24:
	mov	sp, bp
	pop	bp
	ret
L_lab4bapp_20:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_lab4bapp_21
	ALIGN	2
AStk:
	TIMES	512 db 0
BStk:
	TIMES	512 db 0
CStk:
	TIMES	512 db 0
