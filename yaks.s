// yaks.s

YKContextSaver: ; Saves the current context of the task that was running.
    pushf
    
    push bx
    add sp, 2
    mov bx, sp
    or word[bx], 0x0200    
    sub sp, 2
    pop bx
    
    push cs
    push word[bp+2]
    push word[bp]
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

YKContextRestorer: ; Helper function that restores context
    mov sp, [YKRestoreSP]
    pop ds
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    pop bp

    iret
    
YKDispatcher: ; Dispatches the next task, and saves context if necessary.
    push bp
    mov bp, sp
    push ax
    mov ax, [bp+4]
    cmp ax, 1
    pop ax
    je YKContextSaver ; Conditional jump that looks at the boolean result of cmp
    
YKEnterMutex:
    cli
    ret
    
YKExitMutex:
    sti
    ret
    