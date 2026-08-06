module id_ex_reg (

    input clk,
    input rst,
    input FlushE,

    // Decode Stage Data
    input [31:0] RD1D,
    input [31:0] RD2D,
    input [31:0] ImmExtD,
    input [31:0] PCD,
    input [31:0] PCPlus4D,

    // Register Addresses
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdD,

    // Decode Stage Control Signals
    input RegWriteD,
    input MemWriteD,
    input JumpD,
    input JALRD,
    input BranchD,
    input ALUSrcD,

    input [1:0] ResultSrcD,
    input [5:0] ALUControlD,

    // Execute Stage Data
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCE,
    output reg [31:0] PCPlus4E,

    // Register Addresses
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE,

    // Execute Stage Control Signals
    output reg RegWriteE,
    output reg MemWriteE,
    output reg JumpE,
    output reg JALRE,
    output reg BranchE,
    output reg ALUSrcE,

    output reg [1:0] ResultSrcE,
    output reg [5:0] ALUControlE

);

    always @(posedge clk or posedge rst) begin

        if (rst || FlushE) begin

            // Data
            RD1E     <= 32'b0;
            RD2E     <= 32'b0;
            ImmExtE  <= 32'b0;
            PCE      <= 32'b0;
            PCPlus4E <= 32'b0;

            // Register addresses
            Rs1E <= 5'b0;
            Rs2E <= 5'b0;
            RdE  <= 5'b0;

            // Control signals
            RegWriteE   <= 1'b0;
            MemWriteE   <= 1'b0;
            JumpE       <= 1'b0;
            JALRE       <= 1'b0;
            BranchE     <= 1'b0;
            ALUSrcE     <= 1'b0;
            ResultSrcE  <= 2'b00;
            ALUControlE <= 6'b0;

        end

        else begin

            // Data
            RD1E     <= RD1D;
            RD2E     <= RD2D;
            ImmExtE  <= ImmExtD;
            PCE      <= PCD;
            PCPlus4E <= PCPlus4D;

            // Register addresses
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE  <= RdD;

            // Control signals
            RegWriteE   <= RegWriteD;
            MemWriteE   <= MemWriteD;
            JumpE       <= JumpD;
            JALRE       <= JALRD;
            BranchE     <= BranchD;
            ALUSrcE     <= ALUSrcD;
            ResultSrcE  <= ResultSrcD;
            ALUControlE <= ALUControlD;

        end

    end

endmodule