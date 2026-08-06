module clkdivider(
    input clk,
    input reset,
    output reg clkout
);

    reg [25:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            count <= 0;
            clkout <= 0;
        end
        else if (count == 26'd4999999) begin // Toggles every 0.5 seconds
            count <= 0;
            clkout <= ~clkout;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule