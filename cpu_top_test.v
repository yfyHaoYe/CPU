`timescale 1ns / 1ps
`include "definitions.v"

// minisys 32 CPU Top Module

module cpu_top_test(clock,rst,switches,confirm_button,ledss);
    // Inputs
    input clock;
    input rst;
    input [15:0] switches;
    input confirm_button;
    // Outputs
    output [15:0] ledss;

    wire clk;

    cpuclk cclk(
        .clk_in1(clock),
        .clk_out1(clk)
    );

// Controller
    //Input
    wire [`ISA_WIDTH - 1 : 0] Instruction;
    //Output
    wire Jr;
    wire Jmp;
    wire Jal;
    wire Branch;
    wire nBranch;
    wire RegDST;
    wire RegWrite;
    wire MemWrite;
    wire ALUSrc;
    wire Sftmd;
    wire I_format;
    wire [1:0] ALUOp;
    wire MemorIOtoReg;
    wire MemRead;
    wire IORead;
    wire IOWrite;


    Controller ctrl(
        .Opcode(Instruction[31:26]),
        .Function_opcode(Instruction[5:0]),
        .Jr(Jr),
        .Jmp(Jmp),
        .Jal(Jal),
        .Branch(Branch),
        .nBranch(nBranch),
        .RegDST(RegDST),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .Sftmd(Sftmd),
        .I_format(I_format),
        .ALUOp(ALUOp),
        .Alu_resultHigh(ALU_result[31:10]), 
        .MemorIOtoReg(MemorIOtoReg), 
        .MemRead(MemRead), 
        .IORead(IORead), 
        .IOWrite(IOWrite)
        );
    
// Decoder
    //Input
    wire [`ISA_WIDTH - 1 : 0] ALU_result;
    wire [`ISA_WIDTH - 1 : 0] MemReadData;
    wire [`ISA_WIDTH - 1 : 0] RegWriteData;
    wire [`ISA_WIDTH - 1 : 0] LinkAddr;
    //Output
    wire [`ISA_WIDTH - 1 : 0] RegReadData1;
    wire [`ISA_WIDTH - 1 : 0] RegReadData2;
    wire [`ISA_WIDTH - 1 : 0] Sign_extend;

    Decoder de(
        .clock(clk),
        .reset(rst),
        .Instruction(Instruction),
        .opcplus4(LinkAddr),
        .ALU_result(ALU_result),
        .r_wdata(RegWriteData),
        .RegWrite(RegWrite),
        .Jal(Jal),
        .MemtoReg(MemorIOtoReg),
        .RegDst(RegDST),
        .read_data_1(RegReadData1),
        .read_data_2(RegReadData2),
        .Sign_extend(Sign_extend)
        );



//MemOrIO
    //Input
    //Output
    wire [`ISA_WIDTH - 1:0] MemWriteAddr;
    wire [`ISA_WIDTH - 1:0] MemWriteData;
    wire LEDCtrl;
    wire SwitchCtrl;

    MemOrIO moi(
        .mRead(MemRead), 
        .mWrite(MemWrite), 
        .ioRead(IORead), 
        .ioWrite(IOWrite),
        .addr_in(ALU_result), 
        .addr_out(MemWriteAddr), 
        .m_rdata(MemReadData), 
        .io_rdata(switches), 
        .r_wdata(RegWriteData),
        .r_rdata(RegReadData2), 
        .write_data(MemWriteData), 
        .LEDCtrl(LEDCtrl), 
        .SwitchCtrl(SwitchCtrl)
    );


    ioread ir(
        .reset(rst),				// reset, active high
	    .ior(IORead),				// from Controller, 1 means read from input device
        .switchctrl(SwitchCtrl),			// means the switch is selected as input device 
        .ioread_data_switch(switches),	// the data from switch
        .ioread_data(io_rdata)      	// the data to memorio 
    );


    wire ledaddr;
    wire ledcs;

    leds le(
        .ledrst(rst),		// reset, active high 
        .led_clk(clk),	// clk for led 
        .ledwrite(LEDCtrl),	// led write enable, active high 
        .ledcs(1'b1),		// 1 means the leds are selected as output 
        .ledaddr(2'b00),	// 2'b00 means updata the low 16bits of ledout
        .ledwdata(MemWriteData),	// the data (from register/memorio)  waiting for to be writen to the leds of the board
        .ledout(ledss)
    );


//Data_mem
    //Input
    //Output

    Data_mem dm(
        .clock(clk),
        .memWrite(MemWrite),
        .address(MemWriteAddr),
        .writeData(MemWriteData),
        .readData(MemReadData)
        );


//IFetch
    //Input
    wire Zero;
    //Output
    wire [31:0] BranchBaseAddr;
    wire [31:0] Addr_result;

    IFetch ife(
        .clock(clk),
        .reset(rst),
        .IORead(IORead),
        .Addr_result(Addr_result),
        .Zero(Zero),
        .Read_data_1(RegReadData1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .confirm_button(confirm_button),
        .Instruction(Instruction),
        .branch_base_addr(BranchBaseAddr),
        .link_addr(LinkAddr)
        );

//ALU
    //Input
    //Output

    ALU alu(
        .Read_data_1(RegReadData1),
        .Read_data_2(RegReadData2),
        .Sign_extend(Sign_extend),
        .Exe_opcode(Instruction[31:26]),
        .Function_opcode(Function_opcode),
        .Shamt(Shamt),
        .PC_plus_4(BranchBaseAddr),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .I_format(I_format),
        .Sftmd(Sftmd),
        .Jr(Jr),
        .ALU_result(ALU_result),
        .Zero(Zero),
        .Addr_result(Addr_result)
        );



endmodule
