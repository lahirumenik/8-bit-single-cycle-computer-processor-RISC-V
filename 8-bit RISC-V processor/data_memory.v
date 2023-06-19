module data_memory #(
    //parameterized
    parameter N=8, W = 256
    //N = width of address and data
    //W = memory size
    
)(
    input logic [N-1:0] writedata, address,
    output logic [N-1:0] readdata,
    input logic write, read,
    input  clk, reset,
    output reg busywait
);
logic [N-1:0] data_memory_array [W-1:0];
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
integer i;
always @(posedge clk) begin
    if (reset)
    begin
        for (i=0;i<W; i=i+1)
            data_memory_array[i] = 0;
        
        busywait = '0;
		
    end

    else if (readaccess) begin
        readdata = #40 data_memory_array[address];
        busywait = '0;
        readaccess = 0;
        writeaccess = 0;
    end
    else if (writeaccess) begin
        data_memory_array[address] = #40 writedata;
        busywait = '0;
        readaccess = 0;
        writeaccess = 0;        
    end

end


endmodule