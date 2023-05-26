`timescale 1ns / 1ps
`include "definitions.v"

module ALU(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
                 Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4
                 );
    input[31:0]  Read_data_1;		// 从译码单元的Read_data_1中来
    input[31:0]  Read_data_2;		// 从译码单元的Read_data_2中来
    input[31:0]  Sign_extend;		// 从译码单元来的扩展后的立即数
    input[5:0]   Function_opcode;  	// 取指单元来的r-类型指令功能码,r-form instructions[5:0]
    input[5:0]   Exe_opcode;  		// 取指单元来的操作码
    input[1:0]   ALUOp;             // 来自控制单元的运算指令控制编码
    input[4:0]   Shamt;             // 来自取指单元的instruction[10:6]，指定移位次数
    input  		 Sftmd;            // 来自控制单元的，表明是移位指令
    input        ALUSrc;            // 来自控制单元，表明第二个操作数是立即数（beq，bne除外）
    input        I_format;          // 来自控制单元，表明是除beq, bne, LW, SW之外的I-类型指令
    input        Jr;               // 来自控制单元，表明是JR指令
    output       Zero;              // 为1表明计算值为0 
    output reg [31:0] ALU_Result;        // 计算的数据结果
    output[31:0] Addr_Result;		// 计算的地址结果        
    input[31:0]  PC_plus_4;         // 来自取指单元的PC+4

    wire [31:0] Ainput;
    wire [31:0] Binput;
    wire [5:0] Exe_code;
    wire [2:0] ALU_ctl;

    wire[2:0] Sftm;
    reg [31:0] Shift_Result;
    reg [31:0] ALU_output_mux;
    wire[32:0] Branch_Addr;

    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend;
    assign Exe_code = (I_format==0) ? Function_opcode :{ 3'b000 , Exe_opcode[2:0] };
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    assign Zero = (ALU_Result == 0) ? 1 : 0;
    always @(ALU_ctl or Ainput or Binput)
    begin 
        case(ALU_ctl)
        3'b000: ALU_Result = Ainput & Binput;
        3'b001: ALU_Result = Ainput | Binput;
        3'b010: ALU_Result = ALUOp[1] ? $signed(Ainput) + $signed(Binput) : ;
        3'b011: ALU_Result = Ainput + Binput;
        3'b100: ALU_Result = Ainput ^ Binput;
        3'b101: ALU_Result = I_format ? Binput << 16 : ~(Ainput | Binput);
        3'b110: ALU_Result = ALUOp[0] ? PC_plus_4 + Binput : $signed(Ainput) - $signed(Binput);
        3'b111: ALU_Result = Exe_code[0] ? Ainput - Binput : $signed(Ainput) - $signed(Binput);
        default : ALU_Result = 0;
        endcase
    end

    assign Sftm = Function_opcode[2:0];
    always @(*) begin
        if(Sftmd == 1) begin
            case(Sftm)
            3'b000: Shift_Result = Binput << Shamt;
            3'b010: Shift_Result = Binput >> Shamt;
            3'b011: Shift_Result = Binput >>> Shamt;
            3'b100: Shift_Result = Binput << Shamt;
            3'b110: Shift_Result = Binput >> Shamt;
            3'b111: Shift_Result = Binput >>> Shamt;
            default : Shift_Result = 0;
            endcase
        end
        else begin
            Shift_Result = Binput;
        end
    end

endmodule
