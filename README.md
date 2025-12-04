---

# 📘 **Booth Multiplier (8×8 Signed) — Verilog RTL Implementation**

This project implements an **8-bit signed Booth Multiplier** using a **Finite State Machine (FSM)**–driven sequential datapath.
The design performs multiplication using the **Booth Algorithm (Radix-2)** and produces a **16-bit signed product**.

This is a *cycle-based*, hardware-accurate implementation suitable for FPGA or ASIC learning projects.

---

# 🚀 Features

### ✔ **Signed 8×8 multiplication (two’s complement)**

Both inputs `a` and `b` are treated as **signed 8-bit operands**.

### ✔ **Sequential Booth Algorithm (Radix-2)**

Uses the classic Booth algorithm based on `(Q0, Q_1)` pair:

| Q0 | Q_1 | Operation    |
| -- | --- | ------------ |
| 0  | 0   | No operation |
| 1  | 1   | No operation |
| 0  | 1   | Add +M       |
| 1  | 0   | Add −M       |

### ✔ **Internal datapath registers**

* `A` — Accumulator
* `M` — Multiplicand
* `Q` — Multiplier
* `Q_1` — Extra bit for Booth encoding
* `M_bar` — Two’s complement of M (for subtraction)

### ✔ **FSM-controlled**

States:

```
IDLE → LOAD → COMPARE → (ZERO_ONE / ONE_ZERO) → SHIFT → DONE
```

### ✔ **Single-cycle LOAD, multi-cycle execution**

The multiplier performs 8 Booth iterations (one per bit).

### ✔ **Valid/Done handshake**

`load = 1` → start operation
`done = 1` → product valid

---

# 🧠 **How the Algorithm Works (Simple Summary)**

Booth’s algorithm reduces the number of additions required during multiplication by encoding the operations using the pair `(Q0, Q_1)`:

* `01` → Add M
* `10` → Add −M
* `00` or `11` → Do nothing
* Perform **arithmetic right shift** on `{A, Q, Q_1}`
* Repeat for 8 cycles

After 8 iterations, `{A, Q}` contains the final 16-bit signed product.

---

# 🔧 **RTL Architecture**

### **FSM (Control Unit)**

Controls:

* Whether to add `M`, `M_bar`, or do nothing
* When to shift
* When to iterate or finish
* When to assert `done`

### **Datapath**

Includes:

* 8-bit adder for `A + M` or `A + M_bar`
* Shift logic for arithmetic right shift of `{A, Q, Q_1}`
* Internal registers updated on each clock edge

---

---

# 🧪 **Simulation Example Output**

For inputs:

| a  | b  | Expected Product |
| -- | -- | ---------------- |
| 10 | -2 | -20              |
| -8 | 4  | -32              |
| -5 | -2 | 10               |
| 3  | 7  | 21               |

The testbench prints:

```
DONE: A=10  B=-2  Product=-20
DONE: A=-8  B=4   Product=-32
DONE: A=-5  B=-2  Product=10
DONE: A=3   B=7   Product=21
```

---

# 📌 **Notes**

* This multiplier takes **8 cycles**, one per bit of the multiplier.
* Great for learning **FSM + datapath design**, **signed arithmetic**, and **Booth encoding**.
* Can be extended to parameterized bit-width or pipelined versions.
* Next level: **Booth Radix-4**, **Wallace Tree**, **Booth + Wallace hybrid**.

---

# 📂 **Files**

```
booth.v       → RTL design  
booth_tb.v    → Testbench  
README.md     → Documentation  
```

---

# 🏁 Conclusion

This project demonstrates how sequential arithmetic units are built using:

* Control FSM
* Datapath registers
* Combinational add/sub logic
* Shifters
* Signed 2’s complement math

It’s a perfect stepping stone toward:

* Wallace Tree multipliers
* Radix-4 Booth
* Pipelined multipliers
* ALU architecture
* Custom CPU datapath design

---

Done by Jeevanandh R - read my medium blog for VLSI learning updates https://medium.com/@jeevamatrix
