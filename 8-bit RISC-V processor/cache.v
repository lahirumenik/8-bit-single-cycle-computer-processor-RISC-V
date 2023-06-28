`timescale 1ns/100ps
module cache (
    input clock, reset ,
    //cpu
    input logic [7:0] address , cpu_writeData,
    input  write,read ,
    output logic [7:0] cpu_readData,
    output reg busywait,

    //mem
    input logic [31:0] mem_readdata,
    input logic mem_busywait,
    output logic [31:0] mem_writedata,
    output logic  [5:0] mem_address,
    output logic mem_read,mem_write

);
// logic [31:0] mem_readdata;
// logic mem_busywait;
// logic [31:0] mem_writedata;
// logic [5:0] mem_address;
// logic mem_busywait, mem_read, mem_write
// cache(.clock(), .address(), .cpu_writeData(), .write(write), .read(read), .cpu_readData(), .busywait(), .mem_readData(), .mem_busywait(),
// .mem_writeData(), .mem_address(), .mem_read(), .mem_write())

logic [31:0] cacheblock_array [7:0];  
logic dirty_array [7:0];             
logic  valid_array [7:0];             
logic [2:0] tag_array [7:0]; 

logic [2:0] tag, index;
logic dirty, valid;
logic [1:0] offset;
logic cache_write;
reg hit;
reg tagmatch;

assign #1 tag = address[7:5];
assign #1 index = address[4:2];
assign #1 offset = address[1:0];

assign #1 dirty = dirty_array[index];
assign #1 valid = valid_array[index];

//  always @(read,write) begin
//         busywait = (read || write)? 1 : 0;
//     end
// always @(*) begin
//     #0.9 tagmatch = (tag==tag_array[index])

// end

assign #0.9 tagmatch = (tag==tag_array[index]);
assign hit = tagmatch & valid_array[index];
//assign busywait = (write| read) & !hit;
// always @(*) busywait = (write| read);

always @(*) begin
    case(offset)
         0: cpu_readData = cacheblock_array[index][7:0] ;
        1: cpu_readData = cacheblock_array[index][15:8] ;
        2: cpu_readData = cacheblock_array[index][23:16] ;
        3: cpu_readData = cacheblock_array[index][31:24] ;

    endcase


end

 always @(*) begin
        if(hit) begin
            if(read && (!write)) begin
                busywait = 0 ;  
               // tagmatch = '0 ;
                cache_write = 0;  
            end
            else if (write && (!read)) begin
                busywait = 0;       
                cache_write = 1;     
                
            end
        end else begin 
            cache_write = 0;
            busywait = (write||read);
            end
       
    end
    

    always @(posedge clock) begin
       if(cache_write) begin
           #1
            case (offset)
                0: cacheblock_array[index][7:0] = cpu_writeData;
                1: cacheblock_array[index][15:8] = cpu_writeData;
                2: cacheblock_array[index][23:16] = cpu_writeData;
                3: cacheblock_array[index][31:24] = cpu_writeData;
            endcase
           dirty_array[index] = 1;
       end 
    end






parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010;
reg [2:0] state, next_state;

    // combinational next state logic
always @(*)begin
    case (state)
        IDLE:
            if ((read || write) && !dirty && !hit)  
                next_state = MEM_READ;
            else if ((read || write) && dirty && !hit)
                next_state = MEM_WRITE;
            else
                next_state = IDLE;
        
        MEM_READ:
            if (!mem_busywait)
                next_state = IDLE;
            else    
                next_state = MEM_READ;

            MEM_WRITE:
            if (!mem_busywait)
                next_state = MEM_READ;
            else    
                next_state = MEM_WRITE;
        
    endcase
end


integer i;
// sequential logic for state transitioning 
always @(posedge clock, reset)
begin
    if(reset) begin
        state = IDLE;
        for(i = 0 ; i<7 ;i = i+1) begin
            dirty_array[i] = 0 ;
            valid_array[i] = 0 ;
        end
    end
    else
        state = next_state;
end

    // combinational output logic
always @(*)
begin
    case(next_state)
        IDLE: begin
            mem_read = 0;
            mem_write = 0;
            // write = 0;
            // read = 0;
           // mem_address = 8'dx;
           // mem_writedata = 8'dx;
             //busywait = 0;
        end
        
        MEM_READ: 
        begin
            mem_read = 1;
            mem_write = 0;
            mem_address = {tag, index};
           // mem_writedata = 32'dx;
            busywait = 1;


            #1 if(mem_busywait==0) begin
                cacheblock_array[index]  = mem_readdata ;
                valid_array[index] = 1 ;
                tag_array[index] = tag ;
                busywait = 0;
            end
        end

        MEM_WRITE:
        begin
            mem_read = 0;
            mem_write = 1;
        
            mem_address = {tag_array[index], index};
            mem_writedata = cacheblock_array[index];
            busywait = 1;

            if(mem_busywait==0) begin
                dirty_array[index] = 0;
            end

        end
        
    endcase
end

    



endmodule