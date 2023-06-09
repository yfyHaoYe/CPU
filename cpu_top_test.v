`timescale 1ns / 1ps
`include "definitions.v"

// minisys 32 CPU Top Module

module cpu_top_test(clock,rst_bt,switches,confirm_bt,ledss,ena_r,ena_l,led_r,led_l);
    // Inputs
    input clock;
    input rst_bt;
    input [15:0] switches;
    input confirm_bt;
    // Outputs
    output [15:0] ledss;
    
    output [3:0] ena_r;
    output [3:0] ena_l;
    output [7:0] led_r;
    output [7:0] led_l;

    wire clk1;
    wire clk2;
    // wire clk3;
    wire [15:0] ledsshigh;
    wire rst;
    wire confirm_button;

    //按钮防抖
    button bt1(
        .clk(clk1),
        .bt(rst_bt),
        .pos(rst)
    );
    button bt2(
        .clk(clk1),
        .bt(confirm_bt),
        .pos(confirm_button)
    );

    cpuclk cclk(
        .clk_in1(clock),
        .clk_out1(clk1),
        .clk_out2(clk2)
        // .clk_out3(clk3)
    );

    wire [`ISA_WIDTH - 1 : 0] Instruction; // output IFetch  input Controller, Decoder, ALU,
    wire [`ISA_WIDTH - 1 : 0] ALU_result; // output ALU  input Controller, Decder, MemOrIO
    wire Jr; // output Controller  input IFetch, ALU
    wire Jmp; // output Controller  input IFetch
    wire Jal; // output Controller  input IFetch, Decoder
    wire Branch; // output Controller  input IFetch
    wire nBranch; // output Controller  input IFetch
    wire RegDST; // output Controller  input Decoder
    wire RegWrite; // output Controller  input Decoder
    wire MemWrite; // output Controller  input Data_Mem, MemOrIO
    wire ALUSrc; // output Controller  input ALU
    wire Sftmd; // output Controller  input ALU
    wire I_format; // output Controller  input ALU
    wire [1:0] ALUOp; // output Controller  input ALU
    wire MemorIOtoReg; // output Controller  input Decoder
    wire MemRead; // output Controller  input MemOrIO
    wire IORead; // output Controller  input MemOrIO, IFetch, ioread
    wire IOWrite; // output Controller  input MemOrIO


    wire [`ISA_WIDTH - 1 : 0] MemReadData; // output Data_mem  input MemOrIO
    wire [`ISA_WIDTH - 1 : 0] RegWriteData; // output MemOrIO  input Decoder
    wire [`ISA_WIDTH - 1 : 0] LinkAddr; // output IFetch  input Decoder
    
    wire [`ISA_WIDTH - 1 : 0] RegReadData1; // output Decoder  input IFetch, ALU
    wire [`ISA_WIDTH - 1 : 0] RegReadData2; // output Decoder  input MemOrIO, ALU
    wire [`ISA_WIDTH - 1 : 0] Sign_extend; // output Decoder  input ALU

    wire [`ISA_WIDTH - 1:0] MemWriteAddr; // output MemOrIO  input Data_mem
    wire [`ISA_WIDTH - 1:0] MemWriteData; // output MemOrIO  input Data_mem, leds
    wire [`IO_WIDTH - 1:0] io_rdata; // output MemOrIO  input ioread
    wire LEDCtrl; // output MemOrIO  input leds
    wire SwitchCtrl; // output MemOrIO  input ioread

    wire ledaddr;
    wire ledcs;

    wire Zero; //output ALU  input IFetch
    
    wire [31:0] BranchBaseAddr; // output IFetch  input ALU
    wire [31:0] Addr_result; // output ALU  input IFetch
    
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

    Decoder de(
        .clock(clk1),
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


    MemOrIO moi(
        .mRead(MemRead), 
        .mWrite(MemWrite), 
        .ioRead(IORead), 
        .ioWrite(IOWrite),
        .addr_in(ALU_result), 
        .addr_out(MemWriteAddr), 
        .m_rdata(MemReadData), 
        .io_rdata(io_rdata), 
        .r_wdata(RegWriteData),
        .r_rdata(RegReadData2), 
        .write_data(MemWriteData), 
        .LEDCtrl(LEDCtrl), 
        .SwitchCtrl(SwitchCtrl)
    );


    Data_mem dm(
        .clock(clk1),
        .memWrite(MemWrite),
        .address(MemWriteAddr),
        .writeData(MemWriteData),
        .readData(MemReadData)
        );

    IFetch ife(
        .clock(clk1),
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

    ALU alu(
        .Read_data_1(RegReadData1),
        .Read_data_2(RegReadData2),
        .Sign_extend(Sign_extend),
        .Exe_opcode(Instruction[31:26]),
        .Function_opcode(Instruction[5:0]),
        .Shamt(Instruction[10:6]),
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


    ioread ir(
        .reset(rst),				// reset, active high
	    .ior(IORead),				// from Controller, 1 means read from input device
        .switchctrl(SwitchCtrl),			// means the switch is selected as input device 
        .ioread_data_switch(switches),	// the data from switch
        .ioread_data(io_rdata)      	// the data to memorio 
    );

    leds le(
        .ledrst(rst),
        .led_clk(clk1),	
        .ledwrite(LEDCtrl),	// led write enable, active high 
        .ledcs(1'b1),		// 1 means the leds are selected as output 
        .ledaddr(2'b00),	// 2'b00 means updata the low 16bits of ledout
        .ledwdata(MemWriteData),	// the data (from register/memorio)  waiting for to be writen to the leds of the board
        .ledout({ledsshigh,ledss})
    );



    scan4 sc_r(
        .clk(clk1),
        .rst(rst_bt),
        .LEDCtrl(LEDCtrl),
        .ledwdata(ledss),
        .ena(ena_r),
        .light(led_r)
    );

    scan4 sc_l(
        .clk(clk1),
        .rst(rst_bt),
        .LEDCtrl(LEDCtrl),
        .ledwdata(ledsshigh),
        .ena(ena_l),
        .light(led_l)
    );

endmodule
