module Clock_Generator(clock);

output reg clock;

initial
begin
clock=0;
end
always

begin
#1 clock = 1;
#1 clock = 0;
end

endmodule