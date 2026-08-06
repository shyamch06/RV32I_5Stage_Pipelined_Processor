module control_unit (

    input [6:0] OpcodeD,
    input [6:0] Func7D,
    input [2:0] Func3D,

    output RegWriteD,
    output MemWriteD,
    output BranchD,
    output JumpD,
    output JALRD,
    output ALUSrcD,

    output [1:0] ResultSrcD,
    output [2:0] ImmSrcD,
    output [5:0] ALUControlD

);

    wire [2:0] ALUOpD;

    main_decoder MD (

        .OpcodeD(OpcodeD),

        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .JALRD(JALRD),
        .ALUSrcD(ALUSrcD),

        .ResultSrcD(ResultSrcD),
        .ImmSrcD(ImmSrcD),
        .ALUOpD(ALUOpD)

    );

    alu_decoder AD (

        .ALUOpD(ALUOpD),
        .Func3D(Func3D),
        .Func7D(Func7D),

        .ALUControlD(ALUControlD)

    );

endmodule