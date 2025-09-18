; subtraction.asm
; signed short num1 = 4660, num2 = -292;
; signed short dif = 0;
; dif = num1 - num2;
section .data
SYS_exit equ 60
EXIT_SUCCESS equ 0
num1 dw 4660 ;num1 = 1234h
num2 dw -292 ;num2 = FEDCh = -292
dif dw 0 ;dif = 0000h
section .text
global _start
_start:
mov ax, word[num1] ;ax = [num1] = 1234h
sub ax, word[num2] ;ax = ax - [num2] = 1358h
mov word[dif], ax ;[dif] = ax = 1358h
mov rax, SYS_exit ;terminate excuting process
mov rdi, EXIT_SUCCESS ;exit status
syscall ;calling system services