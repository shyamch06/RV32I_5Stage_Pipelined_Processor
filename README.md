# RISC-V 5-Stage Pipelined Processor (RV32I) — Verilog

A 5-stage pipelined RV32I RISC-V processor implemented in Verilog, built from the ground up to handle complex instruction-level parallelism. It features a complete hazard detection unit and data forwarding logic to resolve dependencies. The core is demonstrated live on Basys 3 FPGA hardware — running a tightly optimized Fibonacci-sequence program and streaming the result to a multiplexed 4-digit 7-segment display in real time.

---
## Overview

This project implements the classic 5-stage RISC-V datapath: **Fetch (IF), Decode (ID), Execute (EX), Memory (MEM), and Writeback (WB)**.

Unlike a single-cycle core, this pipelined architecture allows multiple instructions to be processed simultaneously. To ensure correct execution, the processor includes a robust **Hazard Detection Unit** (to stall for load-use hazards and flush the pipeline on taken branches/jumps) and a **Data Forwarding Unit** (to resolve Read-After-Write data dependencies without unnecessary stalling).

As a demo application, the processor boots from `program.mem` and runs a hand-assembled Fibonacci sequence. The internal CPU clock (`clkout`) is divided down from the 100 MHz board clock so that each new Fibonacci value becomes visible to the human eye — roughly one new value every half-second — on the FPGA's 7-segment displays.

---
## Features

- **5-Stage Pipeline Architecture:** Independent IF, ID, EX, MEM, and WB stages separated by synchronous pipeline registers.
- **Data Forwarding Unit:** Eliminates data hazards by forwarding ALU and Memory stage results directly back to the Execute stage.
- **Hazard Detection Unit:** Automatically stalls the IF/ID stages for load-use data hazards and flushes the ID/EX stages on taken control hazards (branches, `jal`, `jalr`).
- **Full RV32I Support:** Handles R-type, I-type (arithmetic + loads), S-type (stores), B-type (branches), `jal`, `jalr`, `lui`, and `auipc`.
- **Clock Divider & Peripherals:** Brings the 100 MHz board clock down to human-visible speeds, utilizing a double-dabble BCD converter and a high-speed multiplexed 7-segment display driver.
- **Hardware Verified:** Includes an `.xdc` constraint file mapped for the Basys 3 board. Fully synthesizable and tested on physical FPGA hardware.

---
## Verification & Results

Correctness was verified in two independent ways: a self-checking simulation testbench, and physical hardware testing on the Basys 3.

### Self-Checking Testbench

A custom testbench drives the design through Icarus Verilog and automatically checks every computed Fibonacci value against the expected sequence, rather than relying on manual waveform inspection:

    Summary: 10 PASS, 0 FAIL out of 10 checks

Building this testbench surfaced two real RTL bugs that manual/visual simulation had missed:

- **Reset-domain-crossing bug:** the clock divider held its output clock frozen while the system reset was asserted — which meant the processor's own synchronous reset could never actually latch, since it needs a valid clock edge *while* reset is high. Fixed by letting the divider free-run independently of the system reset.
- **Uninitialized instruction memory:** any program-counter address beyond the loaded program defaulted to `X` (undefined) in simulation, which could propagate into corrupted register writes. Fixed by pre-filling unused instruction memory with `NOP` (`0x00000013`) before loading the real program.

### Waveform

`fib_value` (register `x1`) stepping cleanly through the Fibonacci sequence in GTKWave:

![Fibonacci sequence waveform](https://github.com/shyamch06/RV32I_5Stage_Pipelined_Processor/blob/main/GTK_Waveform/Riscv_pipelined.jpeg)

### Post-Implementation Timing & Utilization (Vivado, XC7A35T)

| Metric | Result |
|---|---|
| Target clock | 100 MHz (10.000 ns) |
| Worst Negative Slack (WNS) | +5.166 ns |
| Estimated max frequency | ~207 MHz |
| Slice LUTs | 915 / 20,800 (4%) |
| Slice Registers | 565 / 41,600 (1%) |
| Failing endpoints | 0 |

---
## The Software (program.mem)

The processor executes the following highly optimized assembly code to generate the Fibonacci sequence in register `x1`:

| PC (Dec) | Hex Code | RISC-V Assembly | Explanation |
| :--- | :--- | :--- | :--- |
| **0** | `00100093` | `addi x1, x0, 1` | `x1 = 1` (Initialize current Fibonacci number) |
| **4** | `00000113` | `addi x2, x0, 0` | `x2 = 0` (Initialize previous Fibonacci number) |
| **8** | `002081B3` | `add x3, x1, x2` | **[LOOP START]** `x3 = x1 + x2` (Calculate next number) |
| **12** | `00008133` | `add x2, x1, x0` | `x2 = x1` (Update previous number) |
| **16** | `000180B3` | `add x1, x3, x0` | `x1 = x3` (Update current number) |
| **20** | `FF5FF06F` | `jal x0, -12` | Jump back 12 bytes (to PC = 8) to repeat the loop. |

Note: this loop has no halt condition, so it runs indefinitely — after roughly the 47th term, values exceed the 32-bit register width and wrap around via standard integer overflow. This is expected, mathematically correct behavior, not a bug.

---
## How to Simulate

```bash
iverilog -o riscv_sim *.v
vvp riscv_sim
gtkwave pipeline_riscv.vcd
```

The testbench (`tb_topmodule.v`) speeds up the clock divider for simulation via a `defparam` override, so the full 10-check run completes in well under a second of simulated time.

---
## Repository Structure

| Module | Stage/Category | Description |
|---|---|---|
| `topmodule` | **Top-Level** | Wires the processor to the clock divider and 7-segment display chain |
| `processor` | **Core** | Instantiates the 5 pipeline stages, hazard unit, and pipeline registers |
| `fetch_stage`, `pc_mux`, `instruction_memory` | **IF Stage** | Fetches instructions and calculates the next PC / Branch targets |
| `if_id_reg` | **Pipeline Reg** | IF/ID Pipeline Register |
| `instruction_decoder`, `register_file`, `extend`| **ID Stage** | Splits instruction fields, reads registers, and extends immediates |
| `control_unit`, `main_decoder`, `alu_decoder` | **ID Stage** | Generates main control and ALU signals |
| `id_ex_reg` | **Pipeline Reg** | ID/EX Pipeline Register |
| `execute_stage`, `alu`, `branch_unit` | **EX Stage** | Executes arithmetic logic and evaluates branch conditions |
| `forward_muxA`, `forward_muxB` | **EX Stage** | Muxes for the data forwarding network |
| `ex_mem_reg` | **Pipeline Reg** | EX/MEM Pipeline Register |
| `data_memory` | **MEM Stage** | Byte-addressable-ish data memory for loads/stores |
| `mem_wb_reg` | **Pipeline Reg** | MEM/WB Pipeline Register |
| `writeback_mux` | **WB Stage** | Selects ALU result / Memory data / PC+4 for register writeback |
| `hazard_detection_unit` | **Hazards** | Stalls or flushes pipeline to handle load-use/control hazards |
| `forwarding_unit` | **Hazards** | Resolves Read-After-Write (RAW) hazards dynamically |
| `clkdivider`, `bcdconvertor`, `display` | **Peripherals** | Clock division, Binary-to-BCD conversion, and display driver |

---
## Tools Used

* Verilog HDL
* Xilinx Vivado
* Icarus Verilog (iverilog)
* GTKWave
* Basys 3 FPGA Board

---
## Author

**Cherukuri Shyam Sundhar**

Electronics and Communication Engineering

IIT Bhubaneswar
