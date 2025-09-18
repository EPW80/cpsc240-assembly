; addition.asm
; unsigned short num1 = 65244, num2 = 4660;
; unsigned int sum = 0;
; sum = int(num1 + num2);
section .data
SYS_exit equ 60
EXIT_SUCCESS equ 0
num1 dw 65244 ;num1 = FEDCh
num2 dw 4660 ;num2 = 1234h
sum dd 0 ;sum = 00000000h
section .text
global _start
_start:
movzx eax, word[num1] ;eax = 0000FEDCh
movzx ebx, word[num2] ;ebx = 00001234h
add eax, ebx ;eax = eax + ebx = 00011110h
mov dword[sum], eax ;[sum] = eax = 00011110h
mov rax, SYS_exit ;terminate excuting process
mov rdi, EXIT_SUCCESS ;exit status
syscall ;calling system services