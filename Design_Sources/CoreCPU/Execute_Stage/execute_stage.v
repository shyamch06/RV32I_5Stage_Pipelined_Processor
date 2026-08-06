module execute_stage (

    input clk,
    input rst,

    // From ID/EX pipeline register
    input [31:0] RD1E,
    input [31:0] RD2E,
    input [31:0] ImmExtE,
    input [31:0] PCE,
    input [31:0] PCPlus4E,

    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] RdE,

    input RegWriteE,
    input MemWriteE,
    input JumpE,
    input JALRE,
    input BranchE,
    input ALUSrcE,

    input [1:0] ResultSrcE,
    input [5:0] ALUControlE,

    // From later pipeline stages - forwarding
    input [4:0] RdM,
    input [4:0] RdW,

    input RegWriteM,
    input RegWriteW,

    input [31:0] ALUResultM,
    input [31:0] ResultW,

    // Execute stage outputs
    output [31:0] ALUResultE,
    output [31:0] WriteDataE,
    output [31:0] PCTargetE,

    output BranchTakenE,
    output PCSrcE,

    output [1:0] ForwardAE,
    output [1:0] ForwardBE

);

    // --------------------------------------------------
    // Forwarding signals
    // --------------------------------------------------

    forwarding_unit FU (

        .Rs1E(Rs1E),
        .Rs2E(Rs2E),

        .RdM(RdM),
        .RdW(RdW),

        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),

        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)

    );


    // --------------------------------------------------
    // Forwarding MUX A
    // --------------------------------------------------

    wire [31:0] SrcAE;

    forward_muxA FMA (

        .RD1E(RD1E),
        .ResultW(ResultW),
        .ALUResultM(ALUResultM),

        .ForwardAE(ForwardAE),

        .SrcAE(SrcAE)

    );


    // --------------------------------------------------
    // Forwarding MUX B
    // --------------------------------------------------

    wire [31:0] SrcBE;

    forward_muxB FMB (

        .RD2E(RD2E),
        .ResultW(ResultW),
        .ALUResultM(ALUResultM),

        .ForwardBE(ForwardBE),

        .SrcBE(SrcBE)

    );


    // --------------------------------------------------
    // ALU source MUX
    // --------------------------------------------------

    wire [31:0] ALUSrcBE;

    alu_src_mux ASM (

        .SrcBE(SrcBE),
        .ImmExtE(ImmExtE),
        .ALUSrcE(ALUSrcE),

        .ALUSrcBE(ALUSrcBE)

    );


    // --------------------------------------------------
    // ALU
    // --------------------------------------------------

    wire ZeroE;

    alu ALU (

        .SrcAE(SrcAE),
        .SrcBE(ALUSrcBE),
        .ALUControlE(ALUControlE),

        .ALUResultE(ALUResultE),
        .ZeroE(ZeroE)

    );


    // --------------------------------------------------
    // Store data
    // --------------------------------------------------

    assign WriteDataE = SrcBE;


    // --------------------------------------------------
    // Branch decision
    // --------------------------------------------------

    branch_unit BU (

        .BranchE(BranchE),
        .ALUControlE(ALUControlE),

        .SrcAE(SrcAE),
        .SrcBE(SrcBE),

        .BranchTakenE(BranchTakenE)

    );


    // --------------------------------------------------
    // Branch / JAL / JALR target
    // --------------------------------------------------

    target_address TA (

        .PCE(PCE),
        .SrcAE(SrcAE),
        .ImmExtE(ImmExtE),

        .JALRE(JALRE),

        .PCTargetE(PCTargetE)

    );


    // --------------------------------------------------
    // PC source
    // --------------------------------------------------

    pc_src_unit PSU (

        .BranchTakenE(BranchTakenE),
        .JumpE(JumpE),

        .PCSrcE(PCSrcE)

    );

endmodule
