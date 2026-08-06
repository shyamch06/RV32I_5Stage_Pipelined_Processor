module data_memory (

    input clk,
    input MemWriteM,

    input [31:0] ALUResultM,
    input [31:0] WriteDataM,

    output [31:0] ReadDataM

);

    reg [31:0] memo [0:127];

    always @(posedge clk) begin

        if (MemWriteM)
            memo[ALUResultM >> 2] <= WriteDataM;

    end

    assign ReadDataM = memo[ALUResultM >> 2];

endmodule
