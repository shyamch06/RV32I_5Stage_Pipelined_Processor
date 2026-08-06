module fetch_stage (
    input clk,
    input rst,

    input StallF,
    input PCSrcE,

    input [31:0] PCTargetE,

    output [31:0] InstrF,
    output [31:0] PCF,
    output [31:0] PCPlus4F
);

    wire [31:0] PCNextF;

    pc_mux PCMUX (
        .PCSrcE(PCSrcE),
        .PCPlus4F(PCPlus4F),
        .PCTargetE(PCTargetE),
        .PCNextF(PCNextF)
    );

    pc_flop PCFLOP (
        .clk(clk),
        .rst(rst),
        .en(~StallF),
        .PCNextF(PCNextF),
        .PCF(PCF)
    );

    instruction_memory IMEM (
        .PCF(PCF),
        .InstrF(InstrF)
    );

    pc_plus4 PCPLUS (
        .PCF(PCF),
        .PCPlus4F(PCPlus4F)
    );

endmodule
