        CPU     8086
        ORG     0h
InterruptVectorTable:
        ; Internal x86 Interrupts:
        dd      0 ; Reserved (Div err)  ; Int 00h
        dd      0 ; Reserved (Step)     ; Int 01h
        dd      0 ; Reserved (NMI)      ; Int 02h
        dd      0 ; Reserved (Break)    ; Int 03h
        dd      0 ; Reserved (Overflow) ; Int 04h
        dd      0                       ; Int 05h
        dd      0                       ; Int 06h
        dd      0                       ; Int 07h
        ; Hardware Interrupts:
        dd      reset ; Reset               ; Int 08h (IRQ 0)
        dd      tick ; Tick                ; Int 09h (IRQ 1)
        dd      keypress ; Keyboard            ; Int 0Ah (IRQ 2)
        dd      0 ; Simptris Game Over  ; Int 0Bh (IRQ 3)
        dd      0 ; Simptris New Piece  ; Int 0Ch (IRQ 4)
        dd      0 ; Simptris Received   ; Int 0Dh (IRQ 5)
        dd      0 ; Simptris Touchdown  ; Int 0Eh (IRQ 6)
        dd      0 ; Simptris Clear      ; Int 0Fh (IRQ 7)
        ; Software Interrupts:
        dd      0 ; Reserved (PC BIOS)  ; Int 10h
        dd      0                       ; Int 11h
        dd      0                       ; Int 12h
        dd      0                       ; Int 13h
        dd      0                       ; Int 14h
        dd      0                       ; Int 15h
        dd      0                       ; Int 16h
        dd      0                       ; Int 17h
        dd      0                       ; Int 18h
        dd      0                       ; Int 19h
        dd      0                       ; Int 1Ah
        dd      0                       ; Int 1Bh
        dd      0                       ; Int 1Ch
        dd      0                       ; Int 1Dh
        dd      0                       ; Int 1Eh
        dd      0                       ; Int 1Fh
        dd      0                       ; Int 20h
        dd      0 ; Reserved (DOS)      ; Int 21h
        dd      0 ; Simptris Services   ; Int 22h
        dd      0                       ; Int 23h
        dd      0                       ; Int 24h
        dd      0                       ; Int 25h
        dd      0                       ; Int 26h
        dd      0                       ; Int 27h
        dd      0                       ; Int 28h
        dd      0                       ; Int 29h
        dd      0                       ; Int 2Ah
        dd      0                       ; Int 2Bh
        dd      0                       ; Int 2Ch
        dd      0                       ; Int 2Dh
        dd      0                       ; Int 2Eh
        dd      0                       ; Int 2Fh
KeyBuffer:                              ; Address 0xC0
        dw      0
NewPieceType:                           ; Address 0xC2
        dw      0
NewPieceID:                             ; Address 0xC4
        dw      0
NewPieceOrientation:                    ; Address 0xC6
        dw      0
NewPieceColumn:                         ; Address 0xC8
        dw      0
TouchdownID:                            ; Address 0xCA
	dw	0
ScreenBitMap0:                          ; Address 0xCC
        dw      0
ScreenBitMap1:
        dw      0
ScreenBitMap2:
        dw      0
ScreenBitMap3:
        dw      0
ScreenBitMap4:
        dw      0
ScreenBitMap5:
        dw      0
TIMES   100h-($-$$) db  0               ; Fill up to (but not including) address 100h with 0
	jmp	main
; This file contains support routines for 32-bit on the 8086.
; It is intended for use code generated by the C86 compiler.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SR_asldiv:			; l1 /= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_ldiv
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslmod:			; l1 %= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lmod
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslmul:			; l1 *= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lmul
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslshl:			; l1 <<= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lshl
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslshr:			; l1 >>= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lshr
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret


SR_asuldiv:			; u1 /= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_uldiv
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asilmod:			; u1 %= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ilmod
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulmul:			; u1 *= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulmul
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulshl:			; u1 << u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulshl
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulshr:			; u1 >> u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulshr
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret


; Main 32-bit routines begin here:

SR_ldiv:	; N_LDIV@
	pop    cx
	push   cs
	push   cx
	; LDIV@
	xor    cx,cx
	jmp    LSR_01
SR_uldiv:	; N_LUDIV@
	pop    cx
	push   cs
	push   cx
	; F_LUDIV@
	mov    cx,0001
	jmp    LSR_01
SR_lmod:	; N_LMOD@
	pop    cx
	push   cs
	push   cx
	; F_LMOD@
	mov    cx,0002
	jmp    LSR_01
SR_ilmod:	; N_LUMOD@
	pop    cx
	push   cs
	push   cx
	; LUMOD@
	mov    cx,0003
LSR_01:
	push   bp
	push   si
	push   di
	mov    bp,sp
	mov    di,cx
	mov    ax,[bp+0Ah]
	mov    dx,[bp+0Ch]
	mov    bx,[bp+0Eh]
	mov    cx,[bp+10h]
	or     cx,cx
	jne    LSR_02
	or     dx,dx
	je     LSR_10
	or     bx,bx
	je     LSR_10
