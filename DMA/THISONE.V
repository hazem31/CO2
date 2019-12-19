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

module CPU(CLK,ADE,address_Bus,Data_Bus,Read,Write,state,PC1);

inout [31:0] Data_Bus,address_Bus;
output reg Read,Write,state=0;
input ADE,CLK;
reg [31:0] Inst_Memory [0:50];
reg [31:0] RegFile [0:4];
reg [31:0] PC,CPU_Data,CPU_Address;
wire [31:0] IR;
output [31:0] PC1;
initial
begin
PC=0;
Read=0;
Write=0;
CPU_Address = 7000;
RegFile [0] = 0;
RegFile [1] = 0;
RegFile [2] = 0;
Inst_Memory [0] = 32'h04000000;
Inst_Memory [1] = 32'h04000000;
Inst_Memory [2] = 32'h04000000;
Inst_Memory [3] = 32'h04000000;
Inst_Memory [4] = 32'h04000000;
Inst_Memory [5] = 32'h04000000;
Inst_Memory [6] = 32'h04000000;
Inst_Memory [7] = 32'h04000000;
Inst_Memory [8] = 32'h04000000;
Inst_Memory [9] = 32'h04000000;

//$readmemh("Inst_Memory.txt",Inst_Memory);
//$readmemh("RegFile.txt",RegFile);
end
assign IR=Inst_Memory[PC];
assign PC1 = PC;
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

module DMA(CLK,ADE,address_Bus,Data_Bus,Read,Write,DMA_Req1,DMA_Req2);

inout [31:0] Data_Bus,address_Bus;
output reg ADE,Read,Write;
input CLK,DMA_Req1,DMA_Req2;
reg [31:0] Buffer,Control,IO1,IO2;
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
if(DMA_Req1 == 1)
begin
ADE=1;
DMA_address=1001;
Read = 1;
Write = 0;
@(negedge CLK);
#1
IO1<=Data_Bus;
flag =2;
end

if(DMA_Req1 == 2)
begin
ADE=1;
DMA_address=1006;
Read = 1;
Write = 0;
@(negedge CLK);
#1
IO2<=Data_Bus;
flag =2;
end

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

module IO2(CLK,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU,DMA_Req);

inout [31:0] Data_Bus;
input [31:0] address_Bus;
input Read_DMA,Write_DMA,Read_CPU,Write_CPU;
input CLK;
output reg DMA_Req;

reg [31:0] IO_Reg,req_IO;
reg [31:0] IO_Data;

initial
begin
IO_Reg = 50;
req_IO = 0 ;
DMA_Req = 0;
req_IO = 5;
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
		if(req_IO != 0)
		begin
		IO_Reg<=req_IO;
		DMA_Req <=1;
		wait (Read_DMA == 1);
		@(negedge CLK)
		IO_Data<=IO_Reg;
		req_IO<=0;
		end
		
    end
end


endmodule


module Iinput_Output(CLK,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU,DMA_Req);

inout [31:0] Data_Bus;
input [31:0] address_Bus;
input Read_DMA,Write_DMA,Read_CPU,Write_CPU;
input CLK;
output reg DMA_Req;

reg [31:0] IO_Reg,req_IO;
reg [31:0] IO_Data;

initial
begin
IO_Reg = 70;
req_IO = 0 ;
DMA_Req = 0;
req_IO = 6;
end

assign Data_Bus = ((Read_DMA | Read_CPU) & (address_Bus == 1001)) ? IO_Data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

always@(posedge CLK)
begin
	#2
	if(address_Bus == 1001 )
    begin
	 
		if(Read_DMA || Read_CPU)
		begin
		@(negedge CLK);
        IO_Data<=IO_Reg;
		end 
		if(Write_DMA || Write_CPU)
		begin
		#1
        IO_Reg<=Data_Bus;
		end 
		if(req_IO != 0)
		begin
		IO_Reg<=req_IO;
		DMA_Req <=1;
		wait (Read_DMA == 1);
		@(negedge CLK)
		IO_Data<=IO_Reg;
		req_IO <=0;
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
wire [31:0] address_Bus,Data_Bus,PC;
input wire INPUT;
output wire OUTPUT;
wire state,state1;

assign INPUT=clock;
assign OUTPUT=Write_DMA;
CLK MyCLK(clock);

DMA MyDMA(clock,ADE,address_Bus,Data_Bus,Read_DMA,Write_DMA,DMA_Req1,DMA_Req2);


CPU MyCPU(clock,ADE,address_Bus,Data_Bus,Read_CPU,Write_CPU,state,PC);

RAM MyRAM(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU,state1);

Iinput_Output MyIO_1(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU,DMA_Req1);

IO2 MyIO_2(clock,address_Bus,Data_Bus,Read_DMA,Write_DMA,Read_CPU,Write_CPU,DMA_Req2);

endmodule
