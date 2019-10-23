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

endmodule