LSR_02:
	test   di,0001
	jne    LSR_04
	or     dx,dx
	jns    LSR_03
	neg    dx
	neg    ax
	sbb    dx,0000
	or     di,000Ch
LSR_03:
	or     cx,cx
	jns    LSR_04
	neg    cx
	neg    bx
	sbb    cx,0000
	xor    di,0004
LSR_04:
	mov    bp,cx
	mov    cx,0020h
	push   di
	xor    di,di
	xor    si,si
LSR_05:
	shl    ax,1
	rcl    dx,1
	rcl    si,1
	rcl    di,1
	cmp    di,bp
	jb     LSR_07
	ja     LSR_06
	cmp    si,bx
	jb     LSR_07
LSR_06:
	sub    si,bx
	sbb    di,bp
	inc    ax
LSR_07:
	loop   LSR_05
	pop    bx
	test   bx,0002
	je     LSR_08
	mov    ax,si
	mov    dx,di
	shr    bx,1
LSR_08:
	test   bx,0004h
	je     LSR_09
	neg    dx
	neg    ax
	sbb    dx,0000
LSR_09:
	pop    di
	pop    si
	pop    bp
	retf   0008
LSR_10:
	div    bx
	test   di,0002
	je     LSR_11
	xchg   dx,ax
LSR_11:
	xor    dx,dx
	jmp    LSR_09
SR_lshl:	; N_LXLSH@
SR_ulshl:
	; r = a << b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

	mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXLSH@
	cmp    cl,10h
	jnb    LSR_12
	mov    bx,ax
	shl    ax,cl
	shl    dx,cl
	neg    cl
	add    cl,10h
	shr    bx,cl
	or     dx,bx
	pop    cx
	pop    bp
	retf
LSR_12:
	sub    cl,10h
	xchg   dx,ax
	xor    ax,ax
	shl    dx,cl
	pop    cx
	pop    bp
	retf
SR_lshr:	; N_LXRSH@
	; r = a >> b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

        mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXRSH@
	cmp    cl,10h
	jnb    LSR_13
	mov    bx,dx
	shr    ax,cl
	sar    dx,cl
	neg    cl
	add    cl,10h
	shl    bx,cl
	or     ax,bx
	pop    cx
	pop    bp
	retf
LSR_13:
	sub    cl,10h
	xchg   dx,ax
	cwd
	sar    ax,cl
	pop    cx
	pop    bp
	retf
SR_ulshr:	; N_LXURSH@
	; r = a >> b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

        mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXURSH@
	cmp    cl,10h
	jnb    LSR_14
	mov    bx,dx
	shr    ax,cl
	shr    dx,cl
	neg    cl
	add    cl,10h
	shl    bx,cl
	or     ax,bx
	pop    cx
	pop    bp
	retf
LSR_14:
	sub    cl,10h
	xchg   dx,ax
	xor    dx,dx
	shr    ax,cl
	pop    cx
	pop    bp
	retf
SR_lmul:	; N_LXMUL@
SR_ulmul:
	; r = a * b
	push   bp
	push   si
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx
	push   bx

        mov    bx, [bp+6]	; pop loword(a)
	mov    cx, [bp+8]	; pop hiword(a)
	mov    ax, [bp+10]	; pop loword(b)
	mov    dx, [bp+12]	; pop hiword(b)
	
	xchg   si,ax
	xchg   dx,ax
	test   ax,ax
	je     LSR_15
	mul    bx
LSR_15:
	jcxz   LSR_16
	xchg   cx,ax
	mul    si
	add    ax,cx
LSR_16:
	xchg   si,ax
	mul    bx
	add    dx,si
	pop    bx
	pop    cx
	pop    si
	pop    bp
	ret

; Generated by c86 (BYU-NASM) 5.1 (beta) from clib.c
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
new_line:
	db	13,10,36
	ALIGN	2
signalEOI:
	jmp	L_clib_1
L_clib_2:
	mov	al, 0x20
	out	0x20, al
	mov	sp, bp
	pop	bp
	ret
L_clib_1:
	push	bp
	mov	bp, sp
	jmp	L_clib_2
	ALIGN	2
exit:
	jmp	L_clib_4
L_clib_5:
	mov	ah, 4Ch
	mov	al, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_4:
	push	bp
	mov	bp, sp
	jmp	L_clib_5
	ALIGN	2
print:
	jmp	L_clib_7
L_clib_8:
	mov	ah, 40h
	mov	bx, 1
	mov	cx, [bp+6]
	mov	dx, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_7:
	push	bp
	mov	bp, sp
	jmp	L_clib_8
	ALIGN	2
printChar:
	jmp	L_clib_10
L_clib_11:
	mov	ah, 2
	mov	dl, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_10:
	push	bp
	mov	bp, sp
	jmp	L_clib_11
	ALIGN	2
printNewLine:
	jmp	L_clib_13
