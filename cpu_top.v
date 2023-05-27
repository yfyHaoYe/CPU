`timescale 1ns / 1ps
`include "definitions.v"

// minisys 32 CPU Top Module

module cpu_top(
    // Inputs
    input clock,
    input rst,
    input ledcs,
    input [15:0] switches,
    // Outputs
    output [15:0] ledss
    );

    wire clk;

    cpuclk cclk(
        .clk_in1(clock),
        .clk_out1(clk)
    );

// Controller
    //Input
    wire [`ISA_WIDTH - 1 : 0] Instruction;
    //Output
    wire Jr = 1'b0;
    wire Jmp = 1'b0;
    wire Jal = 1'b0;
    wire Branch = 1'b0;
    wire nBranch = 1'b0;
    wire RegDST = 1'b0;
    wire MemtoReg = 1'b0;
    wire RegWrite = 1'b0;
    wire MemWrite = 1'b0;
    wire ALUSrc = 1'b0;
    wire Sftmd = 1'b0;
    wire I_format = 1'b0;
    wire [1:0] ALUOp = 1'b0;
    wire MemRead = 1'b0;
    wire IORead = 1'b0;
    wire IOWrite = 1'b0;


    Controller ctrl(
        .Opcode(Instruction[31:26]),
        .Function_opcode(Instruction[5:0]),
        .Jr(Jr),
        .Jmp(Jmp),
        .Jal(Jal),
        .Branch(Branch),
        .nBranch(nBranch),
        .RegDST(RegDST),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .Sftmd(Sftmd),
        .I_format(I_format),
        .ALUOp(ALUOp),
        .Alu_resultHigh(ALU_result[21:0]), 
        .MemorIOtoReg(), 
        .MemRead(MemRead), 
        .IORead(IORead), 
        .IOWrite(IOWrite)
        );
    
// Decoder
    //Input
    wire [`ISA_WIDTH - 1 : 0] ALU_result;
    wire [`ISA_WIDTH - 1 : 0] m_rdata;
    wire [`ISA_WIDTH - 1 : 0] m_wdata;
    wire [`ISA_WIDTH - 1 : 0] r_wdata;
    wire [`ISA_WIDTH - 1 : 0] link_addr;
    //Output
    wire [`ISA_WIDTH - 1 : 0] Decoder_Data1;
    wire [`ISA_WIDTH - 1 : 0] Decoder_Data2;
    wire [`ISA_WIDTH - 1 : 0] Sign_extend;

    Decoder de(
        .clock(clk),
        .reset(rst),
        .Instruction(Instruction),
        .opcplus4(link_addr),
        .ALU_result(ALU_result),
        .r_wdata(r_wdata),
        .RegWrite(RegWrite),
        .Jal(Jal),
        .MemtoReg(MemtoReg),
        .RegDst(RegDST),
        .read_data_1(Decoder_Data1),
        .read_data_2(Decoder_Data2),
        .Sign_extend(Sign_extend)
        );



//MemOrIO
    //Input
    //Output
    wire [`ISA_WIDTH - 1:0] Address;
    wire [31:0] write_data;
    wire LEDCtrl;
    wire SwitchCtrl;

    MemOrIO moi( 
        .mRead(MemRead), 
        .mWrite(MemWrite), 
        .ioRead(IORead), 
        .ioWrite(IOWrite),
        .addr_in(ALU_result), 
        .addr_out(Address), 
        .m_rdata(m_rdata), 
        .io_rdata(switches), 
        .r_wdata(r_wdata), 
        .r_rdata(Decoder_Data2), 
        .write_data(write_data), 
        .LEDCtrl(LEDCtrl), 
        .SwitchCtrl(SwitchCtrl)
    );


    ioRead ir(
        .reset(rst),				// reset, active high
	    .ior(IORead),				// from Controller, 1 means read from input device
        .switchctrl(SwitchCtrl),			// means the switch is selected as input device 
        .ioread_data_switch(switches),	// the data from switch
        .ioread_data(io_rdata)      	// the data to memorio 
    );


    wire ledaddr;
    wire [23:0] ledout;

    leds le(
        .ledrst(rst),		// reset, active high 
        .led_clk(clk),	// clk for led 
        .ledwrite(ioWrite),	// led write enable, active high 
        .ledcs(ledcs),		// 1 means the leds are selected as output 
        .ledaddr({ledaddr,1'b0}),	// 2'b00 means updata the low 16bits of ledout, 2'b10 means updata the high 8 bits of ledout
        .ledwdata(io_wdata),	// the data (from register/memorio)  waiting for to be writen to the leds of the board
        .ledout(ledout)
    );


//Data_mem
    //Input
    //Output

    Data_mem dm(
        .clock(clk),
        .memWrite(MemWrite),
        .address(Address),
        .writeData(m_wdata),
        .readData(m_rdata)
        );

//IFetch
    //Input
    wire Zero;
    //Output
    wire branch_base_addr;

    IFetch ife(
        .clock(clk),
        .reset(rst),
        .Addr_result(Addr_result),
        .Zero(Zero),
        .Read_data_1(Decoder_Data1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Instruction(Instruction),
        .branch_base_addr(branch_base_addr),
        .link_addr(link_addr)
        );

//ALU
    //Input
    //Output

    ALU alu(
        .Read_data_1(Decoder_Data1),
        .Read_data_2(Decoder_Data2),
        .Sign_extend(Sign_extend),
        .Exe_opcode(Exe_opcode),
        .Function_opcode(Function_opcode),
        .Shamt(Shamt),
        .PC_plus_4(branch_base_addr),
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
