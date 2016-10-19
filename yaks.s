
YKEnterMutex:
    cli
    ret
    
YKExitMutex:
    sti
    ret
    
contextSaver:
    pushf ; Flags
    push cs
    push word[bp+2] ; IP
    
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds

    mov bx, [saveContextTask]
    mov [bx], sp

    jmp contextRestorer

YKDispatcher: ; Dispatches the next task, and saves context if necessary.
    push bp					
	mov bp, sp
	push ax
	mov ax, [bp+4]
	cmp	ax, 1
	pop ax
	je 	contextSaver

contextRestorer:   
    mov bx, [taskToRun]
    mov sp, [bx]

    pop ds
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    iret