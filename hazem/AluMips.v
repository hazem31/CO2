
// inputs:
// 1 - input1 : the first input comming from register file
// 2 - input2 : the second input comming from the mux
// 3 - AluControl : 4 pins that determine which operation to be done
// 4 - shamt incase the SLL instruction the amount of shift left 
// outputs :
// 1- AluOutput : the result of calculations from the ALu 
// 2 - ZeroFlag : it is set to one if the result is zero 

// function: takes two inputs and procceses them based on the control pins and produce the output



module AluMips(AluOutput,ZeroFlag,input1,input2,AluControl,shamt);

input [5:0] shamt; // shamt field 5 pins 
input [31:0] input1,input2; // inputs to the alu 31 pins each
input [3:0] AluControl; // the control pins 4 pins
output reg  [31:0] AluOutput; // the result of calculations 
output ZeroFlag; // 1 pit indicate if zero happend

assign ZeroFlag = (AluOutput == 0) ? 1:0 ; // use assing statement to set the value of zero flag 

// always block to keep looping each time input1 or input2 or control pins change
always@(input1,input2,AluControl)
case (AluControl) // case condition to check values
    0 : AluOutput <= input1 & input2; // 0 on control pins mean do and operation
    1 : AluOutput <= input1 | input2; // 1 on control pins mean do OR operation 
    2 : AluOutput <= input1 + input2; // 2 on control pins mean add the two inputs
    6 : AluOutput <= input1 - input2; // 6 on control pins mean subtract the two inputs
    7 : AluOutput <= (input1 < input2) ? 1:0; // 7 on control pins mean do comapre operation if input1 < input2 then the output is one else zero
    12 : AluOutput <= ~(input1 | input2); // 12 on control pins mean do nor operation
    13 : AluOutput <= (input1<<shamt); // 13 on control pins mean dicards second input and shift left input 1 by the shmat field value
    default: AluOutput <= 0; // incase of error just output zero 
endcase

endmodule // 
