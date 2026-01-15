# Advent of Code 2025 – Hardware-Oriented Solutions (SystemVerilog)

This repository contains my SystemVerilog implementations for Advent of Code 2025 – Day 1 and Day 2, written with a hardware/RTL mindset rather than a traditional software approach.

The focus is on:
- Clear datapath reasoning
- Synthesizable design choices
- Cycle-accurate verification using testbenches

## Instructions
Run using your preferred simulation or synthesis. I used Xilinx Vivado for all synthesis and simulations.

## Day 1 – Secret Entrance 
Problem Summary

A safe dial starts at position 50 and rotates left or right on a circular scale 0–99 based on a sequence of instructions.
The task is to compute a password based on how many times the dial points to 0, under two different counting rules.

My Approach

- Implemented a direct mathematical datapath solution just involving one division.
- Inputs in file parsed in testbench.

Computed:

- Final dial position (modulo 100)
- Zero crossings analytically
- Extra full rotations directly from the distance value
- This results in a low-latency, single-cycle update design, well-suited for hardware.

Files :

- day1_p1.sv and day1_p2.sv – RTL implementation for part 1 and part 2
- day1_tb.sv – Testbench with puzzle input

## Day 2 – Invalid Product IDs 
Problem Summary

Given large ranges of product IDs, identify invalid IDs:

- Part 1: Numbers made of a digit sequence repeated exactly twice
- Part 2: Numbers made of a digit sequence repeated two or more times

The goal is to sum all invalid IDs in the input ranges.

My Approach

- Designed a pipelined RTL solution
- Each stage handles a specific function:

1. Binary → BCD conversion
2. Factorization of digit length
3. Pattern repetition detection
4. Fully streaming and scalable up to 10-digit numbers. The factorization module can be modified to work with more digits as well!

- This design emphasizes throughput, modularity, and timing clarity.

Files

- day2_p1.sv and day2_p2.sv – Top-level pipelined design
- bin_to_bcd.sv – Binary to BCD conversion module
- factorization.sv – Digit-length factorization
- day2_tb.sv – Testbench
