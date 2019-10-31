module PC(PC_in,PC_out,clock);

input clock;
input [31:0] PC_in;
output reg [31:0] PC_out;
//PC Adress initialization
initial
begin
PC_out <= 32'h00000000;
end

always @(posedge clock)
begin
PC_out <= PC_in;
end

endmodule

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

module InstructionMemory(Read_Address,Instruction);

input [31:0] Read_Address;
output [31:0] Instruction; // Both input and output are wires

reg [31:0] Inst_Memory [0:8191];

initial
begin
$readmemh("Inst_Memory.txt",Inst_Memory);
end

assign Instruction = Inst_Memory[Read_Address];

endmodule

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
output reg RegWrite,MemRead,MemWrite,jump;
output reg [1:0] RegDst,MemtoReg,ALUSrc,Branch;
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

5:begin RegDst<=2'bxx;ALUSrc<=0;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=2;ALUOp<=1;jump<=0; // Bne Instruction
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

module AluControlUint(AluControl,JRMuxControl,func,AluOp);
output reg JRMuxControl;
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

module Register_File (Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);

input [4:0] Read1,Read2,WriteReg;
input [31:0] WriteData;
input RegWrite,clock;
output [31:0] Data1,Data2;
reg [31:0] Reg_File[0:31];
integer fd;
// initialization of zero register and stack pointer
initial
begin
Reg_File [0] <= 0;
Reg_File [29] <= 4096;
$readmemh("RegisterFile.txt",Reg_File);
fd = $fopen ("RegisterFile.txt", "w");
end


assign Data1 = Reg_File[Read1];
assign Data2 = Reg_File[Read2];

always @(posedge clock)
begin
if(RegWrite)
begin
Reg_File[WriteReg] <= WriteData;
$fwrite(fd,"%h/n",WriteData,WriteReg);
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
    13 : AluOutput <= (input1<<shamt); // 13 on control pins mean dicards second input and shift left input 1 by the shmat field value
    default: AluOutput <= 0; // incase of error just output zero 
endcase

endmodule

module DataMemory(Data,clk,Address,MemWrite,MemRead,WriteData);

input MemWrite,MemRead,clk;

input [31:0] Address,WriteData;

reg [31:0] locations[0:8191];

output [31:0] Data;

integer fd;

initial
begin
$readmemh("DataMemory.txt",locations);
fd = $fopen ("DataMemory.txt", "w");
end

assign Data = (MemRead) ? locations[Address] : 32'h00000000;

always@(posedge clk)
begin
    if(MemWrite == 1'b1)
    begin
        locations[Address] <= WriteData;
		  $fwrite(fd,"%h/n",WriteData,Address);
    end
end


endmodule 

module MIPS_CPU(output1);

wire [31:0] IR,MemToRegOut,SignEE,ReadData1,ReadData2,Data,UnsignedEE,ALUin2,AluOutput,shiftedSignEE,branch_muxOut,jump_addresss,JumpOut,PC1,PC,JumpRegMUXout,lui;
wire RegWriteOut,RegWrite,CLK,JRMuxControl,ZeroFlag,MemWrite,MemRead,jump,isBranch;
wire [1:0] RegDst,MemtoReg,ALUSrc,Branch; // 2 bits for JAL and 2 bits of alusrc for unsigned exntension
wire [2:0] AluOp;
wire[3:0] AluControl;
wire [4:0] RegDstOut;
output wire output1;

assign output1 = MemRead;
assign PC1 = PC + 4;
assign RegWriteOut = RegWrite & (~JRMuxControl);
assign SignEE = { {16{IR[15]}}, IR[15:0] };
assign UnsignedEE = { 16'b0 , IR[15:0] };		// for andi &  ori & xori operations
assign shiftedSignEE = (SignEE <<2) + PC1;
assign isBranch = ((~Branch[1]) & Branch[0] & ZeroFlag) + (Branch[1] & (~Branch[0]) & (~ZeroFlag)) ; // for beq and bne instructions
assign jump_addresss = { {PC[31:28]}, (IR[27:0]<<2) };
assign lui = { SignEE[15:0] , ReadData2[15:0] };	// for lui operation

PC PCModule(JumpRegMUXout,PC,CLK);

Clock_Generator clock (CLK);

InstructionMemory IM((PC>>2),IR);

control Control_Unit(RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,AluOp,IR[31:26],jump);

AluControlUint ALUcontrolunit1(AluControl,JRMuxControl,IR[5:0],AluOp);

MUX4input2 RegDstMux(IR[20:16], IR[15:11],5'b11111 ,5'b00000, RegDstOut, RegDst);

Register_File RF(IR[25:21],IR[20:16],RegDstOut,MemToRegOut,RegWriteOut,ReadData1,ReadData2,CLK);

MUX4input ALU_SRC (ReadData2,SignEE,UnsignedEE,32'h00000000,ALUin2,ALUSrc);

AluMips ALU(AluOutput,ZeroFlag,ReadData1,ALUin2,AluControl,IR[10:6]);

DataMemory Data_memory(Data,CLK,AluOutput,MemWrite,MemRead,ReadData2);

MUX4input MemtoRegMUX(AluOutput,Data,PC1,lui,MemToRegOut,MemtoReg);

MUX BranchMUX (PC1,shiftedSignEE,branch_muxOut,isBranch);

MUX JumpMUX (branch_muxOut,jump_addresss,JumpOut,jump);

MUX JumpRegMUX(JumpOut,ReadData1,JumpRegMUXout,JRMuxControl);


endmodule