L_clib_14:
	mov	ah, 9
	mov	dx, new_line
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_13:
	push	bp
	mov	bp, sp
	jmp	L_clib_14
	ALIGN	2
printString:
	jmp	L_clib_16
L_clib_17:
	xor	si,si
	mov	bx, [bp+4]
	jmp	printString2
	printString1:
	inc	si
	printString2:
	cmp	byte [bx+si],0
	jne	printString1
	mov	dx, bx
	mov	cx, si
	mov	ah, 40h
	mov	bx, 1
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_16:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_clib_17
	ALIGN	2
printInt:
	jmp	L_clib_19
L_clib_20:
	mov	word [bp-2], 0
	mov	word [bp-4], 10000
	cmp	word [bp+4], 0
	jge	L_clib_21
	mov	byte [bp-10], 45
	inc	word [bp-2]
	mov	ax, word [bp+4]
	neg	ax
	mov	word [bp+4], ax
L_clib_21:
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_clib_22
	mov	word [bp-4], 1
	jmp	L_clib_23
L_clib_22:
	jmp	L_clib_25
L_clib_24:
	mov	ax, word [bp-4]
	cwd
	mov	cx, 10
	idiv	cx
	mov	word [bp-4], ax
L_clib_25:
	mov	ax, word [bp+4]
	cwd
	idiv	word [bp-4]
	test	ax, ax
	je	L_clib_24
L_clib_26:
L_clib_23:
	jmp	L_clib_28
L_clib_27:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-10]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	mov	ax, dx
	mov	word [bp+4], ax
	mov	ax, word [bp-4]
	cwd
	mov	cx, 10
	idiv	cx
	mov	word [bp-4], ax
	mov	ax, word [bp-4]
	mov	word [bp-4], ax
L_clib_28:
	cmp	word [bp-4], 0
	jg	L_clib_27
L_clib_29:
	push	word [bp-2]
	lea	ax, [bp-10]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_19:
	push	bp
	mov	bp, sp
	sub	sp, 10
	jmp	L_clib_20
	ALIGN	2
printLong:
	jmp	L_clib_31
L_clib_32:
	mov	word [bp-2], 0
	mov	word [bp-6], 51712
	mov	word [bp-4], 15258
	cmp	word [bp+6], 0
	jg	L_clib_33
	jl	L_clib_34
	cmp	word [bp+4], 0
	jae	L_clib_33
L_clib_34:
	mov	byte [bp-17], 45
	inc	word [bp-2]
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	neg	ax
	adc	dx, 0
	neg	dx
	mov	word [bp+4], ax
	mov	word [bp+6], dx
L_clib_33:
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	or	dx, ax
	jne	L_clib_35
	mov	word [bp-6], 1
	mov	word [bp-4], 0
	jmp	L_clib_36
L_clib_35:
	jmp	L_clib_38
L_clib_37:
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asldiv
L_clib_38:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_ldiv
	or	dx, ax
	je	L_clib_37
L_clib_39:
L_clib_36:
	jmp	L_clib_41
L_clib_40:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-17]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_lmod
	mov	word [bp+4], ax
	mov	word [bp+6], dx
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asldiv
L_clib_41:
	cmp	word [bp-4], 0
	jg	L_clib_40
	jne	L_clib_43
	cmp	word [bp-6], 0
	ja	L_clib_40
L_clib_43:
L_clib_42:
	push	word [bp-2]
	lea	ax, [bp-17]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_31:
	push	bp
	mov	bp, sp
	sub	sp, 18
	jmp	L_clib_32
	ALIGN	2
printUInt:
	jmp	L_clib_45
L_clib_46:
	mov	word [bp-2], 0
	mov	word [bp-4], 10000
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_clib_47
	mov	word [bp-4], 1
	jmp	L_clib_48
L_clib_47:
	jmp	L_clib_50
L_clib_49:
	mov	ax, word [bp-4]
	xor	dx, dx
	mov	cx, 10
	div	cx
	mov	word [bp-4], ax
L_clib_50:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	test	ax, ax
	je	L_clib_49
L_clib_51:
L_clib_48:
	jmp	L_clib_53
L_clib_52:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-10]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	mov	word [bp+4], dx
	mov	ax, word [bp-4]
	xor	dx, dx
	mov	cx, 10
	div	cx
	mov	word [bp-4], ax
L_clib_53:
	mov	ax, word [bp-4]
	test	ax, ax
	jne	L_clib_52
L_clib_54:
	push	word [bp-2]
	lea	ax, [bp-10]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_45:
	push	bp
	mov	bp, sp
	sub	sp, 10
	jmp	L_clib_46
	ALIGN	2
printULong:
	jmp	L_clib_56
L_clib_57:
	mov	word [bp-2], 0
	mov	word [bp-6], 51712
	mov	word [bp-4], 15258
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	or	dx, ax
	jne	L_clib_58
	mov	word [bp-6], 1
	mov	word [bp-4], 0
	jmp	L_clib_59
L_clib_58:
	jmp	L_clib_61
L_clib_60:
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asuldiv
L_clib_61:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	or	dx, ax
	je	L_clib_60
