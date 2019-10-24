`timescale 1 ns / 1ps
module Clock_Generator(clock);
output reg clock;

initial
begin
clock=0;
end

always
begin
#31 clock=~clock;
end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:47:06 10/19/2019 
// Design Name: 
// Module Name:    InstructionMemory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module InstructionMemory(Read_Address,Instruction);

input [31:0] Read_Address;
output [31:0] Instruction; // Both input and output are wires

reg [31:0] Inst_Memory [0:8191];

//initialization of instruction memory
//there must be a file named IM.txt at "{project directory}/work"
//replace [project directory] with the actual directory of the project
/*
initial
begin
$readmemh("[project directory]/IM.txt",Inst_Memory);
end */

assign Instruction = Inst_Memory[Read_Address[12:0]];

endmodule

module MUX4input2(A,B,C,D,OUT,SEL);

input [4:0] A,B,C,D;
input [1:0] SEL;
output reg [4:0] OUT;
always @ (A,B,C,D,SEL)

case(SEL)
0:OUT <= A;
1:OUT <= B;
2:OUT <= C;
3:OUT <= D;
endcase

endmodule

module MUX4input(A,B,C,D,OUT,SEL);

input [31:0] A,B,C,D;
input [1:0] SEL;
output reg [31:0] OUT;
always @ (A,B,C,D,SEL)

case(SEL)
0:OUT <= A;
1:OUT <= B;
2:OUT <= C;
3:OUT <= D;
endcase

endmodule

module MUX (A,B,OUT,SEL);

input [31:0] A,B;
input SEL;
output reg [31:0] OUT;
always @ (A,B,SEL)

case(SEL)
0:OUT <= A;
1:OUT <= B;
endcase

endmodule

module Register_File (Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);

input [4:0] Read1,Read2,WriteReg;
input [31:0] WriteData;
input RegWrite,clock;
output [31:0] Data1,Data2;
reg [31:0] Reg_File[0:31];

// initialization of zero register and stack pointer
initial
begin
Reg_File [0] <= 0;
Reg_File [29] <= 4096;
end

assign Data1 = Reg_File[Read1];
assign Data2 = Reg_File[Read2];

always @(posedge clock)
begin
if(RegWrite)
Reg_File[WriteReg] <= WriteData;
end

endmodule


//inputs:
// 1 - func: 6 bits represents the operation to be done in case of an R-format type register
// 2 - AluOp : 3 bits comming from the control unit to dertermine which instruction type and operation
// outputs:
// 1 - AluControl : 4 pins going to the Alu to dertermine operation
// 2 - JRMuxControl : one bit to control the mux of the JR address or the other muxes addresses

// function: take the AluOp and func and dertermine what to send to Alu unit on the control pins and JRMuxControl 


module AluControlUint(AluControl,JRMuxControl,func,AluOp);
output  reg JRMuxControl;
input [5:0] func; 
input [2:0] AluOp;
output reg [3:0] AluControl;

// always block that loops everytime func or AluOp change 
always@(func,AluOp)
begin
    // incase R-format look at the func field and determine operation 
    if((func == 8)&&(AluOp ==2))
	 begin
	 JRMuxControl <=1;
	 end
	 else
	 begin
	 JRMuxControl <=0;
    end

    if (AluOp == 2)
    begin
    case (func)
        32 : AluControl <= 2;  // 32 means send to the alu value 2 (add operation) add instruction
        34 : AluControl <= 6;  // 34 means send to the alu value 6 (subtract operation) sub instruction
	36 : AluControl <= 0;  // 36 for and instruction
        37 : AluControl <= 1;  // 37 means send to the alu value 1 (or operation) or instruction
	38 : AluControl <= 3;  // 38 for xor instruction
        42 : AluControl <= 7;  // 42 means send to the alu value 7 (compare operation) slt instruction
        39 : AluControl <= 12; // 39 means send to the alu value 12 (nor operation) nor instruction
	0  : AluControl <= 13; // 0 for sll instruction
	2  : AluControl <= 8;  // 2 for srl instruction
	3  : AluControl <= 9;  // 3 for sra instruction 
        default:AluControl <=0; // just in case make and error value
    endcase  
    end

    // incase Lw or Sw or addi
    else if (AluOp == 0)
    begin
    AluControl <= 2; // send to the alu value 2 (add operation) lw or sw
    end

    // incase beq instruction use the Alu to subtract the two values 
    else if (AluOp == 1) 
    begin 
    AluControl <= 6; // send to the alu value 6 (subtract operation) beq $ bne
    end

    // incase ori instruction use the Alu to or operation 
    else if (AluOp == 3)
    begin
    AluControl <= 1; // send to the alu value 1 (or operation) ori 
    end

    // incase andi instruction use the Alu to and operation 
    else if (AluOp == 4)
    begin
    AluControl <= 0; // send to the alu value 0 (and operation) andi 
    end

    // incase xori instruction use the Alu to and operation 
    else if (AluOp == 5)
    begin
    AluControl <= 3; // send to the alu value 3 (xor operation) xori 
    end

    // in case of slti operation
    else if (AluOp == 6)
    begin
    AluControl <= 7; // send to the alu value 7 (compare operation) slti 
    end

    // in case of error
    else
    begin
    AluControl <= 0;
    end
end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:55 10/17/2019 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


/* inputs:
 1 - input1 : the first input comming from register file
 2 - input2 : the second input comming from the mux
 3 - AluControl : 4 pins that determine which operation to be done
 4 - shamt incase the SLL instruction the amount of shift left 
 outputs :
 1- AluOutput : the result of calculations from the ALu 
 2 - ZeroFlag : it is set to one if the result is zero 
 function: takes two inputs and procceses them based on the control pins and produce the output*/

module AluMips(AluOutput,ZeroFlag,input1,input2,AluControl,shamt);

input [4:0] shamt; // shamt field 5 pins 
input [31:0] input1,input2; // inputs to the alu 31 pins each
input [3:0] AluControl; // the control pins 4 pins
output reg  [31:0] AluOutput; // the result of calculations 
output ZeroFlag; // 1 pit indicate if zero happend

assign ZeroFlag = (AluOutput == 0); // use assing statement to set the value of zero flag 

// always block to keep looping each time input1 or input2 or control pins change
always@(input1,input2,AluControl,shamt)
case (AluControl) // case condition to check values
    0 : AluOutput <= input1 & input2; // 0 on control pins mean do and operation
    1 : AluOutput <= input1 | input2; // 1 on control pins mean do OR operation 
    2 : AluOutput <= input1 + input2; // 2 on control pins mean add the two inputs
    3 : AluOutput <= input1 ^ input2; // 3 for xor operation
    6 : AluOutput <= input1 - input2; // 6 on control pins mean subtract the two inputs
    7 : AluOutput <= (input1 < input2) ? 1:0; // 7 on control pins mean do comapre operation if input1 < input2 then the output is one else zero
    8 : AluOutput <= (input2>>shamt);	// 8 for srl instruction
    9 : AluOutput <= (input2>>>shamt);	// 9 for sra instruction
    12 : AluOutput <= ~(input1 | input2); // 12 on control pins mean do nor operation
    13 : AluOutput <= (input2<<shamt); // 13 on control pins mean dicards second input and shift left input 1 by the shmat field value
    default: AluOutput <= 0; // incase of error just output zero 
endcase

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:21:32 10/19/2019 
// Design Name: 
// Module Name:    DataMemory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DataMemory(Data,clk,Address,MemWrite,MemRead,WriteData);

input MemWrite,MemRead,clk;

input [31:0] Address,WriteData;

reg [31:0] locations[0:8191];

output [31:0] Data;

always@(posedge clk)
begin
    if(MemWrite == 1'b1)
    begin
        locations[Address] <= WriteData; 
    end
end

assign Data = (MemRead == 1'b1) ? locations[Address] : 0;

endmodule


`timescale 1ns / 1ps
module control(RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Instruction,jump);
/* inputs Instruction : 6 bits opcode to determine the type of the operation
	
	outputs 
	
	RegDst:determines the register to be written to
	ALUSrc:determines the second input to the alu "immediate feild or register 2 data"
	MemtoReg:determines the data to be written to a register
	RegWrite:allows to write to a register
	MemRead:allows to read from a memory address
	MemWrite:allows to write in a memory address
	Branch:used in branch condition
	ALUOp:send data to alu control unit
	jump:used in jump condition
*/
input [5:0] Instruction;
output reg RegWrite,MemRead,MemWrite,Branch,jump;
output reg [1:0] RegDst,MemtoReg,ALUSrc;
output reg [2:0] ALUOp;

