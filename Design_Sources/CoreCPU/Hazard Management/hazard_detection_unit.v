module hazard_detection_unit(

    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdE,
    input [1:0] ResultSrcE,
    input PCSrcE,
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg FlushE

);

wire lwStall;

assign lwStall =
        (ResultSrcE == 2'b01) &&
        ((Rs1D == RdE) || (Rs2D == RdE)) &&
        (RdE != 5'b00000);

always @(*) begin

    // Default
    StallF = 0;
    StallD = 0;
    FlushD = 0;
    FlushE = 0;

    // Load-use hazard
    if(lwStall)
    begin

        StallF = 1;
        StallD = 1;
        FlushE = 1;

    end

    // Branch / Jump taken
    if(PCSrcE)
    begin

        FlushD = 1;
        FlushE = 1;

    end

end

endmodule
