module reg_file #(
    //parameterized
    parameter N=8, W=8, A = 3 
    //N = number of registers
    //W = width of a register
    // A = width of  control 
)(
    input logic [W-1:0] IN,
    output logic [W-1:0] OUT1, OUT2,
    input logic [A-1:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS,
    input logic WRITE, CLK, RESET
);
logic [W-1:0] regfiles [N-1:0]; // register files array
integer i; // for looping

//assign for output data
always @(*) begin
   #2 OUT1 <= regfiles[OUT1ADDRESS];
     OUT2 <= regfiles[OUT2ADDRESS];
end


//at positive edge of the clock
always @(posedge CLK)  begin
    if (RESET) begin
       
        for (i=0;i<N;i=i+1) //make all registers as zero
         regfiles[i] ='0;

    end
    else if(WRITE) // when write enable
    #1 regfiles[INADDRESS] = IN; // write to given address
end



endmodule

