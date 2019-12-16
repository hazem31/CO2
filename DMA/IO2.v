`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:05:43 12/14/2019 
// Design Name: 
// Module Name:    IO2 
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
module IO2(CLK,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

inout [31:0] Data_Bus;
input [31:0] address_Bus;
input Read_DMA,Write_DMA,Read_CPU,Write_CPU;
input CLK;

reg [31:0] IO_Reg;
reg [31:0] IO_Data;

assign Data_Bus = (Read_DMA || Read_CPU) ? IO_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin
	if(address_Bus == 1006 )
    begin
	 
		if(Read_DMA || Read_CPU)
		begin
        IO_Data<=IO_Reg;
		end 
		if(Write_DMA || Write_CPU)
		begin
        IO_Reg<=Data_Bus;
		end 
		
    end
end


endmodule
