`include "shift_mux.v"
`include "adder.v"

module ALU #(
    parameter N =8, S=3 //N == input/output bits  & S == select code bits
)(
    input  [N-1:0] DATA1, DATA2,
    output logic [N-1:0] RESULT,
    input  [S-1:0] SELECT,
    output logic ZERO

);

logic [7:0] R_SHIFT; // for rotate shift

Rotate_MUX_16 mux_1 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[0]), .bit_shift(R_SHIFT[7]));

//assign shift_control[1] = shift_control[0]+4'b0001;
Rotate_MUX_16 mux_2 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[1]), .bit_shift(R_SHIFT[6]));

//assign shift_control[2] = shift_control[0]+4'b0010;
Rotate_MUX_16 mux_3 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[2]), .bit_shift(R_SHIFT[5]));

//assign shift_control[3] = shift_control[0] +4'b0011;
Rotate_MUX_16 mux_4 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[3]), .bit_shift(R_SHIFT[4]));

//assign shift_control[4] = shift_control[0]+4'b0100;
Rotate_MUX_16 mux_5 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[4]), .bit_shift(R_SHIFT[3]));

//assign shift_control[5] = shift_control[0]+4'b0101;
Rotate_MUX_16 mux_6 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[5]), .bit_shift(R_SHIFT[2]));

//assign shift_control[6] = shift_control[0]+4'b0110;
Rotate_MUX_16 mux_7 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[6]), .bit_shift(R_SHIFT[1]));

//assign shift_control[7] = shift_control[0]+4'b0111;
Rotate_MUX_16 mux_8 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[7]), .bit_shift(R_SHIFT[0]));



logic [7:0] L_SHIFT;
logic [3:0] shift_control[7:0];
//integer i;
//always @(*) begin
  //  for(i=0; i<8;i++) shift_control[i] = DATA1[3:0] +i;

//end
assign shift_control[0] = DATA1[3:0];
//n_adder FA_1 #(N=4) (.A(shift_control[0]), .B(4'b001), .S(shift_control[1]));
MUX_16 mux_r_1 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[0]), .bit_shift(L_SHIFT[7]));

//assign shift_control[1] = shift_control[0]+4'b0001;

adder_4 FA_1 (.A(shift_control[0]), .B(4'b0001), .S(shift_control[1]));
MUX_16 mux_r_2 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[1]), .bit_shift(L_SHIFT[6]));

//assign shift_control[2] = shift_control[0]+4'b0010;
adder_4 FA_2 (.A(shift_control[0]), .B(4'b0010), .S(shift_control[2]));
MUX_16 mux_r_3 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[2]), .bit_shift(L_SHIFT[5]));

//assign shift_control[3] = shift_control[0] +4'b0011;
adder_4 FA_3 (.A(shift_control[0]), .B(4'b0011), .S(shift_control[3]));
MUX_16 mux_r_4 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[3]), .bit_shift(L_SHIFT[4]));

//assign shift_control[4] = shift_control[0]+4'b0100;
adder_4 FA_4 (.A(shift_control[0]), .B(4'b0100), .S(shift_control[4]));
MUX_16 mux_r_5 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[4]), .bit_shift(L_SHIFT[3]));

//assign shift_control[5] = shift_control[0]+4'b0101;
adder_4 FA_5 (.A(shift_control[0]), .B(4'b0101), .S(shift_control[5]));
MUX_16 mux_r_6 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[5]), .bit_shift(L_SHIFT[2]));

//assign shift_control[6] = shift_control[0]+4'b0110;
adder_4 FA_6 (.A(shift_control[0]), .B(4'b0110), .S(shift_control[6]));
MUX_16 mux_r_7 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[6]), .bit_shift(L_SHIFT[1]));

//assign shift_control[7] = shift_control[0]+4'b0111;
adder_4 FA_7 (.A(shift_control[0]), .B(4'b0111), .S(shift_control[7]));
MUX_16 mux_r_8 (.IN0(DATA2[7]), .IN1(DATA2[6]), .IN2(DATA2[5]), .IN3(DATA2[4]), .IN4(DATA2[3]), .IN5(DATA2[2]), .IN6(DATA2[1]), 
.IN7(DATA2[0]), .control(shift_control[7]), .bit_shift(L_SHIFT[0]));



logic [7:0] arithmetic_shift;

logic [15:0] product, multiplier;
logic [15:0] multiplicand;
//logic [15:0][7:0] shift_lut; //[7:0];


assign multiplier = DATA2;
assign multiplicand =  DATA1;
integer i;
logic [15:0] out_1, out_2, out_3, out_4, out_5, out_6, out_7;

/*
adder_16 F_1 (.A(product), .B({multiplicand[14:0], 1'b0}), .S(out_1));
adder_16 F_2 (.A(product), .B({multiplicand[13:0], 2'b00}), .S(out_2));
adder_16 F_3 (.A(product), .B({multiplicand[12:0], 3'b000}), .S(out_3));
adder_16 F_4 (.A(product), .B({multiplicand[11:0], 4'b0000}), .S(out_4));
adder_16 F_5 (.A(product), .B({multiplicand[10:0], 5'b00000}), .S(out_5));
adder_16 F_6 (.A(product), .B({multiplicand[9:0], 6'b000000}), .S(out_6));
adder_16 F_7 (.A(product), .B({multiplicand[8:0], 7'b0000_000}), .S(out_7));
*/

always @(*) begin

for(i=0;i<=7;i++) begin
    
    if(i==0) begin
        if(multiplier[0]==1) product = multiplicand;
        else product='0;
    end
    if (i==1 && multiplier[i]==1) product = product + {multiplicand[14:0], 1'b0};  
    if (i==2 && multiplier[i]==1) product = product + {multiplicand[13:0], 2'b00}; 
    if (i==3 && multiplier[i]==1) product = product + {multiplicand[12:0], 3'b000};
    if (i==4 && multiplier[i]==1) product = product + {multiplicand[11:0], 4'b0000};
    if (i==5 && multiplier[i]==1) product = product + {multiplicand[10:0], 5'b0000_0}; 
    if (i==6 && multiplier[i]==1) product = product + {multiplicand[9:0], 6'b0000_00};
    if (i==7 && multiplier[i]==1) product = product + {multiplicand[8:0], 7'b0000_000};
           
    end

  end


logic [N-1:0] ADD, OR, AND;
always @(*) begin
     ADD <= DATA1 + DATA2;
     OR <= DATA1 | DATA2;
     AND <=  DATA1 & DATA2;
    /// rotate  <= {DATA2[7:7-DATA1+1],L_SHIFT[7-DATA1:0]};
    arithmetic_shift<= {DATA2[7], L_SHIFT[6:0]};

end
always @(*) begin
    case (SELECT)
    3'b000:   #1 RESULT = DATA1;
    3'b001:   #2 RESULT = ADD;
    3'b010:   #1 RESULT = AND;
    3'b011:   #1 RESULT = OR;
    3'b100:   #2 RESULT = L_SHIFT;
    3'b101:   #2 RESULT  = arithmetic_shift;
    3'b110:   #2 RESULT  = R_SHIFT; // rotate shift
    3'b111:   #3 RESULT = product;

    endcase
end
assign ZERO = RESULT == '0 ;


endmodule

