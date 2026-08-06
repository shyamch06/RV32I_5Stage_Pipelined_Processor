module alu_decoder (

    input [2:0] ALUOpD,
    input [2:0] Func3D,
    input [6:0] Func7D,

    output reg [5:0] ALUControlD

);

    always @(*) begin

        case (ALUOpD)

            // LOAD / STORE
            3'b000:
                ALUControlD = 6'd25;

            // R-TYPE
            3'b001:
            begin

                case ({Func7D, Func3D})

                    {7'b0000000, 3'b000}:
                        ALUControlD = 6'd0;   // ADD

                    {7'b0100000, 3'b000}:
                        ALUControlD = 6'd1;   // SUB

                    {7'b0000000, 3'b111}:
                        ALUControlD = 6'd2;   // AND

                    {7'b0000000, 3'b110}:
                        ALUControlD = 6'd3;   // OR

                    {7'b0000000, 3'b100}:
                        ALUControlD = 6'd4;   // XOR

                    {7'b0000000, 3'b001}:
                        ALUControlD = 6'd5;   // SLL

                    {7'b0000000, 3'b101}:
                        ALUControlD = 6'd6;   // SRL

                    {7'b0100000, 3'b101}:
                        ALUControlD = 6'd7;   // SRA

                    {7'b0000000, 3'b010}:
                        ALUControlD = 6'd8;   // SLT

                    {7'b0000000, 3'b011}:
                        ALUControlD = 6'd9;   // SLTU

                    default:
                        ALUControlD = 6'd25;

                endcase

            end

            // I-TYPE
            3'b010:
            begin

                case (Func3D)

                    3'b000:
                        ALUControlD = 6'd10;  // ADDI

                    3'b111:
                        ALUControlD = 6'd11;  // ANDI

                    3'b110:
                        ALUControlD = 6'd12;  // ORI

                    3'b100:
                        ALUControlD = 6'd13;  // XORI

                    3'b001:
                        ALUControlD = 6'd14;  // SLLI

                    3'b101:
                    begin

                        if (Func7D == 7'b0000000)
                            ALUControlD = 6'd15;  // SRLI
                        else
                            ALUControlD = 6'd16;  // SRAI

                    end

                    3'b010:
                        ALUControlD = 6'd17;  // SLTI

                    3'b011:
                        ALUControlD = 6'd18;  // SLTIU

                    default:
                        ALUControlD = 6'd25;

                endcase

            end

            // BRANCH
            3'b011:
            begin

                case (Func3D)

                    3'b000:
                        ALUControlD = 6'd19;  // BEQ

                    3'b001:
                        ALUControlD = 6'd20;  // BNE

                    3'b100:
                        ALUControlD = 6'd21;  // BLT

                    3'b101:
                        ALUControlD = 6'd22;  // BGE

                    3'b110:
                        ALUControlD = 6'd23;  // BLTU

                    3'b111:
                        ALUControlD = 6'd24;  // BGEU

                    default:
                        ALUControlD = 6'd25;

                endcase

            end

            // JAL / JALR
            3'b100:
                ALUControlD = 6'd27;
            
            // LUI
            3'b101:
                ALUControlD = 6'd29;

            // AUIPC
            3'b110:
                ALUControlD = 6'd30;

            default:
                ALUControlD = 6'd25;

        endcase

    end

endmodule
