
        
YKEnterMutex:
    cli
    ret
    
YKExitMutex:
    sti
    ret
    
YKContextSaver: ; Saves the current context of the task that was running.
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
    mov bx, [YKContextSP]
    mov [bx], sp
    jmp YKContextRestorer

    
YKDispatcher: ; Dispatches the next task, and saves context if necessary.
    
    ;push bp
    ;mov bp, sp
    ;push ax
    ;mov ax, [bp+4]
    ;cmp ax, 1
    ;pop ax


    jmp YKContextSaver ; Conditional jump that looks at the boolean result of cmp
    

YKContextRestorer: ; Helper function that restores context
    mov bx, [bp+6]
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
