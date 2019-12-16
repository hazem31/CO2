`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:37:21 12/14/2019 
// Design Name: 
// Module Name:    RAM 
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
module RAM(CLK,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

inout [31:0] Data_Bus;
input [31:0] address_Bus;
input Read_DMA,Write_DMA,Read_CPU,Write_CPU;
input CLK;
reg [31:0] RAM_Mem [0:1000];
reg [31:0] RAM_Data;
initial
begin
//$readmemh("RAM_Mem.txt",RAM_Mem);
end

assign Data_Bus = (Read_DMA | Read_CPU) ? RAM_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin
	if(address_Bus <= 1000)
    begin
	 
		if(Read_DMA || Read_CPU)
		begin
        RAM_Data<=RAM_Mem[address_Bus];
		end 
		if(Write_DMA || Write_CPU)
		begin
        RAM_Mem[address_Bus]<=Data_Bus;
		end 
		
    end
end


endmodule 
