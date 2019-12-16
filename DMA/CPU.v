`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:51:23 12/14/2019 
// Design Name: 
// Module Name:    CPU 
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
module CPU(CLK,ADE,address_Bus,Data_Bus,Read,Write);

inout [31:0] Data_Bus,address_Bus;
output reg Read,Write;
input ADE,CLK;
reg [31:0] Inst_Memory [0:50];
reg [31:0] RegFile [0:4];
reg [31:0] PC,CPU_Data,CPU_Address;
wire [31:0] IR;
initial
begin
PC=0;
Read=0;
Write=0;
//$readmemh("Inst_Memory.txt",Inst_Memory);
//$readmemh("RegFile.txt",RegFile);
end
assign IR=Inst_Memory[PC];
assign Data_Bus = (~ADE & ~Read) ? CPU_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz; // Check
assign address_Bus = (~ADE) ? CPU_Address : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;


always@(posedge CLK)
begin

if(IR[31:26] == 1) //ADD
begin
RegFile[IR[25:21]]=RegFile[IR[20:16]]+RegFile[IR[15:11]];
PC<=PC+1;
end

if(IR[31:26] == 2 && ADE == 0) //lw
begin
CPU_Address<=IR[20:0];
Read<=1;
Write<=0;
RegFile[IR[25:21]]<=Data_Bus;
PC<=PC+1;
end

if(IR[31:26] == 3 && ADE == 0) //SW
begin
CPU_Address<=IR[20:0];
Read<=0;
Write<=1;
CPU_Data<=RegFile[IR[25:21]];
PC<=PC+1;
end

if(IR[31:26] == 4 && ADE == 0) //DMA
begin
CPU_Address<=5000;
Read<=0;
Write<=0;
CPU_Data<=IR[25:0];
PC<=PC+1;
end

end



endmodule
