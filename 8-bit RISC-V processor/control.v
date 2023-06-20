`define LOADI 8'b0000_0000
`define MOV 8'b0000_0001
`define ADD 8'b0000_0010
`define SUB 8'b0000_0011
`define OR 8'b0000_0101
`define AND 8'b0000_0100

module ControlUnit #(
    parameter I = 32, O = 8, Ao= 3
)(
    input logic [I-1:0] INSTRUCTION,
    output logic MUX1, MUX2, WRITE, JUMP, write_mem, read_mem, reg_write, //reg_Write = 0 => write from ALu, 1=> wite from memory
    output logic [1:0] BRANCH,
    output logic [Ao-1:0] ALUOP
); 
logic [O-1:0] OPCODE;


//INSTRUCTION SET
//loadi = 0000_0000
//movi = 0000_0001
//add = 0000_0010
//sub = 0000_0011
//or = 0000_0100
//and = 0000_0101
//j = 00000110;
//beq= 00000111;
//sll = 0000_1000;
//srl = 0000_1001;
//sra = 0000_1010;
//ror = 0000_1011;
//mult = 0000_1100;
//bne = 000 = 0000_1101
//lwd = 0000_1110
//swd = 0000_1111
//lwi = 0001_0000
//swi = 0001_0001

x

always @(*) begin
    OPCODE = INSTRUCTION[I-1:I-O];
 #1 //delay of 1 time unit

        case(OPCODE)

        //op_loadi call
            8'b00000000 :   begin
                                assign WRITE = 1;   
                                assign  MUX1 = 0;  
                                assign  MUX2 = 0;  
                                assign ALUOP = 3'b000; 
                                assign JUMP = 0;
                                assign BRANCH = '0;
                                assign write_mem = 0;
                                assign read_mem = 0;
                                assign reg_write = 0;
                            end

            //op_mov call
            8'b00000001 :   begin
                                assign WRITE = 1;   
                                assign  MUX1 = 1;   
                                assign  MUX2 = 0;  
                                assign ALUOP = 3'b000;
                                assign JUMP = 0;
                                assign BRANCH = '0;
                                assign write_mem = 0;
                                assign read_mem = 0;
                                assign reg_write = 0;
                            end

            //op_add call
            8'b00000010 :   begin
                                assign WRITE = 1;
                                assign  MUX1= 1; 
                                assign  MUX2 = 0;  
                                assign ALUOP = 3'b001;
                                assign JUMP = 0;  
                                assign BRANCH = '0;
                                assign write_mem = 0;
                                assign read_mem = 0;
                                assign reg_write = 0;
                            end
            //op_sub call
            8'b00000011 :   begin
                                assign WRITE = 1;   
                                assign  MUX1 = 1;   
                                assign  MUX2 = 1;  
                                assign ALUOP = 3'b001;
                                assign JUMP = 0;
                                assign BRANCH = '0;
                                assign write_mem = 0;
                                assign read_mem = 0;
                                assign reg_write = 0;
                            end
            
            //op_and call
            8'b00000100 :   begin
                                assign WRITE = 1;   
                                assign  MUX1 = 1;   
                                assign  MUX2 = 0;   
                                assign ALUOP = 3'b010;
                                assign JUMP = 0;
                                assign BRANCH = '0;
                                assign write_mem = 0;
                                assign read_mem = 0;
                                assign reg_write = 0;
                            end
            
            //op_or call
            8'b00000101 :   begin
                                assign WRITE = 1;  
                                assign  MUX1= 1;    
                                assign  MUX2 = 0;   
                                assign ALUOP = 3'b011;  
                                assign JUMP = 0;
                                assign BRANCH = '0;
                                assign write_mem = 0;
                                assign read_mem = 0;
                                assign reg_write = 0;
                            end

            //j call
            8'b00000110: begin 
                assign WRITE = 0;
                assign MUX1 = 0;
                assign JUMP = 1;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;
            end

            //beq call
            8'b00000111: begin 
                assign WRITE = 0;
                assign MUX1 = 1;
                assign MUX2 = 1;
                assign BRANCH = 2'b01;
                assign ALUOP = 3'b001;
                assign JUMP = 0;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;

            end

            //sll call
            8'b00001000: begin
                assign WRITE = 1;
                assign MUX1 = 0;
                assign MUX2 = 0;
                assign BRANCH = '0;
                assign JUMP = 0;
                assign ALUOP = 3'b100;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;


            end

            //srl call
            8'b00001001: begin
                assign WRITE = 1;
                assign MUX1 = 0;
                assign MUX2 = 1;
                assign BRANCH = '0;
                assign JUMP = 0;
                assign ALUOP = 3'b100;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;


            end

            //sra call
            8'b00001010: begin
                assign WRITE = 1;
                assign MUX1 = 0;
                assign MUX2 = 1;
                assign BRANCH = '0;
                assign JUMP = 0;
                assign ALUOP = 3'b101;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;


            end

             //ror call
            8'b00001011: begin
                assign WRITE = 1;
                assign MUX1 = 0;
                assign MUX2 = 1;
                assign BRANCH = '0;
                assign JUMP = 0;
                assign ALUOP = 3'b110;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;


            end


             //mult call
            8'b00001100: begin
                assign WRITE = 1;
                assign MUX1 = 1;
                assign MUX2 = 0;
                assign BRANCH = '0;
                assign JUMP = 0;
                assign ALUOP = 3'b111;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;


            end

            //bne call
            8'b0000_1101: begin 
                assign WRITE = 0;
                assign MUX1 = 1;
                assign MUX2 = 1;
                assign BRANCH = 2'b10;
                assign ALUOP = 3'b001;
                assign write_mem = 0;
                assign read_mem = 0;
                assign reg_write = 0;

            end

            //lwd call
            8'b0000_1110: begin
                assign WRITE = 1;
                assign MUX1 = 1;
                assign MUX2 = 0;
                assign BRANCH = '0;
                assign ALUOP = '0;
                assign write_mem = 0;
                assign read_mem = 1;
                assign reg_write = 1;

            end

            //swd
            8'b0000_1111: begin
                assign WRITE = 0;
                assign MUX1 = 1;
                assign MUX2 = 0;
                assign BRANCH = '0;
                assign ALUOP = '0;
                assign write_mem = 1;
                assign read_mem = 0;
                assign reg_write = 1;

            end

             //lwi
            8'b0001_0000: begin
                assign WRITE = 1;
                assign MUX1 = 0;
                assign MUX2 = 0;
                assign BRANCH = '0;
                assign ALUOP = '0;
                assign write_mem = 0;
                assign read_mem = 1;
                assign reg_write = 1;

            end

             //swi
            8'b0001_0001: begin
                assign WRITE = 0;
                assign MUX1 = 0;
                assign MUX2 = 0;
                assign BRANCH = '0;
                assign ALUOP = '0;
                assign write_mem = 1;
                assign read_mem = 0;
                assign reg_write = 1;

            end

        endcase

end

endmodule