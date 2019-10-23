`timescale 1ns / 1ps
module control(RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Instruction,jump);
/* inputs Instruction : 6 bits opcode to determine the type of the operation
	
	outputs 
	
	RegDst:determines the register to be written to
	ALUSrc:determines the second input to the alu "immediate feild or register 2 data"
	MemtoReg:determines the data to be written to a register
	RegWrite:allows to write to a register
	MemRead:allows to read from a memory address
	MemWrite:allows to write in a memory address
	Branch:used in branch condition
	ALUOp:send data to alu control unit
	jump:used in jump condition

*/
input [5:0] Instruction;
output reg ALUSrc,RegWrite,MemRead,MemWrite,Branch,jump;
output reg [1:0] ALUOp,RegDst,MemtoReg;

always @*

casex(Instruction)
0:begin RegDst<=1;ALUSrc<=0;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2;jump<=0; // R-type Instructions
end

35:begin RegDst<=0;ALUSrc<=1;MemtoReg<=1;RegWrite<=1;MemRead<=1;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0; 	// load-word Instruction
end

43:begin RegDst<=2'bxx;ALUSrc<=1;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=1;Branch<=0;ALUOp<=0;jump<=0; // store-word Instruction
end

4:begin RegDst<=2'bxx;ALUSrc<=0;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=1;ALUOp<=1;jump<=0; // Branch-equal Instruction
end

8:begin RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0; // add-imediate Instruction
end

13:begin RegDst<=0;ALUSrc<=1;MemtoReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=3;jump<=0; // or-imediate Instruction
end

2:begin RegDst<=2'bxx;ALUSrc<=1'bx;MemtoReg<=2'bxx;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2'bxx;jump<=1; // jump Instruction
end

3:begin RegDst<=2;ALUSrc<=1'bx;MemtoReg<=2;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=1'bx;ALUOp<=2'bxx;jump<=1; // jump and link instruction
end

default:begin RegDst<=0;ALUSrc<=1'bx;MemtoReg<=0;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=0;jump<=0;
end

endcase
endmodule
