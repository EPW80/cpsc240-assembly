# Manual Result Verification for Simulation 1

## Year 2025 - Leap Year Verification

---

## Key Verification Points Covered:

### 1. Hexadecimal to Decimal Conversion
**Verified: 0x07e9 = 2025** ✅

**Calculation:**
```
0x07e9 = (7 × 16²) + (14 × 16¹) + (9 × 16⁰)
       = (7 × 256) + (14 × 16) + (9 × 1)
       = 1792 + 224 + 9
       = 2025
```

**GDB Output:**
- Memory: `0x402000: 0x07e9`
- Decimal: `$1 = 2025`
- **Conclusion: Verified ✅**

---

### 2. Manual Leap Year Calculation

**Rule:** A year is a leap year if:
- `(year % 400 == 0)` OR `((year % 4 == 0) AND (year % 100 != 0))`

**Step-by-Step Calculation for 2025:**

#### Check 1: Is 2025 divisible by 400?
```
2025 ÷ 400 = 5.0625
Quotient = 5
Remainder = 2025 - (5 × 400) = 2025 - 2000 = 25
2025 % 400 = 25 ≠ 0 ❌
```
**Result:** NOT divisible by 400 → Continue to next check

#### Check 2: Is 2025 divisible by 4?
```
2025 ÷ 4 = 506.25
Quotient = 506
Remainder = 2025 - (506 × 4) = 2025 - 2024 = 1
2025 % 4 = 1 ≠ 0 ❌
```
**Result:** NOT divisible by 4 → 2025 is NOT a leap year

**Conclusion: 2025 is NOT a leap year** ✅

---

### 3. Register Value Verification

**GDB Output:**
```
ax = 0x1fa (506 decimal)
bx = 0x4 (4 decimal)
dx = 0x1 (1 decimal)
```

**Verification:**
- **ax = 506**: This is the quotient of `2025 ÷ 4`
  ```
  2025 ÷ 4 = 506 remainder 1
  Verified: ax = 506 ✅
  ```

- **bx = 4**: This is the last divisor used (checking divisibility by 4)
  ```
  Verified: bx = 4 ✅
  ```

- **dx = 1**: This is the remainder of `2025 % 4`
  ```
  2025 % 4 = 1
  Verified: dx = 1 ✅
  ```

**Conclusion:** Register values confirm 2025 % 4 = 1 (not 0) ✅

---

### 4. Memory Verification

**GDB Memory Output:**
```
0x402000 <year>:        0x07e9  → 2025 decimal
0x402002 <yLeap>:       0x0000  → 0 decimal
0x402004 <nLeap>:       0x0001  → 1 decimal
```

**Expected Values:**
| Variable | Expected | Actual | Status |
|----------|----------|--------|--------|
| year     | 2025     | 2025   | ✅ PASS |
| yLeap    | 0        | 0      | ✅ PASS |
| nLeap    | 1        | 1      | ✅ PASS |

**Memory Layout:**
```
Address     Variable    Hex Value    Decimal    Size
0x402000    year        0x07e9       2025       16-bit (dw)
0x402002    yLeap       0x0000       0          16-bit (dw)
0x402004    nLeap       0x0001       1          16-bit (dw)
```

**Verification:**
- ✅ All variables stored consecutively in memory
- ✅ Each variable occupies 2 bytes (16-bit word)
- ✅ Values match expected leap year calculation result

---

### 5. Program Logic Flow Verification

**Assembly Logic:**
```assembly
1. Check: year % 400 == 0? → NO (25 ≠ 0)
2. Check: year % 4 == 0?   → NO (1 ≠ 0)
3. Jump to else_block
4. Execute: inc word[nLeap]
5. Result: nLeap = 1, yLeap = 0
```

**C/C++ Equivalent:**
```c
if((2025 % 400 == 0) || ((2025 % 4 == 0) && (2025 % 100 != 0))) {
    yLeap++;  // NOT executed
} else {
    nLeap++;  // EXECUTED ✅
}
```

**Verification:**
- ✅ Condition evaluates to FALSE (2025 is not a leap year)
- ✅ else_block executed
- ✅ nLeap incremented from 0 to 1
- ✅ yLeap remained at 0

---

## Final Verification Summary

| Test Point | Expected | Actual | Status |
|-----------|----------|--------|--------|
| Year Value | 2025 | 2025 | ✅ PASS |
| Hex Conversion | 0x07e9 = 2025 | Verified | ✅ PASS |
| Is Leap Year? | NO | NO | ✅ PASS |
| yLeap Counter | 0 | 0 | ✅ PASS |
| nLeap Counter | 1 | 1 | ✅ PASS |
| Register ax | 506 | 506 | ✅ PASS |
| Register bx | 4 | 4 | ✅ PASS |
| Register dx | 1 | 1 | ✅ PASS |
| Memory Layout | Correct | Correct | ✅ PASS |
| Program Logic | Correct | Correct | ✅ PASS |

---

## Conclusion

**Simulation 1 Status: ✅ FULLY VERIFIED**

The assembly program correctly:
1. ✅ Stored year = 2025 in memory
2. ✅ Performed modulo calculations (% 400, % 4)
3. ✅ Determined 2025 is NOT a leap year
4. ✅ Incremented nLeap to 1
5. ✅ Left yLeap at 0
6. ✅ Maintained correct register states
7. ✅ Executed proper control flow (else_block)

**The program output matches manual calculations exactly.** The implementation is correct and equivalent to the C/C++ specification.

---

## Mathematical Proof

**Given:** year = 2025

**Leap Year Conditions:**
- Condition A: `year % 400 == 0` → FALSE (2025 % 400 = 25)
- Condition B: `year % 4 == 0` → FALSE (2025 % 4 = 1)
- Condition C: `year % 100 != 0` → TRUE (2025 % 100 = 25)

**Formula:** `A OR (B AND C)`
```
FALSE OR (FALSE AND TRUE)
= FALSE OR FALSE
= FALSE
```

**Therefore:** 2025 is NOT a leap year → nLeap = 1, yLeap = 0 ✅
