;exam02_review.asm
;signed short shortArr[10] = {-3012, 624, 1234, -2345, 3456, -90, 6231, -235, 12357, -7890};
;			//16-bit short integer array
;signed short posMul3[10];	//16-bit non-initial short array
;signed short negMul5[10];	//16-bit non-initial short array
;register long rbx = 0	//64-bit register
;register long rsi = 0	//64-bit register
;register long rdi = 0	//64-bit register
;register long rcx = 10	//64-bit register
;do {
;	if(shortArr[rbx] > 0 && shortArr[rbx]%3 == 0) {	//if positive and multiple of 3
;		posMul3[rsi] = shortArr[rbx];	//move to posMul3 array
;		rsi++;	//rsi = rsi + 1
;	} else if(shortArr[rbx] < 0 && shortArr[rbx]%5 == 0) { 	//if negative and multiple of 5
;		negMul5[rdi] = shortArr[rbx];	//move to negMul5 array
;		rdi++;	//rdi = rdi + 1
;	}
;	rbx++;	//rbx = rbx + 1
;	rcx--;		//rcx = rcx - 1
;} while(rcx != 0);	//if rcx != 0 do loop again

section .data
shortArr	dw	-3012, 624, 1234, -2345, 3456, -90, 6231, -235, 12357, -7890

section .bss
posMul3		resw	10
negMul5		resw	10

section .text
        global _start
_start:
	mov	rbx, 0
	mov	rsi, 0
	mov	rdi, 0
	mov	rcx, 10
doLoop:
	cmp	word[shortArr+(rbx*2)], 0
	jl	negative
positive:
	mov	ax, word[shortArr+(rbx*2)]
	cwd
	mov	r8w, 3
	idiv	r8w
	cmp	dx, 0
	jne	end_if
	mov	ax, word[shortArr+(rbx*2)]
	mov	word[posMul3+(rsi*2)], ax
	inc	rsi
	jmp	end_if
negative:
	mov	ax, word[shortArr+(rbx*2)]
	cwd
	mov	r8w, 5
	idiv	r8w
	cmp	dx, 0
	jne	end_if
	mov	ax, word[shortArr+(rbx*2)]
	add	word[negMul5+(rdi*2)], ax
	inc	rdi
end_if:
	inc	rbx
	loop	doLoop
end_do:
	mov	rax, 60
	mov	rdi, 0
	syscall