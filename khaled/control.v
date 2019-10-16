module control(RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Instruction,jump);
input [5:0] Instruction;
output reg ALUSrc,RegWrite,MemRead,MemWrite,Branch,jump;
output reg [1:0] ALUOp,RegDst,MemtoReg;

always

case(Instruction)
0:// R-type Instructions
begin
RegDst<=1;ALUSrc<=0;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2;jump<=0;
end

35:	// load-word Instruction
begin
RegDst<=0;ALUSrc<=1;MemtoReg<=1;RegWrite<=1;MemRead<=1;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0;
end

43:	// store-word Instruction
begin
RegDst<=2'bx;ALUSrc<=1;MemtoReg<=2'bx;RegWrite<=0;MemRead<=0;MemWrite<=1;Branch<=0;ALUOp<=0;jump<=0;
end

4: 	// Branch-equal Instruction
begin
RegDst<=2'bx;ALUSrc<=0;MemtoReg<=2'bx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=1;jump<=0;
end

8:	// add-imediate Instruction
begin
RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0;
end

13:	// or-imediate Instruction
begin
RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3;jump<=0;
end

2:	// jump Instruction
begin
RegDst<=2'bx;ALUSrc<=1'bx;MemtoReg<=2'bx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2'bx;jump<=1;
end

3: // jump and link instruction
begin
RegDst<=2;ALUSrc<=1'bx;MemtoReg<=2;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=1'bx;ALUOp<=2'bx;jump<=1;
end

default
begin
RegDst<=2'bx;ALUSrc<=1'bx;MemtoReg<=1=2'bx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2'bx;jump<=0;
end

endmodule
