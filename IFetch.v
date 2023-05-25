`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 20:08:47
// Design Name: 
// Module Name: IFetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IFetch(Instruction,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr);
    output[`ISA_WIDTH - 1:0] Instruction;			// the instruction fetched from this module
    output[`ISA_WIDTH - 1:0] branch_base_addr;      // (pc+4) to ALU which is used by branch type instruction
    output[`ISA_WIDTH - 1:0] link_addr;             // (pc+4) to Decoder which is used by jal instruction
    //output reg if_no_op;                                // for if_id_reg (stop id operations)

    input[`ISA_WIDTH - 1:0]  Addr_result;           // the calculated address from ALU
    input[`ISA_WIDTH - 1:0]  Read_data_1;           // the address of instruction used by jr instruction
    input        Branch;                // while Branch is 1,it means current instruction is beq
    input        nBranch;               // while nBranch is 1,it means current instruction is bnq
    input        Jmp;                   // while Jmp 1, it means current instruction is jump
    input        Jal;                   // while Jal is 1, it means current instruction is jal
    input        Jr;                    // while Jr is 1, it means current instruction is jr
    input        Zero;                  // while Zero is 1, it means the ALUresult is zero
    input        clock,reset;           // Clock and reset (Synchronous reset signal, high level is effective, when reset=1, PC value is 0)
    reg[`ISA_WIDTH - 1:0] PC, Next_PC;

    always @* begin
        if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = PC + 4 + branch_base_addr; // the calculated new value for PC
        else if(Jr == 1)
            Next_PC = Read_data_1; // the value of $31 register
        else Next_PC = PC + 4; // PC+4
    end
    always @(posedge clock) begin
        if(reset == 1)
            PC <= 32'h0000_0000;
        else begin
            if((Jmp == 1) || (Jal == 1)) begin
                PC <= {
                        PC[`ISA_WIDTH - 1:`ADDRESS_WIDTH + 2],
                        Instruction[`ADDRESS_WIDTH - 1:0], 
                        2'b00
                    };
                
            end
            else PC <= Next_PC;
        end
    end

    prgrom instmem(
    .clka(clock),
    .addra(PC[15:2]),
    .douta(Instruction)
    );
endmodule
