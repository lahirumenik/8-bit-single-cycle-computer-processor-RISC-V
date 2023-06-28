`include "alu.v"
`include "reg.v"
`include "other.v"
//`include "controlUnit.v"
`include "control.v"
`include "data_memory.v"
`include "cache.v"
`timescale 1ns/100ps
module cpu #(
    parameter W = 32
)(
    input [W-1:0] INSTRUCTION,
    input CLK, RESET,
    output logic signed [W-1:0] PC,
    input logic inst_mem_busy
);
logic [7:0] IMMEDIATE;
logic [2:0] DESTINATION, SOURCE1, SOURCE2;
logic signed [31:0] offset_addddress;

decode #(.I_W(32), .Im_W(8), .A_W(3)) mu_decoder (.INSTRUCTION(INSTRUCTION), .IMMEDIATE(IMMEDIATE), .DESTINATION(DESTINATION), 
.SOURCE1(SOURCE1),.SOURCE2(SOURCE2), .offset_addddress(offset_addddress));

logic [7:0] DATA1, DATA2, RESULT;
logic [2:0] SELECT;
logic WRITE;
logic ZERO;

logic MUX1, MUX2, JUMP, read_mem, write_mem, reg_write, busywait;
logic [1:0] BRANCH;
logic [2:0] ALUOP;

ControlUnit #(.I(32), .O(8), .Ao(3)) my_control_unit (.INSTRUCTION(INSTRUCTION), .MUX2(MUX2), .MUX1(MUX1), .ALUOP(ALUOP),.WRITE(WRITE),
 .JUMP(JUMP), .BRANCH(BRANCH), .read_mem(read_mem), .write_mem(write_mem), .reg_write(reg_write));
//#(.I(32), .O(8), .Ao(3))

logic [7:0] readdata;
// data_memory #(.N(8), .W(256)) my_data_memory (.write(write_mem), .read(read_mem), .clk(CLK), .reset(RESET), .address(RESULT),
//  .writedata(OUT1), .readdata(readdata), .busywait(busywait));

logic [31:0] mem_readdata;
logic [31:0] mem_writedata;
logic [5:0] mem_address;
logic mem_busywait, mem_read, mem_write;

cache data_cache (.clock(CLK), .reset(RESET),  .address(RESULT), .cpu_writeData(OUT1), .write(write_mem), 
.read(read_mem), .cpu_readData(readdata), .busywait(busywait), .mem_readdata(mem_readdata), .mem_busywait(mem_busywait),
 .mem_writedata(mem_writedata), .mem_address(mem_address), .mem_read(mem_read), .mem_write(mem_write));

data_memory #(.N(32), .W(256)) my_data_memory (.write(mem_write), .read(mem_read), .clk(CLK), .reset(RESET), .address(mem_address),
 .writedata(mem_writedata), .readdata(mem_readdata), .busywait(mem_busywait));


logic [7:0]  OUT1, OUT2, out;

reg_file #(.N(8), .W(8), .A(3)) my_reg_file (.INADDRESS(DESTINATION), .OUT1ADDRESS(SOURCE1), .OUT2ADDRESS(SOURCE2), .IN(out_reg_mux), .OUT1(OUT1),
.OUT2(OUT2), .CLK(CLK), .RESET(RESET), .WRITE(WRITE));

logic [7:0] OUT_COM, OUT_MUX1, OUT_MUX2, out_reg_mux;

Complement #(.N(8)) my_complement (.IN_COM(OUT_MUX1), .OUT_COM(OUT_COM));

MUX #(.N(8)) my_mux_1 (.IN0(IMMEDIATE), .IN1(OUT2), .control(MUX1), .out(OUT_MUX1));
MUX #(.N(8)) my_mux_2 (.IN0(OUT_MUX1), .IN1(OUT_COM), .control(MUX2), .out(OUT_MUX2));
MUX #(.N(8)) reg_mux (.IN0(RESULT), .IN1(readdata), .control(reg_write), .out(out_reg_mux));


//alu my_alu (OUT_MUX2, OUT1, ALUOP, RESULT);

ALU #(.N(8), .S(3)) alu (.DATA1(OUT_MUX2), .DATA2(OUT1), .RESULT(RESULT), .SELECT(ALUOP), .ZERO(ZERO));

logic [31:0] offset_address_multiple_4;
logic [31:0] branch_address;
logic pc_case;


//PC adder module
always @(*) begin
    //offset_addddress <= INSTRUCTION[23:16];
    offset_address_multiple_4 = offset_addddress<<2;
   #2 branch_address = PC + offset_address_multiple_4;

end


always @(posedge CLK) begin
    pc_case = (JUMP||((BRANCH == 2'b01) && ZERO) || ((BRANCH == 2'b10) && !ZERO));
    if(RESET) begin
        #1 
        PC <= 0;
    end
    else if (!busywait && !inst_mem_busy) begin
        
        case (pc_case)

        0: #1 PC <= PC+4;
        1: #1 PC <= branch_address+4;

    endcase
        //else #1 PC <= PC + 4;
    end

    


end
endmodule