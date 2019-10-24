`timescale 1 ns / 1ps
module Clock_Generator(clock);
output reg clock;

initial
begin
clock=0;
end

always @*
begin
#31 clock <= ~clock;
end

endmodule


//inputs:
// 1 - func: 6 bits represents the operation to be done in case of an R-format type register
// 2 - AluOp : 3 bits comming from the control unit to dertermine which instruction type and operation
// outputs:
// 1 - AluControl : 4 pins going to the Alu to dertermine operation
// 2 - JRMuxControl : one bit to control the mux of the JR address or the other muxes addresses

// function: take the AluOp and func and dertermine what to send to Alu unit on the control pins and JRMuxControl 


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:24:27 10/22/2019 
// Design Name: 
// Module Name:    PC 
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
module PC(PC_in,PC_out,clock);

input clock;
input [31:0] PC_in;
output reg [31:0] PC_out;

always @(posedge clock)
begin
PC_out = PC_in;
end

initial
begin
    PC_out <=0; // check
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

initial
begin
$readmemh("Inst_Memory.txt",Inst_Memory);
end

assign Instruction = Inst_Memory[Read_Address[13:0]];

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:06 10/21/2019 
// Design Name: 
// Module Name:    MUX_5Bit 
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
module MUX_5Bit(A,B,C,D,OUT,SEL);

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

assign Data1 = Reg_File[Read1];
assign Data2 = Reg_File[Read2];

always @(posedge clock)
begin
if(RegWrite)
Reg_File[WriteReg] <= WriteData;
end

initial
begin
    Reg_File[0] = 0;
end


endmodule
module MUX (A,B,OUT,SEL);

input [31:0] A,B;
input SEL;
output reg [31:0] OUT;
always @ (A,B,SEL)
begin
case(SEL)
0:OUT <= A;
1:OUT <= B;
endcase
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

input [5:0] func; 
input [2:0] AluOp;
output reg [3:0] AluControl;
output reg JRMuxControl;

// always block that loops everytime func or AluOp change 
always@(func,AluOp)
begin

if((func == 8)&&(AluOp ==2))
	 begin
	 JRMuxControl <=1;
	 end
	 else
	 begin
	 JRMuxControl <=0;
	 end
   
    if (AluOp == 2) // incase R-format look at the func field and determine operation 
    begin
	 
    case (func)
        32 : AluControl <= 2; // 32 means send to the alu value 2 (add operation) add instruction
        34 : AluControl <= 6; // 34 means send to the alu value 6 (subtract operation) sub instruction
        37 : AluControl <= 1; // 37 means send to the alu value 1 (or operation) or instruction
        42 : AluControl <= 7; // 42 means send to the alu value 7 (compare operation) slt instruction
        39 : AluControl <= 12; // 39 means send to the alu value 12 (nor operation) nor instruction
        default:AluControl <=0; // just in case make and error value
    endcase 
	 
    end
    // incase Lw or Sw we use the Alu to add the offset to base address
    else if (AluOp == 0)
    begin

    AluControl <= 2; // send to the alu value 2 (add operation) lw or sw

    end
    // incase beq instruction use the Alu to subtract the two values 
    else if (AluOp == 1) 
    begin
        
    AluControl <= 6; // send to the alu value 6 (subtract operation) beq

    end
    // incase ori instruction use the Alu to or operation 
    else if (AluOp == 3)
    begin

    AluControl <= 1; // send to the alu value 1 (or operation) ori 

    end
    // incase Sll instruction use the Alu to shift lift the value from read register 1 by shamt 
    else if (AluOp == 4) 
    begin
        
    AluControl <= 13; // send to the alu value 13 (sll instruction) 

    end
    else
    begin
    AluControl <= 0; //just in case make and  , :incase of an error
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
    6 : AluOutput <= input1 - input2; // 6 on control pins mean subtract the two inputs
    7 : AluOutput <= (input1 < input2) ? 1:0; // 7 on control pins mean do comapre operation if input1 < input2 then the output is one else zero
    12 : AluOutput <= ~(input1 | input2); // 12 on control pins mean do nor operation
    13 : AluOutput <= (input1<<shamt); // 13 on control pins mean dicards second input and shift left input 1 by the shmat field value
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

initial
begin
$readmemh("DataMemory.txt",locations);
end

assign Data = (MemRead == 1'b1) ? locations[Address[13:0]] : 32'h00000000;

always@(posedge clk)
begin
    if(MemWrite == 1'b1)
    begin
        locations[Address[13:0]] <= WriteData; 
    end
end


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
output reg ALUSrc,RegWrite,MemRead,MemWrite,Branch,jump;
output reg [1:0] RegDst,MemtoReg;
output reg [2:0] ALUOp;

always @*

casex(Instruction)
0:begin RegDst<=1;ALUSrc<=0;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2;jump<=0; // R-type Instructions
end

35:begin RegDst<=0;ALUSrc<=1;MemtoReg<=1;RegWrite<=1;MemRead<=1;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0; 	// load-word Instruction
end

43:begin RegDst<=2'bxx;ALUSrc<=1;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=1;Branch<=0;ALUOp<=0;jump<=0; // store-word Instruction
end

4:begin RegDst<=2'bxx;ALUSrc<=0;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=1;ALUOp<=1;jump<=0; // Branch-equal Instruction
end

8:begin RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0; // add-imediate Instruction
end

13:begin RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3;jump<=0; // or-imediate Instruction
end

2:begin RegDst<=2'bxx;ALUSrc<=1'bx;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3'bxx;jump<=1; // jump Instruction
end

3:begin RegDst<=2;ALUSrc<=1'bx;MemtoReg<=2;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=1'bx;ALUOp<=3'bxxx;jump<=1; // jump and link instruction
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
module MIPS_CPU15(); //(CLK,ReadData1,ReadData2,Data);
 wire [31:0] IR,MemToRegOut,SignEE,ALUin2,AluOutput,shiftedSignEE,branch_muxOut,jump_addresss,JumpOut,PC,PC1,JumpRegMUXout;// check with TA (IR)
 wire RegWriteOut,RegWrite,ALUSrc,JRMuxControl,ZeroFlag,MemWrite,MemRead,Branch,jump,isBranch;
 wire [1:0] RegDst,MemtoReg; // 2 bits for JAL 
 wire [2:0] AluOp;
 wire[3:0] AluControl;
 wire [4:0] RegDstOut;
 wire CLK;
    wire [31:0] ReadData1,ReadData2,Data;

assign RegWriteOut = RegWrite & (~JRMuxControl);
assign SignEE = { {16{IR[15]}}, IR[15:0] };
assign shiftedSignEE = (SignEE <<2) + PC1;
assign isBranch = Branch & ZeroFlag;
assign jump_addresss = { {PC1[31:28]}, (IR[27:0]<<2) };
assign PC1 = PC + 4;


Clock_Generator c1(CLK);

PC MIPS_PC(JumpRegMUXout,PC,CLK);

InstructionMemory IM(PC>>2,IR);//check PC<<2

MUX_5Bit RegDstMux(IR[20:16],IR[15:11],5'b11111,5'b00000,RegDstOut,RegDst);// check with TA inputs problem

Register_File RF(IR[25:21],IR[20:16],RegDstOut,MemToRegOut,RegWriteOut,ReadData1,ReadData2,CLK);

MUX ALU_SRC (ReadData2,SignEE,ALUin2,ALUSrc);

AluControlUint ALUcontrolunit1(AluControl,JRMuxControl,IR[5:0],AluOp);

AluMips ALU(AluOutput,ZeroFlag,ReadData1,ALUin2,AluControl,IR[10:6]);

DataMemory Data_memory(Data,CLK,AluOutput,MemWrite,MemRead,ReadData2);

MUX4input MemtoRegMUX(AluOutput,Data,PC1,32'd0,MemToRegOut,MemtoReg);

control Control_Unit(RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,AluOp,IR[31:26],jump);

MUX BranchMUX (PC1,shiftedSignEE,branch_muxOut,isBranch);

MUX JumpMUX (branch_muxOut,jump_addresss,JumpOut,jump);

MUX JumpRegMUX(JumpOut,ReadData1,JumpRegMUXout,JRMuxControl);


endmodule