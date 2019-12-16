`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:21 12/14/2019 
// Design Name: 
// Module Name:    Full 
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
module Full(INPUT,OUTPUT);
wire clock,ADE,Read_DMA,Write_DMA,Read_CPU,Write_CPU;
wire [31:0] address_Bus,Data_Bus;
input wire INPUT;
output wire OUTPUT;
assign INPUT=clock;
assign OUTPUT=Write_DMA;
CLK MyCLK(clock);

DMA MyDMA(clock,ADE,address_Bus,Data_Bus,Read_DMA,Write_DMA);

CPU MyCPU(clock,ADE,address_Bus,Data_Bus,Read_CPU,Write_CPU);

RAM MyRAM(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

Iinput_Output MyIO_1(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

IO2 MyIO_2(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

endmodule
