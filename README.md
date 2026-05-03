# NILM-Edge-Accelerator
### Asynchronous 16x16 Analog-Compute Edge Accelerator for NILM

An ultra-low-power, clockless ASIC architecture designed for **Non-Intrusive Load Monitoring (NILM)**. This accelerator utilizes an asynchronous pipeline and an analog-compute crossbar to perform high-speed harmonic analysis of electrical loads without the power overhead of traditional synchronous GPUs.

## 🚀 Key Features
- **16x16 Analog Crossbar:** Performs parallel matrix-vector multiplication in the analog domain for $O(1)$ complexity.
- **Asynchronous Pipeline:** Uses Muller C-elements and 4-phase handshaking logic to eliminate clock-tree power consumption.
- **ASIC Optimized:** Synthesized to only **75 LUTs** on standard FPGA fabric (Vivado), ensuring a tiny silicon footprint.
- **Clockless Operation:** Data-driven execution prevents race conditions and reduces EMI.

## 📂 Repository Structure
- **/src**: Verilog hardware description files (Asynchronous logic, 16x16 crossbar).
- **/docs**: Synthesis reports (ASIC_Area_Report.txt) and design specifications.
- **/sim**: Testbenches and simulation configurations.

## 🛠️ Performance Metrics
- **Logic Utilization:** 75 LUTs (0 Flip-Flops).
- **Architecture:** Asynchronous Pipeline / Behavior Analog Matrix Multiplier.
- **Primary Application:** Real-time harmonic decomposition for NILM at the edge.

## ⚖️ License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.