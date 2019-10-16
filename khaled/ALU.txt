module ALU(INPUT1,INPUT2,OUTPUT,ZERO,ALU_CTR);

input [31:0] INPUT1,INPUT2; // ALU inputs
input [3:0] ALU_CTR; // ALU control signal
output reg [31:0] OUTPUT;
output ZERO; // zero flag

assign ZERO = (OUTPUT==0);

always @(INPUT1,INPUT2,ALU_CTR)

case(ALU_CTR)
0:OUTPUT <= INPUT1 & INPUT2; //and operation
1:OUTPUT <= INPUT1 | INPUT2; //or operation
2:OUTPUT <= INPUT1 + INPUT2; //add operation
6:OUTPUT <= INPUT1 - INPUT2; //sub operation
7:OUTPUT <= INPUT1 < INPUT2 ? 1:0; //set if less thaan operation
12:OUTPUT <= ~(INPUT1 | INPUT2); //nor operation
endcase

endmodule