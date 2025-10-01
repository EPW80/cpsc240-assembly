# CPSC 240 Assembly Programming Exercises

Collection of x86-64 NASM programs translating C/C++ arithmetic and conditional logic into assembly and verifying results with GDB.

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
- `leap.asm` Implements leap year calculation with conditional logic:
  ```c
  unsigned short year = 2025;
  unsigned short yLeap = 0, nLeap = 0;
  if((year%400 == 0) || ((year%4 == 0) && (year%100 != 0))) {
      yLeap++;
  } else {
      nLeap++;
  }
  ```
  Uses 16-bit variables with modulo operations and if-else branching.

## Build
Assemble and link with NASM + LD:
```bash
nasm -f elf64 -g addition.asm -o addition.o
ld addition.o -o addition

nasm -f elf64 -g subtraction.asm -o subtraction.o
ld subtraction.o -o subtraction

nasm -f elf64 leap.asm -o leap.o
ld leap.o -o leap
```

## Run
```bash
./addition
./subtraction
./leap
```
(Programs terminate immediately via `sys_exit`; use GDB to inspect results.)

## GDB Verification Examples

### Addition Program
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

### Subtraction Program
```bash
gdb ./subtraction
(gdb) break _start
(gdb) run
(gdb) stepi  # mov ax, word[num1]
(gdb) stepi  # sub ax, word[num2]
(gdb) x/1hx &dif   # expect 0x1358
```

### Leap Year Program
```bash
gdb ./leap
(gdb) break end_if
(gdb) run
(gdb) x/1xh &year    # expect 0x07e9 (2025)
(gdb) x/1xh &yLeap   # expect 0x0000 (0)
(gdb) x/1xh &nLeap   # expect 0x0001 (1)
(gdb) print/d *(unsigned short*)&year
(gdb) print/d *(unsigned short*)&yLeap
(gdb) print/d *(unsigned short*)&nLeap
```

## Manual Result Checks

### Addition:
- 0xFEDC (65244) + 0x1234 (4660) = 0x11110 = 69904 (needs 17 bits → use 32-bit sum)

### Subtraction:
- num2 = -292 → 65536 - 292 = 65244 = 0xFEDC
- 4660 - (-292) = 4660 + 292 = 4952 = 0x1358

### Leap Year (2025):
- 2025 % 400 = 25 (not 0)
- 2025 % 4 = 1 (not 0, so NOT a leap year)
- Result: yLeap = 0, nLeap = 1

## Notes
- `movzx` ensures correct zero-extension for unsigned operands before 32-bit add.
- Two's complement automatically handles negative subtraction in `subtraction.asm`.
- All constants and comments include hex equivalents for clarity.

## License
Educational coursework example; no explicit license provided.
