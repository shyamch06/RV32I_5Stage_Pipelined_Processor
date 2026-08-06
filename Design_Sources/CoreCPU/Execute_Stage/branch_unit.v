module branch_unit (

    input BranchE,
    input [5:0] ALUControlE,
    input [31:0] SrcAE,
    input [31:0] SrcBE,

    output reg BranchTakenE

);

    always @(*) begin

        BranchTakenE = 1'b0;

        if (BranchE) begin

            case (ALUControlE)

                6'd19: BranchTakenE = (SrcAE == SrcBE);                    // BEQ
                6'd20: BranchTakenE = (SrcAE != SrcBE);                    // BNE
                6'd21: BranchTakenE = ($signed(SrcAE) < $signed(SrcBE));  // BLT
                6'd22: BranchTakenE = ($signed(SrcAE) >= $signed(SrcBE)); // BGE
                6'd23: BranchTakenE = (SrcAE < SrcBE);                    // BLTU
                6'd24: BranchTakenE = (SrcAE >= SrcBE);                   // BGEU

                default:
                    BranchTakenE = 1'b0;

            endcase

        end

    end

endmodule