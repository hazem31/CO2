module MUX (A,B,OUT,SEL);

input [31:0] A,B;
input SEL;
output reg [31:0] OUT;
always @ (A,B,C,D,SEL)

case(SEL)
0:OUT <= A;
1:OUT <= B;
endcase

endmodule