module adder_4(
    input logic signed [3:0] A, B,
    output logic signed [3:0] S
    
);
    logic C [4:0];
    assign C[0] = '0;
    full_adder fa (.a (A[0]),.b (B[0]),.ci (C[0]), .co (C[1]), .sum (S[0]));
    full_adder fb (.a (A[1]),.b (B[1]),.ci (C[1]), .co (C[2]), .sum (S[1]));
    full_adder fc (.a (A[2]),.b (B[2]),.ci (C[2]), .co (C[3]), .sum (S[2]));
    full_adder fd (.a (A[3]),.b (B[3]),.ci (C[3]), .co (C[4]), .sum (S[3]));
    
endmodule

module adder_16(
    input logic signed [15:0] A, B,
    output logic signed [15:0] S
    
);
    logic C [16:0];
    assign C[0] = '0;
    full_adder fa (.a (A[0]),.b (B[0]),.ci (C[0]), .co (C[1]), .sum (S[0]));
    full_adder fb (.a (A[1]),.b (B[1]),.ci (C[1]), .co (C[2]), .sum (S[1]));
    full_adder fc (.a (A[2]),.b (B[2]),.ci (C[2]), .co (C[3]), .sum (S[2]));
    full_adder fd (.a (A[3]),.b (B[3]),.ci (C[3]), .co (C[4]), .sum (S[3]));
    
    full_adder fe (.a (A[4]),.b (B[4]),.ci (C[4]), .co (C[5]), .sum (S[4]));
    full_adder ff (.a (A[5]),.b (B[5]),.ci (C[5]), .co (C[6]), .sum (S[5]));
    full_adder fg (.a (A[6]),.b (B[6]),.ci (C[6]), .co (C[7]), .sum (S[6]));
    full_adder fh (.a (A[7]),.b (B[7]),.ci (C[7]), .co (C[8]), .sum (S[7]));

    full_adder fi (.a (A[8]),.b (B[8]),.ci (C[8]), .co (C[9]), .sum (S[8]));
    full_adder fj (.a (A[9]),.b (B[9]),.ci (C[9]), .co (C[10]), .sum (S[9]));
    full_adder fk (.a (A[10]),.b (B[10]),.ci (C[10]), .co (C[11]), .sum (S[10]));
    full_adder fl (.a (A[11]),.b (B[11]),.ci (C[11]), .co (C[12]), .sum (S[11]));


    full_adder fq (.a (A[12]),.b (B[12]),.ci (C[12]), .co (C[13]), .sum (S[12]));
    full_adder fr (.a (A[13]),.b (B[13]),.ci (C[13]), .co (C[14]), .sum (S[13]));
    full_adder fs (.a (A[14]),.b (B[14]),.ci (C[14]), .co (C[15]), .sum (S[14]));
    full_adder ft (.a (A[15]),.b (B[15]),.ci (C[15]), .co (C[16]), .sum (S[15]));
    

endmodule


module full_adder
(
    input logic a, b, ci,
    output logic sum, co
);
    logic wire_1, wire_2;
    assign wire_1 = a ^ b; // bitwise XOR
    assign wire_2 = wire_1 & ci; // bitwise AND
    wire wire_3 = a & b; // bitwise AND
    always @(*) begin
        co = wire_2 | wire_3; // bitwise OR
        sum = wire_1 ^ ci ; // bitwise XOR
    end
endmodule