module if_id_reg(
    input clk,
    input rst,
    input StallD,
    input FlushD,

    // Fetch Stage Inputs
    input [31:0] InstrF,
    input [31:0] PCF,
    input [31:0] PCPlus4F,

    // Decode stage stage outputs
    output reg [31:0] InstrD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D
);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        InstrD   <= 32'b0;
        PCD      <= 32'b0;
        PCPlus4D <= 32'b0;
    end

    else if(FlushD)
    begin
        InstrD   <= 32'b0;
        PCD      <= 32'b0;
        PCPlus4D <= 32'b0;
    end

    else if(!StallD)
    begin
        InstrD   <= InstrF;
        PCD      <= PCF;
        PCPlus4D <= PCPlus4F;
    end

end

endmodule