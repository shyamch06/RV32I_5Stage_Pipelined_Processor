module target_address (

    input [31:0] PCE,
    input [31:0] SrcAE,
    input [31:0] ImmExtE,

    input JALRE,

    output [31:0] PCTargetE

);

assign PCTargetE = JALRE ? 
                ((SrcAE + ImmExtE) & 32'hFFFFFFFE) : 
                (PCE + ImmExtE);

endmodule