always @*

casex(Instruction)
0:begin RegDst<=1;ALUSrc<=0;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2;jump<=0; // R-type Instructions
end

35:begin RegDst<=0;ALUSrc<=1;MemtoReg<=1;RegWrite<=1;MemRead<=1;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0; 	// load-word Instruction
end

43:begin RegDst<=2'bxx;ALUSrc<=1;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=1;Branch<=0;ALUOp<=0;jump<=0; // store-word Instruction
end

4:begin RegDst<=2'bxx;ALUSrc<=0;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=1;ALUOp<=1;jump<=0; // Beq Instruction
end

5:begin RegDst<=2'bxx;ALUSrc<=0;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=1;ALUOp<=1;jump<=0; // Bne Instruction
end

8:begin RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0; // add-imediate Instruction
end

10:begin RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=6;jump<=0; // slt-imediate Instruction
end

12:begin RegDst<=0;ALUSrc<=2;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=4;jump<=0; // and-imediate Instruction
end

13:begin RegDst<=0;ALUSrc<=2;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3;jump<=0; // or-imediate Instruction
end

14:begin RegDst<=0;ALUSrc<=2;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=5;jump<=0; // xor-imediate Instruction
end

15:begin RegDst<=0;ALUSrc<=1'bx;MemtoReg<=3;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3'bxxx;jump<=0; // lui Instruction
end

