module alu (
    input [31:0] SrcAE,
    input [31:0] SrcBE,
    input [5:0] ALUControlE,

    output reg [31:0] ALUResultE,
    output ZeroE
);

    always @(*) begin

        case (ALUControlE)

            // R-TYPE
            6'd0:
                ALUResultE = SrcAE + SrcBE;                         // ADD

            6'd1:
                ALUResultE = SrcAE - SrcBE;                         // SUB

            6'd2:
                ALUResultE = SrcAE & SrcBE;                         // AND

            6'd3:
                ALUResultE = SrcAE | SrcBE;                         // OR

            6'd4:
                ALUResultE = SrcAE ^ SrcBE;                         // XOR

            6'd5:
                ALUResultE = SrcAE << SrcBE[4:0];                   // SLL

            6'd6:
                ALUResultE = SrcAE >> SrcBE[4:0];                   // SRL

            6'd7:
                ALUResultE = $signed(SrcAE) >>> SrcBE[4:0];         // SRA

            6'd8:
                ALUResultE = ($signed(SrcAE) < $signed(SrcBE)) ?
                              32'd1 : 32'd0;                         // SLT

            6'd9:
                ALUResultE = (SrcAE < SrcBE) ?
                              32'd1 : 32'd0;                         // SLTU


            // I-TYPE
            6'd10:
                ALUResultE = SrcAE + SrcBE;                         // ADDI

            6'd11:
                ALUResultE = SrcAE & SrcBE;                         // ANDI

            6'd12:
                ALUResultE = SrcAE | SrcBE;                         // ORI

            6'd13:
                ALUResultE = SrcAE ^ SrcBE;                         // XORI

            6'd14:
                ALUResultE = SrcAE << SrcBE[4:0];                   // SLLI

            6'd15:
                ALUResultE = SrcAE >> SrcBE[4:0];                   // SRLI

            6'd16:
                ALUResultE = $signed(SrcAE) >>> SrcBE[4:0];         // SRAI

            6'd17:
                ALUResultE = ($signed(SrcAE) < $signed(SrcBE)) ?
                              32'd1 : 32'd0;                         // SLTI

            6'd18:
                ALUResultE = (SrcAE < SrcBE) ?
                              32'd1 : 32'd0;                         // SLTIU


            // BRANCH
            6'd19:
                ALUResultE = SrcAE - SrcBE;                         // BEQ

            6'd20:
                ALUResultE = SrcAE - SrcBE;                         // BNE

            6'd21:
                ALUResultE = ($signed(SrcAE) < $signed(SrcBE)) ?
                              32'd1 : 32'd0;                         // BLT

            6'd22:
                ALUResultE = ($signed(SrcAE) >= $signed(SrcBE)) ?
                              32'd1 : 32'd0;                         // BGE

            6'd23:
                ALUResultE = (SrcAE < SrcBE) ?
                              32'd1 : 32'd0;                         // BLTU

            6'd24:
                ALUResultE = (SrcAE >= SrcBE) ?
                              32'd1 : 32'd0;                         // BGEU


            // LOAD
            6'd25:
                ALUResultE = SrcAE + SrcBE;                         // LOAD ADDRESS


            // STORE
            6'd26:
                ALUResultE = SrcAE + SrcBE;                         // STORE ADDRESS


            // JAL
            6'd27:
                ALUResultE = SrcAE + 32'd4;                         // JAL


            // JALR
            6'd28:
                ALUResultE = (SrcAE + SrcBE) & 32'hFFFFFFFE;         // JALR


            // LUI
            6'd29:
                ALUResultE = SrcBE;                                 // LUI


            // AUIPC
            6'd30:
                ALUResultE = SrcAE + SrcBE;                         // AUIPC


            default:
                ALUResultE = 32'b0;

        endcase

    end

    assign ZeroE = (ALUResultE == 32'b0);

endmodule