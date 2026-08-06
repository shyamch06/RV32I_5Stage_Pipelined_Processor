module pc_mux (
    input PCSrcE,
    input [31:0] PCPlus4F,PCTargetE,
    output [31:0] PCNextF
);
    assign PCNextF= PCSrcE? PCTargetE: PCPlus4F;
endmodule
