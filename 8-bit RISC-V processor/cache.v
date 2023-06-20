module cache (
    input clock, reset ;
    //CPU
    input [7:0] address , cpu_writeData ;
    input write,read ;
    output logic [7:0] cpu_readData ;
    output logic busywait;

    //MEMORY
    input [31:0] mem_readdata;
    input mem_busywait;
    output [31:0] mem_writedata ;
    output [5:0] mem_address ;
    output  mem_read,mem_write;

);
logic [31:0] cache_array [7:0];  
logic dirty_array [7:0];             
logic  valid_array [7:0];             
logic [2:0] tag_array [7:0]; 

logic [2:0] tag, index, logic tagmatch;
logic dirty, valid;
logic [1:0] offset;

assign #1 tag = address[7:5];
assign #1 index = adress[4:2];
assign #1 offset = address[1:0];

assign #1 dirt = dirty_array[index];
assign #1 valid = valid_array[index];

 always @(read,write) begin
        busywait = (read || write)? 1 : 0;
    end
// always @(*) begin
//     #0.9 tagmatch = (tag==tag_array[index])

// end

assign #0.9 tagmatch = (tag==tag_array[index]);
assign hit = tagmatch & valid[index];

always @(*) begin
    case(offset)
         0: cpu_readData = cacheblock_array[index][7:0] ;
        1: cpu_readData = cacheblock_array[index][15:8] ;
        2: cpu_readData = cacheblock_array[index][23:16] ;
        3: cpu_readData = cacheblock_array[index][31:24] ;

    endcase


end





parameter IDLE = 3'b000, MEM_READ = 3'b001;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((read || write) && !dirty && !hit)  
                    next_state = MEM_READ;
                else if (...)
                    next_state = ...;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_busywait)
                    next_state = ...;
                else    
                    next_state = MEM_READ;
            
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writedata = 8'dx;
                busywait = 0;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {tag, index};
                mem_writedata = 32'dx;
                busywait = 1;
            end
            
        endcase
    end

    // sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end



endmodule