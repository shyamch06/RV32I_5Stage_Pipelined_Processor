module instruction_decoder (
    input  [31:0] InstrD,

    output [6:0] OpcodeD,
    output [4:0] RdD,
    output [2:0] Func3D,
    output [4:0] Rs1D,
    output [4:0] Rs2D,
    output [6:0] Func7D
);

    assign OpcodeD = InstrD[6:0];
    assign RdD     = InstrD[11:7];
    assign Func3D  = InstrD[14:12];
    assign Rs1D    = InstrD[19:15];
    assign Rs2D    = InstrD[24:20];
    assign Func7D  = InstrD[31:25];

endmodule