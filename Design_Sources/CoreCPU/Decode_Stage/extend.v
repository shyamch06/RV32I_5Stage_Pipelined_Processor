module extend (

    input [31:0] InstrD,
    input [2:0] ImmSrcD,

    output reg [31:0] ImmExtD

);

    always @(*) begin

        case (ImmSrcD)

            // I-Type
            3'b000:
                ImmExtD = {{20{InstrD[31]}}, InstrD[31:20]};

            // S-Type
            3'b001:
                ImmExtD = {{20{InstrD[31]}},
                           InstrD[31:25],
                           InstrD[11:7]};

            // B-Type
            3'b010:
                ImmExtD = {{19{InstrD[31]}},
                           InstrD[31],
                           InstrD[7],
                           InstrD[30:25],
                           InstrD[11:8],
                           1'b0};

            // U-Type
            3'b011:
                ImmExtD = {InstrD[31:12], 12'b0};

            // J-Type
            3'b100:
                ImmExtD = {{11{InstrD[31]}},
                           InstrD[31],
                           InstrD[19:12],
                           InstrD[20],
                           InstrD[30:21],
                           1'b0};

            default:
                ImmExtD = 32'b0;

        endcase

    end

endmodule