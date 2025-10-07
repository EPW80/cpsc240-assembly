# Manual GDB Simulation 1 - Year 2025

## Step-by-Step GDB Commands

### 1. Start GDB
```bash
gdb ./leap
```

### 2. Set Breakpoint at end_if
```gdb
(gdb) break end_if
```
**Expected Output:**
```
Breakpoint 1 at 0x40105a
```

### 3. Run the Program
```gdb
(gdb) run
```
**Expected Output:**
```
Starting program: /home/erikwilliams/dev/cpsc240assignments/leap

Breakpoint 1, 0x000000000040105a in end_if ()
```

### 4. Display Memory Contents (Hexadecimal)

**Display year:**
```gdb
(gdb) x/xh &year
```
**Expected Output:**
```
0x402000 <year>:        0x07e9
```

**Display yLeap:**
```gdb
(gdb) x/xh &yLeap
```
**Expected Output:**
```
0x402002 <yLeap>:       0x0000
```

**Display nLeap:**
```gdb
(gdb) x/xh &nLeap
```
**Expected Output:**
```
0x402004 <nLeap>:       0x0001
```

### 5. Display Decimal Values

**Display year (decimal):**
```gdb
(gdb) print/d *(unsigned short*)&year
```
**Expected Output:**
```
$1 = 2025
```

**Display yLeap (decimal):**
```gdb
(gdb) print/d *(unsigned short*)&yLeap
```
**Expected Output:**
```
$2 = 0
```

**Display nLeap (decimal):**
```gdb
(gdb) print/d *(unsigned short*)&nLeap
```
**Expected Output:**
```
$3 = 1
```

### 6. Display Register Values
```gdb
(gdb) info registers ax bx dx
```
**Expected Output:**
```
ax             0x1fa               506
bx             0x4                 4
dx             0x1                 1
```

### 7. Continue Program Execution
```gdb
(gdb) continue
```
**Expected Output:**
```
Continuing.
[Inferior 1 (process XXXXX) exited normally]
```

### 8. Exit GDB
```gdb
(gdb) quit
```

---

## Quick Reference - All Commands in Order

```gdb
gdb ./leap
break end_if
run
x/xh &year
x/xh &yLeap
x/xh &nLeap
print/d *(unsigned short*)&year
print/d *(unsigned short*)&yLeap
print/d *(unsigned short*)&nLeap
info registers ax bx dx
continue
quit
```

---

## Analysis of Results

### Memory Values:
- **year** = 0x07e9 (2025 decimal)
- **yLeap** = 0x0000 (0 decimal) ← NOT incremented
- **nLeap** = 0x0001 (1 decimal) ← INCREMENTED

### Register Values:
- **ax** = 0x1fa (506) → quotient of 2025 ÷ 4
- **bx** = 0x4 (4) → last divisor used
- **dx** = 0x1 (1) → remainder of 2025 % 4

### Calculation:
```
2025 ÷ 4 = 506 remainder 1
2025 % 4 = 1 (not equal to 0)
```

### Conclusion:
Since 2025 is NOT divisible by 4 (remainder = 1), the year 2025 is **NOT a leap year**.
Therefore, the `else_block` was executed, incrementing `nLeap` to 1 while `yLeap` remained 0.

**Result: ✅ CORRECT** - The program correctly identified 2025 as NOT a leap year.
