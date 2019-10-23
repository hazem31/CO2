`timescale 1 ns / 1ps
module Clock_Generator(clock);
output reg clock;

initial
begin
clock=0;
end

always @*
begin
#31 clock=~clock;
end

endmodule
