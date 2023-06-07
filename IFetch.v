`timescale 1ns / 1ps
`include "definitions.v"


module IFetch(Instruction,branch_base_addr,IORead,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,confirm_button,clock,reset,link_addr);
    output [`ISA_WIDTH - 1:0] Instruction;			// the real instruction fetched from this module, 32'h0000_0000 when reset = 1
    output [`ISA_WIDTH - 1:0] branch_base_addr;      // (pc+4) to ALU which is used by branch type instruction
    output [`ISA_WIDTH - 1:0] link_addr;             // (pc+4) to Decoder which is used by jal instruction
    //output reg if_no_op;                                // for if_id_reg (stop id operations)

    input IORead;
    input[`ISA_WIDTH - 1:0]  Addr_result;           // the calculated address from ALU
    input[`ISA_WIDTH - 1:0]  Read_data_1;           // the address of instruction used by jr instruction
    input        Branch;                // while Branch is 1,it means current instruction is beq
    input        nBranch;               // while nBranch is 1,it means current instruction is bnq
    input        Jmp;                   // while Jmp 1, it means current instruction is jump
    input        Jal;                   // while Jal is 1, it means current instruction is jal
    input        Jr;                    // while Jr is 1, it means current instruction is jr
    input        Zero;                  // while Zero is 1, it means the ALUresult is zero
    input        confirm_button;        // confirm input has been finished
    input        clock,reset;           // Clock and reset (Synchronous reset signal, high level is effective, when reset=1, PC value is 0)
    reg[`ISA_WIDTH - 1:0] PC = 32'h0000_0000, Next_PC =  32'h0000_0000;
    wire[`ISA_WIDTH - 1:0] Inst; //Instruction, but not sensitive to reset;

    reg confirm_state = 1'b0;
    assign Instruction = (reset) ? 32'h0000_0000:Inst;
    always @* begin
        if(((Branch == 1) && (Zero == 1)) || ((nBranch == 1) && (Zero == 0))) begin// beq, bne
            Next_PC = Addr_result; // the calculated new value for PC
        end
        else if(Jr == 1)
            Next_PC = Read_data_1; // the value of $31 register
        else  Next_PC = PC + 4; // PC+4
    end
    
    assign link_addr = PC + 4;
    assign branch_base_addr =  PC + 4;
    
    always @(negedge clock) begin
            if(reset == 1) begin
                PC <= 32'h0000_0000;
            end
            else begin
                if((Jmp == 1) || (Jal == 1)) begin
                    PC <= {
                            PC[`ISA_WIDTH - 1:`ADDRESS_WIDTH + 2],
                            Instruction[`ADDRESS_WIDTH - 1:0], 
                            2'b00
                        };
                end
                // else if ((IORead && ~confirm_button) || (IORead && confirm_state) || (PC > 32'h0001_0000))
                //     PC <= PC;
                // else if (IORead && confirm_button && ~confirm_state) begin
                //     PC <= Next_PC;
                //     confirm_state = 1'b1;
                // end
                else if (IORead) begin
                    if (~confirm_button) begin 
                        confirm_state = 1'b0;
                        PC <= PC;
                    end
                    else if(confirm_state) begin
                        confirm_state = 1'b1;
                        PC <= PC;
                    end
                    else begin
                        confirm_state = 1'b1;
                        PC <= Next_PC;
                    end
                end
                else if (PC == 32'h0000_1000) PC<=PC;
                else PC <= Next_PC;
            end
        end

    prgrom instmem(
    .clka(clock),
    .addra({2'b00,PC[31:2]}),
    .douta(Inst)
    );
    
endmodule
