; leap.asm - Leap year calculation program
; CPSC 240 Assignment - Convert C/C++ leap year logic to x86-64 assembly
; unsigned short year = 2025;
; unsigned short yLeap = 0, nLeap = 0;
; if((year%400 == 0) || ((year%4 == 0) && (year%100 != 0))) {
; yLeap++;
; } else {
; nLeap++;
; }

section .data
    SYS_exit        equ 60
    EXIT_SUCCESS    equ 0
    year    dw  2000
    yLeap   dw  0
    nLeap   dw  0

section .text
    global _start

_start:
    mov ax, word[year]
    
    xor dx, dx
    mov bx, 400
    div bx
    cmp dx, 0
    je if_block
    
    mov ax, word[year]
    
    xor dx, dx
    mov bx, 4
    div bx
    cmp dx, 0
    jne else_block
    
    mov ax, word[year]
    xor dx, dx
    mov bx, 100
    div bx
    cmp dx, 0
    je else_block

if_block:
    inc word[yLeap]
    jmp end_if

else_block:
    inc word[nLeap]

end_if:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall