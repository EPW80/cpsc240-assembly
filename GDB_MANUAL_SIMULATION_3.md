# Manual GDB Simulation 3 - Year 2000

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
0x402000 <year>:        0x07d0
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
$1 = 2000
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
ax             0x5                 5
bx             0x190               400
dx             0x0                 0
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
- **year** = 0x07d0 (2000 decimal)
- **yLeap** = 0x0001 (1 decimal) ← INCREMENTED
- **nLeap** = 0x0000 (0 decimal) ← NOT incremented

### Register Values:
- **ax** = 0x5 (5) → quotient of 2000 ÷ 400
- **bx** = 0x190 (400) → last divisor used
- **dx** = 0x0 (0) → remainder of 2000 % 400 ✓

### Calculation:
```
2000 ÷ 400 = 5 remainder 0  → divisible by 400 ✓
```

### Logic Flow:
1. **Check year % 400 == 0**: 2000 % 400 = 0 ✓ (YES! Jump to if_block)
   
Since the first condition is satisfied, the program immediately jumps to `if_block` without checking the other conditions.

### Conclusion:
Since 2000 is divisible by 400, the year 2000 **IS a leap year** (special case).
Therefore, the `if_block` was executed, incrementing `yLeap` to 1 while `nLeap` remained 0.

**Result: ✅ CORRECT** - The program correctly identified 2000 as a leap year.

### Special Note:
Year 2000 is a special case that demonstrates the **"divisible by 400"** rule:
- Years divisible by 100 are usually NOT leap years (e.g., 1900)
- BUT if also divisible by 400, they ARE leap years (e.g., 2000, 2400)
- This ensures the calendar stays synchronized with Earth's orbit
