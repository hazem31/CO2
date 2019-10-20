// fe 7agat m4 kamla ll asf ... w fe 7agat m4 mzbota awe 
//clock 
module clk_gen(clk);
output reg clk;
initial 
begin
clk = 0;
end
always
begin
#5
clk = ~clk;
end
endmodule



//mips
module MIPS_Processor(clk);

reg[31:0] pc,regs[0:31],Imemory[1023:0],Dmemory[1023:0],IR;
endmodule
 


//ALU wires a,b,alucontrol,zero,aluresult
module ALU(a,b,ALUc,zero,ALUr);
input [31:0] a;
input [31:0] b;
output  zero;
input [3:0] ALUc;
output [31:0] ALUr;
assign zero = (ALUr==0);
always @(ALUc,a,b)
case(ALUc)
0:ALUr <= a&b;
1:ALUr <= a|b;
2:ALUr <= a+b;
6:ALUr <= a-b;
7:ALUr <= a<b?1:0;
12:ALUr <= ~(a|b);
default :ALUr <= 0;
endmodule 


//alu control ( ely gaylo mn el aluop w el hy5rog meno w el function )
module ALUcontrol(ALUop,aluc_output,func);
input [5:0] ALUop;
output [1:0] aluc_output ;
input [5:0] func ;
endmodule



//register file(read 1,read 2,read data 1,read data 2,write,write reg,write data,clk)
module Regfile(r1,r2,rd1,rd2,write,write_reg,write_data,clk);
input [4:0] r1;
input [4:0] r2;
input clk;
input write;
input [4:0] write_reg;
output [31:0] write_data;
output [31:0] rd1;
output [31:0] rd2;
reg [31:0] RF[0:31];
always @(posedge clk)
begin 
if(write ==1)
assign RF[write_reg] <= write_data;  
else
assign rd1 = RF[r1];
assign rd2 = RF[r2];
end
endmodule



// da el control nafso 
module control(regdst,jump,branch,mem_read,memto_reg,alu_op,mem_write,alu_src,reg_write,func,opcode)

output regdst,jump,branch,mem_read,memto_reg,mem_write,alu_src,reg_write;
input [5:0] func,opcode;
output [2:0] alu_op;

always@(*)
begin
// ha4of howa R-format wla anhy format blzabt
case(opcode)
// lw howa R-format
'b=000000:
begin
alu_src <= 0;
reg_dst <= 1;
mem_write <= 0;
mem_read <= 0;
branch<= 0;
jump <= 0;
memto_reg <= 0;
reg_write <= 1;
 
// dlw2ty ana 3ayz a3raf howa anhy R-format instruction fa ha4of el function bits
case(func)
begin
       // ADD
      'b 100000: alu_op <= 'b 010;
      // SUB
      'b 100010: alu_op <= 'b 110;
      // AND
      'b 100100: alu_op <= 'b 000;
      // OR
      'b 100101: alu_op <= 'b 001;
      // SLT
      'b 101010: alu_op <= 'b 111;

endcase //bta3t case el function
end // bta3t el R-format
// tab lw howa I-format hy3ml beq bne addi sw lw 
// lw
'b 100011:
begin
alu_src <= 1;
reg_dst <= 0;
jump <=0;
branch <=0;
mem_read <=1;
memto_reg <=1;
mem_write <=0;
reg_write <=1;
alu_op <= 'b010 ; // ka2eno add
end
// sw
'b 101011:
begin
//reg_dst <=1; da dont care aslun
jump <=0;
branch <=0;
mem_read <=0;
//memto_reg <= x; da dont care aslun
alu_op <= 'b010; // ka2eno add
mem_write <=1;
alu_src <=1;
reg_write <=0;
end
endcase // bta3t case el opcode nafso
end // bta3t el begin bta3t el always
endmodule //bta3t el module bta3 el control



// data memory
module data_memory(address,write_data,read_data,mem_read,mem_write,clk);
input [31:0] address;
input [31:0] write_data;
input mem_write;
input mem_read;
output reg [31:0] read_data;
input clk;
reg [31:0] RF[0:31]; // 3ndy 32 register kolhm 32 bit
always(posedge clk)
begin
if(mem_write == 1)
assign RF[address] = write_data; // y3ny el address da el index bta3y .. fa ana ha5od el 7aga el f el write data w a7otha f reg 3enwano howa el address 
else if(mem_read == 1)
assign read_data = RF[address];
end
endmodule
