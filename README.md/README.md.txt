# Asynchronous Analog-Compute Edge Accelerator 🚀

A hybrid ASIC architecture designed for ultra-low-power edge AI and Non-Intrusive Load Monitoring (NILM). 

This project completely removes the traditional digital global clock tree and ALU bottleneck. It routes data using a clockless, 4-phase asynchronous Network-on-Chip (NoC) and computes massive matrix multiplications in $O(1)$ time using a behavioral 16x16 analog memristor crossbar.

## 🧠 Architecture Highlights
* **Clockless Routing:** Utilizes Muller C-elements to implement a Bundled-Data protocol. Power is only consumed when electrical transient data is actively moving through the 128-bit pipeline.
* **Physics-Based Math:** The execution core models a dense 16x16 analog crossbar. It executes Neural Network/Harmonic filtering weights instantly using Ohm's Law ($I = V \cdot G$) and Kirchhoff's Current Law.
* **NILM Optimized:** Designed specifically to analyze 16 concurrent harmonic frequency channels to identify high-frequency motor startup signatures (e.g., HVAC compressors) at the edge.

## 📊 Physical Synthesis Results (Xilinx Vivado)
The RTL was synthesized targeting an **Artix-7 (xc7a100t)** FPGA to verify physical silicon constraints for the full 128-bit data highway and 16x16 crossbar. 

| Metric | Utilization | Notes |
| :--- | :--- | :--- |
| **Slice LUTs** | 75 (0.12%) | Incredible area efficiency by bypassing digital ALUs for a 16-channel MAC array. |
| **Flip-Flops** | 0 | Proves 100% asynchronous, clockless storage. |
| **Latches** | 137 | Level-sensitive data capture via Muller C-element triggers for the 128-bit buses. |
| **Global Clocks (BUFG)**| 1 | Used purely as a high-fanout routing net to drive 128 latches simultaneously without skew, not as a ticking frequency clock. |

## 🛠️ How to Simulate (Icarus Verilog)
To run the behavioral simulation and view the 16-channel simultaneous math:
1. Compile the design:
   `iverilog -o master_sim_16.vvp src/muller_c.v src/async_pipeline_stage.v src/analog_crossbar_16x16.v src/signal_gpu_top_16.v sim/tb_signal_gpu_16.v`
2. Run the executable:
   `vvp master_sim_16.vvp`
3. View the timing and $O(1)$ MAC results in GTKWave:
   `gtkwave master_wave_16.vcd`

## 📁 Repository Contents
* `/src`: Verilog RTL for the 128-bit Asynchronous NoC and 16x16 Analog Core.
* `/sim`: Testbenches demonstrating the 4-phase handshake and 16-channel precision math.
* `/docs`: Full PDF portfolio, Vivado Area Reports, and GTKWave timing proofs.

---
*Designed by Nachiket Kumar | Electrical and Electronics Engineering, BCE*