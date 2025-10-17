; ex6_coutAdd.asm
; unsigned char asc1 = '5', asc2 = '7', asc3[4]="00\n\0";
; unsigned char num1, num2, sum;
; num1 = atoi(asc1);
; num2 = atoi(asc2);
; sum = num1 + num2;
; asc3 = itoa(sum);
; cout << asc1 << '+' << asc2 << '=' << asc3;

section .data
LF		equ	10
NULL		equ	0
SYS_exit	equ	60
EXIT_SUCCESS	equ	0
asc1		db	'5'			;asc1 = 35h
asc2		db	'7'			;asc2 = 37h
asc3		db	"00", LF, NULL		;asc3 = 30,30,10,0
plus		db	'+'
equal		db	'='

section .bss
num1		resb	1			;reserve 1 byte space
num2		resb	1			;reserve 1 byte space
sum		resb	1			;reserve 1 byte space

section .text
        global _start

_start:
	;converts asc1 to num1
	mov	al, byte[asc1]			;al = 35h
	and	al, 0fh				;al = al and 0fh = 05h
	mov	byte[num1], al			;num1 = 05h

	;converts asc2 to num2
	mov	bl, byte[asc2]			;bl = 37h
	and	bl, 0fh				;bl = bl and 0fh = 07h
	mov	byte[num2], bl			;num2 = 07h

	;sum = num1 + num2
	mov	al, byte[num1]			;al = num1 = 05h
	add	al, byte[num2]			;al = num1+num2 = 0Ch = 12
	mov	byte[sum], al			;sum = al = 0Ch = 12

	;converts sum to asc3 code
	mov 	ah, 0				;ah = 0
	mov	al, byte[sum]			;al = sum
	mov	bl, 10				;bl = 10 = 0ah
	div	bl				;ah = ax%10, al = ax/10
        add     byte[asc3+0], al		;asc3+0 = al + 30h = '1'
        add     byte[asc3+1], ah		;asc3+1 = ah + 30h = '2'

	;cout << asc1
	mov     rax, 1				;SYS_write
        mov     rdi, 1				;where to write
        mov     rsi, asc1			;address of asc1
        mov     rdx, 1				;1 character to write
        syscall					;calling system services

	;cout << '+'
	mov     rax, 1				;SYS_write
        mov     rdi, 1				;where to write
        mov     rsi, plus			;address of plus
        mov     rdx, 1				;1 character to write
        syscall					;calling system services

	;cout << asc2
	mov     rax, 1				;SYS_write
        mov     rdi, 1				;where to write
        mov     rsi, asc2			;address of asc2
        mov     rdx, 1				;1 character to write
        syscall					;calling system services

	;cout << '='
	mov     rax, 1				;SYS_write
        mov     rdi, 1				;where to write
        mov     rsi, equal			;address of equal
        mov     rdx, 1				;1 character to write
        syscall					;calling system services

	;cout << asc3
	mov     rax, 1				;SYS_write
        mov     rdi, 1				;where to write
        mov     rsi, asc3			;address of asc2
        mov     rdx, 3				;1 character to write
        syscall					;calling system services

        mov     rax, SYS_exit			;terminate excuting process
        mov     rdi, EXIT_SUCCESS		;exit status
        syscall					;calling system services
