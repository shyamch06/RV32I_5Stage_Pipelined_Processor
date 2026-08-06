module register_file (
    input clk,
    input rst,

    // Decode stage read addresses
    input [4:0] Rs1D,
    input [4:0] Rs2D,

    // Writeback stage
    input [4:0] RdW,
    input [31:0] ResultW,
    input RegWriteW,

    // Decode stage read data
    output [31:0] RD1D,
    output [31:0] RD2D,
    
    // NEW: Dedicated output for the 7-segment display
    output [31:0] x1_out 
);

    reg [31:0] register_mem [31:0];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                register_mem[i] <= 32'b0;
        end
        else if (RegWriteW && (RdW != 5'b00000)) begin
            register_mem[RdW] <= ResultW;
        end
    end

    // x0 is always zero
    assign RD1D = (Rs1D == 5'b00000) ? 32'b0 : register_mem[Rs1D];
    assign RD2D = (Rs2D == 5'b00000) ? 32'b0 : register_mem[Rs2D];

    // NEW: Continuously route x1 to the output port
    assign x1_out = register_mem[1];

endmodule