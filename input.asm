; input.asm
; char num;
; char buffer;
; char ascii[10];
; char mesg[] = "Input a number (1~9): ";
; char multiple[] = " is multiple of 3\n";
; register int r10 = 0;
; do {
; 	cout << "Input a number (1~9): ";
; 	cin >> buffer;
;	ascii[r10] = buffer;
;	r10++;
; } while(r10 < 9);
; r10 = 0;
; do {
;	num = atoi(ascii[r10]);
; 	if(num%3 == 0) {
; 	  cout << num << " is multiple of 3\n";
;	}
;	r10++;
; } while(r10 < 9);

section .bss
num		resb	1
buffer		resb	2
ascii		resb	10

section .data
LF		equ	10
NULL		equ	0
SYS_exit	equ	60
EXIT_SUCCESS	equ	0
mesg		db	"Input a number (1~9): ", NULL
multiple	db	" is multiple of 3", LF, NULL

section .text
	global _start
_start:
	mov	r10, 0
next1:
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, mesg
	mov	rdx, 22
	syscall

	mov	rax, 0
	mov	rdi, 0
	mov	rsi, buffer
	mov	rdx, 2
	syscall

	mov	sil, byte[buffer]
	mov	byte[ascii+r10], sil

	inc	r10
	cmp	r10, 9
	jb	next1

	mov	r10, 0
next2:
	mov	al, byte[ascii+r10]
	and	al, 0fh
	mov	byte[num], al

	mov	ah, 0
	mov	al, byte[num]
	mov	bl, 3
	div	bl
	cmp	ah, 0
	jnz	skip

	mov	rax, 1
	mov	rdi, 1
	lea	rsi, [ascii+r10]
	mov	rdx, 1
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, multiple
	mov	rdx, 19
	syscall
skip:
	inc	r10
	cmp	r10, 9
	jb	next2
done:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
