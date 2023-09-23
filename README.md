# mips-pipelined-cpu
This GitHub repository contains an implementation of a MIPS pipelined CPU using the Verilog hardware description language. 
The CPU design follows the classic MIPS architecture and leverages pipelining techniques to achieve improved performance by allowing multiple instructions to be executed simultaneously.

Features:
1. MIPS Architecture: The CPU is designed based on the widely used MIPS architecture. It supports a subset of MIPS instructions, including arithmetic, logical, memory access, and control flow instructions.

2. Pipelining: The CPU incorporates a pipelining technique to enhance performance by dividing the instruction execution process into multiple stages. Pipelining allows simultaneous execution of multiple instructions, resulting in improved throughput and reduced latency.

3. Five-Stage Pipeline: The CPU pipeline is divided into five stages: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). Each stage performs a specific operation on the instruction being processed, enabling efficient instruction execution.

4. Hazard Detection and Resolution: The CPU handles various hazards that can occur in a pipelined architecture, such as data hazards, control hazards, and structural hazards. Hazard detection and resolution techniques, such as forwarding, stalling, and branch prediction, are implemented to ensure correct and efficient execution of instructions.