2:begin RegDst<=2'bxx;ALUSrc<=1'bx;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3'bxxx;jump<=1; // jump Instruction
end

3:begin RegDst<=2;ALUSrc<=1'bx;MemtoReg<=2;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3'bxxx;jump<=1; // jump and link instruction
end

default:begin RegDst<=0;ALUSrc<=1'bx;MemtoReg<=0;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0;
end

endcase
endmodule


`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:39 10/19/2019 
// Design Name: 
// Module Name:    MIPS_CPU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MIPS_CPU();

reg [31:0] PC;
wire [31:0] IR,MemToRegOut,ReadData1,ReadData2,SignEE, UnsignedEE,ALUin2,AluOutput,Data,shiftedSignEE,branch_muxOut,jump_addresss,JumpOut, PCinput, PCout, lui;
wire RegWriteOut,RegWrite,CLK,JRMuxControl,ZeroFlag,MemWrite,MemRead,Branch,jump,isBranch;
wire [1:0] RegDst,MemtoReg,ALUSrc; // 2 bits for JAL and 2 bits of alusrc for unsigned exntension
wire [2:0] AluOp;
wire[3:0] AluControl;
wire [4:0] RegDstOut;

//PC Adress initialization
initial
begin
PC <= 0;
end

//PC module
always @ (posedge CLK)
begin
PC <= PCout;
end

assign PCinput = PC + 4;
assign RegWriteOut = RegWrite & (~JRMuxControl);
assign SignEE = { {16{IR[15]}}, IR[15:0] };
assign UnsignedEE = { 16'b0 , IR[15:0] };		// for andi &  ori & xori operations
assign shiftedSignEE = (SignEE <<2) + PCinput;
assign isBranch = (IR[28:26]==5) ? (Branch & ~ZeroFlag):(Branch & ZeroFlag) ;
assign jump_addresss = { {PC[31:28]}, (IR[27:0]<<2) };
assign lui = { SignEE[15:0] , ReadData2[15:0] };	// for lui operation


Clock_Generator clock (CLK);

InstructionMemory IM(PC>>2,IR);

control Control_Unit(RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,AluOp,IR[31:26],jump);

AluControlUint ALUcontrolunit1(AluControl,JRMuxControl,IR[5:0],AluOp);

MUX4input2 RegDstMux(IR[20:16], IR[15:11], 5'b11111, 5'b0, RegDstOut, RegDst);
Register_File RF(IR[25:21],IR[20:16],RegDstOut,MemToRegOut,RegWriteOut,ReadData1,ReadData2,CLK);

MUX4input ALU_SRC (ReadData2,SignEE,UnsignedEE,32'b0,ALUin2,ALUSrc);

AluMips ALU(AluOutput,ZeroFlag,ReadData1,ALUin2,AluControl,IR[10:6]);

DataMemory Data_memory(Data,CLK,AluOutput,MemWrite,MemRead,ReadData2);

MUX4input MemtoRegMUX(AluOutput,Data,PCinput,lui,MemToRegOut,MemtoReg);

MUX BranchMUX (PCinput,shiftedSignEE,branch_muxOut,isBranch);

MUX JumpMUX (branch_muxOut,jump_addresss,JumpOut,jump);

MUX JumpRegMUX(JumpOut,ReadData1,PCout,JRMuxControl);


endmodule
