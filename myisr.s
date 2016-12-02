CPU	8086
align	2

reset:

    push bp
    mov bp, sp
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

    call YKEnterISR

    ;Enable interrupts
    sti
    call tickHandler
    cli
    call signalEOI

    call YKExitISR

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
    call YKEnterISR
    sti
    call keypressHandler
    cli
    call signalEOI
    call YKExitISR

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

gameOver:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds

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
    
newPiece:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds

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
received:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds

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
touchdown:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds

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
clear:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds

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
