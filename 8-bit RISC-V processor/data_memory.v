`timescale 1ns/100ps
module data_memory #(
    //parameterized
    parameter N=32, W = 256
    //N = width of address and data
    //W = memory size
    
)(
    input logic [N-1:0] writedata, 
    input logic [5:0] address,
    output logic [N-1:0] readdata,
    input logic write, read,
    input  clk, reset,
    output reg busywait
);
logic [N-1:0] memory_array [W-1:0];
reg readaccess, writeaccess;

always @(*)
begin
	busywait = (read || write)? 1 : 0;
	readaccess = (read && !write)? 1 : 0;
	writeaccess = (!read && write)? 1 : 0;
end

// assign busywait = (read||write)?1:0;
// assign readaccess = (read && !write);
// assign writeaccess = (!read && write);

always @(posedge clk) begin
   

    if (readaccess) begin
        readdata[7:0]   = #40 memory_array[{address,2'b00}];
		readdata[15:8]  = #40 memory_array[{address,2'b01}];
		readdata[23:16] = #40 memory_array[{address,2'b10}];
		readdata[31:24] = #40 memory_array[{address,2'b11}];
		busywait =  0;
		readaccess = 0;
    end
    else if (writeaccess) begin
        memory_array[{address,2'b00}] = #40 writedata[7:0];
		memory_array[{address,2'b01}] = #40 writedata[15:8];
		memory_array[{address,2'b10}] = #40 writedata[23:16];
		memory_array[{address,2'b11}] = #40 writedata[31:24];
		busywait =  0;
		writeaccess =  0;     
    end

end
integer i;
always @(posedge reset)
begin
    if (reset)
    begin
        for (i=0;i<256; i=i+1)
            memory_array[i] = 0;
        
        busywait = 0;
		readaccess = 0;
		writeaccess = 0;
    end
end

endmodule