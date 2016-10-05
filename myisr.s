CPU	8086
align	2

reset:

    call resetHandler


tick:

    ;Save context
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds
    ;Enable interrupts
    sti
    call tickHandler
    cli
    call signalEOI

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

keypress:

    ;Save context
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds
    ;Enable interrupts
    sti
    call keypressHandler
    cli
    call signalEOI

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
