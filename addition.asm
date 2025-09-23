; addition.asm
; unsigned short num1 = 65244, num2 = 4660;
; unsigned short sum = 0;
; sum = num1 + num2;
section .data
SYS_exit equ 60
EXIT_SUCCESS equ 0
num1 dw 65244 ;num1 = FEDCh
num2 dw 4660 ;num2 = 1234h
sum dw 0 ;sum = 0000h
section .text
global _start
_start:
mov ax, word[num1] ;ax = num1 = FEDCh
add ax, word[num2] ;ax = ax + num2 = 1110h (with overflow)
mov word[sum], ax ;[sum] = ax = 1110h
mov rax, SYS_exit ;terminate excuting process
mov rdi, EXIT_SUCCESS ;exit status
syscall ;calling system services