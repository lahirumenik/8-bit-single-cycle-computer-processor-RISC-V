`timescale 1ns/100ps
module inst_cache (
    input clock, reset ,
    input logic [9:0] address,
    output logic [5:0] mem_address,
    output reg busywait,
    input logic [127:0] mem_readinst,    
    input logic mem_busywait,
    output logic [31:0] instruction,
    output logic mem_read

);

// cache(.clock(), .address(), .cpu_writeData(), .write(write), .read(read), .cpu_readData(), .busywait(), .mem_readData(), .mem_busywait(),
// .mem_writeData(), .mem_address(), .mem_read(), .mem_write())
//logic[31:0] instruction;
//logic [127:0] readinst;
//logic inst_mem_busywait, mem_read, inst_busywait
//inst_cache(.clock(CLK), .reset(RESET), .address(), .busywait(inst_busywait), .mem_readinst(readinst), .instruction(instruction),
// .mem_busywait(inst_mem_busywait), .mem_read(mem_read), .mem_address(mem_address));
//instruction_memory(.clock(CLK), .read(mem_read), .address(mem_address), .readinst(readinst), .busywait(inst_mem_busywait))

logic [127:0] cacheblock_array [7:0];              
logic  valid_array [7:0];             
logic [2:0] tag_array [7:0]; 

logic [2:0] tag, index;
logic valid;
logic [1:0] offset;
reg hit;
reg tagmatch;

assign {tag, index, offset} = address[9:2];

assign  #1 valid = valid_array[index];

//  always @(read,write) begin
//         busywait = (read || write)? 1 : 0;
//     end
// always @(*) begin
//     #0.9 tagmatch = (tag==tag_array[index])

// end

assign #1.9 tagmatch = (tag==tag_array[index]);
assign hit = tagmatch & valid;
//assign busywait = (write| read) & !hit;
// always @(*) busywait = (write| read);

always @(*) begin
    case(offset)
         0: instruction = #1 cacheblock_array[index][31:0] ;
        1: instruction = #1 cacheblock_array[index][63:32] ;
        2: instruction = #1 cacheblock_array[index][95:64] ;
        3: instruction = #1 cacheblock_array[index][127:96] ;

    endcase


end

 always @(posedge clock) begin
        if(hit) busywait = 0;
        else busywait = 1;
       
    end
    


parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010;
reg [2:0] state, next_state;

    // combinational next state logic
 always @(*)
    begin
        case (state)
            IDLE:
                if (!hit)  
                    next_state = MEM_READ;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_busywait)
                    next_state = IDLE;
                else    
                    next_state = MEM_READ;

        endcase
    end


integer i;
// sequential logic for state transitioning 
always @(posedge clock, reset)
begin
    if(reset) begin
        state = IDLE;
        for(i = 0 ; i<7 ;i = i+1) begin
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
            
        end
        
        MEM_READ: 
        begin
            mem_read = 1;
            mem_address = {tag, index};
            busywait = 1;


            #1 if(mem_busywait==0) begin
                cacheblock_array[index]  =  mem_readinst ;
                valid_array[index] = 1 ;
                tag_array[index] = tag ;
                
            end
        end

    endcase
end

    



endmodule