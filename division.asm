; division.asm
; unsigned long num1 = 50000000000;
; unsigned int num2 = 3333333;
; unsigned int quotient = 0, remainder = 0;
; quotient = num1 / num2;
; remainder = num1 % num2;
section .data
SYS_exit equ 60
EXIT_SUCCESS equ 0
num1 dq 50000000000 ;num1 = BA43B7400h
num2 dd 3333333 ;num2 = 32DCD5h
quotient dd 0 ;quotient = 00000000h
remainder dd 0 ;remainder = 00000000h
section .text
global _start
_start:
mov rax, qword[num1] ;rax = num1 = BA43B7400h
xor rdx, rdx ;clear rdx for division
div dword[num2] ;rax = rax / num2, rdx = rax % num2
mov dword[quotient], eax ;quotient = eax
mov dword[remainder], edx ;remainder = edx
_stop:
mov rax, SYS_exit ;terminate excuting process
mov rdi, EXIT_SUCCESS ;exit status
syscall ;calling system services