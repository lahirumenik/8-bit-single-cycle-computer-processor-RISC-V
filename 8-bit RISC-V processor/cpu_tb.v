// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne
`include "cpu.v"
`include "instruction_cache.v"
`include "instruction_memory.v"
module cpu_tb;

    logic CLK, RESET;
    logic [31:0] PC;
    logic [31:0] INSTRUCTION;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    logic [7:0] instr_mem [1023:0];
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)

    
    // assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};

   
  
    
    // initial
    // begin
    //     // Initialize instruction memory with the set of instructions you need execute on CPU
        
    //     // METHOD 1: manually loading instructions to instr_mem
    //     //{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000001000000000000000101;
    //    // {instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b00000000000000100000000000001001;
    //     //{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]} = 32'b00000010000001100000010000000010;
        
    //     // METHOD 2: loading instr_mem content from instr_mem.mem file
    //    $readmemb("instr_mem.mem", instr_mem);
    // end


logic [5:0] mem_address;
logic [127:0] readinst;
logic inst_mem_busywait, mem_read, inst_mem_busy;
reg inst_busywait;
inst_cache my_inst_cache(.clock(CLK), .reset(RESET), .address(PC[9:0]), .busywait(inst_busywait), .mem_readinst(readinst), .instruction(INSTRUCTION),
.mem_busywait(inst_mem_busywait), .mem_read(mem_read), .mem_address(mem_address));
instruction_memory inst_memory (.clock(CLK), .read(mem_read), .address(mem_address), .readinst(readinst), .busywait(inst_mem_busywait));

assign inst_mem_busy = (inst_busywait & 1);
    
    /* 
    -----
     CPU
    -----
    */
    cpu #(.W(32)) mycpu(.PC(PC), .INSTRUCTION(INSTRUCTION), .CLK(CLK), .RESET(RESET), .inst_mem_busy(inst_mem_busy));

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1'b1;
        #5
        RESET = 1'b0;
        
        // finish simulation after some time
        #50000
        $finish;
        

    end
    // clock signal generation
    initial forever #4 CLK = ~CLK;

    integer i;
    initial begin
        $dumpfile("cpu_wavedata.vcd");
        for (i=0;i<8;i=i+1)
        begin
            $dumpvars(1, mycpu.my_reg_file.regfiles[i]);
        end
    end        

endmodule