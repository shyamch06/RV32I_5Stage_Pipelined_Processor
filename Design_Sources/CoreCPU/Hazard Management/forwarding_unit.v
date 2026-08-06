module forwarding_unit(

    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] RdM,
    input [4:0] RdW,
    input RegWriteM,
    input RegWriteW,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE

);

always @(*) begin

    // Default: no forwarding
    ForwardAE = 2'b00;
    ForwardBE = 2'b00;

    // Source A
    if(RegWriteM && (RdM != 0) && (RdM == Rs1E))
        ForwardAE = 2'b10;

    else if(RegWriteW && (RdW != 0) && (RdW == Rs1E))
        ForwardAE = 2'b01;

    // Source B
    if(RegWriteM && (RdM != 0) && (RdM == Rs2E))
        ForwardBE = 2'b10;

    else if(RegWriteW && (RdW != 0) && (RdW == Rs2E))
        ForwardBE = 2'b01;

end

endmodule