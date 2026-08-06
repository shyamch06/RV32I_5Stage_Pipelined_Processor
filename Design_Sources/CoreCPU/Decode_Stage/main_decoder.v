module main_decoder(

input [6:0] OpcodeD,

output reg RegWriteD,
output reg MemWriteD,
output reg BranchD,
output reg JumpD,
output reg JALRD,
output reg ALUSrcD,

output reg [1:0] ResultSrcD,
output reg [2:0] ImmSrcD,
output reg [2:0] ALUOpD

);

always @(*) 
begin

    case(OpcodeD)

    // R-Type
    7'b0110011:
    begin

        RegWriteD = 1;
        MemWriteD = 0;
        BranchD   = 0;
        JumpD     = 0;
        JALRD     = 0;
        ALUSrcD   = 0;

        ResultSrcD = 2'b00;
        ImmSrcD    = 3'b000;
        ALUOpD     = 3'b010;

    end

    // I-Type
    7'b0010011:
    begin

        RegWriteD = 1;
        MemWriteD = 0;
        BranchD   = 0;
        JumpD     = 0;
        JALRD     = 0;
        ALUSrcD   = 1;

        ResultSrcD = 2'b00;
        ImmSrcD    = 3'b000;
        ALUOpD     = 3'b010;

    end

    // LOAD
    7'b0000011:
    begin

        RegWriteD = 1;
        MemWriteD = 0;
        BranchD   = 0;
        JumpD     = 0;
        JALRD     = 0;
        ALUSrcD   = 1;

        ResultSrcD = 2'b01;
        ImmSrcD    = 3'b000;
        ALUOpD     = 3'b000;

    end

    // STORE
    7'b0100011:
    begin

        RegWriteD = 0;
        MemWriteD = 1;
        BranchD   = 0;
        JumpD     = 0;
        JALRD     = 0;
        ALUSrcD   = 1;

        ResultSrcD = 2'b00;
        ImmSrcD    = 3'b001;
        ALUOpD     = 3'b000;

    end

    // BRANCH
    7'b1100011:
    begin

        RegWriteD = 0;
        MemWriteD = 0;
        BranchD   = 1;
        JumpD     = 0;
        JALRD     = 0;
        ALUSrcD   = 0;

        ResultSrcD = 2'b00;
        ImmSrcD    = 3'b010;
        ALUOpD     = 3'b001;

    end

    // JAL
    7'b1101111:
    begin

        RegWriteD = 1;
        MemWriteD = 0;
        BranchD   = 0;
        JumpD     = 1;
        JALRD     = 0;
        ALUSrcD   = 0;

        ResultSrcD = 2'b10;
        ImmSrcD    = 3'b100;
        ALUOpD     = 3'b000;

    end

    // JALR
    7'b1100111:
    begin

        RegWriteD = 1;
        MemWriteD = 0;
        BranchD   = 0;
        JumpD     = 1;
        JALRD     = 1;
        ALUSrcD   = 1;

        ResultSrcD = 2'b10;
        ImmSrcD    = 3'b000;
        ALUOpD     = 3'b100;

    end

    default:
    begin

        RegWriteD = 0;
        MemWriteD = 0;
        BranchD   = 0;
        JumpD     = 0;
        ALUSrcD   = 0;

        ResultSrcD = 2'b00;
        ImmSrcD    = 3'b000;
        ALUOpD     = 3'b000;
    end

    endcase

end

endmodule