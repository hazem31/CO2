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


endmodule //