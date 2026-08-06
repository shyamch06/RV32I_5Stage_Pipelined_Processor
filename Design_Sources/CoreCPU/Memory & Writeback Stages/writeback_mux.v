module writeback_mux (

    input [31:0] ALUResultW,
    input [31:0] ReadDataW,
    input [31:0] PCPlus4W,

    input [1:0] ResultSrcW,

    output reg [31:0] ResultW

);

    always @(*) begin

        case (ResultSrcW)

            2'b00:
                ResultW = ALUResultW;

            2'b01:
                ResultW = ReadDataW;

            2'b10:
                ResultW = PCPlus4W;

            default:
                ResultW = 32'b0;

        endcase

    end

endmodule