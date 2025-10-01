; leap.asm - Leap year calculation program
; CPSC 240 Assignment - Convert C/C++ leap year logic to x86-64 assembly
; unsigned short year = 2025;
; unsigned short yLeap = 0, nLeap = 0;
; if((year%400 == 0) || ((year%4 == 0) && (year%100 != 0))) {
; yLeap++;
; } else {
; nLeap++;
; }

section .data
    SYS_exit        equ 0x4C
    EXIT_SUCCESS    equ 0
    year    dw  2025        ; year = 07E9h (16-bit)
    yLeap   dw  0           ; yLeap = 0000h (16-bit)  
    nLeap   dw  0           ; nLeap = 0000h (16-bit)

section .text
    global _start

_start:
    ; Load year into ax register
    mov ax, word[year]      ; ax = year = 07E9h
    
    ; Check if year % 400 == 0
    xor dx, dx              ; Clear dx for division
    mov bx, 400             ; bx = divisor = 400
    div bx                  ; ax = year/400, dx = year%400
    cmp dx, 0               ; Compare remainder with 0
    je if_block             ; If remainder == 0, it's a leap year
    
    ; Restore year value (division modified ax)
    mov ax, word[year]      ; ax = year = 07E9h
    
    ; Check if year % 4 == 0
    xor dx, dx              ; Clear dx for division
    mov bx, 4               ; bx = divisor = 4
    div bx                  ; ax = year/4, dx = year%4
    cmp dx, 0               ; Compare remainder with 0
    jne else_block          ; If remainder != 0, not a leap year
    
    ; If we reach here, year % 4 == 0, now check year % 100 != 0
    mov ax, word[year]      ; Restore year value
    xor dx, dx              ; Clear dx for division
    mov bx, 100             ; bx = divisor = 100
    div bx                  ; ax = year/100, dx = year%100
    cmp dx, 0               ; Compare remainder with 0
    je else_block           ; If remainder == 0 (divisible by 100), not leap year
    
    ; If we reach here, (year%4 == 0) && (year%100 != 0), so it's a leap year

if_block:
    inc word[yLeap]         ; yLeap++
    jmp end_if              ; goto end_if

else_block:
    inc word[nLeap]         ; nLeap++

end_if:
    mov ah, SYS_exit        ; terminate executing process (16-bit DOS function)
    mov al, EXIT_SUCCESS    ; exit status (16-bit)
    int 0x21                ; DOS interrupt (16-bit)