# CPSC 240 Assembly Arithmetic Exercises

Concise reference for two x86-64 NASM programs translating small C/C++ arithmetic snippets into assembly and verifying results with GDB.

## Files
- `addition.asm`  Implements:
  ```c
  unsigned short num1 = 65244; // 0xFEDC
  unsigned short num2 = 4660;  // 0x1234
  unsigned int   sum  = 0;
  sum = int(num1 + num2);      // 65244 + 4660 = 69904 (0x11110)
  ```
  Uses 32-bit register arithmetic with `movzx` to avoid 16-bit overflow.
- `subtraction.asm` Implements:
  ```c
  signed short num1 = 4660;    // 0x1234
  signed short num2 = -292;    // 0xFEDC (two's complement)
  signed short dif  = 0;
  dif = num1 - num2;           // 4660 - (-292) = 4952 (0x1358)
  ```
  Uses native 16-bit signed subtraction.

## Build
Assemble and link with NASM + LD:
```bash
nasm -f elf64 -g addition.asm -o addition.o
ld addition.o -o addition

nasm -f elf64 -g subtraction.asm -o subtraction.o
ld subtraction.o -o subtraction
```

## Run
```bash
./addition
./subtraction
```
(Programs terminate immediately via `sys_exit`; use GDB to inspect results.)

## GDB Verification (Example)
```bash
gdb ./addition
(gdb) break _start
(gdb) run
(gdb) stepi  # movzx eax, word[num1]
(gdb) info registers eax
(gdb) stepi  # movzx ebx, word[num2]
(gdb) stepi  # add eax, ebx
(gdb) x/1wx &sum   # expect 0x00011110
```
Subtraction session key points:
```bash
gdb ./subtraction
(gdb) break _start
(gdb) run
(gdb) stepi  # mov ax, word[num1]
(gdb) stepi  # sub ax, word[num2]
(gdb) x/1hx &dif   # expect 0x1358
```

## Manual Result Checks
Addition:
- 0xFEDC (65244) + 0x1234 (4660) = 0x11110 = 69904 (needs 17 bits → use 32-bit sum)

Subtraction:
- num2 = -292 → 65536 - 292 = 65244 = 0xFEDC
- 4660 - (-292) = 4660 + 292 = 4952 = 0x1358

## Notes
- `movzx` ensures correct zero-extension for unsigned operands before 32-bit add.
- Two's complement automatically handles negative subtraction in `subtraction.asm`.
- All constants and comments include hex equivalents for clarity.

## License
Educational coursework example; no explicit license provided.
