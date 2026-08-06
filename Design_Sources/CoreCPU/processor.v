module processor (

    input clk,
    input rst,

    output [31:0] ResultW,
    output [31:0] Fib_value
);

   // FETCH STAGE SIGNALS

    wire [31:0] InstrF;
    wire [31:0] PCF;
    wire [31:0] PCPlus4F;
    wire StallF;
    wire PCSrcE;
    wire [31:0] PCTargetE;


   // FETCH STAGE

    fetch_stage FETCH (

        .clk(clk),
        .rst(rst),

        .StallF(StallF),
        .PCSrcE(PCSrcE),

        .PCTargetE(PCTargetE),

        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F)

    );


    // IF / ID PIPELINE REGISTER

    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;

    wire StallD;
    wire FlushD;

if_id_reg IF_ID (

    .clk(clk),
    .rst(rst),

    .StallD(StallD),
    .FlushD(FlushD),

    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),

    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)

);
    // DECODE STAGE SIGNALS

    // Instruction fields

    wire [6:0] OpcodeD;
    wire [4:0] Rs1D;
    wire [4:0] Rs2D;
    wire [4:0] RdD;

    wire [2:0] Func3D;
    wire [6:0] Func7D;


    // Register file outputs

    wire [31:0] RD1D;
    wire [31:0] RD2D;


    // Immediate

    wire [31:0] ImmExtD;


    // Control signals

    wire RegWriteD;
    wire MemWriteD;
    wire BranchD;
    wire JumpD;
    wire JALRD;
    wire ALUSrcD;

    wire [1:0] ResultSrcD;
    wire [1:0] ImmSrcD;
    // wire [1:0] ALUOpD;

    wire [5:0] ALUControlD; 

   // INSTRUCTION DECODER

    instruction_decoder ID (

        .InstrD(InstrD),
        .OpcodeD(OpcodeD),
        .RdD(RdD),
        .Func3D(Func3D),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Func7D(Func7D)

    );

   // REGISTER FILE

   // Add a wire to catch the signal
    wire [31:0] x1_data;

    // REGISTER FILE
    register_file RF (
        .clk(clk),
        .rst(rst),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdW(RdW),
        .ResultW(ResultW),
        .RegWriteW(RegWriteW),
        .RD1D(RD1D),
        .RD2D(RD2D),
        
        // Catch the new output port here
        .x1_out(x1_data) 
    );  

    // Assign the captured x1 data directly to the Fib_value output
    assign Fib_value = x1_data;
    
    // IMMEDIATE EXTENSION
    extend EXT (

        .InstrD(InstrD),
        .ImmSrcD(ImmSrcD),

        .ImmExtD(ImmExtD)

    );

    // CONTROL UNIT

    control_unit CU (

        .OpcodeD(OpcodeD),
        .Func7D(Func7D),
        .Func3D(Func3D),

        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .JALRD(JALRD),
        .ALUSrcD(ALUSrcD),

        .ResultSrcD(ResultSrcD),
        .ImmSrcD(ImmSrcD),

        .ALUControlD(ALUControlD)

    );

    // ID / EX PIPELINE REGISTER
    wire [31:0] RD1E;
    wire [31:0] RD2E;
    wire [31:0] ImmExtE;

    wire [31:0] PCE;
    wire [31:0] PCPlus4E;

    wire [4:0] Rs1E;
    wire [4:0] Rs2E;
    wire [4:0] RdE;

    wire RegWriteE;
    wire MemWriteE;
    wire JumpE;
    wire JALRE;
    wire BranchE;
    wire ALUSrcE;

    wire [1:0] ResultSrcE;
    wire [5:0] ALUControlE;
    
    id_ex_reg ID_EX (

    .clk(clk),
    .rst(rst),
    .FlushE(FlushE),

    // Decode stage data
    .RD1D(RD1D),
    .RD2D(RD2D),
    .ImmExtD(ImmExtD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),

    // Register addresses
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdD(RdD),

    // Control
    .RegWriteD(RegWriteD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .JALRD(JALRD),
    .BranchD(BranchD),
    .ALUSrcD(ALUSrcD),

    .ResultSrcD(ResultSrcD),
    .ALUControlD(ALUControlD),

    // Execute stage outputs
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ImmExtE(ImmExtE),
    .PCE(PCE),
    .PCPlus4E(PCPlus4E),

    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),

    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .JALRE(JALRE),
    .BranchE(BranchE),
    .ALUSrcE(ALUSrcE),

    .ResultSrcE(ResultSrcE),
    .ALUControlE(ALUControlE)

    );

// EXECUTE STAGE

wire [31:0] ALUResultE;
wire [31:0] WriteDataE;
wire BranchTakenE;


wire [1:0] ForwardAE;
wire [1:0] ForwardBE;

execute_stage EXECUTE (

    .clk(clk),
    .rst(rst),

    // From ID/EX
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ImmExtE(ImmExtE),
    .PCE(PCE),
    .PCPlus4E(PCPlus4E),

    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),

    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .JALRE(JALRE),
    .BranchE(BranchE),
    .ALUSrcE(ALUSrcE),

    .ResultSrcE(ResultSrcE),
    .ALUControlE(ALUControlE),

    // From later stages
    .RdM(RdM),
    .RdW(RdW),

    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),

    .ALUResultM(ALUResultM),
    .ResultW(ResultW),

    // Outputs
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .PCTargetE(PCTargetE),

    .BranchTakenE(BranchTakenE),
    .PCSrcE(PCSrcE),

    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)

);

// EX / MEM PIPELINE REGISTER
wire [31:0] ALUResultM;
wire [31:0] WriteDataM;
wire [31:0] PCPlus4M;

wire [4:0] RdM;

wire RegWriteM;
wire MemWriteM;

wire [1:0] ResultSrcM;

ex_mem_reg EX_MEM (

    .clk(clk),
    .rst(rst),

    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .PCPlus4E(PCPlus4E),

    .RdE(RdE),

    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),

    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .PCPlus4M(PCPlus4M),

    .RdM(RdM),

    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM)

);

// MEMORY STAGE

wire [31:0] ReadDataM;

data_memory DMEM (

    .clk(clk),
    .MemWriteM(MemWriteM),

    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),

    .ReadDataM(ReadDataM)

);

// MEM / WB PIPELINE REGISTER

wire [31:0] ReadDataW;
wire [31:0] ALUResultW;
wire [31:0] PCPlus4W;

wire [4:0] RdW;

wire RegWriteW;
wire [1:0] ResultSrcW;

mem_wb_reg MEM_WB (

    .clk(clk),
    .rst(rst),

    .ReadDataM(ReadDataM),
    .ALUResultM(ALUResultM),
    .PCPlus4M(PCPlus4M),

    .RdM(RdM),

    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),

    .ReadDataW(ReadDataW),
    .ALUResultW(ALUResultW),
    .PCPlus4W(PCPlus4W),

    .RdW(RdW),

    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW)

);

// WRITEBACK STAGE


writeback_mux WB_MUX (

    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .PCPlus4W(PCPlus4W),

    .ResultSrcW(ResultSrcW),

    .ResultW(ResultW)

);

// HAZARD DETECTION UNIT

wire FlushE;

hazard_detection_unit HDU (

    .Rs1D(Rs1D),
    .Rs2D(Rs2D),

    .RdE(RdE),
    .ResultSrcE(ResultSrcE),

    .PCSrcE(PCSrcE),

    .StallF(StallF),
    .StallD(StallD),

    .FlushD(FlushD),
    .FlushE(FlushE)

);

endmodule
