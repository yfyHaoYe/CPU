//----------------------------ISA Specifications--------------------------------//
`define ISA_WIDTH           32                  // width of a word in the ISA
`define STAGE_CNT           5
`define STAGE_CNT_WIDTH     3                   // stage count width 5 <= 2^3
`define ADDRESS_WIDTH       26                  // address lenth of instructions for j and jal extension
`define SHIFT_AMOUNT_WIDTH  5
`define JAL_REG_IDX         31
`define IMMEDIATE_WIDTH     16
`define REG_FILE_ADDR_WIDTH 5                   // width of register address(idx)
`define OP_CODE_WIDTH       6                   // width of oepration code
`define FUNC_CODE_WIDTH     6                   // width of function code
//------------------------------------------------------------------------------//

//---------------------------------Memory---------------------------------------//
`define RAM_DEPTH           14                  // ram size = 2^RAM_DEPTH words
`define ROM_DEPTH           14                  // rom size = 2^ROM_DEPTH words
`define PC_MAX_VALUE        16_383              // ((1 << (`DEFAULT_ROM_DEPTH + 2)) - 1)

`define MEM_WRITE_BIT       0                   // bit for determining memory write enable
`define MEM_READ_BIT        1                   // bit for determining memory read enable

`define IO_START_BIT        10                  // lowest bit of memory_mapped IO address
`define IO_END_BIT          31                  // highest bit of memory-mapped IO address
`define IO_TYPE_BIT         4                   // bit for determining IO type
//------------------------------------------------------------------------------//

//---------------------------------Control--------------------------------------//
`define OP_CODE_WIDTH       6                   // width of oepration code
`define FUNC_CODE_WIDTH     6                   // width of function code

`define OP_R_FORMAT         6'b00_0000
`define OP_LW               6'b10_0011
`define OP_SW               6'b10_1011
`define FUNC_JR             6'b00_1000
`define OP_JMP              6'b00_0010
`define OP_JAL              6'b00_0011
`define OP_BRANCH           6'b00_0100
`define OP_NBRANCH          6'b00_0101
`define OP_I_FORMAT         3'b001
`define OP_SLL              6'b00_0000
`define OP_SRL              6'b00_0010
`define OP_SLLV             6'b00_0100
`define OP_SRLV             6'b00_0110
`define OP_SRA              6'b00_0011
`define OP_SRAV             6'b00_0111
//------------------------------------------------------------------------------//

//----------------------------------ALU-----------------------------------------//
`define ALU_CONTROL_WIDTH   6                   // width of alu exe code
`define ALU_OP_CODE_WIDTH   2

// ALU opcode: used to determine what operations the ALU will execute
`define EXE_SLL             6'b00_0000
`define EXE_SRL             6'b00_0010
`define EXE_SLLV            6'b00_0100
`define EXE_SRLV            6'b00_0110
`define EXE_SRA             6'b00_0011
`define EXE_SRAV            6'b00_0111
`define EXE_ADD             6'b10_0000
`define EXE_ADDU            6'b10_0001
`define EXE_SUB             6'b10_0010
`define EXE_SUBU            6'b10_0011
`define EXE_AND             6'b10_0100
`define EXE_OR              6'b10_0101
`define EXE_XOR             6'b10_0110
`define EXE_NOR             6'b10_0111
`define EXE_SLT             6'b10_1010
`define EXE_SLTU            6'b10_1011
`define EXE_ADDI            6'b00_1000
`define EXE_ADDIU           6'b00_1001
`define EXE_SLTI            6'b00_1010
`define EXE_SLTIU           6'b00_1011
`define EXE_ANDI            6'b00_1100
`define EXE_ORI             6'b00_1101
`define EXE_XORI            6'b00_1110
`define EXE_LUI             6'b00_1111
`define EXE_NO_OP           6'b11_1111
//new added
`define EXE_MUL             6'b10_1100
`define EXE_MULU            6'b10_1101
`define EXE_DIV             6'b10_1110
`define EXE_DIVU            6'b10_1111
//------------------------------------------------------------------------------//

//--------------------------------Forwarding------------------------------------//
`define FORW_SEL_WIDTH      2                   // width of forwarding select signal
`define FORW_SEL_INPUT      2'b00               // select register input
`define FORW_SEL_ALU_RES    2'b01               // select ALU result
`define FORW_SEL_MEM_RES    2'b10               // select data fetched from memory 
//------------------------------------------------------------------------------//

//----------------------------Condition Check-----------------------------------//
`define COND_TYPE_WIDTH     2                   // width of condition type
`define COND_TYPE_BEQ       2'b10
`define COND_TYPE_BNQ       2'b11
`define NOT_BRANCH          2'b00
//------------------------------------------------------------------------------//

//---------------------------------Clocks---------------------------------------//
`define KEYPAD_DELAY_PERIOD 250_000             // for keypad_unit to scan every 0.25s (0.25s needed to confirm the key)
`define TUBE_DELAY_PERIOD   100_000             // for tube to be refreshed every 1ms
`define UART_DELAY_PERIOD   10                  // for uart_unit (from 100MHz to 10MHz)
`define VGA_DELAY_PERIOD    4                   // for vga_unit (from 100MHz 50 25MHz)
`define CPU_DELAY_PERIOD    1                   // for all cpu components (100MHz)
//------------------------------------------------------------------------------//

