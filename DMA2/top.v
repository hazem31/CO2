
module CLK(clock);
output reg clock;

initial
begin
clock=0;
end

always
begin
#10 clock=~clock;
end

endmodule

module CPU(CLK,ADE,address_Bus,Data_Bus,Read,Write,state);

inout [31:0] Data_Bus,address_Bus;
output reg Read,Write,state=0;
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
CPU_Address = 7000;
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
PC =PC+1;
//change value
CPU_Address = 7000;

end

else if(IR[31:26] == 2 && ADE == 0) //lw
begin
CPU_Address<=IR[20:0];
Read =1;
Write=0;
@(negedge CLK)
#1
state = 1;
RegFile[IR[25:21]] =Data_Bus;
PC =PC+1;
//change value
CPU_Address = 7000;

end

else if(IR[31:26] == 3 && ADE == 0) //SW
begin
CPU_Address =IR[20:0];
Read=0;
Write=1;
CPU_Data = RegFile[IR[25:21]];
PC =PC+1;
@(negedge CLK);
//change value
CPU_Address = 7000;

end

else if(IR[31:26] == 4 && ADE == 0) //DMA
begin
CPU_Address =5000;
Read =0;
Write =0;
CPU_Data =IR[25:0];
PC =PC+1;
@(negedge CLK);
//change value
CPU_Address = 7000;
end

else
begin
Read = 0;
Write = 0;
end

end



endmodule

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
assign Data_Bus = (ADE & ~Read) ? DMA_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
assign address_Bus = (ADE) ? DMA_address : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin
#1
if(address_Bus == 5000 && ADE ==0 )
begin
Control = Data_Bus;
//ADE = 1;
Read = 0;
Write = 0;
flag = 0;
@(negedge CLK);
ADE = 1;
end

else if(ADE == 1 && flag ==0)
begin
DMA_address<=Control[12:0];
Read=1;
Write=0;
@(negedge CLK);
#1
Buffer<=Data_Bus;
flag =1;
end

else if(ADE == 1 && flag ==1)
begin
DMA_address<=Control[25:13];
Write=1;
Read=0;
DMA_Data<=Buffer;
@(negedge CLK);
ADE = 0;
flag =0;
Read = 0;
Write = 0;
DMA_address = 7000;
end

else if(ADE == 1 && flag == 2)
begin
	ADE = 0;
	flag = 0;
	Read =0;
	Write =0;
end

end


endmodule

module IO2(CLK,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

inout [31:0] Data_Bus;
input [31:0] address_Bus;
input Read_DMA,Write_DMA,Read_CPU,Write_CPU;
input CLK;

reg [31:0] IO_Reg;
reg [31:0] IO_Data;

initial
begin
IO_Reg = 50;
end

assign Data_Bus = ((Read_DMA | Read_CPU) & (address_Bus == 1006)) ? IO_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin
	#2
	if(address_Bus == 1006 )
    begin
	 
		if(Read_DMA || Read_CPU)
		begin
        @(negedge CLK)
		IO_Data<=IO_Reg;
		end 
		if(Write_DMA || Write_CPU)
		begin
		#1
        IO_Reg<=Data_Bus;
		end 
		
    end
end


endmodule


module Iinput_Output(CLK,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

inout [31:0] Data_Bus;
input [31:0] address_Bus;
input Read_DMA,Write_DMA,Read_CPU,Write_CPU;
input CLK;

reg [31:0] IO_Reg;
reg [31:0] IO_Data;

initial
begin
IO_Reg = 70;
end

assign Data_Bus = ((Read_DMA | Read_CPU) & (address_Bus == 1001)) ? IO_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin
	#2
	if(address_Bus == 1001 )
    begin
	 
		if(Read_DMA || Read_CPU)
		begin
		@(negedge CLK)
        IO_Data<=IO_Reg;
		end 
		if(Write_DMA || Write_CPU)
		begin
		#1
        IO_Reg<=Data_Bus;
		end 
		
    end
end


endmodule


module RAM(CLK,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU,state);

inout [31:0] Data_Bus;
output reg state;
input [31:0] address_Bus;
input Read_DMA,Write_DMA,Read_CPU,Write_CPU;
input CLK;
reg [31:0] RAM_Mem [0:1000];
reg [31:0] RAM_Data;
initial
begin
//$readmemh("RAM_Mem.txt",RAM_Mem);
// RAM_Data = 15;
state = 0;
end


assign Data_Bus = ((Read_CPU | Read_DMA) & (address_Bus <= 1000))  ? RAM_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin
	#2
	if(address_Bus <= 1000)
    begin
		
		if(Read_DMA || Read_CPU)
		begin
		#1
		state = 1;
        @(negedge CLK)
		RAM_Data<=RAM_Mem[address_Bus];
		end 
		if(Write_DMA || Write_CPU)
		begin
		#1
        RAM_Mem[address_Bus]<=Data_Bus;
		end 
		
    end
end


endmodule 

module Full(INPUT,OUTPUT);
wire clock,ADE,Read_DMA,Write_DMA,Read_CPU,Write_CPU;
wire [31:0] address_Bus,Data_Bus;
input wire INPUT;
output wire OUTPUT;
wire state,state1;

assign INPUT=clock;
assign OUTPUT=Write_DMA;
CLK MyCLK(clock);

DMA MyDMA(clock,ADE,address_Bus,Data_Bus,Read_DMA,Write_DMA);

CPU MyCPU(clock,ADE,address_Bus,Data_Bus,Read_CPU,Write_CPU,state);

RAM MyRAM(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU,state1);

Iinput_Output MyIO_1(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

IO2 MyIO_2(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU);

endmodule
