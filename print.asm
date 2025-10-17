; print.asm
; Calculates 1+2+3+...+99 and displays the result in a terminal window
; char str1[] = "1+2+3+...+99=";
; short sum = 0;
; char ascii[5] = "0000\n";
; register short cx = 1;
; for(cx=1; cx<=99; cx++)
;    sum += cx;
; ascii = itoa(sum);
; cout << str1 << ascii;

section .data
LF		equ	10
NULL		equ	0
SYS_exit	equ	60
EXIT_SUCCESS	equ	0
str1		db	"1+2+3+...+99=", NULL
ascii		db	"0000", LF, NULL

section .bss
sum		resw	1			;reserve 1 word (16-bit) space

section .text
        global _start

_start:
	; initialize sum to 0
	mov	word[sum], 0			;sum = 0
	
	; initialize cx to 1
	mov	cx, 1				;cx = 1

	; calculates 1+2+3+...+99
loop_add:
	add	word[sum], cx			;sum += cx
	inc	cx				;cx++
	cmp	cx, 99				;compare cx with 99
	jbe	loop_add			;if(cx<=99) goto loop_add

	; converts sum into ascii
	mov	rcx, 3				;start from rightmost position
	mov	ax, word[sum]			;ax = [sum]
convert_loop:
	mov	dx, 0				;dx = 0 (clear for division)
	mov	bx, 10				;bx = 10
	div	bx				;dx=(dx:ax)%10, ax=(dx:ax)/10
	add     byte[ascii+rcx], dl		;ascii[rcx] = dl + 30h
	dec	rcx				;rcx--
	cmp	rcx, 0				;compare rcx with 0
	jge	convert_loop			;if(rcx>=0) goto convert_loop

	; cout << str1
        mov     rax, 1				;SYS_write
        mov     rdi, 1				;where to write
        mov     rsi, str1			;address of str1
        mov     rdx, 13				;13 characters to write
        syscall					;calling system services

	; cout << ascii
        mov     rax, 1				;SYS_write
        mov     rdi, 1				;where to write
        mov     rsi, ascii			;address of ascii
        mov     rdx, 5				;5 characters to write
        syscall					;calling system services

	; exit program
        mov     rax, SYS_exit			;terminate executing process
        mov     rdi, EXIT_SUCCESS		;exit status
        syscall					;calling system services
