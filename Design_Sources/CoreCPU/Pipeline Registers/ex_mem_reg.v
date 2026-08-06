module ex_mem_reg(

    input clk,
    input rst,

    // Datasignls
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [31:0] PCPlus4E,

    input [4:0] RdE,

    // Controlsignals
    input RegWriteE,
    input MemWriteE,
    input [1:0] ResultSrcE,

    // Outputs to memory stage
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,

    output reg [4:0] RdM,

    output reg RegWriteM,
    output reg MemWriteM,
    output reg [1:0] ResultSrcM

);

always @(posedge clk or posedge rst)
begin

    if(rst)
        begin

            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            PCPlus4M   <= 32'b0;

            RdM <= 5'b0;

            RegWriteM  <= 1'b0;
            MemWriteM  <= 1'b0;
            ResultSrcM <= 2'b00;
    
        end

    else begin

        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        PCPlus4M   <= PCPlus4E;

        RdM <= RdE;

        RegWriteM  <= RegWriteE;
        MemWriteM  <= MemWriteE;
        ResultSrcM <= ResultSrcE;

    end

end

endmodule
