`timescale 1ns / 1ps
`include "definitions.v"


module IFetch(Instruction,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr);
    output[31:0] Instruction;			// the instruction fetched from this module
    output[31:0] branch_base_addr;      // (pc+4) to ALU which is used by branch type instruction
    output[31:0] link_addr;             // (pc+4) to Decoder which is used by jal instruction
    
    input[31:0]  Addr_result;           // the calculated address from ALU
    input[31:0]  Read_data_1;           // the address of instruction used by jr instruction
    input        Branch;                // while Branch is 1,it means current instruction is beq
    input        nBranch;               // while nBranch is 1,it means current instruction is bnq
    input        Jmp;                   // while Jmp 1, it means current instruction is jump
    input        Jal;                   // while Jal is 1, it means current instruction is jal
    input        Jr;                    // while Jr is 1, it means current instruction is jr
    input        Zero;                  // while Zero is 1, it means the ALUresult is zero
    input        clock,reset;           // Clock and reset (Synchronous reset signal, high level is effective, when reset=1, PC value is 0)
    
endmodule
