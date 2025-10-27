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

loop_add:
	add	word[sum], cx
	inc	cx
	cmp	cx, 99
	jbe	loop_add

	mov	rcx, 3
	mov	ax, word[sum]
convert_loop:
	mov	dx, 0
	mov	bx, 10
	div	bx
	add     byte[ascii+rcx], dl
	dec	rcx
	cmp	rcx, 0
	jge	convert_loop

        mov     rax, 1
        mov     rdi, 1
        mov     rsi, str1
        mov     rdx, 13
        syscall

        mov     rax, 1
        mov     rdi, 1
        mov     rsi, ascii
        mov     rdx, 5
        syscall

        mov     rax, SYS_exit
        mov     rdi, EXIT_SUCCESS
        syscall
