module Complement #(
    parameter N = 8
)(
    input [N-1:0] IN_COM,
    output [N-1:0] OUT_COM
); assign #1 OUT_COM = ~IN_COM + 8'b0000_0001;

endmodule

module MUX #(
    parameter N=8
)(
    input [N-1:0] IN0, IN1,
    input  control,
    output logic [N-1:0] out 
);

always @(*) begin
    case(control)

    0: out = IN0;
    1: out = IN1;
    endcase
end

endmodule



module decode #(
    parameter I_W = 32,
    parameter Im_W = 8,
    parameter A_W = 3
)(
    input [I_W-1:0] INSTRUCTION,
    output [Im_W-1:0] IMMEDIATE,
    output [A_W-1:0] DESTINATION, SOURCE1, SOURCE2 ,
    output signed [31:0] offset_addddress
);
    assign  DESTINATION = INSTRUCTION[18:16];
    assign  SOURCE1 = INSTRUCTION[15:8]; //10:8]
    assign  SOURCE2 = INSTRUCTION[2:0]; 
    assign  IMMEDIATE = INSTRUCTION[7:0]; 
    assign offset_addddress = INSTRUCTION[23:16];


endmodule