L_clib_62:
L_clib_59:
	jmp	L_clib_64
L_clib_63:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-17]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	push	word [bp-4]
	push	word [bp-6]
	lea	ax, [bp+4]
	push	ax
	call	SR_asilmod
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asuldiv
L_clib_64:
	mov	ax, word [bp-6]
	mov	dx, word [bp-4]
	or	dx, ax
	jne	L_clib_63
L_clib_65:
	push	word [bp-2]
	lea	ax, [bp-17]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_56:
	push	bp
	mov	bp, sp
	sub	sp, 18
	jmp	L_clib_57
	ALIGN	2
printByte:
	jmp	L_clib_67
L_clib_68:
	mov	al, byte [bp+4]
	cbw
	mov	cx, 4
	sar	ax, cl
	and	ax, 15
	mov	byte [bp-1], al
	cmp	byte [bp-1], 9
	jle	L_clib_69
	mov	al, byte [bp-1]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_70
L_clib_69:
	mov	al, byte [bp-1]
	cbw
	add	ax, 48
L_clib_70:
	mov	byte [bp-3], al
	mov	al, byte [bp+4]
	and	al, 15
	mov	byte [bp-1], al
	cmp	byte [bp-1], 9
	jle	L_clib_71
	mov	al, byte [bp-1]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_72
L_clib_71:
	mov	al, byte [bp-1]
	cbw
	add	ax, 48
L_clib_72:
	mov	byte [bp-2], al
	mov	ax, 2
	push	ax
	lea	ax, [bp-3]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_67:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_clib_68
	ALIGN	2
printWord:
	jmp	L_clib_74
L_clib_75:
	mov	word [bp-2], 3
	jmp	L_clib_77
L_clib_76:
	mov	ax, word [bp+4]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_80
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_81
L_clib_80:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_81:
	mov	si, word [bp-2]
	lea	dx, [bp-7]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp+4]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp+4], ax
L_clib_79:
	dec	word [bp-2]
L_clib_77:
	cmp	word [bp-2], 0
	jge	L_clib_76
L_clib_78:
	mov	ax, 4
	push	ax
	lea	ax, [bp-7]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_74:
	push	bp
	mov	bp, sp
	sub	sp, 8
	jmp	L_clib_75
	ALIGN	2
printDWord:
	jmp	L_clib_83
L_clib_84:
	lea	ax, [bp+4]
	mov	si, ax
	mov	ax, word [si]
	mov	word [bp-6], ax
	lea	ax, [bp+4]
	mov	si, ax
	add	si, 2
	mov	ax, word [si]
	mov	word [bp-8], ax
	mov	word [bp-2], 3
	jmp	L_clib_86
L_clib_85:
	mov	ax, word [bp-6]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_89
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_90
L_clib_89:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_90:
	mov	dx, word [bp-2]
	add	dx, 4
	mov	si, dx
	lea	dx, [bp-16]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp-6]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp-6], ax
	mov	ax, word [bp-8]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_91
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_92
L_clib_91:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_92:
	mov	si, word [bp-2]
	lea	dx, [bp-16]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp-8]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp-8], ax
L_clib_88:
	dec	word [bp-2]
L_clib_86:
	cmp	word [bp-2], 0
	jge	L_clib_85
L_clib_87:
	mov	ax, 8
	push	ax
	lea	ax, [bp-16]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_83:
	push	bp
	mov	bp, sp
	sub	sp, 16
	jmp	L_clib_84
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
; Generated by c86 (BYU-NASM) 5.1 (beta) from myinth.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
tickCount:
	DW	0
L_myinth_1:
	DW	0
L_myinth_2:
	DB	"RESETTING",0
	ALIGN	2
