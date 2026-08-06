module alu_src_mux (

    input [31:0] SrcBE,
    input [31:0] ImmExtE,
    input ALUSrcE,

    output [31:0] ALUSrcBE

);

    assign ALUSrcBE = ALUSrcE ? ImmExtE : SrcBE;

endmodule