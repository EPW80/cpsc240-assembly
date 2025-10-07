# Manual GDB Simulation 2 - Year 2024

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
0x402000 <year>:        0x07e8
```

**Display yLeap:**
```gdb
(gdb) x/xh &yLeap
```
**Expected Output:**
```
0x402002 <yLeap>:       0x0001
```

**Display nLeap:**
```gdb
(gdb) x/xh &nLeap
```
**Expected Output:**
```
0x402004 <nLeap>:       0x0000
```

### 5. Display Decimal Values

**Display year (decimal):**
```gdb
(gdb) print/d *(unsigned short*)&year
```
**Expected Output:**
```
$1 = 2024
```

**Display yLeap (decimal):**
```gdb
(gdb) print/d *(unsigned short*)&yLeap
```
**Expected Output:**
```
$2 = 1
```

**Display nLeap (decimal):**
```gdb
(gdb) print/d *(unsigned short*)&nLeap
```
**Expected Output:**
```
$3 = 0
```

### 6. Display Register Values
```gdb
(gdb) info registers ax bx dx
```
**Expected Output:**
```
ax             0x14                20
bx             0x64                100
dx             0x18                24
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
- **year** = 0x07e8 (2024 decimal)
- **yLeap** = 0x0001 (1 decimal) ← INCREMENTED
- **nLeap** = 0x0000 (0 decimal) ← NOT incremented

### Register Values:
- **ax** = 0x14 (20) → quotient of 2024 ÷ 100
- **bx** = 0x64 (100) → last divisor used
- **dx** = 0x18 (24) → remainder of 2024 % 100

### Calculation:
```
2024 ÷ 4 = 506 remainder 0  → divisible by 4 ✓
2024 ÷ 100 = 20 remainder 24 → NOT divisible by 100 ✓
```

### Logic Flow:
1. **Check year % 400 == 0**: 2024 % 400 = 24 ❌ (not 0, continue)
2. **Check year % 4 == 0**: 2024 % 4 = 0 ✓ (yes, continue)
3. **Check year % 100 != 0**: 2024 % 100 = 24 ✓ (not 0, so it's a leap year)

### Conclusion:
Since 2024 is divisible by 4 AND NOT divisible by 100, the year 2024 **IS a leap year**.
Therefore, the `if_block` was executed, incrementing `yLeap` to 1 while `nLeap` remained 0.

**Result: ✅ CORRECT** - The program correctly identified 2024 as a leap year.
