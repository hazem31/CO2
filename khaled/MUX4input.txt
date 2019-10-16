module MUX4input(A,B,C,D,OUT,SEL);

input [31:0] A,B,C,D;
input [1:0] SEL;
output reg [31:0] OUT;
always @ (A,B,C,D,SEL)

case(SEL)
0:OUT <= A;
1:OUT <= B;
2:OUT <= C;
3:OUT <= D;
endcase

endmodule