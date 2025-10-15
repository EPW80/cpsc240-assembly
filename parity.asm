;parity.asm
;char flexStr[30] = "Welcome to Ubuntu 22.04.6 LTS";
;char toUpper[30];
;char toLower[30];
;register long rsi = 0;
;register long rcx = 30;
;do {
; if(flexStr[rsi] >= 'A' && flexStr[rsi] <= 'Z') {
; toUpper[rsi] = flexStr[rsi];
; toLower[rsi] = flexStr[rsi] + 0x20;
; }
; else if(flexStr[rsi] >= 'a' && flexStr[rsi] <= 'z') {
; toUpper[rsi] = flexStr[rsi] - 0x20;
; toLower[rsi] = flexStr[rsi];
; }
; else {
; toUpper[rsi] = flexStr[rsi];
; toLower[rsi] = flexStr[rsi];
; }
; rsi++;
; rcx--;
;} while(rcx != 0);

section .data
SYS_exit equ 60
EXIT_SUCCESS equ 0
flexStr db "Welcome to Ubuntu 22.04.6 LTS", 0

section .bss
toUpper resb 30
toLower resb 30

section .text
global _start

_start:
mov rsi, 0
mov rcx, 30

doloop:
mov al, byte[flexStr+rsi]
cmp al, 'A'
jl check_lowercase
cmp al, 'Z'
jg check_lowercase
mov byte[toUpper+rsi], al
add al, 0x20
mov byte[toLower+rsi], al
jmp loop_increment

check_lowercase:
mov al, byte[flexStr+rsi]
cmp al, 'a'
jl if_other
cmp al, 'z'
jg if_other
sub al, 0x20
mov byte[toUpper+rsi], al
mov al, byte[flexStr+rsi]
mov byte[toLower+rsi], al
jmp loop_increment

if_other:
mov al, byte[flexStr+rsi]
mov byte[toUpper+rsi], al
mov byte[toLower+rsi], al

loop_increment:
inc rsi
dec rcx
cmp rcx, 0
jne doloop

mov rax, SYS_exit
mov rdi, EXIT_SUCCESS
syscall
