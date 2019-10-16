module Register_File (Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);

input [4:0] Read1,Read2,WriteReg;
input [31:0] WriteData;
input RegWrite,clock;
output [31:0] Data1,Data2;
reg [31:0] Reg_File[0:31];

assign Data1 = Reg_File[Read1];
assign Data2 = Reg_File[Read2];

always @(posedge clock)
begin
if(RegWrite)
Reg_File[WriteReg] <= WriteData;
end

endmodule
