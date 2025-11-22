%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro scan 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .bss
    buffer resb 4
    n resw 1
    sumN resw 1
    ascii resb 10

section .data
    LF equ 10
    NULL equ 0
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    msg1 db "Input a number (100~140): ", NULL
    msg2 db "1 + 2 + 3 +...+ N = ", NULL

section .text
    global _start

_start:
    print msg1, 26
    scan buffer, 4

    mov ax, 0
    mov bx, 10
    mov rsi, 0

inputLoop:
    and byte[buffer+rsi], 0fh
    add al, byte[buffer+rsi]
    adc ah, 0
    cmp rsi, 2
    je skipMul
    mul bx
skipMul:
    inc rsi
    cmp rsi, 3
    jl inputLoop
    mov word[n], ax

    mov cx, 0
sumLoop:
    add word[sumN], cx
    inc cx
    cmp cx, word[n]
    jbe sumLoop

    mov ax, word[sumN]
    mov rcx, 0
    mov bx, 10
divideLoop:
    mov dx, 0
    div bx
    push rdx
    inc rcx
    cmp ax, 0
    jne divideLoop

    mov rbx, ascii
    mov rdi, 0
popLoop:
    pop rax
    add al, "0"
    mov byte [rbx+rdi], al
    inc rdi
    loop popLoop
    mov byte [rbx+rdi], LF

    print msg2, 20
    print ascii, 5

    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
