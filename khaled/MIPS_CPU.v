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
module MIPS_CPU(CLK,ReadData1,ReadData2,Data);
 wire [31:0] IR,MemToRegOut,SignEE,ALUin2,AluOutput,shiftedSignEE,branch_muxOut,jump_addresss,JumpOut,PC,PC1,JumpRegMUXout;// check with TA (IR)
 wire RegWriteOut,RegWrite,ALUSrc,JRMuxControl,ZeroFlag,MemWrite,MemRead,Branch,jump,isBranch;
 wire [1:0] RegDst,MemtoReg; // 2 bits for JAL 
 wire [2:0] AluOp;
 wire[3:0] AluControl;
 wire [4:0] RegDstOut;
input wire CLK;
output wire [31:0] ReadData1,ReadData2,Data;

assign RegWriteOut = RegWrite & (~JRMuxControl);
assign SignEE = { {16{IR[15]}}, IR[15:0] };
assign shiftedSignEE = (SignEE <<2) + PC1;
assign isBranch = Branch & ZeroFlag;
assign jump_addresss = { {PC1[31:28]}, (IR[27:0]<<2) };
assign PC1 = PC + 4;


PC MIPS_PC(JumpRegMUXout,PC,CLK);

InstructionMemory IM(PC,IR);//check PC<<2

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
