module forward_muxB(

    input [31:0] RD2E,
    input [31:0] ResultW,
    input [31:0] ALUResultM,
    input [1:0] ForwardBE,
    output reg [31:0] SrcBE

);

always @(*) begin

    case(ForwardBE)

        2'b00: SrcBE = RD2E;

        2'b01: SrcBE = ResultW;

        2'b10: SrcBE = ALUResultM;

        default: SrcBE = RD2E;

    endcase

end

endmodule