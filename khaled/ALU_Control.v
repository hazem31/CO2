module ALU_Control (Function_Code,ALUOp,ALU_CTR,JumpRegister);

input [5:0] Function_Code; // function feild
input [1:0] ALUOp; // ALU Control line signal
output reg [3:0]  ALU_CTR; // Alu control signal
output reg JumpRegister;
always @* 

case (ALUOp)

0:
begin
ALU_CTR <= 2; //add for load and store instructions
JumpRegister<=0;
end
1:
begin
ALU_CTR <= 6; //sub for branch instructions
JumpRegister<=0;
end
2: case (Function_Code) // R type instructions
    32:
   begin
   ALU_CTR <= 2; //add
   JumpRegister<=0;
   end
   
   34: 
   begin
   ALU_CTR <= 6; //sub
   JumpRegister<=0;
   end
   
   36: 
   begin
   ALU_CTR <= 0; //and
   JumpRegister<=0;
   end
   
   37: 
   begin
   ALU_CTR <= 1; //or
   JumpRegister<=0;
   end
   
   39: 
   begin
   ALU_CTR <= 12; //nor
   JumpRegister<=0;
   end
   
   42: 
   begin
   ALU_CTR <= 7; //slt
   JumpRegister<=0;
   end
   
   8: 
   begin
   JumpRegister<=1; // JumpRegister instruction
   ALU_CTR <= 4b'xxxx;
   end
   
   endcase
   
3:
begin
ALU_CTR <= 1; //or for or immediate instructions
JumpRegister<=0;
end
endcase

endmodule
