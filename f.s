section .text

global f
f:

    push rbp
    mov  rbp, rsp

    ; arguments location
    ;rdi    ,rsi    ,rdx     ,rcx    ,r8    ,r9     ,[rbp + 16],[rbp + 24]
    ;pixels ,width  ,height  ,jump   ,c3    ,c2     ,    c1    ,    c0

    sub rsp, 120                    ; allocating memory on stack

    mov [rbp - 8], rdi              ; pixels
    mov [rbp - 16], rsi             ; width
    mov [rbp - 24], rdx             ; height
    mov [rbp - 32], rcx             ; jump
    mov [rbp - 40], r8              ; c3
    mov [rbp - 48], r9              ; c2

    ; getting values of the middle of window

    mov     rdx, 0
    mov     rax, [rbp - 24]
    mov     rcx, 2
    div     rcx
    mov     [rbp - 56], rax         ; half of height

    mov     rdx, 0
    mov     rax, [rbp - 16]
    mov     rcx, 2
    div     rcx
    mov     [rbp - 64], rax         ; half of width

    mov     r10, 0                  ; x iter
    mov     r11, 0                  ; y iter

    ; and drawing a coords system

newLine:
    mov     r10, 0

drawCoords:
    cmp     r10, [rbp - 64]
    je      setBlack
    cmp     r11, [rbp - 56]
    je      setBlack

    mov     r9b, 0xff
    jmp     storePixel

setBlack:
    mov     r9b, 0

storePixel:
    mov     rax, r11
    mul     QWORD [rbp - 16]
    add     rax, r10
    mov     r8, 4
    mul     QWORD r8

    mov     [rdi + rax], r9b
    mov     [rdi + rax + 1], r9b
    mov     [rdi + rax + 2], r9b
    mov     [rdi + rax + 3], r9b

    add     r10, 1
    cmp     r10, [rbp - 16]
    jl      drawCoords

    add     r11, 1
    cmp     r11, [rbp - 24]
    jl      newLine

    ;------------------------------------------------------------------------
    ;       [rbp - 56] - half height
    ;       [rbp - 64] - half width

    ; i assume that X values belongs from -4 to 4 and Y values from -15 to 15
    ; so that gives 8 points for OX and 30 for OY
    mov     QWORD [rbp - 72], 8
    mov     QWORD [rbp - 80], 30

    ; and now need to determine how much do the X and Y increase per 1 pixel
    fild    QWORD [rbp - 72]
    fild    QWORD [rbp - 16]
    fdiv
    fstp    QWORD [rbp - 88]

    fild    QWORD [rbp - 80]
    fild    QWORD [rbp - 24]
    fdiv
    fstp    QWORD [rbp - 96]

    ;       [rbp - 88] - X increment per 1 pix
    ;       [rbp - 96] - Y increment per 1 pix

    mov     r10, 0                  ; X iter
    mov     r9b, 200                ; green color

countValue:
    ffree st0
    ffree st1
    ffree st2

    mov     rax, r10
    sub     rax, [rbp - 64]         ; iter - half width
    mov     [rbp - 104], rax        ; current X not scaled value
    fild    QWORD [rbp - 104]
    fld     QWORD [rbp - 88]
    fmul
    fst     QWORD [rbp - 104]       ; current X scaled value

    fild    QWORD [rbp - 40]
    fmul
    fild    QWORD [rbp - 48]
    fadd
    fld     QWORD [rbp - 104]
    fmul
    fild    QWORD [rbp + 16]
    fadd
    fld     QWORD [rbp - 104]
    fmul
    fild    QWORD [rbp + 24]
    fadd                            ; Y counted value

    fld     QWORD [rbp - 96]
    fdiv
    fistp   QWORD [rbp - 112]       ; Y counted pixel

    mov     r11, [rbp - 112]
    mov     rax, r11

    cmp     rax, [rbp - 56]
    jg      nextStep
    mov     rcx, 0
    sub     rcx, [rbp - 56]
    cmp     rax, rcx
    jle     nextStep

drawChart:
    mov     rax, r11
    add     rax, [rbp - 56]
    mul     QWORD [rbp - 16]
    add     rax, r10
    mov     r8, 4
    mul     QWORD r8

    mov     r8b, 0
    mov     [rdi + rax], r8b
    mov     [rdi + rax + 1], r9b
    mov     [rdi + rax + 2], r8b
    mov     [rdi + rax + 3], r8b

nextStep:
    add     r10, 1
    cmp     r10, [rbp - 16]
    jl      countValue

end:
    mov rsp, rbp
    pop rbp
    ret
