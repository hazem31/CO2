`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:49 12/14/2019 
// Design Name: 
// Module Name:    DMA 
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
module DMA(CLK,ADE,address_Bus,Data_Bus,Read,Write);

inout [31:0] Data_Bus,address_Bus;
output reg ADE,Read,Write;
input CLK;
reg [31:0] Buffer,Control;
reg flag;
reg [31:0] DMA_address,DMA_Data;
initial
begin
ADE=0;
flag=0;
Read=0;
Write=0;
end
assign Data_Bus = (ADE) ? DMA_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
assign address_Bus = (ADE) ? DMA_address : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin

if(address_Bus == 5000 && ADE ==0 )
begin
Control<=Data_Bus;
ADE<=1;
Read<=0;
Write<=0;
end

if(ADE == 1 && flag ==0)
begin
DMA_address<=Control[12:0];
Read<=1;
Write<=0;
Buffer<=Data_Bus;
flag<=1;
end

if(ADE == 1 && flag ==1)
begin
DMA_address<=Control[25:13];
Write<=1;
Read<=0;
DMA_Data<=Buffer;
ADE<=0;
end
end


endmodule
