; Generated by c86 (BYU-NASM) 5.1 (beta) from simptrisApp.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
seed:
	DD	37428
L_simptrisApp_1:
	DB	"You made it",0xA,0
	ALIGN	2
STask:
	; >>>>> Line:	11
	; >>>>> void STask() { 
	jmp	L_simptrisApp_2
L_simptrisApp_3:
	; >>>>> Line:	12
	; >>>>> while(1) { 
	jmp	L_simptrisApp_5
L_simptrisApp_4:
	; >>>>> Line:	13
	; >>>>> YKDelayTask(20); 
	mov	ax, 20
	push	ax
	call	YKDelayTask
	add	sp, 2
	; >>>>> Line:	14
	; >>>>> printString("You made it\n"); 
	mov	ax, L_simptrisApp_1
	push	ax
	call	printString
	add	sp, 2
L_simptrisApp_5:
	jmp	L_simptrisApp_4
L_simptrisApp_6:
	mov	sp, bp
	pop	bp
	ret
L_simptrisApp_2:
	push	bp
	mov	bp, sp
	jmp	L_simptrisApp_3
	ALIGN	2
main:
	; >>>>> Line:	18
	; >>>>> void main() { 
	jmp	L_simptrisApp_8
L_simptrisApp_9:
	; >>>>> Line:	19
	; >>>>> YKInitialize(); 
	call	YKInitialize
	; >>>>> Line:	24
	; >>>>> YKNewTask(STask, (void *) &STaskStk[512], 10); 
	mov	al, 10
	push	ax
	mov	ax, (STaskStk+1024)
	push	ax
	mov	ax, STask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	26
	; >>>>> StartSimptris(); 
	call	StartSimptris
	; >>>>> Line:	27
	; >>>>> SeedSimptris(seed); 
	push	word [(seed+2)]
	push	word [(seed+0)]
	call	SeedSimptris
	add	sp, 4
	; >>>>> Line:	29
	; >>>>> YKRun(); 
	call	YKRun
	mov	sp, bp
	pop	bp
	ret
L_simptrisApp_8:
	push	bp
	mov	bp, sp
	jmp	L_simptrisApp_9
	ALIGN	2
STaskStk:
	TIMES	1024 db 0