resetHandler:
	; >>>>> Line:	8
	; >>>>> void resetHandler(){ 
	jmp	L_myinth_3
L_myinth_4:
	; >>>>> Line:	9
	; >>>>> printString("RESETTING"); 
	mov	ax, L_myinth_2
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	10
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_myinth_3:
	push	bp
	mov	bp, sp
	jmp	L_myinth_4
L_myinth_6:
	DB	0xA,"Tick ",0
	ALIGN	2
tickHandler:
	; >>>>> Line:	13
	; >>>>> void tickHandler(){ 
	jmp	L_myinth_7
L_myinth_8:
	; >>>>> Line:	14
	; >>>>> printString("\nTick "); 
	mov	ax, L_myinth_6
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	15
	; >>>>> printInt(tickCount); 
	push	word [tickCount]
	call	printInt
	add	sp, 2
	; >>>>> Line:	16
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	17
	; >>>>> tickCount++; 
	inc	word [tickCount]
	mov	sp, bp
	pop	bp
	ret
L_myinth_7:
	push	bp
	mov	bp, sp
	jmp	L_myinth_8
	ALIGN	2
loopLikeABoss:
	; >>>>> Line:	20
	; >>>>> void loopLikeABoss(){ 
	jmp	L_myinth_10
L_myinth_11:
	; >>>>> Line:	22
	; >>>>> for(; i < 5001; i++){ 
	mov	word [bp-2], 0
	; >>>>> Line:	22
	; >>>>> for(; i < 5001; i++){ 
	jmp	L_myinth_13
L_myinth_12:
	; >>>>> Line:	23
	; >>>>> someLocalVariable++; 
	inc	word [L_myinth_1]
L_myinth_15:
	inc	word [bp-2]
L_myinth_13:
	cmp	word [bp-2], 5001
	jl	L_myinth_12
L_myinth_14:
	mov	sp, bp
	pop	bp
	ret
L_myinth_10:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_11
L_myinth_20:
	DB	") IGNORED",0
L_myinth_19:
	DB	0xA,"KEYPRESS (",0
L_myinth_18:
	DB	0xA,"DELAY COMPLETE",0xA,0
L_myinth_17:
	DB	0xA,"DELAY KEY PRESSED",0xA,0
	ALIGN	2
keypressHandler:
	; >>>>> Line:	27
	; >>>>> void keypressHandler(){ 
	jmp	L_myinth_21
L_myinth_22:
	; >>>>> Line:	28
	; >>>>> if((char)KeyBuffer == 'd'){ 
	cmp	byte [KeyBuffer], 100
	jne	L_myinth_23
	; >>>>> Line:	29
	; >>>>> printString("\nDELAY KEY PRESSED\n"); 
	mov	ax, L_myinth_17
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	30
	; >>>>> loopLikeABoss(); 
	call	loopLikeABoss
	; >>>>> Line:	31
	; >>>>>  
	mov	ax, L_myinth_18
	push	ax
	call	printString
	add	sp, 2
	jmp	L_myinth_24
L_myinth_23:
	; >>>>> Line:	34
	; >>>>> printString("\nKEYPRESS ("); 
	mov	ax, L_myinth_19
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	35
	; >>>>> printChar((char)KeyBuffer); 
	push	word [KeyBuffer]
	call	printChar
	add	sp, 2
	; >>>>> Line:	36
	; >>>>> printString(") IGNORED"); 
	mov	ax, L_myinth_20
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	37
	; >>>>> printNewLine(); 
	call	printNewLine
L_myinth_24:
	mov	sp, bp
	pop	bp
	ret
L_myinth_21:
	push	bp
	mov	bp, sp
	jmp	L_myinth_22

        
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
; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
YKIdleTask:
	; >>>>> Line:	41
	; >>>>> void YKIdleTask(void){ 
	jmp	L_yakc_1
L_yakc_2:
	; >>>>> Line:	42
	; >>>>> while(1){ 
	jmp	L_yakc_4
L_yakc_3:
	; >>>>> Line:	43
	; >>>>> YKIdleCount++; 
	inc	word [YKIdleCount]
L_yakc_4:
	jmp	L_yakc_3
L_yakc_5:
	mov	sp, bp
	pop	bp
	ret
L_yakc_1:
	push	bp
	mov	bp, sp
	jmp	L_yakc_2
L_yakc_10:
	DB	"Priority: ",0
L_yakc_9:
	DB	"SP: ",0
L_yakc_8:
	DB	"Task Printout:",0xA,0
L_yakc_7:
	DB	0xA,"No task to print",0xA,0
	ALIGN	2
printTask:
	; >>>>> Line:	47
	; >>>>> void printTask(Task t){ 
	jmp	L_yakc_11
L_yakc_12:
	; >>>>> Line:	48
	; >>>>> if(!t.priority){ 
	mov	ax, word [bp+8]
	test	ax, ax
	jne	L_yakc_13
	; >>>>> Line:	49
	; >>>>> printString("\nNo task to print\n"); 
	mov	ax, L_yakc_7
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	50
	; >>>>>  
	jmp	L_yakc_14
L_yakc_13:
	; >>>>> Line:	52
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	53
	; >>>>> printString("Task Printout:\n"); 
	mov	ax, L_yakc_8
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	54
	; >>>>> printString("SP: "); 
	mov	ax, L_yakc_9
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	55
	; >>>>> printInt((int)t.stackPtr); 
	push	word [bp+6]
	call	printInt
	add	sp, 2
	; >>>>> Line:	56
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	57
	; >>>>> printString("Priority: "); 
	mov	ax, L_yakc_10
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	58
	; >>>>> printInt(t.priority); 
	push	word [bp+8]
	call	printInt
	add	sp, 2
	; >>>>> Line:	59
	; >>>>> printNewLine(); 
	call	printNewLine
L_yakc_14:
	mov	sp, bp
	pop	bp
	ret
L_yakc_11:
	push	bp
	mov	bp, sp
	jmp	L_yakc_12
	ALIGN	2
YKInitialize:
	; >>>>> Line:	65
	; >>>>> void YKInitialize(){ 
	jmp	L_yakc_16
L_yakc_17:
	; >>>>> Line:	66
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	68
	; >>>>> currentTaskCount = 0; 
	mov	word [currentTaskCount], 0
	; >>>>> Line:	69
	; >>>>> YKRunTask = 0; 
	mov	word [YKRunTask], 0
	; >>>>> Line:	70
	; >>>>> YKCurrentRunningTask = 0; 
	mov	word [YKCurrentRunningTask], 0
	; >>>>> Line:	71
	; >>>>> YKCtxSwCount = 0; 
	mov	word [YKCtxSwCount], 0
	; >>>>> Line:	72
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	73
	; >>>>> YKContextSP = 0; 
	mov	word [YKContextSP], 0
	; >>>>> Line:	74
	; >>>>> YKRestoreSP = 0; 
	mov	word [YKRestoreSP], 0
	; >>>>> Line:	75
	; >>>>> readyRoot = 0; 
	mov	word [readyRoot], 0
	; >>>>> Line:	78
	; >>>>> YKNewTask(&YK 
	mov	al, 255
	push	ax
	mov	ax, (YKIdleTaskStack+512)
	push	ax
	mov	ax, YKIdleTask
	push	ax
	call	YKNewTask
	add	sp, 6
	mov	sp, bp
	pop	bp
	ret
L_yakc_16:
	push	bp
	mov	bp, sp
	jmp	L_yakc_17
	ALIGN	2
YKAddReadyTask:
	; >>>>> Line:	83
	; >>>>> void YKAddReadyTask(TaskPtr readyTask) { 
	jmp	L_yakc_19
L_yakc_20:
	; >>>>> Line:	85
	; >>>>> if(readyTask == 0){ 
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_yakc_21
	; >>>>> Line:	86
	; >>>>> return; 
	jmp	L_yakc_22
	jmp	L_yakc_23
L_yakc_21:
	; >>>>> Line:	89
	; >>>>> }else if(readyRoot == 0){ 
	mov	ax, word [readyRoot]
	test	ax, ax
	jne	L_yakc_24
	; >>>>> Line:	90
	; >>>>> readyTask->next = 0; 
	mov	si, word [bp+4]
	add	si, 8
	mov	word [si], 0
	; >>>>> Line:	91
	; >>>>> readyTask->prev = 0; 
	mov	si, word [bp+4]
	add	si, 10
	mov	word [si], 0
	; >>>>> Line:	92
	; >>>>> readyRoot = readyTask; 
	mov	ax, word [bp+4]
	mov	word [readyRoot], ax
	; >>>>> Line:	93
	; >>>>> readyTail = readyTask; 
	mov	word [readyTail], ax
	; >>>>> Line:	94
	; >>>>> return; 
	jmp	L_yakc_22
	jmp	L_yakc_25
L_yakc_24:
	; >>>>> Line:	97
	; >>>>> while(currentNode != 0) { 
	mov	ax, word [readyRoot]
	mov	word [bp-2], ax
	; >>>>> Line:	97
	; >>>>> while(currentNode != 0) { 
	jmp	L_yakc_27
L_yakc_26:
	; >>>>> Line:	98
	; >>>>> if (readyTask->priority > currentNode->priority) { 
	mov	si, word [bp+4]
	add	si, 4
	mov	di, word [bp-2]
	add	di, 4
	mov	ax, word [di]
	cmp	ax, word [si]
	jge	L_yakc_29
	; >>>>> Line:	99
	; >>>>> if(currentNode->next == 0){ 
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakc_30
	; >>>>> Line:	100
	; >>>>> eadyTask->prev = currentNode 
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	101
	; >>>>> readyTask->prev = currentNode; 
	mov	si, word [bp+4]
	add	si, 10
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	102
	; >>>>> readyTask->next = 0; 
	mov	si, word [bp+4]
	add	si, 8
	mov	word [si], 0
	; >>>>> Line:	103
	; >>>>> readyTail = readyTask; 
	mov	ax, word [bp+4]
	mov	word [readyTail], ax
	; >>>>> Line:	104
	; >>>>> return; 
	jmp	L_yakc_22
	jmp	L_yakc_31
L_yakc_30:
	; >>>>> Line:	105
	; >>>>> }else if(readyTask->priority < (currentNode->next)->priority) { 
	mov	si, word [bp-2]
	add	si, 8
	mov	si, word [si]
	add	si, 4
	mov	di, word [bp+4]
	add	di, 4
	mov	ax, word [di]
	cmp	ax, word [si]
	jge	L_yakc_32
	; >>>>> Line:	108
	; >>>>> readyTask->next = temp; 
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [si]
	mov	word [bp-4], ax
	; >>>>> Line:	108
	; >>>>> readyTask->next = temp; 
	mov	si, word [bp+4]
	add	si, 8
	mov	ax, word [bp-4]
	mov	word [si], ax
	; >>>>> Line:	109
	; >>>>> currentNode->next = readyTask; 
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	110
	; >>>>> temp->prev = readyTask; 
	mov	si, word [bp-4]
	add	si, 10
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	111
	; >>>>> readyTask->prev = currentNode 
	mov	si, word [bp+4]
	add	si, 10
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	112
	; >>>>> return; 
	jmp	L_yakc_22
L_yakc_32:
L_yakc_31:
	; >>>>> Line:	116
	; >>>>> currentNode= currentNode->next; 
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [si]
	mov	word [bp-2], ax
	jmp	L_yakc_33
L_yakc_29:
	; >>>>> Line:	118
	; >>>>> readyTask->next = currentNode; 
	mov	si, word [bp+4]
	add	si, 8
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	119
	; >>>>> readyTask->prev = 0; 
	mov	si, word [bp+4]
	add	si, 10
	mov	word [si], 0
	; >>>>> Line:	120
	; >>>>> currentNode->prev = readyTask; 
	mov	si, word [bp-2]
	add	si, 10
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	121
	; >>>>> readyRoot = readyTask; 
	mov	ax, word [bp+4]
	mov	word [readyRoot], ax
	; >>>>> Line:	122
	; >>>>> return; 
	jmp	L_yakc_22
L_yakc_33:
L_yakc_27:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_26
L_yakc_28:
L_yakc_25:
L_yakc_23:
L_yakc_22:
	mov	sp, bp
	pop	bp
	ret
L_yakc_19:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_20
L_yakc_35:
	DB	"SP should be: ",0
	ALIGN	2
YKNewTask:
	; >>>>> Line:	128
	; >>>>> void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){ 
	jmp	L_yakc_36
L_yakc_37:
	; >>>>> Line:	136
	; >>>>> for (i = 0; i < 8; i++) { 
	mov	ax, word [bp+6]
	sub	ax, 22
	mov	word [bp-8], ax
	mov	word [bp-10], 0
	; >>>>> Line:	136
	; >>>>> for (i = 0; i < 8; i++) { 
	mov	word [bp-10], 0
	jmp	L_yakc_39
L_yakc_38:
	; >>>>> Line:	137
	; >>>>> newSP[i] = 0; 
	mov	ax, word [bp-10]
	shl	ax, 1
	mov	si, ax
	add	si, word [bp-8]
	mov	word [si], 0
L_yakc_41:
	inc	word [bp-10]
L_yakc_39:
	cmp	word [bp-10], 8
	jl	L_yakc_38
L_yakc_40:
	; >>>>> Line:	139
	; >>>>> newSP[8] = (unsigned)task; 
	mov	si, word [bp-8]
	add	si, 16
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	140
	; >>>>> newSP[9] = 0; 
	mov	si, word [bp-8]
	add	si, 18
	mov	word [si], 0
	; >>>>> Line:	141
	; >>>>> newSP[10] = 0x0200; 
	mov	si, word [bp-8]
	add	si, 20
	mov	word [si], 512
	; >>>>> Line:	143
	; >>>>> temp->stackPtr = newSP-1; 
	mov	ax, word [bp-8]
	sub	ax, 2
	mov	si, word [bp-2]
	add	si, 2
	mov	word [si], ax
	; >>>>> Line:	149
	; >>>>> temp = &ykTasks[currentTaskCount]; 
	mov	ax, word [currentTaskCount]
	mov	cx, 12
	imul	cx
	add	ax, ykTasks
	mov	word [bp-2], ax
	; >>>>> Line:	151
	; >>>>> temp->taskFnPtr = (int*)task; 
	mov	si, word [bp-2]
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	152
	; >>>>> temp->priority = priority; 
	mov	al, byte [bp+8]
	xor	ah, ah
	mov	si, word [bp-2]
	add	si, 4
	mov	word [si], ax
	; >>>>> Line:	153
	; >>>>> temp->delay = 0; 
	mov	si, word [bp-2]
	add	si, 6
	mov	word [si], 0
	; >>>>> Line:	154
	; >>>>> temp->next = 0; 
	mov	si, word [bp-2]
	add	si, 8
	mov	word [si], 0
	; >>>>> Line:	155
	; >>>>> temp->prev = 0; 
	mov	si, word [bp-2]
	add	si, 10
	mov	word [si], 0
	; >>>>> Line:	156
	; >>>>> currentTaskCount++; 
	inc	word [currentTaskCount]
	; >>>>> Line:	157
	; >>>>> YKAddReadyTask(temp); 
	push	word [bp-2]
	call	YKAddReadyTask
	add	sp, 2
	; >>>>> Line:	158
	; >>>>> printString("SP should be: "); 
	mov	ax, L_yakc_35
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	159
	; >>>>> printInt((int)taskStack); 
	push	word [bp+6]
	call	printInt
	add	sp, 2
	; >>>>> Line:	162
	; >>>>> if(YKRunTask){ 
	mov	ax, word [YKRunTask]
	test	ax, ax
	je	L_yakc_42
	; >>>>> Line:	163
	; >>>>> Y 
	mov	ax, 1
	push	ax
	call	YKScheduler
	add	sp, 2
	; >>>>> Line:	164
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
L_yakc_42:
	mov	sp, bp
	pop	bp
	ret
L_yakc_36:
	push	bp
	mov	bp, sp
	sub	sp, 10
	jmp	L_yakc_37
L_yakc_44:
	DB	0xA,0xA,"Function Pointer: ",0
	ALIGN	2
YKRun:
	; >>>>> Line:	168
	; >>>>> void YKRun() { 
	jmp	L_yakc_45
L_yakc_46:
	; >>>>> Line:	174
	; >>>>> if(readyRoot == 0){ 
	mov	ax, word [readyRoot]
	test	ax, ax
	jne	L_yakc_47
	; >>>>> Line:	176
	; >>>>> return; 
	jmp	L_yakc_48
L_yakc_47:
	; >>>>> Line:	179
	; >>>>> YKRunTask = 1; 
	mov	word [YKRunTask], 1
	; >>>>> Line:	180
	; >>>>> YKRestoreSP = (int)(readyRoot->stackPtr); 
	mov	si, word [readyRoot]
	add	si, 2
	mov	ax, word [si]
	mov	word [YKRestoreSP], ax
	; >>>>> Line:	181
	; >>>>> printString("\n\nFunction Pointer: "); 
	mov	ax, L_yakc_44
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	182
	; >>>>> printInt((int)(readyRoot->taskFnPtr)); 
	mov	si, word [readyRoot]
	push	word [si]
	call	printInt
	add	sp, 2
	; >>>>> Line:	184
	; >>>>> YKCurrentRunningTask = readyRoot; 
	mov	ax, word [readyRoot]
	mov	word [YKCurrentRunningTask], ax
	; >>>>> Line:	185
	; >>>>> YKCtxSwCount++; 
	inc	word [YKCtxSwCount]
	; >>>>> Line:	186
	; >>>>> YKDispatcher(0, (int*)readyRoot->taskFnPtr); 
	mov	si, word [readyRoot]
	push	word [si]
	xor	ax, ax
	push	ax
	call	YKDispatcher
	add	sp, 4
L_yakc_48:
	mov	sp, bp
	pop	bp
	ret
L_yakc_45:
	push	bp
	mov	bp, sp
	jmp	L_yakc_46
L_yakc_50:
	DB	"SCHEDULER: ",0xA,0
	ALIGN	2
YKScheduler:
	; >>>>> Line:	189
	; >>>>> void YKScheduler(unsigned contextSave){ 
	jmp	L_yakc_51
L_yakc_52:
	; >>>>> Line:	190
	; >>>>> printString("SCHEDULER: \n"); 
	mov	ax, L_yakc_50
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	193
	; >>>>> if (readyRoot != YKCurrentRunningTask) { 
	mov	ax, word [YKCurrentRunningTask]
	cmp	ax, word [readyRoot]
	je	L_yakc_53
	; >>>>> Line:	194
	; >>>>> Y 
	inc	word [YKCtxSwCount]
	; >>>>> Line:	195
	; >>>>> YKContextSP = (int)(YKCurrentRunningTask->stackPtr); 
	mov	si, word [YKCurrentRunningTask]
	add	si, 2
	mov	ax, word [si]
	mov	word [YKContextSP], ax
	; >>>>> Line:	196
	; >>>>> YKRestoreSP = (int)(readyRoot->stackPtr); 
	mov	si, word [readyRoot]
	add	si, 2
	mov	ax, word [si]
	mov	word [YKRestoreSP], ax
	; >>>>> Line:	202
	; >>>>> YKCurrentRunningTask = readyRoot; 
	mov	ax, word [readyRoot]
	mov	word [YKCurrentRunningTask], ax
	; >>>>> Line:	203
	; >>>>> YKDispatcher(contextSave, readyRoot->taskFnPtr); 
	mov	si, word [readyRoot]
	push	word [si]
	push	word [bp+4]
	call	YKDispatcher
	add	sp, 4
L_yakc_53:
	mov	sp, bp
	pop	bp
	ret
L_yakc_51:
	push	bp
	mov	bp, sp
	jmp	L_yakc_52
L_yakc_55:
	DB	"Finished dispatcher",0
	ALIGN	2
printhelp:
	; >>>>> Line:	207
	; >>>>> void printhelp() { 
	jmp	L_yakc_56
L_yakc_57:
	; >>>>> Line:	208
	; >>>>> printString("Finished dispatcher"); 
	mov	ax, L_yakc_55
	push	ax
	call	printString
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_yakc_56:
	push	bp
	mov	bp, sp
	jmp	L_yakc_57
	ALIGN	2
YKCtxSwCount:
	TIMES	2 db 0
YKIdleCount:
	TIMES	2 db 0
ykTasks:
	TIMES	132 db 0
YKSuspList:
	TIMES	2 db 0
YKAvailTCBList:
	TIMES	2 db 0
currentTaskCount:
	TIMES	2 db 0
YKRunTask:
	TIMES	2 db 0
YKContextSP:
	TIMES	2 db 0
YKRestoreSP:
	TIMES	2 db 0
YKCurrentRunningTask:
	TIMES	2 db 0
YKIdleTaskStack:
	TIMES	512 db 0
readyRoot:
	TIMES	2 db 0
readyTail:
	TIMES	2 db 0
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
