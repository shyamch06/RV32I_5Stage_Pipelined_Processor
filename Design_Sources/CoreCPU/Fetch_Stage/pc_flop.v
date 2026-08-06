module pc_flop (
    input clk,rst,en,
    input [31:0] PCNextF,
    output reg [31:0] PCF
);
    always @(posedge clk) begin
        if(rst)
           PCF <= 32'd0;
        else if(en)
            PCF <= PCNextF;
    end
endmodule