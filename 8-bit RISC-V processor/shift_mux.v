module MUX_16 (
    input IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7,
    input [3:0] control,
    output logic bit_shift
);
always @(*) begin
    case(control)

    4'b0000: bit_shift = IN0;
    4'b0001: bit_shift = IN1;
    4'b0010: bit_shift = IN2;
    4'b0011: bit_shift = IN3;
    4'b0100: bit_shift =IN4;
    4'b0101: bit_shift =IN5;
    4'b0110: bit_shift =IN6;
    4'b0111: bit_shift =IN7;
    4'b1000:bit_shift = 0;
    4'b1001:bit_shift = 0;
    4'b1010:bit_shift = 0;
    4'b1011:bit_shift = 0;
    4'b1100:bit_shift = 0;
    4'b1101:bit_shift = 0;
    4'b1110:bit_shift = 0;
    4'b1111: bit_shift = 0;

    endcase
end

endmodule

module Rotate_MUX_16 (
    input IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7,
    input [3:0] control,
    output logic bit_shift
);
always @(*) begin
    case(control)

    4'b0000: bit_shift = IN0;
    4'b0001: bit_shift = IN1;
    4'b0010: bit_shift = IN2;
    4'b0011: bit_shift = IN3;
    4'b0100: bit_shift =IN4;
    4'b0101: bit_shift =IN5;
    4'b0110: bit_shift =IN6;
    4'b0111: bit_shift =IN7;
    4'b1000:bit_shift = IN0;
    4'b1001:bit_shift = IN1;
    4'b1010:bit_shift = IN2;
    4'b1011:bit_shift = IN3;
    4'b1100:bit_shift = IN4;
    4'b1101:bit_shift = IN5;
    4'b1110:bit_shift = IN6;
    4'b1111: bit_shift = IN7;

    endcase
end

endmodule