//-----------------------------------IO-----------------------------------------//
`define IO_WIDTH            16                  // number of physical switches and leds used

// seven seg tube parameters
`define SEGMENT_CNT         8                   // number of segments (including the dot segment)
`define DIGIT_CNT           8                   // number of digits on the segment display
`define OVERFLOW_CNT        2                   // two excess digits to overflow, total 10 digits
`define DIGIT_CNT_WIDTH     3                   // 8  == 2^3 for digits on the segment display
`define OVERFLOW_CNT_WIDTH  1                   // 10 <= 2^4 and this needs 1 more bit for total number of digits
`define DIGIT_RADIX_WIDTH   4                   // decimal needs at least 4 bits per digit

// mods used to isolate each digit of the tube
`define DIGIT_1_MOD         1_0000_0000
`define DIGIT_2_MOD         1_000_0000
`define DIGIT_3_MOD         1_00_0000
`define DIGIT_4_MOD         1_0_0000
`define DIGIT_5_MOD         1_0000
`define DIGIT_6_MOD         1_000
`define DIGIT_7_MOD         1_00
`define DIGIT_8_MOD         1_0
`define DIGIT_9_MOD         1

// control for tube digit enabling
`define DISABLE_ALL_DIGITS  8'b1111_1111
`define ENABLE_DIGHT_1      8'b0111_1111
`define ENABLE_DIGHT_2      8'b1011_1111
`define ENABLE_DIGHT_3      8'b1101_1111
`define ENABLE_DIGHT_4      8'b1110_1111
`define ENABLE_DIGHT_5      8'b1111_0111
`define ENABLE_DIGHT_6      8'b1111_1011
`define ENABLE_DIGHT_7      8'b1111_1101
`define ENABLE_DIGHT_8      8'b1111_1110

`define VGA_BIT_DEPTH       12                  // VGA color depth

// VGA display parameters
`define DISPLAY_WIDTH       640
`define DISPLAY_HEIGHT      480
`define COORDINATE_WIDTH    10                  // width of coordinate value
`define LEFT_BORDER         48
`define RIGHT_BORDER        16
`define TOP_BORDER          33
`define BOTTOM_BORDER       10
`define HORIZONTAL_GAP      96                  // horizontal gap duration
`define VERTICAL_GAP        2                   // vertical gap duration

// VGA colors
`define BG_COLOR            12'b110111011101    // light gray
`define DIGITS_BOX_BG_COLOR 12'b110011001100    // dark gray

// VGA display asset parameters
`define DIGITS_BOX_WIDTH    492
`define DIGITS_BOX_HEIGHT   40
`define DIGITS_BOX_X        74
`define DIGITS_BOX_Y        215

`define DIGITS_WIDTH        468
`define DIGITS_W_WIDTH      9                   // width of width 468 <= 2^9
`define DIGITS_HEIGHT       16
`define DIGITS_X            86
`define DIGITS_Y            227
`define DIGITS_IDX_WIDTH    6                   // number of digits 39 + 7 <= 2^6

`define DIGIT_WIDTH         12
`define DIGIT_W_WIDTH       4                   // width of width 12 <= 2^4
`define DIGIT_H_WIDTH       4                   // width of height 16 <= 2^4

`define STATUS_WIDTH        88
`define STATUS_W_WIDTH      7                   // width of width 88 <= 2^7
`define STATUS_HEIGHT       22
`define STATUS_H_WIDTH      5                   // width of height 22 <= 2^5
`define STATUS_X            291
`define STATUS_Y            180
//------------------------------------------------------------------------------//