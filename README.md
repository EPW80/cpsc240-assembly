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
- `parity.asm` Implements string case conversion with do-while loop:
  ```c
  char flexStr[30] = "Welcome to Ubuntu 22.04.6 LTS";
  char toUpper[30], toLower[30];
  register long rsi = 0, rcx = 30;
  do {
      if(flexStr[rsi] >= 'A' && flexStr[rsi] <= 'Z') {
          toUpper[rsi] = flexStr[rsi];
          toLower[rsi] = flexStr[rsi] + 0x20;
      } else if(flexStr[rsi] >= 'a' && flexStr[rsi] <= 'z') {
          toUpper[rsi] = flexStr[rsi] - 0x20;
          toLower[rsi] = flexStr[rsi];
      } else {
          toUpper[rsi] = flexStr[rsi];
          toLower[rsi] = flexStr[rsi];
      }
      rsi++; rcx--;
  } while(rcx != 0);
  ```
  Uses 8-bit character arrays and 64-bit registers for loop control.
- `print.asm` Implements summation calculation and display:
  ```c
  char str1[] = "1+2+3+...+99=";
  short sum = 0;
  char ascii[5] = "0000\n";
  register short cx = 1;
  for(cx=1; cx<=99; cx++)
      sum += cx;
  ascii = itoa(sum);
  cout << str1 << ascii;
  ```
  Uses 16-bit arithmetic with for loop, ASCII conversion via division by 10.
- `input.asm` Implements array-based input processing with dual loops:
  ```c
  char num, buffer;
  char ascii[10];
  char mesg[] = "Input a number (1~9): ";
  char multiple[] = " is multiple of 3\n";
  register int r10 = 0;
  do {
      cout << "Input a number (1~9): ";
      cin >> buffer;
      ascii[r10] = buffer;
      r10++;
  } while(r10 < 9);
  r10 = 0;
  do {
      num = atoi(ascii[r10]);
      if(num%3 == 0) {
          cout << num << " is multiple of 3\n";
      }
      r10++;
  } while(r10 < 9);
  ```
  Uses two-loop structure: first collects 9 inputs into array, second processes stored values.
- `macro.asm` Implements sum calculator with macros:
  ```c
  #macro print(addr, n)  // expands to sys_write syscall
  #macro scan(addr, n)   // expands to sys_read syscall
  
  char buffer[4];
  short n, sumN;
  char ascii[10];
  char msg1[] = "Input a number (100~140): ";
  char msg2[] = "1 + 2 + 3 +...+ N = ";
  
  print(msg1, 26);
  scan(buffer, 4);
  
  // Inline atoi: convert ASCII to integer using multiplication by 10
  n = atoi(buffer);
  
  // Calculate sum 1+2+3+...+n
  for(cx=0; cx<=n; cx++)
      sumN += cx;
  
  // Inline itoa: stack-based successive division by 10
  ascii = itoa(sumN);
  
  print(msg2, 20);
  print(ascii, 5);
  ```
  Uses macros for I/O, inline atoi/itoa conversions, word-sized variables.

## Build
Assemble and link with NASM + LD:
```bash
nasm -f elf64 -g addition.asm -o addition.o
ld addition.o -o addition

nasm -f elf64 -g subtraction.asm -o subtraction.o
ld subtraction.o -o subtraction

nasm -f elf64 leap.asm -o leap.o
ld leap.o -o leap

nasm -f elf64 parity.asm -o parity.o
ld parity.o -o parity

nasm -f elf64 print.asm -o print.o
ld print.o -o print

nasm -f elf64 input.asm -o input.o
ld input.o -o input

nasm -f elf64 macro.asm -o macro.o
ld macro.o -o macro
```

## Run
```bash
./addition
./subtraction
./leap
./parity
./print        # Displays: 1+2+3+...+99=4950
./input        # Interactive: prompts for 9 numbers, displays multiples of 3
./macro        # Interactive: prompts for number (100-140), displays sum
```
(Most programs terminate immediately via `sys_exit`; use GDB to inspect results.)

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

### Parity/String Conversion Program
```bash
gdb ./parity
(gdb) break loop_increment
(gdb) run
(gdb) x/s 0x402000    # flexStr: "Welcome to Ubuntu 22.04.6 LTS"
(gdb) x/s 0x40201e    # toUpper: "WELCOME TO UBUNTU 22.04.6 LTS"
(gdb) x/s 0x40203c    # toLower: "welcome to ubuntu 22.04.6 lts"
(gdb) x/30cb 0x402000  # Show original characters with ASCII values
(gdb) x/30cb 0x40201e  # Show uppercase conversion
(gdb) x/30cb 0x40203c  # Show lowercase conversion
```

### Print Summation Program
```bash
gdb ./print
(gdb) break loop_add
(gdb) break convert_loop
(gdb) run
(gdb) continue  # At cx=1
(gdb) x/1hd &sum        # sum after first iteration
(gdb) continue  # Continue through loop
# At end of loop:
(gdb) x/1hd &sum        # expect 4950 (sum of 1+2+...+99)
(gdb) continue  # At ASCII conversion
(gdb) x/5cb &ascii      # expect "4950\n"
```

### Input Array Processing Program
```bash
gdb ./input
(gdb) break next2
(gdb) run
# Input 9 numbers when prompted: 3 1 2 4 5 6 7 8 9
(gdb) x/9cb &ascii      # View all stored inputs
(gdb) continue          # Process first value
(gdb) print/d $r10      # Current index
(gdb) print/d $ah       # Remainder after div by 3 (0 = multiple)
# Continue through all 9 iterations to see which output
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

### Print (Sum 1+2+...+99):
- Formula: n(n+1)/2 = 99(100)/2 = 4950
- Result: "1+2+3+...+99=4950"

### Input (Multiples of 3):
- Input: 3,1,2,4,5,6,7,8,9
- Multiples of 3: 3, 6, 9
- Output: "3 is multiple of 3", "6 is multiple of 3", "9 is multiple of 3"

### Macro (Sum 1+2+...+N):
- Input: 100 → Output: 5050 (formula: n(n+1)/2)
- Input: 120 → Output: 7260
- Input: 140 → Output: 9870
- Macros expand: `print msg1, 26` → 5 syscall instructions
- Inline conversions eliminate function call overhead

## Notes
- `movzx` ensures correct zero-extension for unsigned operands before 32-bit add.
- Two's complement automatically handles negative subtraction in `subtraction.asm`.
- All constants and comments include hex equivalents for clarity.

## License
Educational coursework example; no explicit license provided.
