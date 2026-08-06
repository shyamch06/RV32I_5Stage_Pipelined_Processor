module forward_muxA(

    input [31:0] RD1E,
    input [31:0] ResultW,
    input [31:0] ALUResultM,
    input [1:0] ForwardAE,
    output reg [31:0] SrcAE

);

always @(*) begin

    case(ForwardAE)

        2'b00: SrcAE = RD1E;

        2'b01: SrcAE = ResultW;

        2'b10: SrcAE = ALUResultM;

        default: SrcAE = RD1E;

    endcase

end

endmodule