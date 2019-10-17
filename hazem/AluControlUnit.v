
// inputs:
// 1 - func: 6 bits represents the operation to be done in case of an R-format type register
// 2 - AluOp : 3 bits comming from the control unit to dertermine which instruction type and operation
// outputs:
// 1 - AluControl : 4 pins going to the Alu to dertermine operation
// 2 - JRMuxControl : one bit to control the mux of the JR address or the other muxes addresses

// function: take the AluOp and func and dertermine what to send to Alu unit on the control pins and JRMuxControl 


module AluControlUint(AluControl,JRMuxControl,func,AluOp);

input [5:0] func; 
input [2:0] AluOp;
output reg [3:0] AluControl;
output JRMuxControl;

assign JRMuxControl = (func == 8) ? 1:0; // assign statement to set jrMux to one and change the address 

// always block that loops everytime func or AluOp change 
always@(func,AluOp)
begin
    // incase R-format look at the func field and determine operation 
    if (AluOp == 2)
    begin
    case (func)
        32 : AluControl <= 2; // 32 means send to the alu value 2 (add operation) add instruction
        34 : AluControl <= 6; // 34 means send to the alu value 6 (subtract operation) sub instruction
        37 : AluControl <= 1; // 37 means send to the alu value 1 (or operation) or instruction
        42 : AluControl <= 7; // 42 means send to the alu value 7 (compare operation) slt instruction
        39 : AluControl <= 12 // 39 means send to the alu value 12 (nor operation) nor instruction
        default: AluControl <= 0; // just in case make and error value

    endcase 
    end
    // incase Lw or Sw we use the Alu to add the offset to base address
    else if (AluOp == 0)
    begin

    AluControl <= 2; // send to the alu value 2 (add operation) lw or sw

    end
    // incase beq instruction use the Alu to subtract the two values 
    else if (AluOp == 1) 
    begin
        
    AluControl <= 6; // send to the alu value 6 (subtract operation) beq

    end
    // incase ori instruction use the Alu to or operation 
    else if (AluOp == 3)
    begin

    AluControl <= 1; // send to the alu value 1 (or operation) ori 

    end
    // incase Sll instruction use the Alu to shift lift the value from read register 1 by shamt 
    else if (AluOp == 4) 
    begin
        
    AluControl <= 13; // send to the alu value 13 (sll instruction) 

    end
    else
    begin
    AluControl <= 0; //just in case make and  , :incase of an error
    end
end
endmodule