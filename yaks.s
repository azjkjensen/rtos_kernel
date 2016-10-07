
YKEnterMutex:
    cli
    ret
    
YKExitMutex:
    sti
    ret
    
YKDispatcher: ; Dispatches the next task, and saves context if necessary.
    
    push cs
    pushf
    
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