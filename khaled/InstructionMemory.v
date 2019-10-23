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
